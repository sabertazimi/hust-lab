/*
* Repl.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

const path = require('path');
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

            switch (cmd) {
                case 'cd':
                    this.cmd_cd(pathstr);
                    break;
                case 'ls':
                    this.cmd_ls(pathstr);
                    break;
                case 'pwd':
                    this.cmd_pwd();
                    break;
                case 'mkdir':
                    this.cmd_mkdir(pathstr);
                    break;
                case 'rm':
                    this.cmd_rm(pathstr);
                    break;
                case 'touch':
                    this.cmd_touch(pathstr);
                    break;
                case 'cat':
                    this.cmd_cat(pathstr);
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
                    console.log('Unkown command');
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
            console.log(this.imfs.readdir(_path));
        } catch (err) {
            console.log(err.message);
        }
    }

    cmd_pwd() {
        console.log(this.imfs.cwd);
    }

    cmd_mkdir(_path) {
        try {
            this.imfs.mkdir(_path);
        } catch (err) {
            console.log(err.message);
        }
    }

    cmd_rm(_path) {

    }

    cmd_touch(_path) {

    }

    cmd_cat(_path) {

    }

    cmd_write(_path, content) {

    }

    cmd_clear() {

    }

    cmd_exit() {
        console.log('');
        console.log('Log out from in-memory file system ...');
        this.exit = true;
        console.log('Done.');
    }
}

module.exports = Repl;
