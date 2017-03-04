/*
 * main.js
 * Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */
 
'use strict';

const Imfs = require('./Imfs.js');
const Repl = require('./Repl.js');

let imfs = new Imfs();
let repl = new Repl(imfs);

repl.start();
