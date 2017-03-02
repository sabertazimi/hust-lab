/*
* CPU.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/


const fs = require('fs');
const path = require('path');

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
    const total = 0;
    const idle = 0;
    const usage = 0.0;
    
    fs.readFile('proc/stat', 'utf-8', (err, data) => {
        const stat = data.split('\n');
        const cpustat = stat[coreNumber].split(' ');

        for (let i = 1; i < 10; i++) {
            total += parseInt(cpustat[i], 10);
        
            // column 4: idle spare time
            if (i == 4) {
                idle = parseInt(cpustat[i], 10);
            }
        }
    });
    
    setTimeout(() => {
        const stat = data.split('\n');
        const cpustat = stat[coreNumber].split(' ');

        for (let i = 1; i < 10; i++) {
            total -= parseInt(cpustat[i], 10);
        
            // column 4: idle spare time
            if (i == 4) {
                idle -= parseInt(cpustat[i], 10);
            }
        }
    }, 1);
    
    usage = 100.0 * (idle*1.0 - total*1.0) / (-total*1.0);
    cpuUsage[coreNumber] = usage;
    console.log(cpuUsage[coreNumber])
};

