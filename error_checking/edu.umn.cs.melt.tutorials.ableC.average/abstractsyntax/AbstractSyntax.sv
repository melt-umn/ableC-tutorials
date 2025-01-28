grammar edu:umn:cs:melt:tutorials:ableC:average:abstractsyntax;

imports edu:umn:cs:melt:ableC:abstractsyntax:env; -- TODO: Why is this import needed?
imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;

imports silver:langutil;
imports silver:langutil:pp;

abstract production averageExpr
top::Expr ::= l::Expr r::Expr
{
  top.pp = pp"(${l.pp} ~~ ${r.pp})";
  attachNote extensionGenerated("average");

  local localErrors::[Message] =
    (if !l.typerep.isArithmeticType
     then [errFromOrigin(l, s"Average operand must have arithmetic type (got ${show(80, l.typerep)})")]
     else []) ++
    (if !r.typerep.isArithmeticType
     then [errFromOrigin(l, s"Average operand must have arithmetic type (got ${show(80, r.typerep)})")]
     else []);
  forward fwrd = divExpr(addExpr(@l, @r), mkIntConst(2));
  forwards to if !null(localErrors) then errorExpr(localErrors) else @fwrd;
}
