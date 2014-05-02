# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Handle google gdata spreadsheet service."""


from optparse import OptionParser
import glob
import os
import shutil
import subprocess
import tempfile

import gdata.gauth
import gdata.spreadsheets.client

from authenticator import SpreadsheetAuthorizer
import mtb
import test_conf as conf

from common_util import print_and_exit
from firmware_constants import GV


# Skip operations about the Summary worksheet.
# There are two tables in the worksheet. But it seems that there are problems
# with table operations in the new Google Sheets for present.
skip_summary_flag = True


SHEET_DESCRIPTION = ('This sheet is autogenerated from autotest/client/'
                     'site_tests/firmware_TouchMTB/spreadsheet.py')

# Old Google Spreadsheet that suffered from 400K cells limit.
# Leave it here for reference.
# 'Touchpad relative pressure readings' spreadsheet key which is copied from the
# url of the spreadsheet https://docs.google.com/a/google.com/spreadsheet/ccc?
# key=0Ah6uZRmm2hgYdG4wX0JaQkVqa2gybTQwMnRfNmxsR1E

# New style Google Spreadsheet: cells limit is 2 million.
# 'Touchpad relative pressure readings (new Google Sheets)' spreadsheet key
# which is copied from the url of the spreadsheet
# https://docs.google.com/a/google.com/spreadsheets/d/1kE2lhfjTiq5o7Z5DqnJhMXrGbfUSa1rXbfhKopdIrYc/
TARGET_SPREADSHEET_KEY = '1kE2lhfjTiq5o7Z5DqnJhMXrGbfUSa1rXbfhKopdIrYc'

RESULTS = ['result:', '=B4*I5+J5', '=C4*I5+J5', '=D4*I5+J5', '=E4*I5+J5',
           '=F4*I5+J5', '=G4*I5+J5', '=H4*I5+J5']
ACTUALS = ['actual:', '11.945895975', '25.517564775', '46.566217775',
           '76.976808975', '107.513063775', '151.746650975', '248.8453439']
AVERAGES = ['mean:', '=AVERAGE(B6:B405)', '=AVERAGE(C6:C405)',
            '=AVERAGE(D6:D405)', '=AVERAGE(E6:E405)', '=AVERAGE(F6:F405)',
            '=AVERAGE(G6:G405)', '=AVERAGE(H6:H405)', 'slope:', 'icept']
HEADERS = ['', 'size0', 'size1', 'size2', 'size3', 'size4', 'size5', 'size6',
           '=transpose(Regress(B4:F4,B3:F3))']

MEASURED = ['H4', 'G4', 'F4', 'E4', 'D4', 'C4', 'B4']
COMPUTED = ['H2', 'G2', 'F2', 'E2', 'D2', 'C2', 'B2']

SLOPE_CELL = (5, 9)
INTERCEPT_CELL = (5, 10)

CELLS = [
  RESULTS,
  ACTUALS,
  AVERAGES,
  HEADERS
]

CROSS_SHEET_CELL = '=\'%s\'!%s'
SUMMARY_WORKSHEET_TITLE = 'Summary'
TABLE_COMPUTED = 'Computed Pressures'
TABLE_MEASURED = 'Measured Pressures'

options = None
ACTUAL_SURFACE_AREA = [ '11.945895975', '25.517564775', '46.566217775',
                        '76.976808975', '107.513063775', '151.746650975',
                        '248.8453439' ]
results_table = { 'A': 'device', 'B': 'size6', 'C': 'size5', 'D': 'size4',
                  'E': 'size3', 'F': 'size2', 'G': 'size1', 'H': 'size0' }
surface_title = [ 'surface area', '248.8453439', '151.746650975',
                  '107.513063775', '76.976808975', '46.566217775',
                  '25.517564775', '11.945895975' ]
diameter_title = [ 'diameter (mm)', '17.8', '13.9', '11.7', '9.9', '7.7',
                   '5.7', '3.9']

def print_verbose(msg):
    """Print the message if options.verbose is True.

    @param msg: the message to print
    """
    if options.verbose:
        print msg


class GestureEventFiles:
    """Get gesture event files and parse the pressure values."""
    DEFAULT_RESULT_DIR = 'latest'
    FILE_PATTERN = '{}.%s*.dat'.format(conf.PRESSURE_CALIBRATION)
    PRESSURE_LIST_MAX_SIZE = 80 * 5

    def __init__(self):
        self._get_machine_ip()
        self._get_result_dir()
        self._get_gesture_event_files()
        self._get_event_pressures()
        self._get_list_of_pressure_dicts()

    def __del__(self):
        self._cleanup()

    def _cleanup(self):
        """Remove the temporary directory that holds the gesture event files."""
        if os.path.isdir(self.event_dir):
            print 'Removing tmp directory "%s" .... ' % self.event_dir
            try:
                shutil.rmtree(self.event_dir)
            except Exception as e:
                msg = 'Error in removing tmp directory ("%s"): %s'
                print_and_exit(msg % (self.event_dir, e))

    def _cleanup_and_exit(self, err_msg):
        """Clean up and exit with the error message.

        @param err_msg: the error message to print
        """
        self._cleanup()
        print_and_exit(err_msg)

    def _get_machine_ip(self):
        """Get the ip address of the chromebook machine."""
        if options.device:
            self.machine_ip = options.device
            return
        msg = '\nEnter the ip address (xx.xx.xx.xx) of the chromebook machine: '
        self.machine_ip = raw_input(msg)

    def _get_result_dir(self):
        """Get the test result directory located in the chromebook machine."""
        if not options.result_dir:
            print '\nEnter the test result directory located in the machine.'
            print 'It is a directory under %s' % conf.log_root_dir
            print ('If you have just performed the pressure calibration test '
                   'on the machine,\n' 'you could just press ENTER to use '
                   'the default "latest" directory.')
            result_dir = raw_input('Enter test result directory: ')
            if result_dir == '':
                result_dir = self.DEFAULT_RESULT_DIR
        else:
            result_dir = options.result_dir
        self.result_dir = os.path.join(conf.log_root_dir, result_dir)

    def _get_gesture_event_files(self):
        """Scp the gesture event files in the result_dir in machine_ip."""
        try:
            self.event_dir = tempfile.mkdtemp(prefix='touch_firmware_test_')
        except Exception as e:
            err_msg = 'Error in creating tmp directory (%s): %s'
            self._cleanup_and_exit(err_msg % (self.event_dir, e))

        # Try to scp the gesture event files from the chromebook machine to
        # the event_dir created above on the host.
        # An example gesture event file looks like
        #   pressure_calibration.size0-lumpy-fw_11.27-calibration-20130307.dat
        filepath = os.path.join(self.result_dir, self.FILE_PATTERN % '')
        cmd = 'scp root@%s:%s %s' % (self.machine_ip, filepath, self.event_dir)
        try:
            print ('scp gesture event files from "machine_ip:%s" to %s\n' %
                   (self.machine_ip, self.event_dir))
            subprocess.call(cmd.split())
        except subprocess.CalledProcessError as e:
            self._cleanup_and_exit('Error in executing "%s": %s' % (cmd, e))

    def _get_event_pressures(self):
        """Parse the gesture event files to get the pressure values."""
        self.pressures = {}
        self.len_pressures = {}
        for s in GV.SIZE_LIST:
            # Get the gesture event file for every finger size.
            filepath = os.path.join(self.event_dir, self.FILE_PATTERN % s)
            event_files = glob.glob(filepath)
            if not event_files:
                err_msg = 'Error: there is no gesture event file for size %s'
                self._cleanup_and_exit(err_msg % s)

            # Use the latest event file for the size if there are multiple ones.
            event_files.sort()
            event_file = event_files[-1]

            # Get the list of pressures in the event file.
            mtb_packets = mtb.get_mtb_packets_from_file(event_file)
            target_slot = 0
            list_z = mtb_packets.get_slot_data(target_slot, 'pressure')
            len_z = len(list_z)
            if self.PRESSURE_LIST_MAX_SIZE > len_z:
                bgn_index = 0
                end_index = len_z
            else:
                # Get the middle segment of the list of pressures.
                bgn_index = (len_z - self.PRESSURE_LIST_MAX_SIZE) / 2
                end_index = (len_z + self.PRESSURE_LIST_MAX_SIZE) / 2
            self.pressures[s] = list_z[bgn_index : end_index]
            self.len_pressures[s] = len(self.pressures[s])

    def _get_list_of_pressure_dicts(self):
        """Get a list of pressure dictionaries."""
        self.list_of_pressure_dicts = []
        for index in range(max(self.len_pressures.values())):
            pressure_dict = {}
            for s in GV.SIZE_LIST:
                if index < self.len_pressures[s]:
                    pressure_dict[s] = str(self.pressures[s][index])
            self.list_of_pressure_dicts.append(pressure_dict)
            print_verbose('      row %4d: %s' % (index, str(pressure_dict)))

class PressureSpreadsheet(object):
    """A spreadsheet class to perform pressures calibration in worksheets."""
    WORKSHEET_ROW_COUNT = 1000
    WORKSHEET_COL_COUNT = 20
    START_ROW_NUMBER = 2
    DATA_BEGIN_COLUMN = 2
    COMPUTED_TABLE_ROW = 12
    MEASURED_TABLE_ROW = 3

    def __init__(self, worksheet_title):
        """Initialize the spreadsheet and the worksheet

        @param spreadsheet_title: the spreadsheet title
        @param worksheet_title: the worksheet title
        """
        self.computed_table = None
        self.feed = None
        self.measured_table = None
        self.number_records = 0
        self.spreadsheet_key = TARGET_SPREADSHEET_KEY
        self.ss_client = gdata.spreadsheets.client.SpreadsheetsClient()
        self.summary_feed = None
        self.worksheet_title = worksheet_title
        authorizer = SpreadsheetAuthorizer()
        if not authorizer.authorize(self.ss_client):
            raise "Please check the access permission of the spreadsheet"
        self._get_new_worksheet_by_title(worksheet_title)
        if not skip_summary_flag:
            self._get_summary_tables()

    def _get_worksheet_entry_by_title(self, worksheet_title):
        """Check if the worksheet title exists?"""
        worksheet_feed = self.ss_client.get_worksheets(self.spreadsheet_key)
        for entry in worksheet_feed.entry:
            if entry.title.text == worksheet_title:
                return entry
        return None

    def _get_new_worksheet_by_title(self, worksheet_title,
                                    row_count=WORKSHEET_ROW_COUNT,
                                    col_count=WORKSHEET_COL_COUNT):
        """Create a new worksheet using the title.

        If the worksheet title already exists, using a new title name such as
        "Copy n of title", where n = 2, 3, ..., MAX_TITLE_DUP + 1

        @param title: the worksheet title
        @param row_count: the number of rows in the worksheet
        @param col_count: the number of columns in the worksheet

        """
        MAX_TITLE_DUP = 10
        new_worksheet_title = worksheet_title
        for i in range(2, MAX_TITLE_DUP + 2):
            if not self._get_worksheet_entry_by_title(new_worksheet_title):
                break
            new_worksheet_title = 'Copy %d of %s' % (i, worksheet_title)
            self.worksheet_title = new_worksheet_title
        else:
            msg = 'Too many duplicate copies of the worksheet title: %s.'
            print_and_exit(msg % worksheet_title)

        # Add the new worksheet and get the worksheet_id.
        worksheet_entry = self.ss_client.add_worksheet(self.spreadsheet_key,
                                                       new_worksheet_title,
                                                       row_count,
                                                       col_count)
        worksheet_id = worksheet_entry.get_worksheet_id()
        self.feed = gdata.spreadsheets.data.build_batch_cells_update(
                    self.spreadsheet_key, worksheet_id)
        self.feed.add_set_cell(1, 1, SHEET_DESCRIPTION)


    def _insert_pressure_data(self, list_of_pressure_dicts):
        """Insert the lists of pressures of all finger sizes to a worksheet.

        @param list_of_pressure_dicts: a list of pressure dictionaries
        """
        # Set column headers for figner sizes
        for row in range(len(CELLS)):
            for column in range(len(CELLS[row])):
                self.feed.add_set_cell(self.START_ROW_NUMBER + row,
                                       column + 1,
                                       CELLS[row][column])

        # Insert the pressures row by row
        row = self.START_ROW_NUMBER + len(CELLS)
        for pressure_dict in list_of_pressure_dicts:
            print_verbose('      %s' % str(pressure_dict))
            col = self.DATA_BEGIN_COLUMN
            for size in GV.SIZE_LIST:
                if size in pressure_dict:
                    self.feed.add_set_cell(row, col, pressure_dict[size])
                col = col + 1
            row = row + 1

    def _insert_summary_record(self, table, row_source):
        """ Paste a record into measured/computed table in summary sheet from
            a row in source sheet.

        Append one record in the table first as the gdata api does not allow
        formula in the record data for add_record(). In other word, we have
        to fill data with add_set_cell() one-by-one instead.

        @param table: Target table entry
        @param row_source: row in source sheet
        """
        record = { 'device' : self.worksheet_title }
        self.ss_client.add_record(self.spreadsheet_key,
                                  table.get_table_id(),
                                  record)
        row_target = int(table.data.start_row) + int(table.data.num_rows)
        # As there will be one record inserted measured table, we need to
        # increase the row number by one for computed_table
        if table == self.computed_table:
            row_target = row_target + 1
        for i in range(len(row_source)):
            formula = CROSS_SHEET_CELL % (self.worksheet_title, row_source[i])
            self.summary_feed.add_set_cell(row_target,
                                           i + 2,
                                           formula)

    def insert_pressures_to_worksheet(self, list_of_pressure_dicts):
        """Insert the lists of pressures of all finger sizes to a new worksheet.

        @param list_of_pressure_dicts: a list of pressure dictionaries
        """
        self.number_records = len(list_of_pressure_dicts)
        print 'Insert the data to device worksheet...'
        self._insert_pressure_data(list_of_pressure_dicts)

        print 'Finalizing the insertion...'
        self.ss_client.batch(self.feed, force=True)

        if not skip_summary_flag:
            print 'Insert the data to summary worksheet...'
            self._insert_summary_record(self.computed_table, COMPUTED)
            self._insert_summary_record(self.measured_table, MEASURED)
            print 'Finalizing the insertion...'
            self.ss_client.batch(self.summary_feed, force=True)

    def _get_summary_table(self, title, header_row, start_row):
        """Insert the lists of pressures of all finger sizes to a new worksheet.

        @param title: Title of the table
        @param header_row: Row of the header in the table
        @param start_row: starting row of data in the table
        """
        tables = self.ss_client.get_tables(self.spreadsheet_key)
        for table in tables.entry:
            if table.title.text == title:
                return table
        # table is not created yet
        table = self.ss_client.add_table(self.spreadsheet_key,
                                         title,
                                         title,
                                         SUMMARY_WORKSHEET_TITLE,
                                         header_row,
                                         0,
                                         start_row,
                                         gdata.spreadsheets.data.INSERT_MODE,
                                         results_table)
        # add additional table descriptions
        if title == 'Computed Pressures':
            row = self.COMPUTED_TABLE_ROW - 1
            for col in range(len(surface_title)):
                self.summary_feed.add_set_cell(row, col + 1, surface_title[col])
            for col in range(len(diameter_title)):
                self.summary_feed.add_set_cell(row + 1, col + 1,
                                               diameter_title[col])
        return table

    def _delete_nonexist_table(self, title):
        """Remove the nonexist table entries.

        @param title: Title of the table
        """
        tables = self.ss_client.get_tables(self.spreadsheet_key)
        for table in tables.entry:
            if table.title.text == title:
                self.ss_client.delete(table)

    def _get_summary_tables(self):
        """Insert the results of all finger sizes to summary worksheet."""
        entry = self._get_worksheet_entry_by_title(SUMMARY_WORKSHEET_TITLE)
        if not entry:
            self._delete_nonexist_table(TABLE_MEASURED)
            self._delete_nonexist_table(TABLE_COMPUTED)
            entry = self.ss_client.add_worksheet(self.spreadsheet_key,
                                                 SUMMARY_WORKSHEET_TITLE,
                                                 self.WORKSHEET_ROW_COUNT,
                                                 self.WORKSHEET_COL_COUNT)
        self.summary_feed = gdata.spreadsheets.data.build_batch_cells_update(
                            self.spreadsheet_key, entry.get_worksheet_id())
        table_row = self.MEASURED_TABLE_ROW
        self.measured_table = self._get_summary_table(TABLE_MEASURED,
                                                      table_row,
                                                      table_row + 1)
        table_row = self.COMPUTED_TABLE_ROW
        self.computed_table = self._get_summary_table(TABLE_COMPUTED,
                                                      table_row,
                                                      table_row + 1)

def get_worksheet_title():
    """Get the worksheet title."""
    worksheet_title = ''
    if options.name:
        return options.name
    while not worksheet_title:
        print '\nInput the name of the new worksheet to insert the events.'
        print ('This is usually the board name with the firmware version, '
               'e.g., Lumpy 11.27')
        worksheet_title = raw_input('Input the new worksheet name: ')
    return worksheet_title

def print_slope_intercept(worksheet_title):
    """read calibration data from worksheet and print it on command line

    @param worksheet_title title of the worksheet to pull info from
    """
    # init client
    ss_client = gdata.spreadsheets.client.SpreadsheetsClient()
    authorizer = SpreadsheetAuthorizer()
    if not authorizer.authorize(ss_client):
        raise "Please check the access permission of the spreadsheet"

    # look up the worksheet id
    worksheet_id = None
    worksheet_feed = ss_client.get_worksheets(TARGET_SPREADSHEET_KEY)
    for entry in worksheet_feed.entry:
        if entry.title.text == worksheet_title:
            worksheet_id = entry.get_worksheet_id()
    if not worksheet_id:
        raise "cannot find worksheet" + worksheet_title

    # print calibration info
    slope_cell = ss_client.get_cell(TARGET_SPREADSHEET_KEY,
                                    worksheet_id,
                                    SLOPE_CELL[0], SLOPE_CELL[1])
    print "slope=" + slope_cell.cell.numeric_value

    intercept_cell = ss_client.get_cell(TARGET_SPREADSHEET_KEY,
                                        worksheet_id,
                                        INTERCEPT_CELL[0], INTERCEPT_CELL[1])
    print "intercept=" + intercept_cell.cell.numeric_value

def main():
    """Parse the gesture events and insert them to the spreadsheet."""
    if options.print_info:
        worksheet_title = get_worksheet_title()
        print_slope_intercept(worksheet_title)
        return

    # Get the gesture event files and parse the events.
    list_of_pressure_dicts = GestureEventFiles().list_of_pressure_dicts

    # Access the spreadsheet, and create a new worksheet to insert the events.
    ss = PressureSpreadsheet(worksheet_title)
    ss.insert_pressures_to_worksheet(list_of_pressure_dicts)

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option('-d', '--device',
                    dest='device', default=None,
                    help='device ip address to connect to')
    parser.add_option('--result-dir',
                    dest='result_dir', default=None,
                    help='test results directory on the device')
    parser.add_option('-v', '--verbose',
                    dest='verbose', default=False, action='store_true',
                    help='verbose debug output')
    parser.add_option('-n', '--name',
                    dest='name', default=None,
                    help='worksheet name')
    parser.add_option('--print-info',
                    dest='print_info', default=False, action="store_true",
                    help='print pressure calibration info only')
    (options, args) = parser.parse_args()
    if len(args) > 0:
        parser.print_help()
        exit(-1)

    options.verbose = options.verbose
    device_ip = options.device
    result_dir = options.result_dir
    main()
