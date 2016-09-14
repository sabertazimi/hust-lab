package com.sabertazimi.tao.analysis.node;

import java.io.PrintStream;

import com.sabertazimi.tao.analysis.AnalysisNode;

public abstract class StartChunkNode extends AnalysisNode  {

    public ChunkNode chunk;

    @Override
    public void print(int retractNum, PrintStream out) {
        chunk.print(retractNum, out);
    }
}
