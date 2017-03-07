/*
* CPU.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

const fs = require('fs');
const path = require('path');

const readCPUUsage = (coreNumber, sleepTime = 100) => {
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

    // sleep
    const date = new Date();
    let curDate = null;
    do {
        curDate = new Date();
    } while (curDate - date < sleepTime);

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

    return usage;
};

module.exports = readCPUUsage;
