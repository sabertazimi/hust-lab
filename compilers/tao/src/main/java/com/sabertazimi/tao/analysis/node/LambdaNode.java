package com.sabertazimi.tao.analysis.node;

import java.io.PrintStream;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import com.sabertazimi.tao.analysis.AnalysisNode;

public abstract class LambdaNode extends AnalysisNode {

    public List<String> paramNameList = new LinkedList<>();
    public ChunkNode chunk;

    @Override
    public void print(int retractNum, PrintStream out) {
        out.print(" do(");
        printParams(retractNum, out, paramNameList);
        out.print(")\n");
        if(chunk != null) {
            chunk.print(retractNum + 1, out);
        }
        printRetract(retractNum, out);
        out.print("end");
    }
}
