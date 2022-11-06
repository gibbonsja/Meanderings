# Condensed Nial

The following is my personal interpretation of Nial, take it as you will.

Nial borrows from Lisp and Functional programming and combines
that with a data model of nested arrays. It is the product of early work
in the array language community.

## Nial vs APL

Nial differs from APL etc in that it uses the standard ascii character set for 
programming, does not have distinct monadic and dyadic interpretations for
an operator and does not have special verb train interpretations.

In Nial an operator can be used in either an infix form (x opn y)
or a prefix form (opn x) and has the same behaviour in both contexts with
the infix form being just 'opn [x,y]'.

    3 4 5 reshape tell 60

is the same as 

	reshape [2 3 4, tell 60]

More on parsing and precedence/binding-power of operators later.

## Arrays
 
Arrays have type, dimension/valence, and shape. Dimension 0 objects
are scalars, dimension 1 are lists/vectors, higher dimension arrays
are just arrays. Arrays can be nested arbitrarily.
 
The available data types are 
 
- boolean: l (true), o (false), lol (packed array of 3 bools)
- integer: 123, -456 (64 or 32 bits depending on implementation) 
- real: 3.14159, 2.34e10 (64 bit double) 
- character: `a, `|, char 10 (8 bit), 'strings are arrays'
- phrase: "abc, "_123 (symbols, not identifiers)
- fault: ?no_way, ??way  (exceptions)
- array: [1,2,3,4], 1 2 3 4 (strand form), [1, "abc, 3 4 5, [5.33]]

Homogeneous arrays of type boolean, integer, real, and character are packed for efficiency.
 
# Scope
 
Nial has a global scope as well nested local scopes. Every identifier
in Nial exists within a scope and has a role (related to parsing) and a behaviour (related 
to evaluation)
 
The role of an identifier, once established, can not be changed within a scope 
but the identifier may be redefined in a nested scope to have a different role. 
Keywords can never be redefined.
 
The role is one of
 
- keyword: if, while, repeat, etc (role is fixed across all scopes)
- variable: abc, _def
- expression
- operation (behaviour is a function)
- transformer (behaviour is a form of higher order function) 
 
# Expressions and Strands
 
Nial is an expression oriented language and all expression return a value.

Along with the expression there is the expression sequence (*exp-seq*) which takes the form
of a sequence of expressions separated and optionally terminated by the character
';'. The value of an expression sequence is the value of the last expression 
unless it is terminated by ';' in which case it is the fault *?noexpr*.
 
Expressions (*exp*) can be broken down into groups
 
## Primary Expressions (*pexp*)
 
    var                                  value of a variable
	named-expr                           evaluation of a named expression
	(exp)                                parenthesised expression
	int, real, bool, char
	[exp,...]                            vector
 
When parsing a string of tokens a sequence of primary expressions separated by spaces is 
called a strand e.g.
 
    1 2 (3*4) pi (if this_works then 'Hooray' else 'Crap' end) 
 
and is identical to the vector 
 
    [1,2,3*4,pi, *Hooray or Crap*]
	
When the Nial parser is looking for an expression and encounters a primary expression it will
attempt to form the longest strand possible. 
 
## Operation Application (*op-exp)
 
    opn x                                operator application
	x := y                               assignment, same as: x gets y
    x opn y                              by convention this is opn[x,y]
    opn strand                           strand is the single arg
    [opn1,opn2,...]                      an alas x [opn1 x, opn2 x, ...]

## Control Expressions

    if exp then esp-seq elseif exp then exp-seq else exp-seq end
	for var with exp do exp-seq end
	while exp do exp-seq end
	repeat exp-seq until exp end
	case exp from const: exp-seq end ... else exp-seq end

**Block Expressions**

Block expressions create a local context and allow for *local* and *nonlocal* variable declarations.

    { local x y; nonlocal u v; exp-seq }
	begin local x..; nonlocal u..; exp-seq end


## Operators and Transformers

Nial has a large number of builtin operators for 
- creating and manipulating arrays (shape,
  reshape, transpose, lower, raise etc), 
- maths (+, -, /, reciprocal etc)
- I/O
 
If you look at Nial operators as taking 1 argument with no
preconceptions of monadic or dyadic and x, y etc are single expressions
or strands of expressions then

    x fn y -is- f [x;y]                  by convention
    fn x y z ... -is- fn [x,y,z,...]     strand is the single arg
    [fn1,fn2,...] x  -is- [fn1 x, fn2 x, ...]   an atlas

Atlases are operators in themselves and so can be composed and nested with
other operators (including atlases) e.g. average is

    /[+,tally]

or

    valence reshape [pass, tell *] 2 3 4 5 6

This is just function composition in a tacit form.

Nial doesn't have conventions on verb trains such as the 'hook', its
functional and doesn't need them. Just write *f[g,h]*, a composition
of two functions for the hook.

If you want to formalise this Nial has a form of HOF called a transformer so
in a tacit style you can write

  hook is tr f g h (f[g,h])

then you can write

     average is hook [/,+,tally]

If you prefer a non-tacit style then you can write

   hook is tr f g h op x { (g x) f (h x) }

OP is Nial's lambda.

Nial has multiple assignment

   x y z := tell 3

So in a sense you can write an operator with multiple arguments as

   op x y z { .... }

or as

  op args { x y z := args; ... }

The interpreter will handle the first form more efficiently.


## Gotchas

IS is not the same as := (gets). One is a definition, the other
an assignment. For example

  x := 10

  a := 1 + x     
  b is (1+x)   


a is now 21 and will stay that way until reassigned however b
is 1+x whatever x is and if x changes then evaluating b will too.


  


