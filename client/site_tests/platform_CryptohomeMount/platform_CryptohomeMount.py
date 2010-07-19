# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import logging
import os
import re
import shutil

from autotest_lib.client.bin import test
from autotest_lib.client.common_lib import error, utils

class platform_CryptohomeMount(test.test):
    version = 1

    def __run_cmd(self, cmd):
        result = utils.system_output(cmd + ' 2>&1', retain_output=True,
                                     ignore_status=True)
        return result


    def run_once(self):
        test_user = 'this_is_a_local_test_account@chromium.org';
        test_password = 'this_is_a_test_password';
        # Get the hash for the test user account
        cmd = ('/usr/sbin/cryptohome --action=obfuscate_user --user='
               + test_user)
        result = self.__run_cmd(cmd).strip()
        values = result.rsplit(' ', 1)
        user_hash = values[1]

        # Remove the test user account
        cmd = ('/usr/sbin/cryptohome --action=remove --force --user='
               + test_user)
        self.__run_cmd(cmd)
        # Ensure that the user directory does not exist
        if os.path.exists('/home/.shadow/' + user_hash):
          raise error.TestFail('Cryptohome could not remove the test user.')

        # Mount the test user account
        cmd = ('/usr/sbin/cryptohome --action=mount --user=' + test_user
               + ' --password=' + test_password)
        self.__run_cmd(cmd)
        # Ensure that the user directory exists
        if not os.path.exists('/home/.shadow/' + user_hash):
          raise error.TestFail('Cryptohome could not create the test user.')
        # Ensure that the user directory is mounted
        cmd = ('/usr/sbin/cryptohome --action=is_mounted')
        if (self.__run_cmd(cmd).strip() == '0'):
          raise error.TestFail('Cryptohome created the user but did not mount.')

        # Unmount the directory
        cmd = ('/usr/sbin/cryptohome --action=unmount')
        self.__run_cmd(cmd)
        # Ensure that the user directory is not mounted
        cmd = ('/usr/sbin/cryptohome --action=is_mounted')
        if (self.__run_cmd(cmd).strip() != '0'):
          raise error.TestFail('Cryptohome did not unmount the user.')

        # Make sure that an incorrect password fails
        incorrect_password = 'this_is_an_incorrect_password'
        cmd = ('/usr/sbin/cryptohome --action=mount --user=' + test_user
               + ' --password=' + incorrect_password)
        self.__run_cmd(cmd)
        # Ensure that the user directory is not mounted
        cmd = ('/usr/sbin/cryptohome --action=is_mounted')
        if (self.__run_cmd(cmd).strip() != '0'):
          raise error.TestFail('Cryptohome mounted with a bad password.')

        # Remove the test user account
        cmd = ('/usr/sbin/cryptohome --action=remove --force --user='
               + test_user)
        self.__run_cmd(cmd)
