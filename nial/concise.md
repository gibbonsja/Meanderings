# Condensed Nial

The following is my personal interpretation of Nial.

Nial borrows from Lisp and Functional programming and combines
that with a data model of nested arrays. It is the product of early work
in the array language community.

## Terms

Throughout this document the terms *operator* and *function* will be used interchangeably.

Nial is expression oriented and *operator* relates more to the syntax of expressions while
*function* relates to the execution of expressions.


## Nial vs APL

Nial differs from APL etc in that it uses the standard ascii character set for 
programming, does not have distinct monadic and dyadic interpretations for
an operator and does not have special verb train conventions.

In Nial an operator can be used in either an infix form (x opn y)
or a prefix form (opn x) and has the same behaviour in both contexts with
the infix form being just 'opn [x,y]'.

    3 4 5 reshape tell 60

is the same as 

	reshape [2 3 4, tell 60]

Verb train conventions are repleced by higher order functions and vectors of
functions.

Nial expressions are evaluated left to right while APL is right to left.


More on parsing and precedence/binding-power of operators later.

## Arrays
 
Arrays have type, dimension/valence, and shape. Dimension 0 objects
are scalars, dimension 1 are lists/vectors, higher dimension arrays
are just arrays. Arrays can be nested arbitrarily.
 
The available data types are 
 
- boolean: l (true), o (false), lol (packed array of 3 bools)
- integer: 123, -456 (64 or 32 bits depending on implementation) 
- real: 3.14159, 2.34e10 (64 bit double) 
- character: \`a, char 10 (8 bit), 'strings are arrays'
- phrase: "abc, "_123 (symbols, not identifiers)
- fault: ?no_way, ??way  (exceptions)
- array: [1,2,3,4], 1 2 3 4 (strand form), [1, "abc, 3 4 5, [5.33]]

Homogeneous arrays of type boolean, integer, real, and character are packed for efficiency.
 
# Scope and Role
 
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

Builtin variables, operators and transformers have their role defined during initialisation. Identifiers that are not builtin are associated with a role during their definition which takes the form

    <identifier> IS <expression|operation|transformer>

or for a variable role

    <identifier> := <expression>
    local <identifier>
    nonlocal <identifier>

Please note that in the fragment

    x := 10
    a := 1 + x     
    b is (1+x)   

a is now a variable with value 21 and will stay that way until reassigned however b
is an expression referencing x,  evaluating b at some point in a program will give a value
depending on the current value of x at that point.
 
 
# Expressions and Strands
 
Nial is an expression oriented language and all expression return a value.

Along with the expression there is the expression sequence (*exp-seq*) which takes the form
of a sequence of expressions separated and optionally terminated by the character
';'. The value of an expression sequence is the value of the last expression 
unless it is terminated by ';' in which case it is the fault *?noexpr*.
 
Expressions (*exp*) can be broken down into groups
 
## Primary Expressions (*pexp*)
 
    var                                    value of a variable
    named-expr                             evaluation of a named expression
    (exp)                                  parenthesised expression
    int, real, bool, char, phrase, string, fault
    [exp,...]                              vector
    !x                                     cast
    {local x; nonlocal y; exp...}          block expression
    begin local x; nonlocal y; exp.. end   another form of block expression
 
Block expressions create a local context and allow for *local* and *nonlocal* variable declarations.

When the Nial parser is looking for an expression and encounters a primary expression it will
attempt to form the longest possible strand, a sequence of primary expressions separated by spaces.

For example
 
    1 2 (3*4) pi (if this_works then 'Hooray' else 'Crap' end) 
 
which is identical to the vector 
 
    [1,2,3*4,pi, *Hooray" or "Crap*]

Strand formation also takes precedence over operator application

    reverse 1 2 3 begin local t; t := 5; t*2 end 66

returns
 
    66 10 3 2 1
	
 
 
## Operator Application (*op-exp*)
 
    opn x                                operator application
    x := y                               assignment, same as: x gets y
    x y z := v                           multiple value assignment
    x opn y                              by convention this is opn[x,y]
    opn strand                           strand is the single arg
    [opn1,opn2,...]                      an alas x [opn1 x, opn2 x, ...]

an atlas is by itself is an operation and so can be nested in another atlas. The behaviour of a nested
atlas can be easily understood by viewing it as a tree of operations. 

For example 

    f[g,h,k[m,n]] x

can be viewed as the tree of operators

           f
         / | \
        g  h  k
             / \
            m   n

and when applied, leaf nodes operate directly on the argument x and interior nodes
operate on the array of results of their children.


## Control Expressions

    if exp then esp-seq elseif exp then exp-seq else exp-seq end
    for var with exp do exp-seq end
    while exp do exp-seq end
    repeat exp-seq until exp end
    case exp from const: exp-seq end ... else exp-seq end

# Operators

Nial has a large number of builtin operators for 
- creating and manipulating arrays (shape,
  reshape, transpose, lower, raise etc), 
- maths (+, -, /, reciprocal etc)
- I/O

Operators can also be created in Nial via 

- a lambda form
- a composition of existing operators 
- by application of a transformer 
- by currying another operator 
- by an atlas of operators.

A Lambda Form (or DFN) takes the form

    op x { exp... }                 an operator with one argument
    op x y .. { exp... }            an operator with multiple arguments but not really

Currying takes the form

    exp fn

Application of a transformer is simply

    trf fn

where fn is a single operator.
 
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

This is just function composition in a pseudo tacit form.

Nial doesn't have  conventions on verb trains such as APL's 'fork', its
functional, has atlases, and doesn't need them. Just write *f[g,h]*, a composition
of two functions for the fork.

Nial has multiple assignment

   x y z := tell 3

So in a sense you can write an operator with multiple arguments as

   op x y z { .... }

or as

  op args { x y z := args; ... }

If you specify multiple arguments in a definition then you must provide a vector with exactly 
that many elements when applying the operator. Specifying a single argument allows you to pass
a vector with as many elements as you like.

## Pervasiveness

Some builin operators in Nial have a property called *pervasive* (unary, binary or multi).

A unary pervasive operation maps maps an array to another array with identical
structure, mapping each atom by the functions behaviour on atoms. All of the 
scientific operations and the unary operations of arithmetic and logic are unary
pervasive.

    sin (2 3 reshape tell 6)
    
         0.  0.841471  0.909297
    0.14112 -0.756802 -0.958924

A binary pervasive operation maps two array having identical structure to one
with the same structure, mapping each pair of corresponding atoms by the 
functions behaviour on the corresponding pairs of atoms. Binary of the binary
 operations of arithmetic and logic are binary-pervasive

    x := 2 3 reshape 1 2 3 5 6;
    y := 2 3 reshape 7 8 9 10 11 12;
    x/y

    0.142857     0.25 0.333333
         0.4 0.454545      0.5
     

A multi-pervasive operation maps an array having items of identical structure
to one of the the same structure, applying the operation to the simple arrays
formed from all the atoms in corresponding positions in the items. The 
operations in this group are the reductive operations of arithmetic and logic 
(and, or, max, min, product & sum).

    x := 2 3 4 reshape tell 24
    
    0 1  2  3   12 13 14 15
    4 5  6  7   16 17 18 19
    8 9 10 11   20 21 22 23
    
    +x
    
    276

    y := 2 raise x
    
    +-----------+-----------+-----------+
    |0 1 2 3    |4 5 6 7    |8 9 10 11  |
    +-----------+-----------+-----------+
    |12 13 14 15|16 17 18 19|20 21 22 23|
    +-----------+-----------+-----------+
     
    +y
    
    60 66 72 78

## Parsing an Operator Expression

Nial parses and evaluates left to right and all operators in Nial have the same left 
binding power and the same right binding power, however
the right binding power is stronger than the left. So

    2 - 4 * 6

will be treated as 

    (2 - 4) * 6

and return -12 as will the prefix version of -

    -[2,4]*6

As per the old saying, when in doubt use parentheses.

Transformers always bind to the single operator on their right. If you want that to be a function
composition use parentheses.

As stated above strand formation takes precedence over operator evaluation. So

    1 2 3 - 4 5 6 * 7 8 9  

returns 

    -21 -24 -27




# Transformers

Nial has a class of 2nd order functions called transformers. 

A transformer takes a single operator as argument and produces another operator.  

There are a number of builtin transformers and transformers can be defined in Nial with the form

    tr f <operator-specification>
    tr f g h ... <operator-specification>

Note that in the 2nd form, application of the transformer will require an atlas of the same size as the 
number of operators mentioned in the definition.

The <operator-expression> above can be any form of operation, a DFN, a composition of functions, 
an atlas or a currying.

For example to define fork as a transformer you can write in a tacit style

    fork is tr f g h (f[g,h])

then you can write

     average is fork [/,+,tally]

If you prefer a non-tacit style then you can write

   fork is tr f g h op x { (g x) f (h x) }





