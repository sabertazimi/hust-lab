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
     * judge whether current node is directory or not
     *      
     * @method isDir
     * @param  {object} node current node
     * @return {Boolean}      true stand for is directory
     */     
    isDir(node) {
        if (typeof node !== "object") {
            return false;
        } else {
            return node[""] === true;
        }
    }
    
    /**    
     * judge whether current node is file or not
     *      
     * @method isFile
     * @param  {object} node current node
     * @return {Boolean}      true stand for is file
     */     
    isFile(node) {
        if (typeof node !== "object") {
            return false;
        } else {
            return !node[""];
        }
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
        let patharr = formatPath.substr(1).split("/");
        
        // remove tail '/' when from relative path
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
            this.cwd = formatPath;
        } else {
            throw new Error(`Error: directory '${formatPath}' not exists.`);
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
        const formatPath = this.resolvePath(_path);
        const patharr = this.path2arr(formatPath);
        
        // root directory
        if (patharr.length === 0) {
            return true;
        }
        
		let cache = this.data;
		let i = 0;
        
		for(; i < patharr.length - 1; i++) {
			if(!this.isDir(cache[patharr[i]])) {
				return false;
            }
            
			cache = cache[patharr[i]];
		}
        
		return !!cache[patharr[i]];
    }
    
    /**
    * read content of directory
    *
    * @method readdir
    * @param  {string} _path path string for target
    * @return {array}       string array of file/subdir name
    */
    readdir(_path) {
        const formatPath = this.resolvePath(_path);
        const patharr = this.path2arr(formatPath);
        
        // root directory
        if (patharr.length === 0) {
            return Object.keys(this.data).filter(Boolean);
        }
        
		let cache = this.data;
		let i = 0;
        
		for(; i < patharr.length - 1; i++) {
			if(!this.isDir(cache[patharr[i]])) {
                throw new Error(`Error: directory '${formatPath}' not exists.`);
            }
            
			cache = cache[patharr[i]];
		}
        
		if (!this.isDir(cache[patharr[i]])) {
            throw new Error(`Error: directory '${formatPath}' not exists.`);
		}
        
		return Object.keys(cache[patharr[i]]).filter(Boolean);
    }
    
    /**
    * make new directory
    *
    * @method mkdir
    * @param  {string} _path path string for target
    * @return {object}      reference to imfs (this)
    */
    mkdir(_path) {
        const formatPath = this.resolvePath(_path);
        const patharr = this.path2arr(formatPath);
        
        // root directory
        if (patharr.length === 0) {
            return this;
        }
        
        let cache = this.data;
        let i = 0;
        
        for(; i < patharr.length - 1; i++) {
            if(this.isFile(cache[patharr[i]])) {
                throw new Error(`Error: homonymous file '${patharr[i]}' exists.`);
            } else if(!this.isDir(cache[patharr[i]])) {
                // create new directory when non-exist
                cache[patharr[i]] = {"":true};
            }
            
            cache = cache[patharr[i]];
        }
        
        if (this.isDir(cache[patharr[i]])) {
            throw new Error(`Error: directory '${patharr[i]}' exists.`);
        } else {
            cache[patharr[i]] = {"":true};
        }
        
        console.log(`Success: mkdir '${formatPath}'.`);
        
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
