# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""FAFT config setting overrides for Pit."""


class Values(object):
    self.chrome_ec = True
    self.ec_capability = (['battery', 'keyboard', 'arm', 'lid'])
