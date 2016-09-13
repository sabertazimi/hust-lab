/*
 * Tao.java
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

package com.sabertazimi.tao;

import org.apache.log4j.Logger;
import com.sabertazimi.tao.analysis.Token;

public class Tao {
    private static final Logger logger = Logger.getLogger(Tao.class);

	public static void main(String args[]) {
        Token token = new Token(Token.Type.Identifier, "2333");
        String value = token.getValue();
        logger.info("Token value: " + value);
	}
}

