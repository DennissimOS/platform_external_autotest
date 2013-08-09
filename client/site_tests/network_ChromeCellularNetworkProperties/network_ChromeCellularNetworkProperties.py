# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import dbus
import dbus.types
import logging

from autotest_lib.client.bin import test
from autotest_lib.client.common_lib import error
from autotest_lib.client.cros.cellular.chrome_testing \
        import chrome_networking_test_context as cntc
from autotest_lib.client.cros.cellular.chrome_testing import test_utils
from autotest_lib.client.cros.cellular.pseudomodem import mm1
from autotest_lib.client.cros.cellular.pseudomodem import pseudomodem

class network_ChromeCellularNetworkProperties(test.test):
    """
    This test configures the cellular pseudomodem in various ways and makes sure
    that Service properties exposed by shill are propagated to Chrome. The API
    call that is under test is "chrome.networkingPrivate.getProperties".

    This test uses the pseudomodem to mock out cellular, but it can also be
    extended to other technologies.

    """
    version = 1

    class SimplePropagationTest(object):
        """
        Test class for simple property propagation. This class helps compare
        a read-only network property and a ModemManager property that have a 1:1
        correspondence with each other by setting the ModemManager property to
        a series of values and checking that the UI property value matches
        the expectation.

        An instance of this class takes in a specially formatted dictionary
        that enumerates the corresponding ModemManager and UI property values:

          {
            "properties" : (<MM property>, <UI property>),
            "values" : [
                         ( <MM value 1>, <UI value 1> ),
                         ( <MM value 2>, <UI value 2> ),
                         ( <MM value 3>, <UI value 3> ),
                         ...
                       ]
          }

        The "properties" key maps to a tuple containing the ModemManager
        property and the UI property that are under test. The test will go
        through each of the tuples contained in "values", set the ModemManager
        property to the first value and check that the UI property takes on
        the second value.

        UI properties allow "path expansion by '.'" meaning that a UI property
        will be expanded at the first occurrence of the '.' character to allow
        for nested dictionaries. For example:

            property: "A.B.C"

          corresponds to a UI property dictionary of the form:

            {
              ...
              "A": {
                     ...
                     "B.C": value,
                     ...
                   },
              ...
            }

        This class is called "Simple" because it only applies to properties
        that are read-only and won't cause significant changes such as a
        modem reset or service recreation.

        """

        def __init__(self, chrome_testing_context,
                     property_map,
                     mm_property_interface,
                     dbus_type=None,
                     initial_property_list=None):
            """
            @param chrome_testing_context: Instance of
                    cntc.ChromeNetworkingTestContext.
            @param property_map: Contains the property mapping that will be
                    tested as described in the class docstring.
            @param mm_property_interface: The ModemManager1 D-Bus interface
                    that the property is listed under.
            @param initial_property_list: Optional list of tuples containing
                    ModemManager properties and values that will be assigned
                    before the comparison checks are done.
            @param dbus_type: The dbus.types instance that the property should
                    be converted to, or None if it should be assigned as is.

            """
            self._chrome = chrome_testing_context
            self._property_map = property_map
            self._mm_iface = mm_property_interface
            self._initial_list = initial_property_list
            self._dbus_type = dbus_type


        def _get_modem_proxy(self):
            self._bus = dbus.SystemBus()
            manager = self._bus.get_object(mm1.I_MODEM_MANAGER, mm1.MM1)
            devices = manager.GetManagedObjects(
                    dbus_interface=mm1.I_OBJECT_MANAGER).keys()
            if len(devices) != 1:
                raise error.TestFail(
                        'Expected exactly one modem object, found: '
                        + len(devices))
            return self._bus.get_object(mm1.I_MODEM_MANAGER, devices[0])


        def _find_cellular_network(self):
            """
            Finds the current cellular network. Asserts that it matches the fake
            network from pseudomodem and returns the network.

            """
            networks = self._chrome.find_cellular_networks()
            if len(networks) != 1:
                raise error.TestFail(
                        'Expected 1 cellular network, found ' +
                        str(len(networks)))
            network = networks[0]
            test_utils.simple_network_sanity_check(
                    network,
                    pseudomodem.DEFAULT_TEST_NETWORK_PREFIX,
                    self._chrome.CHROME_NETWORK_TYPE_CELLULAR)
            return network


        def compare(self):
            """
            Runs the property comparison checks.

            """
            # Get a modem proxy. This proxy should remain valid throughout the
            # test.
            self._modem = self._get_modem_proxy()

            # Perform the initial property assignments.
            if self._initial_list:
                for prop, value in self._initial_list:
                    logging.info('Assigning initial property (%s, %s)',
                                 prop, repr(value))
                    self._modem.Set(self._mm_iface, prop, value,
                                    dbus_interface=mm1.I_PROPERTIES)

            # Store the GUID of the fake test network.
            self._network_guid = self._find_cellular_network()['GUID']

            # Run the checks.
            mm_prop, ui_prop = self._property_map['properties']
            logging.info('Testing ModemManager property "%s.%s" against UI '
                         'property "%s".', self._mm_iface, mm_prop, ui_prop)
            for mm_value, ui_value in self._property_map['values']:
                logging.info('Setting ModemManager value to: %s',
                             repr(mm_value))
                if self._dbus_type:
                    mm_value = self._dbus_type(mm_value)
                self._modem.Set(self._mm_iface, mm_prop, mm_value,
                                dbus_interface=mm1.I_PROPERTIES)

                logging.info('Checking UI property: %s', ui_prop)
                test_utils.check_ui_property(
                        self._chrome, self._network_guid,
                        ui_prop, ui_value)


    def _run_once_internal(self):
        name_prefix = pseudomodem.DEFAULT_TEST_NETWORK_PREFIX
        tests = [ self.SimplePropagationTest(
                        self._chrome_testing,
                        { 'properties': ( 'AccessTechnologies',
                                          'Cellular.NetworkTechnology' ),
                          'values': [ ( mm1.MM_MODEM_ACCESS_TECHNOLOGY_LTE,
                                        'LTE'),
                                      ( mm1.MM_MODEM_ACCESS_TECHNOLOGY_EVDO0,
                                        'EVDO' ),
                                      ( mm1.MM_MODEM_ACCESS_TECHNOLOGY_UMTS,
                                        'UMTS' ),
                                      ( mm1.MM_MODEM_ACCESS_TECHNOLOGY_GSM,
                                        'GSM' ) ]
                        },
                        mm1.I_MODEM,
                        dbus.types.UInt32)
                ]

        if self._family == '3GPP':
            tests.extend([
                self.SimplePropagationTest(
                    self._chrome_testing,
                    { 'properties': ( 'OperatorName', 'Name' ),
                      'values': [ ( name_prefix + ' Service 1',
                                    name_prefix + ' Service 1' ),
                                  ( name_prefix + ' Service 2',
                                    name_prefix + ' Service 2' ),
                                  ( name_prefix + ' Service 3',
                                    name_prefix + ' Service 3' ),
                                  ( name_prefix + ' Service 4',
                                    name_prefix + ' Service 4' ) ]
                    },
                    mm1.I_MODEM_3GPP),
                self.SimplePropagationTest(
                    self._chrome_testing,
                    { 'properties': ( 'RegistrationState',
                                      'Cellular.RoamingState' ),
                      'values': [
                              ( mm1.MM_MODEM_3GPP_REGISTRATION_STATE_ROAMING,
                                'roaming' ),
                              ( mm1.MM_MODEM_3GPP_REGISTRATION_STATE_HOME,
                                'home' ) ]
                    },
                    mm1.I_MODEM_3GPP,
                    dbus.types.UInt32)
            ])
        elif self._family == 'CDMA':
            tests.extend([
                self.SimplePropagationTest(
                    self._chrome_testing,
                    { 'properties': ( 'EvdoRegistrationState',
                                      'Cellular.RoamingState' ),
                      'values': [
                              ( mm1.MM_MODEM_CDMA_REGISTRATION_STATE_ROAMING,
                                'roaming' ),
                              ( mm1.MM_MODEM_CDMA_REGISTRATION_STATE_HOME,
                                'home' ) ]
                    },
                    mm1.I_MODEM_CDMA,
                    dbus.types.UInt32,
                    [ ( 'EvdoRegistrationState',
                         dbus.types.UInt32(
                                mm1.MM_MODEM_CDMA_REGISTRATION_STATE_HOME) ),
                      ( 'Cdma1xRegistrationState',
                         dbus.types.UInt32(
                                mm1.MM_MODEM_CDMA_REGISTRATION_STATE_UNKNOWN) )
                    ]),
                self.SimplePropagationTest(
                    self._chrome_testing,
                    { 'properties': ( 'Cdma1xRegistrationState',
                                      'Cellular.RoamingState' ),
                      'values': [
                              ( mm1.MM_MODEM_CDMA_REGISTRATION_STATE_ROAMING,
                                'roaming' ),
                              ( mm1.MM_MODEM_CDMA_REGISTRATION_STATE_HOME,
                                'home' ) ]
                    },
                    mm1.I_MODEM_CDMA,
                    dbus.types.UInt32,
                    [ ( 'Cdma1xRegistrationState',
                         dbus.types.UInt32(
                                mm1.MM_MODEM_CDMA_REGISTRATION_STATE_HOME) ),
                      ( 'EvdoRegistrationState',
                         dbus.types.UInt32(
                                mm1.MM_MODEM_CDMA_REGISTRATION_STATE_UNKNOWN) )
                    ])
            ])
        for test in tests:
            test.compare()


    def run_once(self, family):
        with pseudomodem.TestModemManagerContext(True, family):
            with cntc.ChromeNetworkingTestContext() as testing_context:
                self._family = family
                self._chrome_testing = testing_context
                self._run_once_internal()
