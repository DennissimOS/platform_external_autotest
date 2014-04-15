# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import logging
import re

from autotest_lib.client.bin import utils
from autotest_lib.client.common_lib import error
from autotest_lib.client.common_lib.cros.network import netblock

class Interface:
    """Interace is a class that contains the queriable address properties
    of an network device.
    """
    ADDRESS_TYPE_MAC = 'link/ether'
    ADDRESS_TYPE_IPV4 = 'inet'
    ADDRESS_TYPE_IPV6 = 'inet6'
    ADDRESS_TYPES = [ ADDRESS_TYPE_MAC, ADDRESS_TYPE_IPV4, ADDRESS_TYPE_IPV6 ]

    INTERFACE_NAME_ETHERNET = 'eth0'  # Assume this is `the` ethernet interface.


    @staticmethod
    def get_connected_ethernet_interface(ignore_failures=False):
        """Get an interface object representing a connected ethernet device.

        Raises an exception if no such interface exists.

        @param ignore_failures bool function will return None instead of raising
                an exception on failures.
        @return an Interface object except under the conditions described above.

        """
        # Assume that ethernet devices are called ethX until proven otherwise.
        for device_name in ['eth%d' % i for i in range(5)]:
            ethernet_if = Interface(device_name)
            if ethernet_if.exists and ethernet_if.ipv4_address:
                return ethernet_if

        else:
            if ignore_failures:
                return None

            raise error.TestFail('Failed to find ethernet interface.')


    def __init__(self, name, host=None):
        self._name = name
        self._run = utils.run
        if host is not None:
            self._run = host.run


    @property
    def name(self):
        """@return name of the interface (e.g. 'wlan0')."""
        return self._name


    @property
    def addresses(self):
        """@return the addresses (MAC, IP) associated with interface."""
        # "ip addr show %s 2> /dev/null" returns something that looks like:
        #
        # 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
        #    link/ether ac:16:2d:07:51:0f brd ff:ff:ff:ff:ff:ff
        #    inet 172.22.73.124/22 brd 172.22.75.255 scope global eth0
        #    inet6 2620:0:1000:1b02:ae16:2dff:fe07:510f/64 scope global dynamic
        #       valid_lft 2591982sec preferred_lft 604782sec
        #    inet6 fe80::ae16:2dff:fe07:510f/64 scope link
        #       valid_lft forever preferred_lft forever
        #
        # We extract the second column from any entry for which the first
        # column is an address type we are interested in.  For example,
        # for "inet 172.22.73.124/22 ...", we will capture "172.22.73.124/22".
        try:
            result = self._run('ip addr show %s 2> /dev/null' % self._name)
            address_info = result.stdout
        except error.CmdError, e:
            # The "ip" command will return non-zero if the interface does
            # not exist.
            return {}

        addresses = {}
        for address_line in address_info.splitlines():
            address_parts = address_line.lstrip().split()
            if len(address_parts) < 2:
                continue
            address_type, address_value = address_parts[:2]
            if address_type in self.ADDRESS_TYPES:
                if address_type not in addresses:
                    addresses[address_type] = []
                addresses[address_type].append(address_value)
        return addresses


    @property
    def exists(self):
        """@return True if this interface exists, False otherwise."""
        # No valid interface has no addresses at all.
        return bool(self.addresses)


    @property
    def mac_address(self):
        """@return the (first) MAC address, e.g., "00:11:22:33:44:55"."""
        return self.addresses.get(self.ADDRESS_TYPE_MAC, [None])[0]


    @property
    def ipv4_address_and_prefix(self):
        """@return the IPv4 address/prefix, e.g., "192.186.0.1/24"."""
        return self.addresses.get(self.ADDRESS_TYPE_IPV4, [None])[0]


    @property
    def ipv4_address(self):
        """@return the (first) IPv4 address, e.g., "192.168.0.1"."""
        netblock_addr = self.netblock
        return netblock_addr.addr if netblock_addr else None


    @property
    def ipv4_prefix(self):
        """@return the IPv4 address prefix e.g., 24."""
        addr = self.netblock
        return addr.prefix_len if addr else None


    @property
    def ipv4_subnet(self):
        """@return string subnet of IPv4 address (e.g. '192.168.0.0')"""
        addr = self.netblock
        return addr.subnet if addr else None


    @property
    def ipv4_subnet_mask(self):
        """@return the IPv4 subnet mask e.g., "255.255.255.0"."""
        addr = self.netblock
        return addr.netmask if addr else None


    def is_wifi_device(self):
        """@return True if iw thinks this is a wifi device."""
        if self._run('iw dev %s info' % self._name,
                     ignore_status=True).exit_status:
            logging.debug('%s does not seem to be a wireless device.',
                          self._name)
            return False
        return True


    @property
    def netblock(self):
        """Return Netblock object for this interface's IPv4 address.

        @return Netblock object (or None if no IPv4 address found).

        """
        netblock_str = self.ipv4_address_and_prefix
        return netblock.Netblock(netblock_str) if netblock_str else None


    @property
    def signal_level(self):
        """Get the signal level for an interface.

        This is currently only defined for WiFi interfaces.

        localhost test # iw dev mlan0 link
        Connected to 04:f0:21:03:7d:b2 (on mlan0)
                SSID: Perf_slvf0_ch36
                freq: 5180
                RX: 699407596 bytes (8165441 packets)
                TX: 58632580 bytes (9923989 packets)
                signal: -54 dBm
                tx bitrate: 130.0 MBit/s MCS 15

                bss flags:
                dtim period:    2
                beacon int:     100

        @return signal level in dBm (a negative, integral number).

        """
        if not self.is_wifi_device():
            return None

        result_lines = self._run('iw dev %s link' %
                                 self._name).stdout.splitlines()
        signal_pattern = re.compile('signal:\s+([-0-9]+)\s+dbm')
        for line in result_lines:
            cleaned = line.strip().lower()
            match = re.search(signal_pattern, cleaned)
            if match is not None:
                return int(match.group(1))

        logging.error('Failed to find signal level for %s.', self._name)
        return None


    def noise_level(self, frequency_mhz):
        """Get the noise level for an interface at a given frequency.

        This is currently only defined for WiFi interfaces.

        This only works on some devices because 'iw survey dump' (the method
        used to get the noise) only works on some devices.  On other devices,
        this method returns None.

        @param frequency_mhz: frequency at which the noise level should be
               measured and reported.
        @return noise level in dBm (a negative, integral number) or None.

        """
        if not self.is_wifi_device():
            return None

        # This code has to find the frequency and then find the noise
        # associated with that frequency because 'iw survey dump' output looks
        # like this:
        #
        # localhost test # iw dev mlan0 survey dump
        # ...
        # Survey data from mlan0
        #     frequency:              5805 MHz
        #     noise:                  -91 dBm
        #     channel active time:    124 ms
        #     channel busy time:      1 ms
        #     channel receive time:   1 ms
        #     channel transmit time:  0 ms
        # Survey data from mlan0
        #     frequency:              5825 MHz
        # ...

        result_lines = self._run('iw dev %s survey dump' %
                                 self._name).stdout.splitlines()
        my_frequency_pattern = re.compile('frequency:\s*%d mhz' %
                                          frequency_mhz)
        any_frequency_pattern = re.compile('frequency:\s*\d{4} mhz')
        inside_desired_frequency_block = False
        noise_pattern = re.compile('noise:\s*([-0-9]+)\s+dbm')
        for line in result_lines:
            cleaned = line.strip().lower()
            if my_frequency_pattern.match(cleaned):
                inside_desired_frequency_block = True
            elif inside_desired_frequency_block:
                match = noise_pattern.match(cleaned)
                if match is not None:
                    return int(match.group(1))
                if any_frequency_pattern.match(cleaned):
                    inside_desired_frequency_block = False

        logging.error('Failed to find noise level for %s at %d MHz.',
                      self._name, frequency_mhz)
        return None
