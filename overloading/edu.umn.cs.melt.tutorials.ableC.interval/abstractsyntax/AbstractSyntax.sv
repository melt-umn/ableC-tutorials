grammar edu:umn:cs:melt:tutorials:ableC:interval:abstractsyntax;

imports silver:langutil;
imports silver:langutil:pp;

imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;
imports edu:umn:cs:melt:ableC:abstractsyntax:env;

abstract production newInterval
top::Expr ::= min::Expr max::Expr
{
  top.pp = pp"intr [${min.pp}, ${max.pp}]";

  local localErrors::[Message] =
    checkIntervalHeaderDef("new_interval", top.env);
  local fwrd::Expr =
    directCallExpr(name("new_interval"), foldExpr([min, max]));
  forwards to mkErrorCheck(localErrors, fwrd);
}

abstract production initInterval
top::Initializer ::= i::InitList
{
  top.pp = ppConcat([text("{"), ppImplode(text(", "), i.pps), text("}")]);
  propagate env, controlStmtContext;
  i.expectedType = top.expectedType;
  i.expectedTypes = [];
  i.tagEnvIn = emptyEnv();
  i.initIndex = 0;
  forwards to
    case i of
    | consInit(positionalInit(exprInitializer(min)), consInit(positionalInit(exprInitializer(max)), nilInit())) ->
      exprInitializer(newInterval(min, max))
    | _ -> exprInitializer(errorExpr([errFromOrigin(top, "Invalid interval initializer")]))
    end;
}

-- Extension productions that are used to resolve overloaded operators
abstract production memberInterval
top::Expr ::= lhs::Expr deref::Boolean rhs::Name
{
  top.pp = parens(ppConcat([lhs.pp, text(if deref then "->" else "."), rhs.pp]));
  attachNote extensionGenerated("interval");
  propagate env, controlStmtContext;

  local localErrors::[Message] =
    checkIntervalHeaderDef("new_interval", top.env) ++
    checkIntervalType(lhs.typerep, ".") ++
    (if rhs.name == "min" || rhs.name == "max"
     then []
     else [errFromOrigin(rhs, s"interval does not have member ${rhs.name}")]);
  local fwrd::Expr =
    memberExpr(
      explicitCastExpr(
        typeName(
          tagReferenceTypeExpr(
            nilQualifier(), structSEU(),
            name("_interval_s")),
          baseTypeExpr()),
        lhs),
      false, rhs);
  forwards to mkErrorCheck(localErrors, fwrd);
}

abstract production negInterval
top::Expr ::= i::Expr
{
  top.pp = pp"-(${i.pp})";
  attachNote extensionGenerated("interval");
  propagate env, controlStmtContext;

  local localErrors::[Message] =
    checkIntervalHeaderDef("neg_interval", top.env) ++
    checkIntervalType(i.typerep, "-");
  local fwrd::Expr =
    directCallExpr(name("neg_interval"), foldExpr([i]));
  forwards to mkErrorCheck(localErrors, fwrd);
}

abstract production invInterval
top::Expr ::= i::Expr
{
  top.pp = pp"~(${i.pp})";
  attachNote extensionGenerated("interval");
  propagate env, controlStmtContext;
  
  local localErrors::[Message] =
    checkIntervalHeaderDef("inv_interval", top.env) ++
    checkIntervalType(i.typerep, "~");
  local fwrd::Expr =
    directCallExpr(name("inv_interval"), foldExpr([i]));
  forwards to mkErrorCheck(localErrors, fwrd);
}

abstract production addInterval
top::Expr ::= i1::Expr i2::Expr
{
  top.pp = pp"(${i1.pp}) + (${i2.pp})";
  attachNote extensionGenerated("interval");
  propagate env, controlStmtContext;

  local localErrors::[Message] =
    checkIntervalHeaderDef("add_interval", top.env) ++
    checkIntervalType(i1.typerep, "+") ++
    checkIntervalType(i2.typerep, "+");
  local fwrd::Expr =
    directCallExpr(name("add_interval"), foldExpr([i1, i2]));
  forwards to mkErrorCheck(localErrors, fwrd);
}

abstract production subInterval
top::Expr ::= i1::Expr i2::Expr
{
  top.pp = pp"(${i1.pp}) - (${i2.pp})";
  attachNote extensionGenerated("interval");
  propagate env, controlStmtContext;

  local localErrors::[Message] =
    checkIntervalHeaderDef("sub_interval", top.env) ++
    checkIntervalType(i1.typerep, "-") ++
    checkIntervalType(i2.typerep, "-");
  local fwrd::Expr =
    directCallExpr(name("sub_interval"), foldExpr([i1, i2]));
  forwards to mkErrorCheck(localErrors, fwrd);
}

abstract production mulInterval
top::Expr ::= i1::Expr i2::Expr
{
  top.pp = pp"(${i1.pp}) * (${i2.pp})";
  attachNote extensionGenerated("interval");
  propagate env, controlStmtContext;

  local localErrors::[Message] =
    checkIntervalHeaderDef("mul_interval", top.env) ++
    checkIntervalType(i1.typerep, "*") ++
    checkIntervalType(i2.typerep, "*");
  local fwrd::Expr =
    directCallExpr(name("mul_interval"), foldExpr([i1, i2]));
  forwards to mkErrorCheck(localErrors, fwrd);
}

abstract production divInterval
top::Expr ::= i1::Expr i2::Expr
{
  top.pp = pp"(${i1.pp}) / (${i2.pp})";
  attachNote extensionGenerated("interval");
  propagate env, controlStmtContext;

  local localErrors::[Message] =
    checkIntervalHeaderDef("div_interval", top.env) ++
    checkIntervalType(i1.typerep, "/") ++
    checkIntervalType(i2.typerep, "/");
  local fwrd::Expr =
    directCallExpr(name("div_interval"), foldExpr([i1, i2]));
  forwards to mkErrorCheck(localErrors, fwrd);
}

abstract production equalsInterval
top::Expr ::= i1::Expr i2::Expr
{
  top.pp = pp"(${i1.pp}) == (${i2.pp})";
  attachNote extensionGenerated("interval");
  propagate env, controlStmtContext;

  local localErrors::[Message] =
    checkIntervalHeaderDef("equals_interval", top.env) ++
    checkIntervalType(i1.typerep, "==") ++
    checkIntervalType(i2.typerep, "==");
  local fwrd::Expr =
    directCallExpr(name("equals_interval"), foldExpr([i1, i2]));
  forwards to mkErrorCheck(localErrors, fwrd);
}

-- Check the given env for the given function name
function checkIntervalHeaderDef
[Message] ::= n::String env::Decorated Env
{
  return
    if !null(lookupValue(n, env))
    then []
    else [errFromOrigin(ambientOrigin(), "Missing include of interval.xh")];
}

-- Check that operand has interval type
function checkIntervalType
[Message] ::= t::Type op::String
{
  return
    if typeAssignableTo(extType(nilQualifier(), intervalType()), t)
    then []
    else [errFromOrigin(ambientOrigin(), s"Operand to ${op} expected interval type (got ${showType(t)})")];
}

