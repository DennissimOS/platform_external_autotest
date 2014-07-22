# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import glob
import logging
import os
import re
import shutil
import tempfile

from autotest_lib.client.bin import test, utils
from autotest_lib.client.common_lib import error

class security_Minijail0(test.test):
    version = 1


    def is_64bit(self):
        return os.path.isdir('/lib64')


    def get_test_option(self, handle, name):
        setup = ''
        for l in handle.readlines():
            m = re.match('^# %s: (.*)' % name, l.strip())
            if m:
                setup = m.group(1)
        return setup


    def run_test(self, path, static):
        # Tests are shell scripts with a magic comment line of the form '# args:
        # <stuff>' in them. The <stuff> is substituted in here as minijail0
        # arguments. They can also optionally contain a magic comment of the
        # form '# setup: <stuff>', in which case <stuff> is executed as a shell
        # command before running the test.
        #
        # If '%T' is present in either of the above magic comments, a temporary
        # directory is created, and its name is substituted for '%T' in both of
        # them.
        # If '%S' is present in either of the above magic comments, it is
        # replaced with src folder of these tests.
        args = self.get_test_option(file(path), 'args')
        setup = self.get_test_option(file(path), 'setup')
        args64 = self.get_test_option(file(path), 'args64')
        args32 = self.get_test_option(file(path), 'args32')
        td = None
        if setup:
            if '%T' in setup:
                td = tempfile.mkdtemp()
                setup = setup.replace('%T', td)
            if '%S' in setup:
                setup = setup.replace('%S', self.srcdir)
            utils.system(setup)

        if self.is_64bit() and args64:
            args = args + ' ' + args64

        if (not self.is_64bit()) and args32:
            args = args + ' ' + args32

        if '%T' in args:
            td = td or tempfile.mkdtemp()
            args = args.replace('%T', td)
        if '%S' in args:
            args = args.replace('%S', self.srcdir)

        if static:
            ret = utils.system('/sbin/minijail0 %s %s/staticbashexec %s'
                                % (args, self.srcdir, path),
                                ignore_status=True)
        else:
            ret = utils.system('/sbin/minijail0 %s /bin/bash %s'
                                % (args, path),
                                ignore_status=True)
        if td:
            # The test better not have polluted our mount namespace :).
            shutil.rmtree(td)
        return ret


    def setup(self):
        os.chdir(self.srcdir)
        utils.make()


    def run_once(self):
        failed = []
        ran = 0
        for p in glob.glob('%s/test-*' % self.srcdir):
            name = os.path.basename(p)
            logging.info('Running: %s', name)
            if self.run_test(p, static=False):
                failed.append(name)
            ran += 1
            if name != 'test-caps':
                if self.run_test(p, static=True):
                    failed.append(name + ' static')
                ran += 1
        if ran == 0:
            failed.append("No tests found to run from %s!" % (self.srcdir))
        if failed:
            logging.error('Failed: %s', failed)
            raise error.TestFail('Failed: %s' % failed)
