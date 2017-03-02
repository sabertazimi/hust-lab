/*
* CPU.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

const fs = require('fs');
const path = require('path');
const sleep = require('sleep');

const coreTotal = 0;
const core0 = 1;
const core1 = 2;
const core2 = 3;
const core3 = 4;

const readCPUUsage = (coreNumber, sleepTime) => {
    let total = 0;
    let idle = 0;
    let usage = 0.0;
    let data = '';
    let stat = '';
    let cpustat = '';
    
    data = fs.readFileSync('/proc/stat', 'utf8');
    stat = String.prototype.split.call(data, '\n');
    cpustat = String.prototype.split.call(stat[coreNumber], /\s+/);
    
    for (let i = 1; i < 10; i++) {
        total += parseInt(cpustat[i], 10);
        
        // column 4: idle spare time
        if (i == 4) {
            idle = parseInt(cpustat[i], 10);
        }
    }
    
    sleep.msleep(sleepTime);
    
    data = fs.readFileSync('/proc/stat', 'utf8');
    stat = String.prototype.split.call(data, '\n');
    cpustat = String.prototype.split.call(stat[coreNumber], /\s+/);
    
    for (let i = 1; i < 10; i++) {
        total -= parseInt(cpustat[i], 10);
        
        // column 4: idle spare time
        if (i == 4) {
            idle -= parseInt(cpustat[i], 10);
        }
    }
    
    usage = 100.0 * (idle*1.0 - total*1.0) / (-total*1.0);
    // console.log(`${coreNumber} usage ${usage}`);
};

readCPUUsage(coreTotal, 100);
readCPUUsage(core0, 100);
readCPUUsage(core1, 100);
readCPUUsage(core2, 100);
readCPUUsage(core3, 100);

