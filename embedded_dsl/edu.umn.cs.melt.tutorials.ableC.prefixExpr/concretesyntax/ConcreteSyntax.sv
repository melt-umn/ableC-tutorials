grammar edu:umn:cs:melt:tutorials:ableC:prefixExpr:concretesyntax;

imports silver:langutil;

imports edu:umn:cs:melt:ableC:concretesyntax;

imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;
imports edu:umn:cs:melt:tutorials:ableC:prefixExpr:abstractsyntax;

marking terminal PrefixExpr_t 'prefix' lexer classes {Keyword, Global};

-- Bridge production from host concrete syntax to extension concrete syntax
-- Note that this begins with a 'marking' terminal, more on that later
concrete production prefixExpr_c
top::AssignExpr_c ::= 'prefix' '(' pe::PrefixExpr_c ')'
{
  top.ast = prefixExpr(pe.ast);
}

-- 'closed' nonterminal = allow nonforwarding productions, disallow new attributes in other extensions
closed tracked nonterminal PrefixExpr_c with ast<PrefixExpr>;

terminal NewPlus_t '+' lexer classes Operator;

-- New syntax for prefix expressions
-- Note that most of the terminals used here are from the host
-- Only the NewPlus_t above is now.
-- Note how it overlaps with the Plus_t from the host.
  
concrete productions top::PrefixExpr_c
| NewPlus_t pe1::PrefixExpr_c pe2::PrefixExpr_c
  { top.ast = addPrefixExpr(pe1.ast, pe2.ast); }
| '-' pe1::PrefixExpr_c pe2::PrefixExpr_c
  { top.ast = subPrefixExpr(pe1.ast, pe2.ast); }
| '*' pe1::PrefixExpr_c pe2::PrefixExpr_c
  { top.ast = mulPrefixExpr(pe1.ast, pe2.ast); }
| '/' pe1::PrefixExpr_c pe2::PrefixExpr_c
  { top.ast = divPrefixExpr(pe1.ast, pe2.ast); }
| c::PrefixConstant_c
  { top.ast = exprPrefixExpr(c.ast); }
| id::Identifier_t
  { top.ast = exprPrefixExpr(declRefExpr(fromId(id))); }
-- 'Escape hatch' production for writing normal expressions
| '(' e::Expr_c  ')'
  { top.ast = exprPrefixExpr(e.ast); }

-- Mirrors Constant_c
-- Can't use Constant_c due to constraints on adding new terminals to host follow sets
-- More on that later.
closed tracked nonterminal PrefixConstant_c with ast<Expr>;
concrete productions top::PrefixConstant_c
-- dec
| c::DecConstant_t
    { top.ast = realConstant(integerConstant(c.lexeme, false, noIntSuffix())); }
| c::DecConstantU_t
    { top.ast = realConstant(integerConstant(c.lexeme, true, noIntSuffix())); }
| c::DecConstantL_t
    { top.ast = realConstant(integerConstant(c.lexeme, false, longIntSuffix())); }
| c::DecConstantUL_t
    { top.ast = realConstant(integerConstant(c.lexeme, true, longIntSuffix())); }
| c::DecConstantLL_t
    { top.ast = realConstant(integerConstant(c.lexeme, false, longLongIntSuffix())); }
| c::DecConstantULL_t
    { top.ast = realConstant(integerConstant(c.lexeme, true, longLongIntSuffix())); }
-- oct
| c::OctConstant_t
    { top.ast = realConstant(octIntegerConstant(c.lexeme, false, noIntSuffix())); }
| c::OctConstantU_t
    { top.ast = realConstant(integerConstant(c.lexeme, true, noIntSuffix())); }
| c::OctConstantL_t
    { top.ast = realConstant(integerConstant(c.lexeme, false, longIntSuffix())); }
| c::OctConstantUL_t
    { top.ast = realConstant(integerConstant(c.lexeme, true, longIntSuffix())); }
| c::OctConstantLL_t
    { top.ast = realConstant(integerConstant(c.lexeme, false, longLongIntSuffix())); }
| c::OctConstantULL_t
    { top.ast = realConstant(integerConstant(c.lexeme, true, longLongIntSuffix())); }
| c::OctConstantError_t
    { top.ast = errorExpr([errFromOrigin(top, "Erroneous octal constant: " ++ c.lexeme)]); }
-- hex
| c::HexConstant_t
    { top.ast = realConstant(hexIntegerConstant(c.lexeme, false, noIntSuffix())); }
| c::HexConstantU_t
    { top.ast = realConstant(hexIntegerConstant(c.lexeme, true, noIntSuffix())); }
| c::HexConstantL_t
    { top.ast = realConstant(hexIntegerConstant(c.lexeme, false, longIntSuffix())); }
| c::HexConstantUL_t
    { top.ast = realConstant(hexIntegerConstant(c.lexeme, true, longIntSuffix())); }
| c::HexConstantLL_t
    { top.ast = realConstant(hexIntegerConstant(c.lexeme, false, longLongIntSuffix())); }
| c::HexConstantULL_t
    { top.ast = realConstant(hexIntegerConstant(c.lexeme, true, longLongIntSuffix())); }
-- floats
| c::FloatConstant_t
    { top.ast = realConstant(floatConstant(c.lexeme, doubleFloatSuffix())); }
| c::FloatConstantFloat_t
    { top.ast = realConstant(floatConstant(c.lexeme, floatFloatSuffix())); }
| c::FloatConstantLongDouble_t
    { top.ast = realConstant(floatConstant(c.lexeme, longDoubleFloatSuffix())); }
-- hex floats
| c::HexFloatConstant_t
    { top.ast = realConstant(hexFloatConstant(c.lexeme, doubleFloatSuffix())); }
| c::HexFloatConstantFloat_t
    { top.ast = realConstant(hexFloatConstant(c.lexeme, floatFloatSuffix())); }
| c::HexFloatConstantLongDouble_t
    { top.ast = realConstant(hexFloatConstant(c.lexeme, longDoubleFloatSuffix())); }
-- characters
| c::CharConstant_t
    { top.ast = characterConstant(c.lexeme, noCharPrefix()); }
| c::CharConstantL_t
    { top.ast = characterConstant(c.lexeme, wcharCharPrefix()); }
| c::CharConstantU_t
    { top.ast = characterConstant(c.lexeme, char16CharPrefix()); }
| c::CharConstantUBig_t
    { top.ast = characterConstant(c.lexeme, char32CharPrefix()); }
