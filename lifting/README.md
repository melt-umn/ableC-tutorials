# Lifting declarations to the global level
A common pattern when writing extensions is to wish to generate a global declaration for a local piece of code, for example in the case of the [closure extension](https://github.com/melt-umn/ableC-closure).  This can be accomplished via the lifting mechanism.

## Semantics
Lifiting can be performed from the three most-commonly extended nonterminals, `Expr`, `Stmt` and `TypeExpr`.  Productions `injectGlobalDeclsExpr`, `injectGlobalDeclsStmt` and `injectGlobalDeclsTypeExpr` each wrap `Decls` to lift to the global scope, and the base AST of the appropriate type that relies on the lifted item.  Definitions from the `Decls` to be lifted are inserted into the global environment of what is wrapped, and are passed up the tree to be included in the environment for any later definitions.  These productions will then be transformed away by ableC during later phases of translation.  

A common pattern is where multiple locations wish to lift the same declaration to the global level, but to avoid re-defining this if it has already been declared.  To assist in this, the production `maybeDecl :: (Decl ::= (Boolean ::= Decorated Env) Decl)` is provided, taking a function to look at the environment to check for an existing declaration (in which case the production forwards to `nilDecl()`), and a `Decl` to declare otherwise.  Several further helpers are provided, `maybeValueDecl`, `maybeTagDecl` and `maybeRefIdDecl`, that take a name and a `Decl`, checking to see if the name is declared in the respective namespace.  

## How does this work?
The ableC translation process consists of two essential phases:
* During the first phase, the freshly-constructed extension AST is decorated with attributes and checked for errors.  The `host` attribute is then used to construct a second AST from the first, to contain only non-forwarding productions that have a direct C translation.  This includes eliminating injection productions, which involves using a number of other synthesized and inherited attributes to relocate portions of the tree.  
* This second AST is also decorated to verify that the host translation process did not introduce errors.  It is then simply pretty-printed and written to a file.  

In order to avoid generating duplicate global declarations, a lifted declaration must be immediately visible at every point in the AST to the right of the initial declaration.  This is accomplished by inserting definitions from global declarations being passed up the tree into the global environment at every point in the tree where a new scope is opened.  More details on this may be found documented in the source code, in [Lifted.sv](https://github.com/melt-umn/ableC/tree/develop/grammars/edu.umn.cs.melt.ableC/abstractsyntax/host/Lifted.sv) and the files in the [abstractsyntax:env grammar](https://github.com/melt-umn/ableC/tree/develop/grammars/edu.umn.cs.melt.ableC/abstractsyntax/env).  

## Example
An example use of lifting may be found in [AbstractSyntax.sv](edu.umn.cs.melt.tutorials.ableC.globalint/abstractsyntax/AbstractSyntax.sv).  This extension provides an expression that refers to an int variable that may be accessed from anywhere within a program.  The `injectGlobalDeclsExpr` and `maybeValueDecl` productions are used to lift a parsed expression to the global level, the first time that this name is used.  This extension may be useful for some types of macro programming, such as shown in [log.xc](log.xc).  

[Next section: Operator overloading](../overloading/)
