/*
 * view.js
 * Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */
 
const readCPUUsage = require('./js/CPU.js');
const readMemUsage = require('./js/Memory.js')

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

const systemUpdateInterval = 2000;

const updateSystemInfo = () => {
    const CPUUsagePara = document.querySelector('div#System p#cpu-usage');
    const MemUsagePara = document.querySelector('div#System p#mem-usage');
    CPUUsagePara.innerHTML = `CPU Usage: ${readCPUUsage(coreTotal).toFixed(2)} %`;
    MemUsagePara.innerHTML = `Memory Free: ${readMemUsage(memAvail, memGB).toFixed(2)} GB`;
};

const openTab = (evt, id) => {
  const tabcontent = document.getElementsByClassName('tabcontent');

  for (let i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = 'none';
  }

  document.getElementById(id).style.display = 'block';
};

const updateUI = () => {
    setInterval(updateSystemInfo, systemUpdateInterval);
}

updateUI();

