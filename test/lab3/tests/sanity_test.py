#!/usr/bin/env python

import os
import os.path
import tempfile
import subprocess
import time
import signal
import re
import sys
import shutil

file_locations = os.path.expanduser(os.getcwd())
logisim_location = os.path.join(os.getcwd(),"logisim.jar")

create = 0

if create:
  new = open('new.out', 'w')

class TestCase():
  """
      Runs specified circuit file and compares output against the provided reference trace file.
  """

  def __init__(self, circfile, tracefile):
    self.circfile  = circfile
    self.tracefile = tracefile

  def __call__(self):
    output = tempfile.TemporaryFile(mode='r+')
    proc = subprocess.Popen(["java","-jar",logisim_location,"-tty","table",self.circfile],
                            stdin=open('/dev/null'),
                            stdout=subprocess.PIPE)
    try:
      reference = open(self.tracefile)
      passed = compare_unbounded(proc.stdout,reference)
    finally:
      os.kill(proc.pid,signal.SIGTERM)
    if passed:
      return (True, "Matched expected output")
    else:
      return (False, "Did not match expected output")

def compare_unbounded(student_out, reference_out):
  passed = True
  while True:
    line1 = student_out.readline()
    line2 = reference_out.readline()
    if line2 == '':
      break
    if create:
      new.write(line1)
    m = re.match(line2, line1)
    if m == None or m.start() != 0 or m.end() != len(line2):
      passed = False
  return passed


#def fraction_lines_match_unbounded2(student_out,reference_out, filename):
#  if filename[0:3] == 'ALU' and log:
#    print >> logfile, alu_header
#  elif filename[0:3] == 'reg' and log:
#    print >> logfile, reg_header
#  elif log: #CPU
#    print >> logfile, cpu_header
#  total_lines = 0
#  matched_lines = 0
#  line1 = student_out.readline()
#  line2 = reference_out.readline()
#  while line2:    
#    if re.split('\W+', line2) == ['', '1', ''] or re.split('\W+', line2) == ['', '0', '']or re.split('\W+', line2) == ['', '']: # Stall line
#      line3 = reference_out.readline()
#      while re.match(line2, line1) and not re.match(line3, line1):
#        if log:
#          print >> logfile, '\t|' + to_hex(line1) + '\t|' + to_hex(line2) + '\t|'
#        line1 = student_out.readline()
#      line2 = line3
#      continue
#    if re.match(line2, line1):
#      matched_lines += 1
#      if log:
#        print >> logfile, '\t|' + to_hex(line1) + '\t|'
#    else:
#      if log:
#        print >> logfile, '***\t|' + to_hex(line1) + '\t|'
#        print >> logfile, 'REF\t|' + to_hex(line2) + '\t|'
#    if create:
#      print >> new, line1
#    total_lines += 1
#    line1 = student_out.readline()
#    line2 = reference_out.readline()
#  if log:
#    print >> logfile, ''
#  return float(matched_lines)/float(total_lines) 

def run_tests(tests):
  # actual submission testing code
  print "Testing files..."
  tests_passed = 0
  tests_failed = 0

  for description,test in tests:
    test_passed, reason = test()
    if test_passed:
      print "\tPASSED test: %s" % description
      tests_passed += 1
    else:
      print "\tFAILED test: %s (%s)" % (description, reason)
      tests_failed += 1
  
  print "Passed %d/%d tests" % (tests_passed, (tests_passed + tests_failed))

tests = [
#  ("ALU add (with overflow) test",TestCase(os.path.join(file_locations,'alu-add.circ'), os.path.join(file_locations,'reference_output/alu-add.out'))),
#  ("RegFile insert test",
#        TestCase(os.path.join(file_locations,'regfile-insert.circ'),
#                 os.path.join(file_locations,'reference_output/regfile-insert.out'))),
#  ("RegFile $zero test",
#        TestCase(os.path.join(file_locations,'regfile-zero.circ'),
#                 os.path.join(file_locations,'reference_output/regfile-zero.out'))),
#  ("alu-mult test",TestCase(os.path.join(file_locations,'alu-mult.circ'), os.path.join(file_locations,'reference_output/alu-mult.out'))),
  ("CPU addu and addiu test",TestCase(os.path.join(file_locations,'CPU-addu-addiu.circ'), os.path.join(file_locations,'reference_output/CPU-addu-addiu.out'))),
  ("CPU mult, mfhi and mflo test",TestCase(os.path.join(file_locations,'CPU-mult-mf.circ'), os.path.join(file_locations,'reference_output/CPU-mult-mf.out'))),
  ("CPU branches test",TestCase(os.path.join(file_locations,'CPU-branches.circ'), os.path.join(file_locations,'reference_output/CPU-branches.out'))),
#  ("CPU mult, mfhi and mflo test",TestCase(os.path.join(file_locations,'CPU-mult-mf.circ'), os.path.join(file_locations,'reference_output/CPU-mult-mf-non-pipelined.out'))),
#  ("CPU addu and addiu test",TestCase(os.path.join(file_locations,'CPU-addu-addiu.circ'), os.path.join(file_locations,'reference_output/CPU-addu-addiu-non-pipelined.out'))),
]

if __name__ == '__main__':
  run_tests(tests)
