# Task: Implement the rcat utility and get these tests to pass on a system 
# which has the UNIX cat command present

require "open3"
require "debugger"

working_dir = File.dirname(__FILE__)
# test1_file = "#{working_dir}/data/test1.txt"
# test2_file     = "#{working_dir}/data/test2.txt"

############################################################################

output  = `mac_conversion -T -h 0x3476`
fail "Failed to calculate correct time conversion" unless output.strip == 'Time: 2:49:40 PM'

############################################################################

output  = `mac_conversion -D -h 0x6852`
fail "Failed to calculate correct date conversion " unless output.strip == 'Date: Mar 08, 2021'

############################################################################

output  = `mac_conversion -D -f data/test1.txt`

fail "Failed to calculate correct date conversion" unless output.strip == 'Date: Feb 15, 2013'

############################################################################

output  = `mac_conversion -T -f data/test1.txt`

fail "Failed to calculate correct time conversion " unless output.strip == 'Time: 8:18:30 AM'


puts "You passed the tests, yay!"
