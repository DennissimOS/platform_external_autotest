# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""A module providing the summary for multiple test results.

This firmware_summary module is used to collect the test results of
multiple rounds from the logs generated by different firmware versions.
The test results of the various validators of every gesture are displayed.
In addition, the test results of every validator across all gestures are
also summarized.

Usage:
$ python firmware_summary log_directory


A typical summary output looks like

Test Summary (by gesture)            :  fw_2.41   fw_2.42     count
---------------------------------------------------------------------
one_finger_tracking
  CountTrackingIDValidator           :     1.00      0.90        12
  LinearityBothEndsValidator         :     0.97      0.89        12
  LinearityMiddleValidator           :     1.00      1.00        12
  NoGapValidator                     :     0.74      0.24        12
  NoReversedMotionBothEndsValidator  :     0.68      0.34        12
  NoReversedMotionMiddleValidator    :     1.00      1.00        12
  ReportRateValidator                :     1.00      1.00        12
one_finger_to_edge
  CountTrackingIDValidator           :     1.00      1.00         4
  LinearityBothEndsValidator         :     0.88      0.89         4
  LinearityMiddleValidator           :     1.00      1.00         4
  NoGapValidator                     :     0.50      0.00         4
  NoReversedMotionMiddleValidator    :     1.00      1.00         4
  RangeValidator                     :     1.00      1.00         4

  ...


Test Summary (by validator)          :   fw_2.4  fw_2.4.a     count
---------------------------------------------------------------------
  CountPacketsValidator              :     1.00      0.82         6
  CountTrackingIDValidator           :     0.92      0.88        84

  ...

"""


import getopt
import os
import sys

import firmware_log
import test_conf as conf

from collections import defaultdict

from common_util import print_and_exit
from firmware_constants import OPTIONS
from test_conf import (log_root_dir, merged_validators, segment_weights,
                       validator_weights)
from validators import BaseValidator, get_parent_validators


class OptionsDisplayMetrics:
    """The options of displaying metrics."""
    # Defining the options of displaying metrics
    HIDE_SOME_METRICS_STATS = '0'
    DISPLAY_ALL_METRICS_STATS = '1'
    DISPLAY_ALL_METRICS_WITH_RAW_VALUES = '2'
    DISPLAY_METRICS_OPTIONS = [HIDE_SOME_METRICS_STATS,
                               DISPLAY_ALL_METRICS_STATS,
                               DISPLAY_ALL_METRICS_WITH_RAW_VALUES]
    DISPLAY_METRICS_DEFAULT = DISPLAY_ALL_METRICS_WITH_RAW_VALUES

    def __init__(self, option):
        """Initialize with the level value.

        @param option: the option of display metrics
        """
        if option not in self.DISPLAY_METRICS_OPTIONS:
            option = self.DISPLAY_METRICS_DEFAULT

        # To display all metrics statistics grouped by validators?
        self.display_all_stats = (
                option == self.DISPLAY_ALL_METRICS_STATS or
                option == self.DISPLAY_ALL_METRICS_WITH_RAW_VALUES)

        # To display the raw metrics values in details on file basis?
        self.display_raw_values = (
                option == self.DISPLAY_ALL_METRICS_WITH_RAW_VALUES)


class FirmwareSummary:
    """Summary for touch device firmware tests."""

    def __init__(self, log_dir, display_metrics=False, debug_flag=False,
                 display_scores=False, individual_round_flag=False,
                 segment_weights=segment_weights,
                 validator_weights=validator_weights):
        """ segment_weights and validator_weights are passed as arguments
        so that it is possible to assign arbitrary weights in unit tests.
        """
        if os.path.isdir(log_dir):
            self.log_dir = log_dir
        else:
            error_msg = 'Error: The test result directory does not exist: %s'
            print error_msg % log_dir
            sys.exit(1)

        self.display_metrics = display_metrics
        self.display_scores = display_scores
        self.slog = firmware_log.SummaryLog(log_dir,
                                            segment_weights,
                                            validator_weights,
                                            individual_round_flag,
                                            debug_flag)

    def _print_summary_title(self, summary_title_str):
        """Print the summary of the test results by gesture."""
        # Create a flexible column title format according to the number of
        # firmware versions which could be 1, 2, or more.
        #
        # A typical summary title looks like
        # Test Summary ()          :    fw_11.26             fw_11.23
        #                               mean  ssd  count     mean ssd count
        # ----------------------------------------------------------------------
        #
        # The 1st line above is called title_fw.
        # The 2nd line above is called title_statistics.
        #
        # As an example for 2 firmwares, title_fw_format looks like:
        #     '{0:<37}:  {1:>12}  {2:>21}'
        title_fw_format_list = ['{0:<37}:',]
        for i in range(len(self.slog.fws)):
            format_space = 12 if i == 0 else (12 + 9)
            title_fw_format_list.append('{%d:>%d}' % (i + 1, format_space))
        title_fw_format = ' '.join(title_fw_format_list)

        # As an example for 2 firmwares, title_statistics_format looks like:
        #     '{0:>47} {1:>6} {2:>5} {3:>8} {4:>6} {5:>5}'
        title_statistics_format_list = []
        for i in range(len(self.slog.fws)):
            format_space = (12 + 35) if i == 0 else 8
            title_statistics_format_list.append('{%d:>%d}' % (3 * i,
                                                              format_space))
            title_statistics_format_list.append('{%d:>%d}' % (3 * i + 1 , 6))
            title_statistics_format_list.append('{%d:>%d}' % (3 * i + 2 , 5))
        title_statistics_format = ' '.join(title_statistics_format_list)

        # Create title_fw_list
        # As an example for two firmware versions, it looks like
        #   ['Test Summary (by gesture)', 'fw_2.4', 'fw_2.5']
        title_fw_list = [summary_title_str,] + self.slog.fws

        # Create title_statistics_list
        # As an example for two firmware versions, it looks like
        #   ['mean', 'ssd', 'count', 'mean', 'ssd', 'count', ]
        title_statistics_list = ['mean', 'ssd', 'count'] * len(self.slog.fws)

        # Print the title.
        title_fw = title_fw_format.format(*title_fw_list)
        title_statistics = title_statistics_format.format(
                *title_statistics_list)
        print '\n\n', title_fw
        print title_statistics
        print '-' * len(title_statistics)

    def _print_result_stats(self, gesture=None):
        """Print the result statistics of validators."""
        for validator in self.slog.validators:
            stat_scores_data = []
            statistics_format_list = []
            for fw in self.slog.fws:
                result = self.slog.get_result(fw=fw, gesture=gesture,
                                              validators=validator)
                scores_data = result.stat_scores.all_data
                if scores_data:
                    stat_scores_data += scores_data
                    statistics_format_list.append('{:>8.2f} {:>6.2f} {:>5}')
                else:
                    stat_scores_data.append('')
                    statistics_format_list.append('{:>21}')

            # Print the score statistics of all firmwares on the same row.
            if any(stat_scores_data):
                stat_scores_data.insert(0, validator)
                statistics_format_list.insert(0,'  {:<35}:')
                statistics_format = ' '.join(statistics_format_list)
                print statistics_format.format(*tuple(stat_scores_data))

    def _print_result_stats_by_gesture(self):
        """Print the summary of the test results by gesture."""
        self._print_summary_title('Test Summary (by gesture)')
        for gesture in self.slog.gestures:
            print gesture
            self._print_result_stats(gesture=gesture)

    def _print_result_stats_by_validator(self):
        """Print the summary of the test results by validator. The validator
        results of all gestures are combined to compute the statistics.
        """
        self._print_summary_title('Test Summary (by validator)')
        self._print_result_stats()

    def _get_metric_name_for_display(self, metric_name):
        """Get the metric name for display.
        We would like to shorten the metric name when displayed.

        @param metric_name: a metric name
        """
        return metric_name.split('--')[0]

    def _get_merged_validators(self):
        merged = defaultdict(list)
        for validator_name in self.slog.validators:
            parents = get_parent_validators(validator_name)
            for parent in parents:
                if parent in merged_validators:
                    merged[parent].append(validator_name)
                    break
            else:
                merged[validator_name] = [validator_name,]
        return sorted(merged.values())

    def _print_statistics_of_metrics(self, detailed=True, gesture=None):
        """Print the statistics of metrics by gesture or by validator.

        @param gesture: print the statistics grouped by gesture
                if this argument is specified; otherwise, by validator.
        @param detailed: print statistics for all derived validators if True;
                otherwise, print the merged statistics, e.g.,
                both StationaryFingerValidator and StationaryTapValidator
                are merged into StationaryValidator.
        """
        # Print the complete title which looks like:
        #   <title_str>  <fw1>  <fw2>  ...  <description>
        fws = self.slog.fws
        num_fws = len(fws)
        fws_str_max_width = max(map(len, fws))
        fws_str_width = max(fws_str_max_width + 1, 10)
        table_name = ('Detailed table (for debugging)' if detailed else
                      'Summary table')
        title_str = ('Metrics statistics by gesture: ' + gesture if gesture else
                     'Metrics statistics by validator')
        description_str = 'description (lower is better)'
        fw_format = '{:>%d}' % fws_str_width
        complete_title = ('{:<37}: '.format(title_str) +
                          (fw_format * num_fws).format(*fws) +
                          '  {:<40}'.format(description_str))
        print '\n' * 2
        print table_name
        print complete_title
        print '-' * len(complete_title)

        # Print the metric name and the metric stats values of every firmwares
        name_format = ' ' * 6 + '{:<31}:'
        description_format = ' {:<40}'
        float_format = '{:>%d.2f}' % fws_str_width
        blank_format = '{:>%d}' % fws_str_width

        validators = (self.slog.validators if detailed else
                      self._get_merged_validators())

        for validator in validators:
            fw_stats_values = defaultdict(dict)
            for fw in fws:
                result = self.slog.get_result(fw=fw, gesture=gesture,
                                              validators=validator)
                stat_metrics = result.stat_metrics

                for metric_name in stat_metrics.metrics_values:
                    fw_stats_values[metric_name][fw] = \
                            stat_metrics.stats_values[metric_name]

            fw_stats_values_printed = False
            for metric_name, fw_values_dict in sorted(fw_stats_values.items()):
                values = []
                values_format = ''
                for fw in fws:
                    value = fw_values_dict.get(fw, '')
                    values.append(value)
                    values_format += float_format if value else blank_format

                # The metrics of some special validators will not be shown
                # unless the display_all_stats flag is True or any stats values
                # are non-zero.
                if (validator not in conf.validators_hidden_when_no_failures or
                        self.display_metrics.display_all_stats or any(values)):
                    if not fw_stats_values_printed:
                        fw_stats_values_printed = True
                        if isinstance(validator, list):
                            print (' ' + ' {}' * len(validator)).format(*validator)
                        else:
                            print '  ' + validator
                    disp_name = self._get_metric_name_for_display(metric_name)
                    print name_format.format(disp_name),
                    print values_format.format(*values),
                    print description_format.format(
                            stat_metrics.metrics_props[metric_name].description)

    def _print_raw_metrics_values(self):
        """Print the raw metrics values."""
        # The subkey() below extracts (gesture, variation, round) from
        # metric.key which is (fw, round, gesture, variation, validator)
        subkey = lambda key: (key[2], key[3], key[1])

        # The sum_len() below is used to calculate the sum of the length
        # of the elements in the subkey.
        sum_len = lambda lst: sum([len(str(l)) if l else 0 for l in lst])

        mnprops = firmware_log.MetricNameProps()
        print '\n\nRaw metrics values'
        print '-' * 80
        for fw in self.slog.fws:
            print '\n', fw
            for validator in self.slog.validators:
                result = self.slog.get_result(fw=fw, validators=validator)
                metrics_dict = result.stat_metrics.metrics_dict
                if metrics_dict:
                    print '\n' + ' ' * 3 + validator
                for metric_name, metrics in sorted(metrics_dict.items()):
                    disp_name = self._get_metric_name_for_display(metric_name)
                    print ' ' * 6 + disp_name

                    metric_note = mnprops.metrics_props[metric_name].note
                    if metric_note:
                        msg = '** Note: value below represents '
                        print ' ' * 9 + msg + metric_note

                    # Make a metric value list sorted by
                    #   (gesture, variation, round)
                    value_list = sorted([(subkey(metric.key), metric.value)
                                         for metric in metrics])

                    max_len = max([sum_len(value[0]) for value in value_list])
                    template_prefix = ' ' * 9 + '{:<%d}: ' % (max_len + 5)
                    for (gesture, variation, round), value in value_list:
                        template = template_prefix + (
                                '{}' if isinstance(value, tuple) else '{:.2f}')
                        gvr_str = '%s.%s (%s)' % (gesture, variation, round)
                        print template.format(gvr_str, value)

    def _print_final_weighted_averages(self):
        """Print the final weighted averages of all validators."""
        title_str = 'Test Summary (final weighted averages)'
        print '\n\n' + title_str
        print '-' * len(title_str)
        weighted_average = self.slog.get_final_weighted_average()
        for fw in self.slog.fws:
            print '%s: %4.3f' % (fw, weighted_average[fw])

    def print_result_summary(self):
        """Print the summary of the test results."""
        print self.slog.test_version
        if self.display_metrics:
            self._print_statistics_of_metrics(detailed=False)
            self._print_statistics_of_metrics(detailed=True)
            if self.display_metrics.display_raw_values:
                self._print_raw_metrics_values()
        if self.display_scores:
            self._print_result_stats_by_gesture()
            self._print_result_stats_by_validator()
            self._print_final_weighted_averages()


def _usage_and_exit():
    """Print the usage message and exit."""
    prog = sys.argv[0]
    print 'Usage: $ python %s [options]\n' % prog
    print 'options:'
    print '  -D, --%s' % OPTIONS.DEBUG
    print '        enable debug flag'
    print '  -d, --%s <directory>' % OPTIONS.DIR
    print '        specify which log directory to derive the summary'
    print '  -h, --%s' % OPTIONS.HELP
    print '        show this help'
    print '  -i, --%s' % OPTIONS.INDIVIDUAL
    print '        Calculate statistics of every individual round separately'
    print '  -m, --%s <verbose_level>' % OPTIONS.METRICS
    print '        display the summary metrics.'
    print '        verbose_level:'
    print '          0: hide some metrics statistics if they passed'
    print '          1: display all metrics statistics'
    print '          2: display all metrics statistics and ' \
                        'the detailed raw metrics values (default)'
    print '  -s, --%s' % OPTIONS.SCORES
    print '        display the scores (0.0 ~ 1.0)'
    print
    print 'Examples:'
    print '    Specify the log root directory.'
    print '    $ python %s -d /tmp' % prog
    print '    Hide some metrics statistics.'
    print '    $ python %s -m 0' % prog
    print '    Display all metrics statistics.'
    print '    $ python %s -m 1' % prog
    print '    Display all metrics statistics with detailed raw metrics values.'
    print '    $ python %s         # or' % prog
    print '    $ python %s -m 2' % prog
    sys.exit(1)


def _parsing_error(msg):
    """Print the usage and exit when encountering parsing error."""
    print 'Error: %s' % msg
    _usage_and_exit()


def _parse_options():
    """Parse the options."""
    # Set the default values of options.
    options = {OPTIONS.DEBUG: False,
               OPTIONS.DIR: log_root_dir,
               OPTIONS.INDIVIDUAL: False,
               OPTIONS.METRICS: OptionsDisplayMetrics(None),
               OPTIONS.SCORES: False,
    }

    try:
        short_opt = 'Dd:him:s'
        long_opt = [OPTIONS.DEBUG,
                    OPTIONS.DIR + '=',
                    OPTIONS.HELP,
                    OPTIONS.INDIVIDUAL,
                    OPTIONS.METRICS + '=',
                    OPTIONS.SCORES,
        ]
        opts, args = getopt.getopt(sys.argv[1:], short_opt, long_opt)
    except getopt.GetoptError, err:
        _parsing_error(str(err))

    for opt, arg in opts:
        if opt in ('-h', '--%s' % OPTIONS.HELP):
            _usage_and_exit()
        elif opt in ('-D', '--%s' % OPTIONS.DEBUG):
            options[OPTIONS.DEBUG] = True
        elif opt in ('-d', '--%s' % OPTIONS.DIR):
            options[OPTIONS.DIR] = arg
            if not os.path.isdir(arg):
                print 'Error: the log directory %s does not exist.' % arg
                _usage_and_exit()
        elif opt in ('-i', '--%s' % OPTIONS.INDIVIDUAL):
            options[OPTIONS.INDIVIDUAL] = True
        elif opt in ('-m', '--%s' % OPTIONS.METRICS):
            options[OPTIONS.METRICS] = OptionsDisplayMetrics(arg)
        elif opt in ('-s', '--%s' % OPTIONS.SCORES):
            options[OPTIONS.SCORES] = True
        else:
            msg = 'This option "%s" is not supported.' % opt
            _parsing_error(opt)

    return options


if __name__ == '__main__':
    options = _parse_options()
    summary = FirmwareSummary(options[OPTIONS.DIR],
                              display_metrics=options[OPTIONS.METRICS],
                              individual_round_flag=options[OPTIONS.INDIVIDUAL],
                              display_scores=options[OPTIONS.SCORES],
                              debug_flag=options[OPTIONS.DEBUG])
    summary.print_result_summary()
