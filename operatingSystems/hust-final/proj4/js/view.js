/*
* view.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

const execSync = require('child_process').execSync;
const readCPUUsage = require('./js/CPU.js');
const readMemUsage = require('./js/Memory.js');
const getProcessItems = require('./js/Process.js');
const getSystemInfo = require('./js/System.js');

const coreTotal = 0;
const core0 = 1;
const core1 = 2;
const core2 = 3;
const core3 = 4;

const memTotal = 0;
// const memFree = 1;
const memAvail = 2;
const memCached = 4;
const memKB = 0;
const memMB = 1;
const memGB = 2;

const S_modelName = 0;
const S_cpuMHz = 1;
const S_cacheSize = 2;
const S_addrSize = 3;

const P_TOTAL = 0;
const P_CPU = 1;
const P_CPUUsage = 2;
const P_PID = 3;
const P_NAME = 4;
const P_MemUsage = 5;
const P_State = 6;

const systemUpdateInterval = 2000;
const processUpdateInterval = 3000;

const updateSystemInfo = () => {
    const SystemDiv = document.querySelector('div#System');

    if (SystemDiv.className === 'tabcontent') {
        // non-active
        return;
    }

    const CPUUsagePara = document.querySelector('div#System p#cpu-usage');
    const MemUsagePara = document.querySelector('div#System p#mem-usage');
    const modelNamePara = document.querySelector('div#System p#model-name');
    const CPUMHzPara = document.querySelector('div#System p#cpu-mhz');
    const cacheSizePara = document.querySelector('div#System p#cache-size');
    const addrSizePara = document.querySelector('div#System p#addr-size');
    const [modelName, CPUMHz, cacheSize, addrSize] = getSystemInfo();

    CPUUsagePara.innerHTML = `CPU Usage: ${readCPUUsage(coreTotal).toFixed(2)} %`;
    MemUsagePara.innerHTML = `Memory Free: ${readMemUsage(memAvail, memGB).toFixed(2)} GB`;
    modelNamePara.innerHTML = `Model Name: ${modelName}`;
    CPUMHzPara.innerHTML = `CPU MHz: ${CPUMHz}`;
    cacheSizePara.innerHTML = `Cache Size: ${cacheSize}`;
    addrSizePara.innerHTML = `Address Size: ${addrSize}`;

    // console.log(CPUUsagePara);
    // console.log(MemUsagePara);
};

const updateProcessInfo = () => {
    const ProcessDiv = document.querySelector('div#Process');

    if (ProcessDiv.className === 'tabcontent') {
        // non-active
        return;
    }

    const processTable = document.querySelector('div#Process div.process-table');
    const processTableHeader = '<ul class="process-list">   \
    <li>Name</li>           \
    <li>PID</li>            \
    <li>State</li>          \
    <li>CPU</li>            \
    <li>Memory</li>         \
    </ul>';

    // <li>Disk</li>           \
    // <li>Network</li>        \
    const processItems = getProcessItems();

    processTable.innerHTML = processTableHeader;
    for (let key of processItems.keys()) {
        const processData = processItems.get(key);
        // console.log(processData);
        processTable.innerHTML += `<ul class="process-list">                 \
        <li>${processData[P_NAME]}</li>         \
        <li>${processData[P_PID]}</li>          \
        <li>${processData[P_State]}</li>          \
        <li>${processData[P_CPUUsage].toFixed(2)}</li>     \
        <li>${processData[P_MemUsage].toFixed(2)} MB</li>     \
        </ul>`;
    }
};

const openTab = (evt, id) => {
    const tabcontent = document.getElementsByClassName('tabcontent');

    for (let i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = 'none';
        tabcontent.className = 'tabcontent';
    }

    document.getElementById(id).style.display = 'block';
    document.getElementById(id).className += ' active';
};

const killProcess = () => {
    const pidText = document.getElementById('kill-pid');

    if (pidText.value && /^[0-9]*$/.test(pidText.value)) {
        execSync(`kill ${pidText.value}`);
    }
};

const updateUI = () => {
    setInterval(updateSystemInfo, systemUpdateInterval);
    setInterval(updateProcessInfo, processUpdateInterval);
};

updateUI();

