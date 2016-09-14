package com.sabertazimi.tao.analysis.node;

import java.io.PrintStream;

import com.sabertazimi.tao.analysis.AnalysisNode;

public abstract class OperateNode extends AnalysisNode {

    public ExpressionNode expression;
    public WhenNode condition;

    @Override
    public void print(int retractNum, PrintStream out) {
        expression.print(retractNum, out);
        if(condition != null) {
            condition.print(retractNum, out);
        }
    }

}
