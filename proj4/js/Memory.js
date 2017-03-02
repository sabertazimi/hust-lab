/*
 * Memory.js
 * Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */
 
const fs = require('fs');
const path = require('path');

const memTotal = 0;
const memFree = 1;
const memAvail = 2;
const memCached = 4;
const memKB = 0;
const memMB = 1;
const memGB = 2;

const readMemoryUsage = (memKind, memUnit) => {
    const data = fs.readFileSync('/proc/meminfo', 'utf8');
    const stat = String.prototype.split.call(data, '\n');
    const memstat = String.prototype.split.call(stat[memKind], /\s+/);
    let memData = memstat[1];
    
    if (memUnit == memMB || memUnit == memGB) {
        memData /= 1024;
    } 
    
    if (memUnit == memGB) {
        memData /= 1024;
    }
};

readMemoryUsage(memTotal, memKB);
readMemoryUsage(memTotal, memMB);
readMemoryUsage(memTotal, memGB);
readMemoryUsage(memFree, memKB);
readMemoryUsage(memFree, memMB);
readMemoryUsage(memFree, memGB);
readMemoryUsage(memAvail, memKB);
readMemoryUsage(memAvail, memMB);
readMemoryUsage(memAvail, memGB); readMemoryUsage(memCached, memKB);
readMemoryUsage(memCached, memMB);
readMemoryUsage(memCached, memGB);

