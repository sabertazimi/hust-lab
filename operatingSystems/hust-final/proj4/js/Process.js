/*
* Process.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

const fs = require('fs');
const path = require('path');

const readProcessDir = (dir) => {
    let results = [];
    let list = '';
    let len;

    list = fs.readdirSync(dir, 'utf8');

    if (list.length === 0) {
        return null;
    }

    list.forEach((file) => {
        let stat;
        file = path.resolve(dir, file);

        stat = fs.statSync(file);

        // find a process info directory, push it into results
        if (stat && stat.isDirectory && /^[0-9]*$/.test(file.split('/')[2])) {
            results = results.concat(file);
        }
    });

    return results;
};

const getTotalCPU = () => {
    let cpuData = fs.readFileSync('/proc/stat', 'utf8');
    let cpuStat = String.prototype.split.call(cpuData, '\n');
    let cpuUsage = String.prototype.split.call(cpuStat[0], /\s+/);

    let total = 0;

    for (let i = 1; i < 10; i++) {
        total += parseInt(cpuUsage[i], 10);
    }

    return total;
};

const readProcessRawData = () => {
    let processRawData = new Map();
    const processDirs = readProcessDir('/proc');
    processDirs.forEach((dir) => {
        // important file: /proc/*/stat => status info of process
        const file = path.resolve(dir, 'stat');
        const data = fs.readFileSync(file, 'utf8');
        const stat = String.prototype.split.call(data, /\s+/);

        // important file: /proc/*/status => memory info of process
        const files = path.resolve(dir, 'status');
        const datas = fs.readFileSync(files, 'utf8');
        const status = String.prototype.split.call(datas, '\n');

        const rawData = [stat, status];

        processRawData.set(stat[pid], rawData);
    });

    return processRawData;
};

// enum for stat[XXX]
const pid = 0;
const comm = 1;
const tty = 6;
const utime = 13;
const stime = 14;
const priority = 18;
const vsize = 22;
const rss = 23;
const sleepTime = 10;

// enum for status
const VmRSS = 21;
const state = 2;

const stat = 0;
const status = 1;

const P_TOTAL = 0;
const P_CPU = 1;

const getProcessData = (key, rawData) => {
    const totalCPU = getTotalCPU();
    const processCPU = parseInt(rawData[stat][utime]) + parseInt(rawData[stat][stime]);
    const processName = rawData[stat][comm].replace('(', '').replace(')', '');
    const processState = String.prototype.split.call(rawData[status][state], /\s+/)[2];//.replace('(', '').replace(')', '');
    let processMem = String.prototype.split.call(rawData[status][VmRSS], /\s+/);
    if (processMem[0] === 'VmRSS:') {
        processMem = parseInt(processMem[1]);
        processMem /= 1024;
    } else {
        processMem = 0;
    }

    const processData = [totalCPU, processCPU, 0, key, processName, processMem, processState];

    return processData;
}

const getProcessItems = () => {
    let processItems = new Map();
    let processRawData = readProcessRawData();

    for (let key of processRawData.keys()) {
        const rawData = processRawData.get(key);
        const [totalCPU, processCPU, cpuUsage, proceesID, processName, processMem, processState] = getProcessData(key, rawData);
        const processItem = [totalCPU, processCPU, cpuUsage, processName, processName, processMem, processState];
        processItems.set(key, processItem);
    }

    const date = new Date();
    let curDate = null;
    do {
        curDate = new Date();
    } while (curDate - date < sleepTime);

    processRawData = readProcessRawData();

    for (let key of processRawData.keys()) {
        if (processItems.has(key)) {
            // update information
            const rawData = processRawData.get(key);
            let [totalCPU2, processCPU2, cpuUsage, processID, processName, processMem, processState] = getProcessData(key, rawData);

            // calculate cpu usage
            // update cpu usage
            const processItem = processItems.get(key);
            const totalCPU1 = processItem[P_TOTAL];
            const processCPU1 = processItem[P_CPU];
            cpuUsage = 100 * (processCPU2 * 1.0 - processCPU1 * 1.0) / (totalCPU2 * 1.0 - totalCPU1 * 1.0);

            const newProcessItem = [totalCPU2, processCPU2, cpuUsage, processID, processName, processMem, processState];
            processItems.set(key, newProcessItem);
        } else {
            // add new process
            const rawData = processRawData.get(key);
            const [totalCPU, processCPU, cpuUsage, processID, processName, processMem, processState] = getProcessData(key, rawData);
            const processItem = [totalCPU, processCPU, cpuUsage, processID, processName, processMem, processState];
            processItems.set(key, processItem);
        }
    }

    // remove missing process
    for (let key of processItems.keys()) {
        if (!processRawData.has(key)) {
            processItems.delete(key);
        }
    }

    return processItems;
};

module.exports = getProcessItems;
