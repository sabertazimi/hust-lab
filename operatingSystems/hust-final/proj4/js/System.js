/*
 * System.js
 * Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */
 
const fs = require('fs');
const path = require('path');

const getSystemInfo = () => {
    const data = fs.readFileSync('/proc/cpuinfo', 'utf8');
    const stat = String.prototype.split.call(data, '\n');
    const modelName = String.prototype.split.call(stat[4], /\s+:\s+/)[1];
    const cpuMHz = String.prototype.split.call(stat[7], /\s+:\s+/)[1] + " MHz";
    const cacheSize = String.prototype.split.call(stat[8], /\s+:\s+/)[1];
    const addrSize = String.prototype.split.call(stat[24], /\s+:\s+/)[1];
    
    return [modelName, cpuMHz, cacheSize, addrSize];
};

module.exports = getSystemInfo;

