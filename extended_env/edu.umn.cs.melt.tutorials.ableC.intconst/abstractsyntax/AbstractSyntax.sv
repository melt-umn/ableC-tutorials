grammar edu:umn:cs:melt:tutorials:ableC:intconst:abstractsyntax;

imports silver:langutil;
imports silver:langutil:pp;

imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:env;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;

abstract production intConstDecl
top::Decl ::= n::Name v::Integer
{
  top.pp = pp"intconst ${n.pp} = ${text(toString(v))};";
  attachNote extensionGenerated("intconst");
  propagate env;
  local localErrors::[Message] = n.intConstRedeclarationCheck;
  
  local fwrd::Decl =
    defsDecl([intConstDef(n.name, intConstItem(v))]);
  
  forwards to
    if !null(localErrors)
    then decls(consDecl(warnDecl(localErrors), consDecl(fwrd, nilDecl())))
    else fwrd;
}

abstract production intConstRef
top::Expr ::= n::Name
{
  top.pp = n.pp;
  propagate env;
  local localErrors::[Message] = n.intConstLookupCheck;
  
  local fwrd::Expr = mkIntConst(n.intConstItem.value); -- Helper function that constructs an integer literal Expr
  
  forwards to mkErrorCheck(localErrors, fwrd);
}

