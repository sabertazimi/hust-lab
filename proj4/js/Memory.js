/*
 * Memory.js
 * Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */
 
const fs = require('fs');
const path = require('path');

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
    
    return memData;
};

module.exports = readMemoryUsage;
