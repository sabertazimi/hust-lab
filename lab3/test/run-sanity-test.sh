#!/bin/bash

# Just run this file and you can test your circ files!
# Make sure your files are in the directory above this one though!
# Credits to William Huang

cp alu.circ tests
cp regfile.circ tests
cp cpu.circ tests
cp mem.circ tests
cd tests
./sanity_test.py
cd ..
