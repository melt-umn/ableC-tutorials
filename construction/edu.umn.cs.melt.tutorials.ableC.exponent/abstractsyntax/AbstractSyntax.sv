grammar edu:umn:cs:melt:tutorials:ableC:exponent:abstractsyntax;

imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:env;
imports edu:umn:cs:melt:ableC:abstractsyntax:overloadable;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;

imports silver:langutil;
imports silver:langutil:pp;

abstract production exponentExpr
top::Expr ::= l::Expr r::Expr
{
  top.pp = pp"(${l.pp} ** ${r.pp})";

  local localErrors::[Message] =
    (if !l.typerep.isArithmeticType
     then [err(l.location, s"Exponent base must have aritimetic type (got ${showType(l.typerep)})")]
     else []) ++
    (if !r.typerep.isIntegerType
     then [err(l.location, s"Exponent power must have integer type (got ${showType(r.typerep)})")]
     else []);

  local lTempName::String = "_l_" ++ toString(genInt());
  local rTempName::String = "_r_" ++ toString(genInt());
  local fwrd::Expr =
    ableC_Expr {
      ({$Decl{autoDecl(name(lTempName, location=builtin), decExpr(l, location=builtin))};
        $Decl{autoDecl(name(rTempName, location=builtin), decExpr(r, location=builtin))};
        $directTypeExpr{l.typerep} _res = 1;
        if ($name{rTempName} < 0) {
          $name{lTempName} = 1 / $name{lTempName};
          $name{rTempName} = -$name{rTempName};
        }
        for (long _i = 0; _i < $name{rTempName}; _i++) {
          _res *= $name{lTempName};
        }
        _res;})
    };
  
  r.env = addEnv(l.defs, l.env);
  
  forwards to mkErrorCheck(localErrors, fwrd);
}

global builtin::Location = builtinLoc("exponent");
