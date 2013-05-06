# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import dbus

from autotest_lib.client.bin import utils
from autotest_lib.client.cros import constants

def connect():
    """Create and return a DBus connection to session_manager.

    Connects to the session manager over the DBus system bus.  Returns
    appropriately configured DBus interface object.

    @return a dbus.Interface object connection to the session_manager.
    """
    bus = dbus.SystemBus()
    proxy = bus.get_object('org.chromium.SessionManager',
                           '/org/chromium/SessionManager')
    return dbus.Interface(proxy, 'org.chromium.SessionManagerInterface')


class SignalListener(object):
    """A class to listen for ownership-related DBus signals.

    The session_manager emits a couple of DBus signals when certain events
    related to device ownership occur.  This class provides a way to
    listen for them and check on their status.
    """
    _got_new_key = False
    _got_new_policy = False
    _main_loop = None

    def __init__(self, g_main_loop):
        """Constructor

        @param g_mail_loop: glib main loop object.
        """
        self._main_loop = g_main_loop


    def listen_for_new_key_and_policy(self):
        """Set to listen for signals indicating new owner key and device policy.
        """
        self.__listen_to_signal(self.__handle_new_key, 'SetOwnerKeyComplete')
        self.__listen_to_signal(self.__handle_new_policy,
                                'PropertyChangeComplete')


    def wait_for_signals(self, desc,
                         timeout=constants.DEFAULT_OWNERSHIP_TIMEOUT):
        """Block for |timeout| seconds waiting for the signals to come in.

        @param desc: string describing the high-level reason you're waiting
                     for the signals.
        @param timeout: maximum seconds to wait for the signals.

        @raises TimeoutError if the timeout is hit.
        """
        utils.poll_for_condition(
            condition=lambda: self.__received_signals(),
            desc='Initial policy push complete.',
            timeout=constants.DEFAULT_OWNERSHIP_TIMEOUT)
        self.__reset_signal_state()

    def __received_signals(self):
        """Run main loop until all pending events are done, checks for signals.

        Runs self._main_loop until it says it has no more events pending,
        then returns the state of the internal variables tracking whether
        desired signals have been received.

        @return True if both signals have been handled, False otherwise.
        """
        context = self._main_loop.get_context()
        while context.iteration(False):
            pass
        return self._got_new_key and self._got_new_policy


    def __reset_signal_state(self):
        """Resets internal signal tracking state."""
        self._got_new_policy = self._got_new_key = False


    def __listen_to_signal(self, callback, signal):
        """Connect a callback to a given session_manager dbus signal.

        Sets up a signal receiver for signal, and calls the provided callback
        when it comes in.

        @param callback: a callable to call when signal is received.
        @param signal: the signal to listen for.
        """
        bus = dbus.SystemBus()
        bus.add_signal_receiver(
            handler_function=callback,
            signal_name=signal,
            dbus_interface='org.chromium.Chromium',
            bus_name=None,
            path='/org/chromium/SessionManager')


    def __handle_new_key(self, success):
        """Callback to be used when a new key signal is received."""
        self._got_new_key = (success == 'success')


    def __handle_new_policy(self, success):
        """Callback to be used when a new policy signal is received."""
        self._got_new_policy = (success == 'success')
