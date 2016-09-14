package com.sabertazimi.tao.analysis.node;

import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

import com.sabertazimi.tao.analysis.AnalysisNode;
import com.sabertazimi.tao.analysis.TerminalSymbol;


public class ArrayNode extends AnalysisNode {

    public List<ExpressionNode> content = new ArrayList<>();

    @Override
    public void print(int retractNum, PrintStream out) {
        out.print("[");
        printParams(retractNum, out, content);
        out.print("]");
    }

    @Override
    public void match(AnalysisNode analysisNode) { }

    @Override
    public void match(TerminalSymbol token) { }
}
