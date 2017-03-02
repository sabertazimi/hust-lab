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

const cpuUsage = {
    coreTotal: 0,
    core0: 0,
    core1: 0,
    core2: 0,
    core3: 0
};

const readCPUUsage = (coreNumber) => {
    let total = 0;
    let idle = 0;
    let usage = 0.0;
    let data = '';
    let stat = '';
    let cpustat = '';
    
    data = fs.readFileSync('/proc/stat', 'utf8');
    stat = String.prototype.split.call(data, '\n');
    cpustat = String.prototype.split.call(stat[coreNumber], ' ');
    console.log(cpustat);
    
    for (let i = 1; i < 10; i++) {
        if (isNaN(parseInt(cpustat[1], 10))) {
            i++;
        }
        
        total += parseInt(cpustat[i], 10);
        
        // column 4: idle spare time
        if (isNaN(parseInt(cpustat[1], 10))) {
            if (i == 5) {
                idle = parseInt(cpustat[i], 10);
            }
        } else {
            if (i == 4) {
                idle = parseInt(cpustat[i], 10);
            }
            
        }
        
        if (isNaN(parseInt(cpustat[1], 10))) {
            i--;
        }
    }
    
    sleep.msleep(1);
    
    data = fs.readFileSync('/proc/stat', 'utf8');
    stat = String.prototype.split.call(data, '\n');
    cpustat = String.prototype.split.call(stat[coreNumber], ' ');
    console.log(cpustat);
    
    for (let i = 1; i < 10; i++) {
        if (isNaN(parseInt(cpustat[1], 10))) {
            i++;
        }
        
        total -= parseInt(cpustat[i], 10);
        console.log(`${coreNumber} total ${total}`);
        
        // column 4: idle spare time
        if (isNaN(parseInt(cpustat[1], 10))) {
            if (i == 5) {
                idle -= parseInt(cpustat[i], 10);
            }
        } else {
            if (i == 4) {
                idle -= parseInt(cpustat[i], 10);
            }
        }
    
        if (isNaN(parseInt(cpustat[1], 10))) {
            i--;
        }
    }
    
    console.log(`${coreNumber} total ${total}`);
    console.log(`${coreNumber} idle ${idle}`);
    usage = 100.0 * (idle*1.0 - total*1.0) / (-total*1.0);
    console.log(`${coreNumber} usage ${usage}`);
    cpuUsage[coreNumber] = usage;
    // console.log(cpuUsage[coreNumber]);
};

readCPUUsage(coreTotal);
readCPUUsage(core0);
readCPUUsage(core1);
readCPUUsage(core2);
readCPUUsage(core3);

