package com.sabertazimi.tao.analysis;

/**
 * Created by sabertazimi on 16-9-14.
 */
public class LexicalAnalysisException extends Exception{
    private final String errorMsg;

    public LexicalAnalysisException() {
        errorMsg = "Lexical Exception";
    }

    public LexicalAnalysisException(char c) {
        errorMsg = "Lexical Exception: " + c;
    }

    public LexicalAnalysisException(String str) {
        errorMsg = "Lexical Exception: " + str;
    }
}
