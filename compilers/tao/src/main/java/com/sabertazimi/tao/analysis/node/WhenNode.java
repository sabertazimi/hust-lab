package com.sabertazimi.tao.analysis.node;

import java.io.PrintStream;

import com.sabertazimi.tao.analysis.AnalysisNode;


public abstract class WhenNode extends AnalysisNode {

    public ExpressionNode condition;

    @Override
    public void print(int retractNum, PrintStream out) {
        out.print(" when ");
        condition.print(retractNum, out);
    }
}
