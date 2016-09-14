/*
 * LexicalAnalysis.java
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

package com.sabertazimi.tao.analysis;

import java.io.CharArrayReader;
import java.io.Reader;
import java.io.IOException;
import java.util.List;
import java.util.LinkedList;
import java.util.HashMap;

import static com.sabertazimi.tao.analysis.Token.Type;

public class LexicalAnalysis {
    private final Reader reader;
    private Token endToken = null;

    private enum State {
        Normal,
        Identifier,
        Sign,
        Annotation,
        String,
        RegEx,
        Space;
    }

    public LexicalAnalysis(Reader reader) {
        this.reader = reader;
        this.state = State.Normal;
    }

    /*
     * Parser 不断调用 read() 获取 Token 对象, 直到 EndSymbol/异常 为止
     */
    Token read() throws IOException, LexicalAnalysisException {
        if (endToken != null) {
            return endToken;
        }

        while (tokenBuffer.isEmpty()) {
            int read = reader.read();
            char c = (read == -1 ? '\0' : (char) read);

            while (!readChar(c)) {
                ;
            }
        }

        Token token = tokenBuffer.removeLast();

        if (token.type == Type.EndSymbol) {
            endToken = token;
        }

        return token;
    }

    private State state;
    private final LinkedList<Token> tokenBuffer = new LinkedList<>();
    private StringBuilder readBuffer = null;
    private static final char[] FilterChar = new char[]{'\b', '\f', '\r'};
    private static final char[] Space = new char[]{' ', '\t'};
    private static final char[] IdentifierRearSign = new char[]{'?', '!'};
    private static final HashMap<Character, Character> StringTMMap = new HashMap<>();
    private boolean transferredMeaningSign;

    static {
        StringTMMap.put('\"', '\"');
        StringTMMap.put('\'', '\'');
        StringTMMap.put('\\', '\\');
        StringTMMap.put('b', '\b');
        StringTMMap.put('f', '\f');
        StringTMMap.put('t', '\t');
        StringTMMap.put('r', '\r');
        StringTMMap.put('n', '\n');
    }

    private boolean inIdentifierSetButNotRear(char c) {
        return (c >= 'a' && c <= 'z')
                | (c >= 'A' && c <= 'Z')
                | (c >= '0' && c <= '9')
                | (c == '_');
    }

    private boolean include(char[] range, char c) {
        boolean include = false;

        for (int i = 0; i < range.length; ++i) {
            if (range[i] == c) {
                include = true;
                break;
            }
        }

        return include;
    }

    private void refreshBuffer(char c) {
        readBuffer = new StringBuilder();
        readBuffer.append(c);
    }

    private void createToken(Type type) {
        Token token = new Token(type, readBuffer.toString());
        tokenBuffer.addFirst(token);
        readBuffer = null;
    }

    private void createToken(Type type, String value) {
        Token token = new Token(type, value);
        tokenBuffer.addFirst(token);
        readBuffer = null;
    }

    /*
     * readBuffer.append(c) 不断缓存读入字符
     * 在合适时机(由状态机决定)调用 createToken() 生成 Token 并返回给 Parser 使用
     */
    private boolean readChar(char c) throws LexicalAnalysisException {
        // Finite State Machine
        boolean moveCursor = true;
        Type createType = null;


        if (!include(FilterChar, c)) {

            if (state == State.Normal) {
                if (inIdentifierSetButNotRear(c)) {
                    state = State.Identifier;
                } else if (SignParser.inCharSet(c)) {
                    state = State.Sign;
                } else if (c == '#') {
                    state = State.Annotation;
                } else if (c == '\"' | c == '\'') {
                    state = State.String;
                    transferredMeaningSign = false;
                } else if (c == '`') {
                    state = State.RegEx;
                    transferredMeaningSign = false;
                } else if (include(Space, c)) {
                    state = State.Space;
                } else if (c == '\n') {
                    createType = Type.NewLine;
                } else if (c == '\0') {
                    createType = Type.EndSymbol;
                } else {
                    throw new LexicalAnalysisException(c);
                }

                refreshBuffer(c);
            } else if (state == State.Identifier) {
                if (inIdentifierSetButNotRear(c)) {
                    readBuffer.append(c);
                } else if (include(IdentifierRearSign, c)) {
                    createType = Type.Identifier;
                    readBuffer.append(c);
                    state = State.Normal;
                } else {
                    createType = Type.Identifier;
                    state = State.Normal;
                    moveCursor = false;
                }
            } else if (state == State.Sign) {
                if (SignParser.inCharSet(c)) {
                    readBuffer.append(c);
                } else {
                    List<String> list = SignParser.parse(readBuffer.toString());

                    for (String signStr : list) {
                        createToken(Type.Sign, signStr);
                    }

                    // tokens have been created in above foreach loop
                    createType = null;
                    state = State.Normal;
                    moveCursor = false;
                }
            } else if (state == State.Annotation) {
                if (c != '\n' && c != '\0') {
                    readBuffer.append(c);
                } else {
                    createType = Type.Annotation;
                    state = State.Normal;
                    moveCursor = false;
                }
            } else if (state == State.String) {
                if (c == '\n') {
                    throw new LexicalAnalysisException(c);
                } else if (c == '\0') {
                    throw new LexicalAnalysisException(c);
                } else if (transferredMeaningSign) {
                    Character tms = (Character) StringTMMap.get(c);

                    if (tms == null) {
                        throw new LexicalAnalysisException(c);
                    }

                    readBuffer.append(tms);
                    transferredMeaningSign = false;
                } else if (c == '\\') {
                    transferredMeaningSign = true;
                } else {
                    readBuffer.append(c);
                    char firstChar = readBuffer.charAt(0);

                    // seperator matching
                    if (firstChar == c) {
                        createType = Type.String;
                        state = State.Normal;
                    }
                }
            } else if (state == State.RegEx) {
                if (transferredMeaningSign) {
                    if (c != '`') {
                        throw new LexicalAnalysisException(c);
                    }

                    readBuffer.append(c);
                } else if (c == '\\') {
                    transferredMeaningSign = true;
                } else if (c == '\0') {
                    throw new LexicalAnalysisException(c);
                } else if (c == '`') {
                    readBuffer.append(c);
                    createType = Type.RegEx;
                    state = State.Normal;
                } else {
                    readBuffer.append(c);
                }
            } else if (state == State.Space) {
                if (include(Space, c)) {
                    readBuffer.append(c);
                } else {
                    createType = Type.Space;
                    state = State.Normal;
                    moveCursor = false;
                }
            }

        }

        if (createType != null) {
            createToken(createType);
        }

        return moveCursor;
    }
}

