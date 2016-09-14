package com.sabertazimi.tao.intermediatecode;

import java.util.List;

import com.sabertazimi.tao.analysis.node.ChunkNode;
import com.sabertazimi.tao.intermediatecode.CodeChunk.Command;

public class IntermediateCodeCreator {

    private final int functionStartIndex;

    public IntermediateCodeCreator(int functionStartIndex) {
        this.functionStartIndex = functionStartIndex;
    }

    public Result create(ChunkNode chunk) throws IntermediateCodeExpression {
        ChunkContext context = new ChunkContext(functionStartIndex);
        CodeCreator.instance.handleChunk(chunk, context);
        context.codeChunk.push(Command.Return, -1);
        PlaceholderReplacement.instance.handle(context.placeholderRegisterList);
        return new Result(context.codeChunk, context.functionRecorder.getContainer());
    }
    
    public static class Result {
        public final CodeChunk targetCode;
        public final List<CodeChunk> functionBodyTable;

        private Result(CodeChunk targetCode, List<CodeChunk> functionBodyTable) {
            this.targetCode = targetCode;
            this.functionBodyTable = functionBodyTable;
        }
    }
}
