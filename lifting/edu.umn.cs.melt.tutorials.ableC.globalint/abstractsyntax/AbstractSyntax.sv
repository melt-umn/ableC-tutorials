grammar edu:umn:cs:melt:tutorials:ableC:globalint:abstractsyntax;

imports silver:langutil;

imports edu:umn:cs:melt:ableC:abstractsyntax:host;

abstract production globalIntRefExpr
top::Expr ::= n::Name
{
  attachNote extensionGenerated("globalint");
  -- The name of the variable implementing this global int
  local varName::String = s"_globalint_${n.name}";
  
  forwards to
    injectGlobalDeclsExpr(
      -- The AST to be lifted
      consDecl(
        -- Forward to a declaration of the variable if it hasn't already been declared
        maybeValueDecl(
          varName,
          ableC_Decl { int $name{varName}; }),
        nilDecl()),
      -- The 'base' AST that will exist after lifting has occured
      declRefExpr(name(varName)));
}

