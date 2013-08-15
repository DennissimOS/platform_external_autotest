# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""FAFT config setting overrides for Link."""


class Values(object):
    firmware_screen = 7
    dev_screen = 4
    chrome_ec = True
    long_rec_combo = True
    ec_capability = ['adc_ectemp', 'battery', 'charging',
                     'keyboard', 'lid', 'x86', 'thermal',
                     'usb', 'peci', 'kblight', 'smart_usb_charge']
    wp_voltage = 'pp3300'
