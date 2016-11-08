#!/bin/bash

# Just run this file and you can test your circ files!
# Make sure your files are in the directory above this one though!
# Credits to William Huang

cp -fr regfile.circ tests
cd tests
python sanity_test.py
cd ..
