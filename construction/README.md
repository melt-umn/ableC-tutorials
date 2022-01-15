# AST construction tools in ableC
As can be seen in some of the previous examples, building ASTs in ableC can be rather tedious.  It is often possible to move some otherwise-generated code into static functions in header files, but this is not always possible.  To remedy this, a set of tools is provided by ableC for building abstract syntax trees.  

## Silver-ableC: Constructing abstract syntax trees using C concrete syntax
The ableC extension to Silver (known as silver-ableC) allows for abstract syntax trees to be written conveniently using the concrete syntax of C.  [More information about the silver-ableC extension](https://github.com/melt-umn/silver-ableC/blob/develop/README.md)

## Construction helper functions
Some common patterns are often repeated when writing small fragments of abstract syntax, such as declaring a variable or checking for errors.  The `edu:umn:cs:melt:ableC:abstractsyntax:construction` grammar contains a number of helper functions and productions that are useful in constructing abstract syntax trees.  Some of the more useful ones are:
* `mkDecl :: (Stmt ::= String Type Expr Location)`: Create a statement that is the declaration of a single variable with the given type, initialized with the given expression.  
* `mkDeclGeneral :: (Stmt ::= String Type Location)`: Create a statement that is the uninitialized declaration of a single variable with the given type.  
* `mkAssign :: (Stmt ::= String Expr Location)`: Create a statement that assigns an expression to a name.
* `mkIntConst :: (Expr ::= Integer Location)`: Create an integer literal.
* `mkErrorCheck :: (Expr ::= [Message] Expr)`: If the parameter messages are empty, return the expression.  If the parameter messages contain only warnings, wrap the messages and expression in `warnExpr`.  If the parameter messages contain errors, wrap the messages in `errorExpr`.  
A number of helpers are also provided to fold various list nonterminals from lists of components, such as `foldExpr :: (Exprs ::= [Expr])` or `foldDecl :: (Decls ::= [Decl])`.  

## Substitution
On occasion some extensions, such as the [template extension](https://github.com/melt-umn/ableC-templating), may wish to substitute new trees for names in existing ASTs.  The substitution mechanism provides a way of doing this, using Silver's reflection capabilities to perform a sequence of substitutions on an ableC abstract syntax tree.  Substitutions to be performed are represented by the `Substitution` type, and may be created by the following constructors:
* `nameSubstitution :: (Substitution ::= String Name)`: Replace a name anywhere in the tree with another name.
* `typedefSubstitution :: (Substitution ::= String BaseTypeExpr)`: Replace a `typedef`ed name in a type expression with a different type expression.
* `declRefSubstitution :: (Substitution ::= String Expr)`: Replace a name in an expression with a different expression.
* `stmtSubstitution :: (Substitution ::= String Stmt)`: Replace a statement consisting of just a reference to a name with another statement.
* `exprsSubstitution :: (Substitution ::= String Exprs)`: Replace an expression list consisting just of a single name with another expression list.
* `parametersSubstitution :: (Substitution ::= String Parameters)`: Replace a parameter list consisting just of a single unnamed parameter with a `typedef`ed name as the type expression with a new parameter list.  
* `refIdSubstitution :: (Substitution ::= String Parameters)`: Replace the refId specified on a `struct` via GCC `__attribute__`s with a new refId.  This is used when generating a struct to implement a parametric type, such as in the [closure extension](https://github.com/melt-umn/ableC-closure).  

A number of helper functions are available that use the attributes to actually perform a subsititution on a nonterminal, such as `substExpr :: (Expr ::= subs::[Substitution] base::Expr)`.  These are defined in [Util.sv](https://github.com/melt-umn/ableC/tree/develop/grammars/edu.umn.cs.melt.ableC/abstractsyntax/substitution/Util.sv).  

## Example
A simple example making use of these constructs is an exponent operator, which can be found in [AbstractSyntax.sv](edu.umn.cs.melt.tutorials.ableC.exponent/abstractsyntax/AbstractSyntax.sv).  This operator raises a numeric base to an integer power by performing repeated multiplication in a loop.  

Since the evaluation of expressions in C may have side-effects, every child expression should be included in the forward exactly once.  To avoid duplications, temporary variables are used, declared with type expressions generated from the types of the operands.  The names of these temporary variables must be specified with `toString(genIntT())` prefixes; this is to ensure uniqueness such that when this operator is nested, a variable is not initialized with another variable of the same name, which would effectively be an initialization with itself.  

[Next section: Lifting](../lifting/)
