/*
* imfs.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

'use strict';

class Imfs {
    constructor(data) {
        this.data = data || {};
        this.cwd = '/';
    }

    /**
    * change path string to path array
    *
    * @method resolvePath
    * @param  {string} _path path string for target
    * @return {array}       path array
    */
    resolvePath(_path) {
        return [];
    }

    /**
    * judge a dir/file whether exists or not
    *
    * @method isExist
    * @param  {string}  _path path string for target
    * @return {Boolean}       true stand for existance
    */
    isExist(_path) {
    }


    /**
    * read content of directory
    *
    * @method readdir
    * @param  {string} _path path string for target
    * @return {array}       string array of file/subdir name
    */
    readdir(_path) {
    }


    /**
    * make new directory/file
    *
    * @method mkdir
    * @param  {string} _path path string for target
    * @return {object}      reference to imfs (this)
    */
    mkdir(_path) {
        return this;
    }

    /**
    * delete directory/file
    *
    * @method rmdir
    * @param  {string} _path path string for target
    * @return {object}      reference to imfs (this)
    */
    rmdir(_path) {
        return this;
    }

    /**
    * read content of file
    *
    * @method readFile
    * @param  {string} _path path string for target
    * @return {string}       content of file
    */
    readFile(_path) {
    }

    /**
    * write content to file
    *
    * @method writeFile
    * @param  {string} _path path string for target
    * @param  {string} content content to write
    * @return {object}      reference to imfs (this)
    */
    writeFile(_path, content) {
        return this;
    }
}

module.exports = Imfs;
