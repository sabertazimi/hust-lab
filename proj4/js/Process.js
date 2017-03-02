/*
 * Process.js
 * Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

const fs = require('fs');
const path = require('path');

const readProcessDir = (dir, done) => {
  let results = [];

  fs.readdir(dir, (err, list) => {
    if (err) {
      return done(dir);
    }

    let pending = list.length;

    if (pending === 0) {
      return done(null, results);
    }

    list.forEach((file) => {
      file = path.resolve(dir, file);

      fs.stat(file, (err, stat) => {
        // find a process info directory, push it into results
        if (stat && stat.isDirectory && /^[0-9]*$/.test(file.split('/')[2])) {
          results = results.concat(file);
        }

        if (!--pending) done(null, results);
      });
    });
  });
}

readProcessDir('/proc', (err, res) => {
  if (err) {
    return console.log(err);
  } else {
    res.forEach((dir) => {
      // readProcessStat(dir);
      // readProcessStatm(dir);
      readProcessIO(dir);
   });
  }
});

// enum for stat[XXX]
const pid = 0;
const comm = 1;
const tty = 6;
const utime = 13;
const stime = 14;
const priority = 18;
const vsize = 22;
const rss = 23;

const readProcessStat = (dir) => {
    // important file: /proc/*/stat => status info of process
    const file = path.resolve(dir, 'stat');

    fs.readFile(file, 'utf-8', (err, data) => {
      const stat = data.split(' ');
      console.log(`${stat[comm]} pid: ${stat[pid]}`);
      console.log(`${stat[comm]} ttyid: ${stat[tty]}`);
      console.log(`${stat[comm]} priority: ${stat[priority]}`);
      console.log(`${stat[comm]} utime: ${stat[utime]}`);
      console.log(`${stat[comm]} stime: ${stat[stime]}`);
      console.log(`${stat[comm]} virtual memory size: ${stat[vsize]}`);
      console.log(`${stat[comm]} resident set size: ${stat[rss]}`);
    });
}

// enum for statm
const pagesize = 4096;  // getconf PAGE_SIZE
const memUse = 1;

const readProcessStatm = (dir) => {
    // important file: /proc/*/statm => memory info of process
    const file = path.resolve(dir, 'statm');

    fs.readFile(file, 'utf-8', (err, data) => {
      const statm = data.split(' ');
      console.log(`memory usage : ${statm[memUse]}`);
    });
}

const readProcessIO = (dir) => {
    // important file: /proc/*/io => io info of process
    const file = path.resolve(dir, 'io');

    fs.readFile(file, 'utf-8', (err, data) => {
      if (data) {
        const io = data.split('\n');
        const writeBytes = io[5].split(' ')[1];
        const cancelledWriteBytes = io[6].split(' ')[1];
        console.log(`write bytes: ${writeBytes}`);
        console.log(`cancelled write bytes: ${cancelledWriteBytes}`);
      } else {
        // @TODO
      }
    });
}