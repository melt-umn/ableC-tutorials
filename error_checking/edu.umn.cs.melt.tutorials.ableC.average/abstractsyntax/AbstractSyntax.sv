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
  propagate env, controlStmtContext;

  local localErrors::[Message] =
    (if !l.typerep.isArithmeticType
     then [errFromOrigin(l, s"Average operand must have arithmetic type (got ${showType(l.typerep)})")]
     else []) ++
    (if !r.typerep.isArithmeticType
     then [errFromOrigin(l, s"Average operand must have arithmetic type (got ${showType(r.typerep)})")]
     else []);
  local fwrd::Expr =
    divExpr(addExpr(l, r), mkIntConst(2));
  
  {- Same as
  forwards to
    if !null(localErrors)
    then errorExpr(localErrors)
    else fwrd;-}
  forwards to mkErrorCheck(localErrors, fwrd);
}
