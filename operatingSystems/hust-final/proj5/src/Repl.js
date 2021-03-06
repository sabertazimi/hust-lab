/*
 * Repl.js
 * Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

'use strict';

const fs = require('fs');
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
        console.log('Restore config file ...');

        const jsonFile = fs.openSync('imfs.json', 'a+');
        const jsonData = fs.readFileSync(jsonFile, 'utf8');

        if (jsonData) {
            this.imfs.data = JSON.parse(jsonData);
        }

        fs.closeSync(jsonFile);

        console.log('Done.');
        console.log(`Enter 'help' to get more helpful information.`);
        console.log('');

        this.repl();
    }

    repl() {
        while (!this.exit) {
            const prompt = ((this.imfs.cwd === '/') ? '/' : path.basename(this.imfs.cwd));
            const command = readline.question(`${prompt} $ `).split(/\s+/);
            const cmd = command[0];
            const pathstr = command[1];
            const paths = command.slice(1);
            const content = command.slice(2).join(' ');

            switch (cmd) {
                case 'cd':
                    this.cmd_cd(pathstr);
                    break;
                case 'ls':
                    if (paths.length === 0) {
                        this.cmd_ls(this.imfs.cwd);
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
                case 'help':
                    this.cmd_help();
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
        console.log('Store config file ...');

        const data = JSON.stringify(this.imfs.data);

        if (data) {
            fs.writeFileSync('imfs.json', data, 'utf8');
        }

        this.exit = true;

        console.log('Done.');
        console.log('Log out from in-memory file system ...');
        console.log('Done.');
    }

    cmd_help() {
        console.log('Welcome to in-memory file system');
        console.log('\tcd    <path>           : change current working directory.');
        console.log('\tls    <directory ...>  : list content of directory.');
        console.log('\tpwd                    : print current working directory.');
        console.log('\tmkdir <directory ...>  : create new directory.');
        console.log('\trm    <target ...>     : remove file or directory.');
        console.log('\ttouch <file ...>       : create new file.');
        console.log('\tcat   <file ...>       : print content of file.');
        console.log('\twrite <file> <content> : write content to file.');
        console.log('\tclear                  : clear screen.');
        console.log('\texit                   : log out from in-memory file system.');
    }
}

module.exports = Repl;
