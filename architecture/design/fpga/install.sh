#! /bin/sh
#
# install.sh
# Copyright (C) 2017 sabertazimi <sabertazimi@avalon>
#
# Distributed under terms of the MIT license.
#

echo "deb http://www.emdebian.org/debian stable main" >> /etc/apt/source.list
sudo apt-get update
sudo apt-get install libgmp3c2
sudo apt-get install gcc-4.3-mips-linux-gnu libgmp3c2-mips-cross
sudo apt install logisim # install logisim platform
sudo apt install verilog # install icarus verilog simulatr
sudo apt install gtkwave # install waveform viewer comes with icarus verilog
sudo apt install yosys   # synthesize
sudo apt install geda    # graphic eda toolchains
