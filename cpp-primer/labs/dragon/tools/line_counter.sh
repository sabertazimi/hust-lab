#! /bin/sh
#
# line_counter.sh
# Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
#
# Distributed under terms of the MIT license.
#

find src -name "*.[chly]" | xargs cat | grep -v ^$ | wc -l
find src -name "*.cc" | xargs cat | grep -v ^$ | wc -l
