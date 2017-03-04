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
            
            imfs.resolvePath("/a/b/c").should.be.eql("/a/b/c");
            imfs.resolvePath("/a//b/c").should.be.eql("/a/b/c");
            imfs.resolvePath("/a//b//c").should.be.eql("/a/b/c");
            imfs.resolvePath("//a//b//c").should.be.eql("/a/b/c");
            imfs.resolvePath("/a/////b/c").should.be.eql("/a/b/c");
            imfs.resolvePath("/./a/d///..////b/c").should.be.eql("/a/b/c");
            imfs.resolvePath("/..").should.be.eql("/");
            imfs.resolvePath("/.").should.be.eql("/");
            imfs.resolvePath("/.git").should.be.eql("/.git");
            imfs.resolvePath("/a/b/c/.git").should.be.eql("/a/b/c/.git");
            imfs.resolvePath("/a/b/c/..git").should.be.eql("/a/b/c/..git");
            imfs.resolvePath("/a/b/c/..").should.be.eql("/a/b");
            imfs.resolvePath("/a/b/c/../..").should.be.eql("/a");
            imfs.resolvePath("/a/b/c/../../..").should.be.eql("/");
        });
    });
});

