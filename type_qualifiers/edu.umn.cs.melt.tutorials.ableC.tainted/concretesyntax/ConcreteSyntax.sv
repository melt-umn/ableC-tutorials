grammar edu:umn:cs:melt:tutorials:ableC:tainted:concretesyntax;

imports silver:langutil only ast; 

imports edu:umn:cs:melt:ableC:concretesyntax;

imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;
imports edu:umn:cs:melt:tutorials:ableC:tainted:abstractsyntax;

marking terminal Tainted_t 'tainted' lexer classes {Keyword, Global};
marking terminal Untainted_t 'untainted' lexer classes {Keyword, Global};

concrete production taintedTypeQualifier_c
top::TypeQualifier_c ::= 'tainted'
{
  top.typeQualifiers = foldQualifier([taintedQualifier()]);
  top.mutateTypeSpecifiers = [];
}

concrete production untaintedTypeQualifier_c
top::TypeQualifier_c ::= 'untainted'
{
  top.typeQualifiers = foldQualifier([untaintedQualifier()]);
  top.mutateTypeSpecifiers = [];
}

