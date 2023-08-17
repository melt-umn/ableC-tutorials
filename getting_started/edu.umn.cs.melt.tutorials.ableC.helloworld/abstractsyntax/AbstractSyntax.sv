grammar edu:umn:cs:melt:tutorials:ableC:helloworld:abstractsyntax;

imports edu:umn:cs:melt:ableC:abstractsyntax:host;

abstract production hello
s::Stmt ::=
{
  forwards to
    exprStmt(
      directCallExpr( 
        name("printf"),
        consExpr(
          stringLiteral("\"Hello, world!\\n\""),
          nilExpr())));
}

