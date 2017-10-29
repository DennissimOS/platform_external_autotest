# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import logging
import pprint
import time

from autotest_lib.client.common_lib import error
from autotest_lib.server import autotest
from autotest_lib.server.cros.faft.firmware_test import FirmwareTest


class firmware_Cr50DeviceState(FirmwareTest):
    """Verify Cr50 tracks the EC and AP state correctly.

    Put the device through S0, S0ix, S3, and S5. Cr50 responds to these state
    changes by enabling/disabling uart and changing its suspend type. Verify
    that none of these cause any interrupt storms on Cr50. Make sure that there
    aren't any interrupt storms and that Cr50 enters regular or deep sleep a
    reasonable amount of times.
    """
    version = 1

    DEEP_SLEEP_STEP_SUFFIX = ' Num Deep Sleep Steps'

    # Use negative numbers to keep track of counts not in the IRQ list.
    KEY_DEEP_SLEEP = -3
    KEY_TIME = -2
    KEY_RESET = -1
    KEY_REGULAR_SLEEP = 112
    INT_NAME = {
        KEY_RESET  : 'Reset Count',
        KEY_DEEP_SLEEP  : 'Deep Sleep Count',
        KEY_TIME  : 'Cr50 Time',
        4 : 'HOST_CMD_DONE',
        81  : 'GPIO0',
        98  : 'GPIO1',
        103 : 'I2CS WRITE',
        KEY_REGULAR_SLEEP : 'PMU WAKEUP',
        124 : 'RBOX_INTR_PWRB',
        160 : 'EVENT TIMER',
        174 : 'CR50_RX_SERVO_TX',
        177 : 'CR50_TX_SERVO_RX',
        181 : 'AP_TX_CR50_RX',
        184 : 'AP_RX_CR50_TX',
        188 : 'EC_TX_CR50_RX',
        191 : 'EC_RX_CR50_TX',
        193 : 'USB',
    }
    # The time in seconds to wait in each state
    SLEEP_TIME = 30
    SHORT_WAIT = 5
    CONSERVATIVE_WAIT_TIME = SLEEP_TIME + SHORT_WAIT + 10
    # Cr50 should wake up twice per second while in regular sleep
    SLEEP_RATE = 2

    DEEP_SLEEP_MAX = 1

    # If there are over 100,000 interrupts, it is an interrupt storm.
    DEFAULT_COUNTS = [0, 100000]
    # A dictionary of ok count values for each irq that shouldn't follow the
    # DEFAULT_COUNTS range.
    EXPECTED_IRQ_COUNT_RANGE = {
        KEY_RESET : [0, 0],
        KEY_DEEP_SLEEP : [0, DEEP_SLEEP_MAX],
        KEY_TIME : [0, CONSERVATIVE_WAIT_TIME],
        'S0ix' + DEEP_SLEEP_STEP_SUFFIX : [0, 0],
        'S3' + DEEP_SLEEP_STEP_SUFFIX : [1, 1],
        'S5' + DEEP_SLEEP_STEP_SUFFIX : [1, 1],
        # Regular sleep is calculated based on the cr50 time
    }

    GET_TASKINFO = ['IRQ counts by type:(.*)Service calls']

    START = ''
    INCREASE = '+'
    DS_RESUME = 'DS'

    def get_taskinfo_output(self):
        """Return a dict with the irq numbers as keys and counts as values"""
        output = self.cr50.send_command_get_output('taskinfo',
            self.GET_TASKINFO)[0][1].strip()
        return output


    def get_irq_counts(self):
        """Return a dict with the irq numbers as keys and counts as values"""
        output = self.get_taskinfo_output()
        irq_list = output.split('\n')
        irq_counts = {}
        for irq_info in irq_list:
            num, count = irq_info.split()
            irq_counts[int(num)] = int(count)
        irq_counts[self.KEY_RESET] = int(self.servo.get('cr50_reset_count'))
        irq_counts[self.KEY_DEEP_SLEEP] = int(self.cr50.get_deep_sleep_count())
        irq_counts[self.KEY_TIME] = int(self.cr50.gettime())
        return irq_counts


    def get_expected_count(self, irq_key, cr50_time):
        """Get the expected irq increase for the given irq and state

        Args:
            irq_key: the irq int
            cr50_time: the cr50 time in seconds

        Returns:
            A list with the expected irq count range [min, max]
        """
        if irq_key == self.KEY_REGULAR_SLEEP:
            min_count = cr50_time if cr50_time >= self.SLEEP_TIME else 0
            max_count = cr50_time * self.SLEEP_RATE
            return [min_count, max_count]
        return self.EXPECTED_IRQ_COUNT_RANGE.get(irq_key, self.DEFAULT_COUNTS)


    def check_increase(self, irq_key, name, increase, expected_range):
        """Verify the irq count is within the expected range

        Args:
            irq_key: the irq int
            name: the irq name string
            increase: the irq count
            expected_range: A list with the valid irq count range [min, max]

        Returns:
            '' if increase is in the given range. If the increase isn't in the
            range, it returns an error message.
        """
        min_count, max_count = expected_range
        if min_count > increase or max_count < increase:
            err_msg = '%s %s: %s not in range %s' % (name, irq_key, increase,
                expected_range)
            return err_msg
        return ''


    def get_step_events(self):
        """Use the deep sleep counts to determine the step events"""
        ds_counts = self.get_irq_step_counts(self.KEY_DEEP_SLEEP)
        events = []
        for i, count in enumerate(ds_counts):
            if not i:
                events.append(self.START)
            elif count != ds_counts[i - 1]:
                # If the deep sleep count changed, Cr50 recovered deep sleep
                # and the irq counts are reset.
                events.append(self.DS_RESUME)
            else:
                events.append(self.INCREASE)
        return events


    def get_irq_step_counts(self, irq_key):
        """Get a list of the all of the step counts for the given irq"""
        return [ irq_dict.get(irq_key, 0) for irq_dict in self.steps ]


    def check_irq_counts(self, state):
        """Check the IRQ counts at each step.

        Args:
            state: The power state: S0, S0ix, S3, or S5.

        Returns:
            A list of errors
        """

        num_steps = len(self.steps)
        # Get all of the deep sleep counts
        events = self.get_step_events()

        irq_list = list(self.irqs)
        irq_list.sort()

        irq_diff = ['                step' + ''.join(self.step_names)]
        step_errors = [ [] for i in range(num_steps) ]

        cr50_times = self.get_irq_step_counts(self.KEY_TIME)
        cr50_diffs = []
        for i, cr50_time in enumerate(cr50_times):
            if events[i] == self.INCREASE:
                cr50_time -= cr50_times[i - 1]
            cr50_diffs.append(cr50_time)

        # Go through each irq and update its info in the progress dict
        for irq_key in irq_list:
            name = self.INT_NAME.get(irq_key, 'Unknown')
            irq_progress_str = ['%16s %3s:' % (name, irq_key)]

            irq_counts = self.get_irq_step_counts(irq_key)
            for step, count in enumerate(irq_counts):
                event = events[step]

                # The deep sleep counts are not reset after deep sleep. Change
                # the event to INCREASE.
                if irq_key == self.KEY_DEEP_SLEEP and event == self.DS_RESUME:
                    event = self.INCREASE

                if event == self.INCREASE:
                    count -= irq_counts[step - 1]

                # Check that the count increase is within the expected value.
                if event != self.START:
                    expected_range = self.get_expected_count(irq_key,
                            cr50_diffs[step])

                    rv = self.check_increase(irq_key, name, count,
                            expected_range)
                    if rv:
                        logging.info('Unexpected count for %s %s', state, rv)
                        step_errors[step].append(rv)

                irq_progress_str.append(' %2s %7d' % (event, count))

            irq_diff.append(''.join(irq_progress_str))

        errors = {}

        ds_key = state + self.DEEP_SLEEP_STEP_SUFFIX
        expected_range = self.get_expected_count(ds_key, 0)
        rv = self.check_increase(None, ds_key, events.count(self.DS_RESUME),
                expected_range)
        if rv:
            logging.info('Unexpected count for %s %s', state, rv)
            errors[ds_key] = rv
        for i, step_error in enumerate(step_errors):
            if step_error:
                logging.error('Step %d errors:\n%s', i,
                        pprint.pformat(step_error))
                step = '%s step %d %s' % (state, i, self.step_names[i].strip())
                errors[step] = step_error

        logging.info('DIFF %s IRQ Counts:\n%s', state, pprint.pformat(irq_diff))
        if errors:
            logging.info('ERRORS %s IRQ Counts:\n%s', state,
                    pprint.pformat(errors))
        return errors


    def enter_state(self, state):
        """Get the command to enter the power state"""
        self.stage_irq_add(self.get_irq_counts(), 'start %s' % state)
        if state == 'S0':
            self.servo.power_short_press()
        else:
            if state == 'S0ix':
                full_command = 'echo freeze > /sys/power/state &'
            elif state == 'S3':
                full_command = 'echo mem > /sys/power/state &'
            elif state == 'S5':
                full_command = 'poweroff'
            self.faft_client.system.run_shell_command(full_command)

        time.sleep(self.SHORT_WAIT);
        # check S3 state transition
        if not self.wait_power_state(state, 10):
            raise error.TestFail('Platform failed to reach %s state.' % state)
        self.stage_irq_add(self.get_irq_counts(), 'in %s' % state)


    def stage_irq_add(self, irq_dict, name=''):
        """Add the current irq counts to the stored dictionary of irq info"""
        self.steps.append(irq_dict)
        self.step_names.append('%11s' % name)
        self.irqs.update(irq_dict.keys())


    def reset_irq_counts(self):
        """Reset the test IRQ counts"""
        self.steps = []
        self.step_names = []
        self.irqs = set()


    def run_transition(self, state):
        """Verify there are no Cr50 interrupt storms in the power state.

        Enter the power state, return to S0, and then verify that Cr50 behaved
        correctly.

        Args:
            state: the power state: S0ix, S3, or S5

        Returns:
            A list of errors or an empty list if there were none
        """
        self.reset_irq_counts()

        # Enter the given state
        self.enter_state(state)

        logging.info('waiting %d seconds', self.SLEEP_TIME)
        time.sleep(self.SLEEP_TIME)

        # Return to S0
        self.enter_state('S0')

        # Check that the progress of the irq counts seems reasonable
        return self.check_irq_counts(state)


    def run_once(self, host):
        """Go through S0ix, S3, and S5. Verify there are no interrupt storms"""
        all_errors = []

        # Initialize the Test IRQ counts
        self.reset_irq_counts()

        # Make sure the DUT is in s0
        self.enter_state('S0')

        # Login before entering S0ix so cr50 will be able to enter regular sleep
        client_at = autotest.Autotest(host)
        client_at.run_test('login_LoginSuccess')
        rv = self.run_transition('S0ix')
        if rv:
            all_errors.append(rv)

        # Enter S3
        rv = self.run_transition('S3')
        if rv:
            all_errors.append(rv)

        # Enter S5
        rv = self.run_transition('S5')
        if rv:
            all_errors.append(rv)

        if all_errors:
            raise error.TestFail('Unexpected IRQ counts: %s' % all_errors)
