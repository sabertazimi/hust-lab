/*
* imfs.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

'use strict';

const path = require('path');   // utils for resolve path

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
    * @return {string}       normalized absolute path
    */
    resolvePath(_path) {
        let formatPath = _path;
        
        // combine path to absolute path
        if (!path.isAbsolute(formatPath)) {
            formatPath = path.join(this.cwd, formatPath);
        }
        
        formatPath = path.normalize(formatPath);
        
        return formatPath;
    }
    
    
    /**    
     * change normalized absolute path to array
     *      
     * @param  {string} formatPath normalized absolute path
     * @return {array}            path array
     */     
    path2arr(formatPath) {
        let patharr = fromatPath.substr(1).split("/");
        
        // remove tail '/'
        if (!patharr[patharr.length - 1]) {
            patharr.pop();
        }
        
        return patharr;
    }
    
    /**
    * change current working directory
    *
    * @method chdir
    * @param  {string}  _path path string for target
    * @return {object}      reference to imfs (this)
    */
    chdir(_path) {
        const formatPath = this.resolvePath(_path);
        
        if (this.isExist(formatPath)) {
            console.log(formatPath);
            console.log(this.cwd);
            this.cwd = formatPath;
            console.log(this.cwd);
        } else {
            throw new Error('Error: path not exist.');
        }
    }
    
    /**
    * judge a dir/file whether exists or not
    *
    * @method isExist
    * @param  {string}  _path path string for target
    * @return {Boolean}       true stand for existance
    */
    isExist(_path) {
        return true;
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
    * make new directory
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
