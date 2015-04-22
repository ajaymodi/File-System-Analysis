# Task: Implement the rcat utility and get these tests to pass on a system 
# which has the UNIX cat command present

require "open3"

working_dir = File.dirname(__FILE__)
# test1_file = "#{working_dir}/data/test1.txt"
# test2_file     = "#{working_dir}/data/test2.txt"

############################################################################

output  = `address4forensics -L -b 128 --physical-known=12345678`

fail "Failed to calculate correct Logical address" unless output.strip == '12345550'

############################################################################

output  = `address4forensics -P --partition-start=128 -c 58 -k 4 -r 6 -t 2 -f 16`

fail "Failed to calculate correct physical addres " unless output.strip == '390'


############################################################################

output  = `address4forensics -P -s 128 -b 120 --logical-known=390`

fail "Failed to calculate correct Physical address" unless output.strip == '510'

############################################################################

output  = `address4forensics -C -b 120 --logical-known=390 -k 4 -r 6 -t 2 -f 16`

fail "Failed to calculate correct cluster addres " unless output.strip == '90'

############################################################################

output  = `address4forensics -C -b 120 --physical-known=390 -k 4 -r 6 -t 2 -f 16`

fail "Failed to calculate correct cluster addres " unless output.strip == '60'

############################################################################

output  = `address4forensics -L --partition-start=128 -c 58 -k 4 -r 6 -t 2 -f 16`

fail "Failed to calculate correct logical addres " unless output.strip == '262'

############################################################################

output  = `address4forensics -P -B -s 100 -b 120 --logical-known=390`

fail "Failed to calculate correct physical address in bytes " unless output.strip == '51000'


puts "You passed the tests, yay!"
