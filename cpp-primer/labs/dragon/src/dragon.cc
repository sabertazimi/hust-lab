/*
 * dragon.cc
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include "syntax/Tree.h"
#include "syntax/AstPrinter.h"
#include "semantic/Scope.h"
#include "semantic/semantic.h"
#include "ir/Translater.h"
#include "codegen/X86.h"

using namespace std;

#define AST_DEBUG
// #undef AST_DEBUG

#define SEMA_DEBUG
// #undef SEMA_DEBUG

#define IR_DEBUG
// #undef IR_DEBUG

#define ASM_DEBUG
// #undef ASM_DEBUG

extern FILE *yyin;
extern int yyparse(void);
extern Program *tree;
extern int parse_failed;

ScopeStack *gtable;     ///< global scope stack

int main(int argc, char **argv) {
    FILE *fp = NULL;

    if (argc > 1 && (fp = fopen(argv[1], "r")) != NULL) {
        yyin = fp;
    }

    // yyparse return value: 1 represent error occurs
    while (yyparse()) {
        fprintf(stderr, "*** please fix syntax error first!\n");
        fclose(fp);
        exit(1);
    }

    if (parse_failed == 1) {
        fprintf(stderr, "*** please fix syntax error first!\n");
        fclose(fp);
        return 0;
    }

#ifdef AST_DEBUG
    AstPrinter *ast_ap = new AstPrinter("dragon.ast");
    tree->print(ast_ap);
#endif

    // set up global scope stack
    gtable = new ScopeStack();

	BuildSymbol *bs = new BuildSymbol(gtable);
    bs->visitProgram(tree);
	TypeCheck *tc = new TypeCheck(gtable);
    tc->visitProgram(tree);

    if (bs->failed == 1 || tc->failed == 1) {
        fprintf(stderr, "*** please fix semantic error first!\n");
        fclose(fp);
        return 0;
    }

#ifdef SEMA_DEBUG
    AstPrinter *sema_ap = new AstPrinter("dragon.sym");
    tree->globalScope->print(sema_ap);
#endif

    // IR generation
    Translater *tr = Translater::translate(tree);

#ifdef IR_DEBUG
    cout << endl;
    AstPrinter *ir_ap = new AstPrinter("dragon.tac");
    tr->print(ir_ap);
#endif

    // Code generation
    AstPrinter *asm_ap = new AstPrinter("dragon.S");
    X86 *x86 = new X86(asm_ap);
    x86->emitAsm(tr);

    // invoke gcc to compile asm file
    string output;
    if (argc >= 3) {
        output = string(argv[2]);
    } else {
        output = string(argv[1]) + ".exe";
    }
    string asmCmd = "gcc -m32 -Wall -Wextra -g dragon.S -o " + output;
    system(asmCmd.c_str());

#ifndef ASM_DEBUG
    system("rm -fr dragon.S");
#endif

    fclose(fp);
    return 0;
}
