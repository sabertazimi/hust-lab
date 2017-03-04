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
            let command = readline.question(`${prompt} $ `);

            command = command.split(/\s+/);

            switch (command[0]) {
                case 'cd':
                    const pathstr = command[1];
                    this.cmd_cd(pathstr);
                    break;
                case 'ls':
                    console.log('ls');
                    break;
                case 'pwd':
                    this.cmd_pwd();
                    break;
                case 'mkdir':
                    console.log('mkdir');
                    break;
                case 'rm':
                    console.log('rm');
                    break;
                case 'touch':
                    console.log('touch');
                    break;
                case 'cat':
                    console.log('cat');
                    break;
                case 'write':
                    console.log('write');
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
            console.log(err);
        }
    }

    cmd_ls() {

    }

    cmd_pwd() {
        console.log(this.imfs.cwd);
    }

    cmd_mkdir(_path) {

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
