/*
 * series.js
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */
(function(){
    'use strict';

    let sum = 0;
    let cnt = 0;

    for (let i = 0; i < 32; i++) {
        sum = i*(i+1)/2;
        process.stdout.write(sum.toString(16) + " ");
        cnt++;
        if (cnt % 8 == 0) {
            process.stdout.write("\n");
            cnt = 0;
        }
    }

})();
