/*
 * Token.java
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

package com.sabertazimi.tao.analysis;

public class Token {
	public static enum Type {
        Keyword,
        Number,
        Identifier,
        Sign,
        Annotation,
        String,
        RegEx,
        Space,
        NewLine,
        EndSymbol;
	};
    final Type type;
    final String value;

    public Token (Type type, String value) {
        if (type == Type.Identifier) {
            char firstChar = value.charAt(0);

            if (firstChar >= '0' && firstChar <= '9') {
                type = Type.Number;
            }
            // else if (keywordsSet.contains(value)) {
            //     type = Type.Keyword;
            // }
        }

        this.type = type;
        this.value = value;
    }

    public String getValue() {
        return this.value;
    }
}

