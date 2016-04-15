/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  type.h,v
 * Revision 1.19  1995/05/11  18:54:40  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.18  1995/04/21  05:45:01  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.17  1995/04/09  21:31:03  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.16  1995/03/23  15:31:42  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.15  1995/03/01  16:23:29  rcm
 * Various type-checking bug fixes; added T_REDUNDANT_EXTERNAL_DECL.
 *
 * Revision 1.14  1995/02/01  23:02:10  rcm
 * Added Text node and #pragma collection
 *
 * Revision 1.13  1995/02/01  07:39:10  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.12  1995/01/27  01:39:20  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.11  1995/01/25  21:38:31  rcm
 * Added TypeModifiers to make type modifiers extensible
 *
 * Revision 1.10  1995/01/25  02:16:28  rcm
 * Changed how Prim types are created and merged.
 *
 * Revision 1.9  1995/01/20  03:38:26  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.8  1995/01/06  16:49:17  rcm
 * added copyright message
 *
 * Revision 1.7  1994/12/23  09:18:52  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.6  1994/12/20  09:24:29  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.5  1994/11/22  01:54:56  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:13:47  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.3  1994/11/03  07:39:09  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.2  1994/10/28  18:53:23  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Mon Apr 26 15:01:06 EDT 1993
 *
 *
 *
 * Copyright (c) 1994 MIT Laboratory for Computer Science
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE MIT LABORATORY FOR COMPUTER SCIENCE BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * Except as contained in this notice, the name of the MIT Laboratory for
 * Computer Science shall not be used in advertising or otherwise to
 * promote the sale, use or other dealings in this Software without prior
 * written authorization from the MIT Laboratory for Computer Science.
 * 
 *************************************************************************/
#if 0
#pragma ident "type.h,v 1.19 1995/05/11 18:54:40 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#ifndef _TYPE_H_
#define _TYPE_H_

GLOBAL Node *EllipsisNode; /* represents '...'  primitive type */



/* A declarator has several context-dependent scoping options: */
typedef enum {
    Redecl,    /* may redeclare a typdef name */
    NoRedecl,  /* may not redeclare a typedef name */
    SU,        /* is a structure or union field */
    Formal     /* is a formal parameter, goes into scope of the following body
		  (storage class NOT extern, static, typedef, auto) */
} ScopeState;

/* Global Type constants */
extern Node *PrimVoid,  *PrimChar, *PrimSchar, *PrimUchar, 
            *PrimSshort, *PrimUshort, 
            *PrimSint,  *PrimUint,  *PrimSlong, *PrimUlong, 
            *PrimSlonglong, *PrimUlonglong,
            *PrimFloat, *PrimDouble, *PrimLongdouble;

extern Node *StaticString;

extern Node *SintZero,  *UintZero, 
            *SlongZero, *UlongZero, 
            *FloatZero, *DoubleZero;

extern Node *PtrVoid;
extern Node *PtrNull;

extern Node *SintOne,  *UintOne, 
            *SlongOne, *UlongOne, 
            *FloatOne, *DoubleOne;

/* Global flags (yuck) */

#if 0
/* no longer necessary -- now parser detects whether '{' begins a create
   scope by itself */
GLOBAL extern int NoNewScope;                   /* type.c */
    /* This determines whether or not a '{' begins a create scope.
       NoNewScope > 0 in the following cases:
             struct { ... }
	     union { ... }
	     enum { ... }
	     array initializers:  = { a, b, ... }
    */
#endif

GLOBAL extern Bool OldStyleFunctionDefinition;  /* procedure.c */
    /* The parameter declarations of an old-style function definition
       must be scoped into the body of function, not their current scope.
       This flag tracks this condition; it is TRUE from the end of the
       argument list (which is all identifiers) until the next '{', which
       starts the body. */


/* Global Variables from type.c */
GLOBAL extern Node *Undeclared;  /* used for undeclared identifiers */


/* Global Procedures from type.c */
GLOBAL void InitTypes(void);

GLOBAL Node *TypeQualifyNode(Node *node, TypeQual tq);
GLOBAL TypeQual MergeTypeQuals(TypeQual left, TypeQual right, Coord coord);
GLOBAL Node *MakeMergedType(Node *type1, Node *qual1);
GLOBAL TypeQual NodeTq(Node *node);
GLOBAL void     NodeSetTq(Node *node, TypeQual mask, TypeQual tq);
GLOBAL void     NodeAddTq(Node *node, TypeQual tq);
GLOBAL void     NodeRemoveTq(Node *node, TypeQual tq);
GLOBAL TypeQual NodeTypeQuals(Node *node);
GLOBAL TypeQual NodeDeclQuals(Node *node);
GLOBAL TypeQual NodeStorageClass(Node *node);
GLOBAL void     NodeSetStorageClass(Node *node, TypeQual sc);
GLOBAL TypeQual NodeDeclLocation(Node *node);
GLOBAL void     NodeSetDeclLocation(Node *node, TypeQual dl);
GLOBAL int  TQtoText(char array[], TypeQual tq);
GLOBAL int  PrintTQ(FILE *out, TypeQual tq);

GLOBAL Node *StartPrimType(BasicType basic, Coord coord);
GLOBAL Node *MergePrimTypes(Node *node, Node *node2);
GLOBAL Node *FinishPrimType(Node *PrimNode);
GLOBAL Node *MakeDefaultPrimType(TypeQual tq, Coord coord);
GLOBAL Node *SansSign(Node *type);
GLOBAL void PrimToText(char array[], Node *type);
GLOBAL int  PrintPrimType(FILE *out, Node *type);

GLOBAL Node *LookupFunction(Node *call);
GLOBAL Node *LookupPostfixExpression(Node *post);
GLOBAL Bool IsAType(const char *name);
GLOBAL Node *GetTypedefType(Node *id);
GLOBAL void OutOfScope(Node *var);

GLOBAL int   NodeSizeof(Node *node, Node *node_type);
GLOBAL int   NodeAlignment(Node *node, Node *node_type);

GLOBAL Node *ArrayRefType(Node *atype, List *dims);
GLOBAL Bool  IsObjectType(Node *node);
GLOBAL Bool  IsFunctionType(Node *node);
GLOBAL Bool  IsIncompleteType(Node *node);
GLOBAL Bool  IsVoidType(Node *node);
GLOBAL Bool  IsArrayType(Node *node);
GLOBAL Bool  IsSueType(Node *node);
GLOBAL Bool  IsStructType(Node *node);
GLOBAL Bool  IsUnionType(Node *node);
GLOBAL Bool  IsEnumType(Node *node);
GLOBAL Bool  IsPointerType(Node *node);
GLOBAL Bool  IsScalarType(Node *node);
GLOBAL Bool  IsArithmeticType(Node *node);
GLOBAL Bool  IsIntegralType(Node *node);
GLOBAL Bool  IsFloatingType(Node *node);
GLOBAL Bool  IsLvalue(Node *node);
GLOBAL Bool  IsModifiableLvalue(Node *node);
GLOBAL Bool  IsVoidArglist(List *arglist);
GLOBAL Bool  IsEllipsis(Node *node);
GLOBAL Bool  IsRelationalExpression(Node *node);
GLOBAL Bool  IsLogicalExpression(Node *node);
GLOBAL Bool  IsLogicalOrRelationalExpression(Node *node);
GLOBAL Bool  IsPtrToObject(Node *node);
GLOBAL Bool  IsPtrToVoid(Node *node);
GLOBAL Bool  IsPtrToFunction(Node *node);
GLOBAL Node *ArrayType(Node *array);
GLOBAL Bool  IsStructType(Node *node);
GLOBAL Node *PtrSubtype(Node *node);
GLOBAL Bool      DeclIsExtern(Node *node);
GLOBAL Bool      DeclIsEnumConst(Node *node);
GLOBAL Bool      DeclIsTypedef(Node *node);
GLOBAL Bool      NodeIsConstQual(Node *node);
GLOBAL Bool      IsUnsizedArray(Node *node);
GLOBAL Bool      IsStructComplete(Node *node);
GLOBAL Bool      IsUnionComplete(Node *node);
GLOBAL Bool TypeIsChar(Node *type);
GLOBAL Bool TypeIsSint(Node *type);
GLOBAL Bool TypeIsUint(Node *type);
GLOBAL Bool TypeIsSlong(Node *type);
GLOBAL Bool TypeIsUlong(Node *type);
GLOBAL Bool TypeIsFloat(Node *type);
GLOBAL Bool TypeIsDouble(Node *type);
GLOBAL Bool TypeIsString(Node *type);
GLOBAL Bool NodeTypeIsChar(Node *node);
GLOBAL Bool NodeTypeIsSint(Node *node);
GLOBAL Bool NodeTypeIsUint(Node *node);
GLOBAL Bool NodeTypeIsSlong(Node *node);
GLOBAL Bool NodeTypeIsUlong(Node *node);
GLOBAL Bool NodeTypeIsFloat(Node *node);
GLOBAL Bool NodeTypeIsDouble(Node *node);
GLOBAL Bool NodeTypeIsString(Node *node);
GLOBAL Bool NodeTypeIsIntegral(Node *node);
GLOBAL Bool IsPrimChar(Node *node);
GLOBAL Bool IsArrayOfChar(Node *node);
GLOBAL Bool IsStringConstant(Node *node);
GLOBAL Bool IsAggregateType(Node *node);
GLOBAL Bool DeclIsStatic(Node *node);
GLOBAL Bool DeclIsExternal(Node *node);
GLOBAL Node *FunctionReturnType(Node *node);
GLOBAL void FunctionSetReturnType(Node *node, Node *new_type);
GLOBAL void FunctionPushArglist(Node *node, Node *new_arg);
GLOBAL Bool IsPrimitiveStmt(Node *node);

GLOBAL Bool TypeEqual(Node *type1, Node *type2);
GLOBAL Bool TypeEqualQualified(Node *type1, Node *type2, Bool strict_toplevel, Bool strict_recursive);


/* Global Procedures from complex-types.c */

GLOBAL Node *SetBaseType(Node *complex, Node *base);
GLOBAL Node *GetShallowBaseType(Node *complex);
GLOBAL Node *GetDeepBaseType(Node *complex);
GLOBAL Node *ExtendArray(Node *array, Node *dim, Coord coord);
GLOBAL Node *AddArrayDimension(Node *array, Node *dim);
GLOBAL Node *ModifyDeclType(Node *decl, Node *modifier);
GLOBAL Node *SetDeclType(Node *decl, Node *type, ScopeState redeclare);
GLOBAL Node *SetDeclInit(Node *decl, Node *init);
GLOBAL Node *SetDeclBitSize(Node *decl, Node *bitsize);
GLOBAL Node *SetDeclAttribs(Node *decl, List *attribs);
GLOBAL List *AppendDecl(List *list, Node *decl, ScopeState redeclare);
GLOBAL Node *FinishType(Node *type);
GLOBAL Node *FinishDecl(Node *type);

/* Global procedures from sue.c */

GLOBAL void PrintSUE(FILE *out, SUEtype *sue, int offset, Bool norecurse);
GLOBAL Node *SetSUdclNameFields(Node *sudcl, Node *id, List *fields, Coord left_coord, Coord right_coord);
GLOBAL Node *SetSUdclName(Node *sudcl, Node *id, Coord coord);
GLOBAL Node *BuildEnum(Node *id, List *values, Coord enum_coord, Coord left_coord, Coord right_coord);
GLOBAL Node *BuildEnumConst(Node *id, Node *value);
GLOBAL void ShadowTag(SUEtype *create, SUEtype *shadowed);
GLOBAL void VerifySUEcomplete(Node *type);
GLOBAL Node *ForceNewSU(Node *sudcl, Coord coord);
GLOBAL int SUE_Sizeof(SUEtype *sue);
GLOBAL int SUE_Alignment(SUEtype *sue);
GLOBAL Node *SUE_FindField(SUEtype *sue, Node *field_name);
GLOBAL Bool  SUE_SameTagp(SUEtype *sue1, SUEtype *sue2);

/* Global procedures from procedure.c */

GLOBAL Node *AddParameterTypes(Node *decl, List *types);
GLOBAL Node *AddDefaultParameterTypes(Node *decl);
GLOBAL Node *DefineProc(Bool old_style, Node *decl);
GLOBAL Node *SetProcBody(Node *proc, Node *block);
GLOBAL Node *AddReturn(Node *returnnode);
GLOBAL void  FunctionConflict(Node *orig, Node *create);
GLOBAL Node *BuildLabel(Node *id, Node *stmt);
GLOBAL Node *ResolveGoto(Node *id, Coord coord);
GLOBAL void  EndOfLabelScope(Node *label);

/* Global operators from type.c */
GLOBAL Node *NodeDataType(Node *node);
GLOBAL Node *NodeDataTypeSuperior(Node *node);
GLOBAL void  SetNodeDataType(Node *node, Node *type);
GLOBAL Node *SdclFindField(Node *sdcl, Node *field_name);

/* From operators.c */
GLOBAL const char *OperatorName(OpType op);
GLOBAL const char *OperatorText(OpType op);
GLOBAL Bool  IsAssignmentOp(OpType op);
GLOBAL Bool  IsComparisonOp(OpType op);
GLOBAL Bool  IsConversionOp(OpType op);
GLOBAL Bool  IsArithmeticOp(OpType op);


/* From constexpr.c */

GLOBAL Bool NodeIsConstant(Node *node);
GLOBAL Node *NodeGetConstantValue(Node *node);
GLOBAL void NodeSetConstantValue(Node *node, Node *value);

GLOBAL int           NodeConstantCharValue(Node *node);
GLOBAL int           NodeConstantSintValue(Node *node);
GLOBAL unsigned int  NodeConstantUintValue(Node *node);
GLOBAL long          NodeConstantSlongValue(Node *node);
GLOBAL unsigned long NodeConstantUlongValue(Node *node);
GLOBAL float         NodeConstantFloatValue(Node *node);
GLOBAL double        NodeConstantDoubleValue(Node *node);
GLOBAL const char   *NodeConstantStringValue(Node *node);
GLOBAL unsigned long NodeConstantIntegralValue(Node *node);
GLOBAL Bool          NodeConstantBooleanValue(Node *node);

GLOBAL void          NodeSetCharValue(Node *node, int i);
GLOBAL void          NodeSetSintValue(Node *node, int i);
GLOBAL void          NodeSetUintValue(Node *node, unsigned u);
GLOBAL void          NodeSetSlongValue(Node *node, long l);
GLOBAL void          NodeSetUlongValue(Node *node, unsigned long ul);
GLOBAL void          NodeSetFloatValue(Node *node, float f);
GLOBAL void          NodeSetDoubleValue(Node *node, double d);
GLOBAL void          NodeSetStringValue(Node *node, const char *s);

GLOBAL Bool  IsConstantZero(Node *node);
GLOBAL Bool  IsConstantString(Node *node);
GLOBAL Bool  IsIntegralConstant(Node *node);
GLOBAL Bool  IntegralConstEqual(Node *value1, Node *value2);

GLOBAL void ConstFoldTernary(Node *node);
GLOBAL void ConstFoldCast(Node *node);


#endif  /* ifndef _TYPE_H_ */
