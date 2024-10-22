grammar edu:umn:cs:melt:tutorials:ableC:intconst:abstractsyntax;

imports silver:util:treemap as tm;

-- Define an item to store values to be placed into the environment
synthesized attribute value::Integer;

tracked nonterminal IntConstItem with value;

abstract production intConstItem
top::IntConstItem ::= value::Integer
{
  top.value = value;
}

abstract production errorIntConstItem
top::IntConstItem ::= 
{
  top.value = 0; -- Default value in case of error
}

-- Define a new namespace on the environment storing the new type of item
synthesized attribute intConsts::Scopes<IntConstItem> occurs on Env;
synthesized attribute intConstContribs::Contribs<IntConstItem> occurs on Defs, Def;

aspect production emptyEnv_i
top::Env ::=
{
  top.intConsts = [tm:empty()];
}
aspect production addEnv_i
top::Env ::= d::Defs  e::Decorated Env
{
  top.intConsts = addGlobalScope(gd.intConstContribs, addScope(d.intConstContribs, e.intConsts));
}
aspect production openScopeEnv_i
top::Env ::= e::Decorated Env
{
  top.intConsts = tm:empty() :: e.intConsts;
}
aspect production nonGlobalEnv_i
top::Env ::= e::Decorated Env
{
  top.intConsts = init(e.intConsts);
}
aspect production globalEnv_i
top::Env ::= e::Decorated Env
{
  top.intConsts = [last(e.intConsts)];
}
aspect production functionEnv_i
top::Env ::= e::Decorated Env
{
  top.intConsts = functionScope(e.intConsts);
}

aspect production nilDefs
top::Defs ::=
{
  top.intConstContribs = [];
}
aspect production consDefs
top::Defs ::= h::Def  t::Defs
{
  top.intConstContribs = h.intConstContribs ++ t.intConstContribs;
}

aspect default production
top::Def ::=
{
  top.intConstContribs = [];
}

abstract production intConstDef
top::Def ::= s::String  v::IntConstItem
{
  top.intConstContribs = [(s, v)];
}

function lookupIntConst
[IntConstItem] ::= n::String  e::Decorated Env
{
  return lookupScope(n, e.intConsts);
}

-- We put these attributes on Name to have it do the actual lookup and error checking.
-- This is somewhat cleaner than writing seperate helper functions.
synthesized attribute intConstItem::Decorated IntConstItem occurs on Name;
synthesized attribute intConstLookupCheck::[Message] occurs on Name;
synthesized attribute intConstRedeclarationCheck::[Message] occurs on Name;

aspect production name
top::Name ::= n::String
{
  local intConsts::[IntConstItem] = lookupIntConst(n, top.env);
  top.intConstLookupCheck =
    case intConsts of
    | [] -> [errFromOrigin(top, "Undeclared integer constant " ++ n)]
    | _ :: _ -> []
    end;
    
  top.intConstRedeclarationCheck =
    case intConsts of
    | [] -> []
    | v :: _ ->
      [errFromOrigin(top,
        "Redeclaration of " ++ n ++ ". Original (from " ++
        getParsedOriginLocationOrFallback(v).unparse ++ ")")]
    end;
  
  local intConst::IntConstItem = if null(intConsts) then errorIntConstItem() else head(intConsts);
  top.intConstItem = intConst;
}
