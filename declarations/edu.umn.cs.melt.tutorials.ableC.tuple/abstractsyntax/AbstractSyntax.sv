grammar edu:umn:cs:melt:tutorials:ableC:tuple:abstractsyntax;

imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:env;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;

imports silver:langutil;
imports silver:langutil:pp;


abstract production tupleDecl
top::Decl ::= n::Name tns::TypeNames
{
  top.pp = pp"tuple ${n.pp} (${ppImplode(pp", ", tns.pps)})";
  attachNote extensionGenerated("tuple");
  propagate env, controlStmtContext;

  tns.index = 0;

  forwards to
    decls(
      foldDecl(
        -- declarations implicit in tns, such as forward-declaring structs
        tns.decls ++
        -- typedef struct ${n} ${n};
        [typedefDecls(
           nilAttribute(),
           tagReferenceTypeExpr(nilQualifier(), structSEU(), n),
           consDeclarator(
             declarator(n, baseTypeExpr(), nilAttribute(), nothingInitializer()),
             nilDeclarator())),
         -- Defer the struct definition until all members have been defined
         -- Construct a chain of deferredDecl productions for each member refId
         foldr(
           deferredDecl,
           -- struct ${n} { ${tns.tupleStructItems} };
           typeExprDecl(
             nilAttribute(),
             structTypeExpr(
               nilQualifier(),
               structDecl(
                 nilAttribute(),
                 justName(n),
                 tns.tupleStructItems))),
           -- Compute the list of all member refIds
           catMaybes(map((.maybeRefId), tns.typereps)))]));
}

synthesized attribute tupleStructItems :: StructItemList occurs on TypeNames;
inherited attribute index :: Integer occurs on TypeNames;

aspect production consTypeName
top::TypeNames ::= h::TypeName t::TypeNames
{
  attachNote extensionGenerated("tuple");
  local fieldName::String = "f" ++ toString(top.index);
  top.tupleStructItems =
    consStructItem(
      structItem(
        nilAttribute(),
        h.bty,
        consStructDeclarator(
          structField(name(fieldName), h.mty, nilAttribute()),
          nilStructDeclarator())),
      t.tupleStructItems);
  t.index = top.index + 1;
}

aspect production nilTypeName
top::TypeNames ::=
{
  top.tupleStructItems = nilStructItem();
}