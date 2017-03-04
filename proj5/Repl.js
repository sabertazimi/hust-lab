/*
* Repl.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

const readline = require('readline-sync');

class Repl {
    constructor() {
        this.exit = false;
        this.cwd = '/';
    }

    start() {
        console.log('Log in to in-memory file system ...');
        console.log('Done.');
        console.log('');
        
        while (!this.exit) {
            let command = readline.question(`${this.cwd} $ `);

            command = command.split(/\s+/);
            
            switch (command[0]) {
                case 'cd':
                    console.log('cd');
                    break;
                case 'ls':
                    console.log('ls');
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
                case 'exit':
                    console.log('');
                    console.log('Log out from in-memory file system ...');
                    this.cmd_exit();
                    console.log('Done.');
                    break;
                default:
                    console.log('Unkown command');
                    break;
            }
        }
    }

    cmd_cd(_path) {

    }

    cmd_ls() {

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

    cmd_exit() {
        this.exit = true;
    }
}

module.exports = Repl;
