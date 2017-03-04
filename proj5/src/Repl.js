/*
* Repl.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

'use strict';

const path = require('path');
const process = require('process');
const readline = require('readline-sync');

class Repl {
    constructor(imfs) {
        this.imfs = imfs;
        this.exit = false;
    }

    start() {
        console.log('Log in to in-memory file system ...');
        console.log('Done.');
        console.log('');

        while (!this.exit) {
            const prompt = ((this.imfs.cwd === '/') ? '/' : path.basename(this.imfs.cwd));
            const command = readline.question(`${prompt} $ `).split(/\s+/);
            const cmd = command[0];
            const pathstr = command[1];
            const content = command[2];
            const paths = command.slice(1);

            switch (cmd) {
                case 'cd':
                    this.cmd_cd(pathstr);
                    break;
                case 'ls':
                    if (paths.length === 0) {
                        this.cmd_ls(pathstr);
                    } else {
                        paths.forEach((pathstr) => {
                            this.cmd_ls(pathstr);
                        });
                    }
                    break;
                case 'pwd':
                    this.cmd_pwd();
                    break;
                case 'mkdir':
                    paths.forEach((pathstr) => {
                        this.cmd_mkdir(pathstr);
                    });
                    break;
                case 'rm':
                    paths.forEach((pathstr) => {
                        this.cmd_rm(pathstr);
                    });
                    break;
                case 'touch':
                    paths.forEach((pathstr) => {
                        this.cmd_touch(pathstr);
                    });
                    break;
                case 'cat':
                    paths.forEach((pathstr) => {
                        this.cmd_cat(pathstr);
                    });
                    break;
                case 'write':
                    this.cmd_write(pathstr, content);
                    break;
                case 'clear':
                    this.cmd_clear();
                    break;
                case 'exit':
                    this.cmd_exit();
                    break;
                default:
                    console.log(`Error: unkown command '${cmd}'.`);
                    break;
            }
        }
    }

    cmd_cd(_path) {
        try {
            this.imfs.chdir(_path);
        } catch (err) {
            console.log(err.message);
        }
    }

    cmd_ls(_path) {
        try {
            _path = _path || '/';
            const nodes = this.imfs.readdir(_path);
            nodes.forEach((node) => {
                process.stdout.write(`${node}\t`);
            });
            console.log('');
        } catch (err) {
            console.log(err.message);
        }
    }

    cmd_pwd() {
        console.log(this.imfs.cwd);
    }

    cmd_mkdir(_path) {
        try {
            this.imfs.mkNode(_path, 0);
        } catch (err) {
            console.log(err.message);
        }
    }

    cmd_rm(_path) {
        try {
            this.imfs.rmNode(_path);
        } catch (err) {
            console.log(err.message);
        }
    }

    cmd_touch(_path) {
        try {
            this.imfs.mkNode(_path, 1);
        } catch (err) {
            console.log(err.message);
        }
    }

    cmd_cat(_path) {
        try {
            console.log(this.imfs.readFile(_path));
        } catch (err) {
            console.log(err.message);
            console.log(err);
        }
    }

    cmd_write(_path, content) {
        try {
            this.imfs.writeFile(_path, content);
        } catch (err) {
            console.log(err.message);
        }
    }

    cmd_clear() {
        console.log('\x1Bc'); // \033c
    }

    cmd_exit() {
        console.log('');
        console.log('Log out from in-memory file system ...');
        this.exit = true;
        console.log('Done.');
    }
}

module.exports = Repl;
