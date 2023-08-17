grammar edu:umn:cs:melt:tutorials:ableC:tainted:abstractsyntax;

imports silver:langutil;
imports silver:langutil:pp;

imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;
imports edu:umn:cs:melt:ableC:abstractsyntax:env;

abstract production taintedQualifier
top::Qualifier ::=
{
  top.pp = pp"tainted";
  top.mangledName = "tainted";
  top.qualIsPositive = true;
  top.qualIsNegative = false;
  top.qualAppliesWithinRef = true;
  top.qualCompat = \qualToCompare::Qualifier ->
    case qualToCompare of
      taintedQualifier() -> true
    | _                  -> false
    end;
  top.errors :=
    if containsQualifier(untaintedQualifier(), top.typeToQualify)
    then [errFromOrigin(top, "cannot qualify a type as both tainted and untainted")]
    else [];
}

abstract production untaintedQualifier
top::Qualifier ::=
{
  top.pp = pp"untainted";
  top.mangledName = "untainted";
  top.qualIsPositive = false;
  top.qualIsNegative = true;
  top.qualAppliesWithinRef = true;
  top.qualCompat = \qualToCompare::Qualifier ->
    case qualToCompare of
      untaintedQualifier() -> true
    | _                  -> false
    end;
  top.errors :=
    if containsQualifier(taintedQualifier(), top.typeToQualify)
    then [errFromOrigin(top, "cannot qualify a type as both tainted and untainted")]
    else [];
}

