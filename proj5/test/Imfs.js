/*
* Imfs.js
* Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

const should = require('should');
const Imfs = require('../src/Imfs.js');

describe('Imfs', () => {
    describe("resolvePath", () => {
        it("should get normalized absolute path", () => {
            const imfs = new Imfs();
            
            // absolute path testing
            imfs.resolvePath("/a/b/c").should.be.eql("/a/b/c");
            imfs.resolvePath("/./a/d///..////b/c").should.be.eql("/a/b/c");
            imfs.resolvePath("/.").should.be.eql("/");
            imfs.resolvePath("/..").should.be.eql("/");
            imfs.resolvePath("/a/b/c/.git").should.be.eql("/a/b/c/.git");
            imfs.resolvePath("/a/b/c/..git").should.be.eql("/a/b/c/..git");
            imfs.resolvePath("/a/b/c/../..").should.be.eql("/a");
            
            
            imfs.cwd = '/a/b/c';
            
            // relative path testing
            imfs.resolvePath(".////..////").should.be.eql("/a/b/");
            imfs.resolvePath("./").should.be.eql("/a/b/c/");
            imfs.resolvePath("./.git").should.be.eql("/a/b/c/.git");
            imfs.resolvePath("./..git").should.be.eql("/a/b/c/..git");
            imfs.resolvePath("../../").should.be.eql("/a/");
        });
    });
});

