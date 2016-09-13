/*
 * TokenTest.java
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

package com.sabertazimi.tao.analysis;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class TokenTest {
    private Token token;

    @Before
    public void setUp() {
        token = new Token(Token.Type.Identifier, "2333");
    }

    @Test
    public void getValue_ShouldReturnValue() {
        assertEquals("2333", token.getValue());
    }
}

