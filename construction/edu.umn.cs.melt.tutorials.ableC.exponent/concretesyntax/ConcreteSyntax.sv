grammar edu:umn:cs:melt:tutorials:ableC:exponent:concretesyntax;

imports edu:umn:cs:melt:ableC:concretesyntax;
imports silver:langutil only ast; 

imports edu:umn:cs:melt:tutorials:ableC:exponent:abstractsyntax;

marking terminal ExponentOp_t '**' lexer classes {Operator};

-- Exponentiation is typically right associative, unlike other arthmetic operators
concrete production exponentExpr_c
top::AddMulRightOp_c ::= '**'
{
  top.ast = exponentExpr(top.leftExpr, top.rightExpr);
}