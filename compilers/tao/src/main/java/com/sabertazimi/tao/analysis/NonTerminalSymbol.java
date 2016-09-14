package com.sabertazimi.tao.analysis;

/**
 * Created by sabertazimi on 16-9-14.
 */
import java.util.ArrayList;
import java.util.HashSet;

class NonTerminalSymbol {

    static enum Exp {
        //空白
        SplitSpaceSign, SpaceOrEnter, Space,
        //基本单元
        Enter, This, Null, Boolean,
        Number, Variable, String, RegEx,
        Element,
        //表达式相关
        L0Expression, L0ParamExpression, L0Sign,
        L1Expression, L1ParamExpression,
        L2Expression, L2ParamExpression, L2Sign,
        L3Expression, L3ParamExpression, L3Sign,
        L4Expression, L4ParamExpression, L4Sign,
        L5Expression, L5ParamExpression, L5Sign,
        L6Expression, L6ParamExpression, L6Sign,
        L7Expression, L7ParamExpression, L7Sign,
        L8Expression, L8ParamExpression, L8Sign,
        L9Expression, L9ParamExpression, L9Sign,
        L10Expression, L10ParamExpression, L10Tail, L10TailOperation,
        L11Expression,
        //控制流语法
        Chunk, StartChunk, Line,
        Command, Operate, When,
        DefineVariable, DefineVariableElement,
        DefineFunction, ParamsList,
        IfElseChunk, TryCatch,
        WhileChunk, DoUntilChunk,
        ForEachChunk, ForEachCommand, ForEachCondition,
        //语法糖
        Lambda,
        List, Map, MapEntry,
        Invoker, InvokerBraceless, InvokerBanLambda, InvokerBracelessBanLambda,
        ParamList, ParamListBanTokens ,
        Array, Container,
    }

    final Exp exp;
    Character sign = null;

    final ArrayList<Object[]> expansionList = new ArrayList<>();
    final ArrayList<TerminalSymbol> banList = new ArrayList<>();

    final ArrayList<HashSet<TerminalSymbol>> firstSetList = new ArrayList<>();
    final HashSet<TerminalSymbol> firstSet = new HashSet<>();

    NonTerminalSymbol(Exp exp) {
        this.exp = exp;
    }

    /*
     * chain pattern
     */
    NonTerminalSymbol ban(TerminalSymbol...args) {
        for(TerminalSymbol node:args) {
            banList.add(node);
        }
        return this;
    }

    /*
     * chain pattern
     */
    NonTerminalSymbol or(Object...args) {
        expansionList.add(args);
        return this;
    }

    /*
     * chain pattern
     */
    NonTerminalSymbol sign(char sign) {
        this.sign = sign;
        return this;
    }

    @Override
    public String toString() {
        String str = String.valueOf(exp);
        if(sign != null) {
            str += "(" + sign + ")";
        }
        return str;
    }
}
