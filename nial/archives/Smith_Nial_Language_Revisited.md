> **APL "Wish Lists": the Nial Programming Language Revisited**

**Stuart Smith**

stuart.smith3\@comcast.net

*Main topics:APL, Nial, functional programming, function arrays, array
theory*

**1. Abstract**

Proposals for new language features have appeared regularly within the
APL community. Some of these have been adopted, while others remain
objects of discussion and controversy. This paper focuses on three
recurring categories of proposed language features: function arrays,
additional data types, and control structures. We examine these features
from the point of view of Nial, a general-purpose programming language
that has a long history within the APL community and whose array
processing capabilities are similar to those of APL2 (both APL2 and Nial
were strongly influenced by versions of Trenchard More's array theory).
Because of their utility in many common programming situations, function
arrays, certain special data types, and conventional control structures
were incorporated into Nial almost from the beginning of its
development. The purpose of this paper is to show (1) how function
arrays, the special data types, and control structures work in Nial and
(2) what considerations went into their inclusion in the language. The
presence of these features in an actual programming language provides a
concrete basis for discussion of the pertinent language issues. Although
no longer in serious contention with current commercial APL\'s, Nial is
nonetheless worth another look for its outstanding design and
implementation.

**2. Introduction**

Nial's origins are in Trenchard More's work in array theory
\[7,8,9,10\]. Jenkins and Falster \[3, p. 24\] characterize array theory
as follows:

> What is unique about array theory is that it attempts to combine two
> different organizing principles for data: rectangular arrangement and
> nested collections. The former is observed in the vectors and matrices
> used by linear algebra and in tensors used in physics. The latter
> correspond to finite sets, nested lists, and various forms of
> hierarchy. They correspond to the two classical ways of looking at
> ordering. From the point of view of programming languages, the data
> structures of APL correspond to the first organization and those of
> Lisp correspond to the second.

Nial was created by More, who was then at the IBM Cambridge Scientific
Center, and Michael Jenkins, now professor emeritus of Computer Science
at Queen's University in Kingston, Ontario. Colleagues at IBM, Queen\'s,
and the Technical University of Denmark also contributed to the
language. Beginning in 1972, IBM developed a succession of experimental
interpreters for More\'s array theory. These interpreters became the
starting point for the Nial programming language while Jenkins was
working with More at IBM in 1979. In the period 1980 to 1983 Jenkins and
More collaborated closely to refine the language definition and Jenkins
led a team at Queen's to produce Q'Nial, a portable interpreter for Nial
written in C \[5\]. This effort was funded by Queen's, IBM, and a
Canadian research grant. Queen\'s subsequently spun off a company,
N.I.A.L Systems Limited (NSL), and gave it exclusive rights to market
Q\'Nial for the University. By the late 1980\'s Q\'Nial had spread to
more than 60 universities, but it never attracted wide interest among
commercial users. NSL now promotes Q\'Nial primarily for educational
purposes and supports a small cadre of loyal customers. Free versions of
Q\'Nial are currently available on request from NSL for Windows 9x and
2000, Solaris, and Linux\[12\].

**3. Nial Terminology and Syntax**

In Nial, functions are called "operations", and what in APL are called
"operators" (scan, reduce, inner and outer product, etc.) are called
"transformers" in Nial. In general the Nial terminology will be used
here.

In Nial, lists of items can be notated in either bracket-comma form,
e.g.,

> \[ 1 , \[ 2 , 3 \] , 4 \]

or "strand" form, which is simply a juxtaposition of two or more array
expressions, e.g.:

> 1 ( 2 3 ) 4

Both examples result in a nested list of three items with the second
item a list of two items.

The composition of operations is also accomplished by juxtaposition. No
composition operator is required; the names of the desired operations
are simply juxtaposed. For example, the expression

> G IS ln sqrt abs

defines an operation G which takes the natural logarithm of the square
root of the absolute value of its unnamed array argument. This form of
function definition is similar to tacit definition in J. Nial also
supports the lambda style of operation definition, which names its
arguments. For example, G could be defined like this:

> G IS OPERATION X {
>
> ln sqrt abs X
>
> }

A Nial program "statement" is an expression terminated with a semicolon.
The return value of an operation is indicated by an expression not
terminated with a semicolon. This expression must be the last one on its
execution path within the operation. Here, for example, is an operation
that computes an approximation to *π* using Rectangle Rule numeric
integration:

> pi\_approx IS OPERATION n {
>
> x := 0.5 + tell n / n ;
>
> 4 / n \* sum recip ( 1 + ( x \* x ) )
>
> }

The first statement computes *n* equally spaced values in the interval
\[0,1\] and assigns them to array x. The second statement, which is not
terminated with a semicolon, computes the approximation and returns it
as the value of pi\_approx for the given *n.* The equivalent function in
APL is

> Z←PIAPPROX N;X
>
> \[1\] X←(0.5+⍳n)÷N
>
> \[2\] Z←(4÷N)×+/÷1+X⋆2

Either infix or prefix notation can be used in Nial. For example, both X
+ 1 and + X 1 are valid.

**4. Operation (Function) Arrays**

In Nial there are several ways to create new operations from existing
ones: by composition, by transformation (similar to APL's operators), by
left currying, by parameterized expression, and by a list of operations
called an "atlas." The atlas provides the capabilities desired in a
function array. An atlas applies each component operation to the
argument, producing a list of results. Here, for example, the square
root, reciprocal, and opposite (negation) operations are applied as an
atlas to the argument 2, giving as a result a list of three values:

> \[ sqrt , recip , opp \] 2
>
> 1.41421 0.5 --2

This is equivalent to

> \[ sqrt 2 , recip 2 , opp 2 \]
>
> 1.41421 0.5 --2

An atlas can be given a name by the Nial definition mechanism:

> my\_atlas IS \[ sqrt , recip , opp \]
>
> my\_atlas 2
>
> 1.41421 0.5 --2

The atlas notation serves several important purposes. According to the
Q'Nial Manual \[11\] its primary use is as a shorthand for describing
operations without a need to explicitly name their arguments. It is
therefore one of the key supports for functional programming styles like
the FP notation described by Backus in his 1977 Turing Award paper
\[1\]. For example, we can define an operation to compute the arithmetic
mean of its array argument using the conventional lambda form, which
names its arguments:

> average IS OPERATION A {
>
> sum A / tally A
>
> }

or, with the use of an atlas, we can define the same operation like
this:

> average IS /\[sum,tally\]

This is a functional programming-style definition, which does not name
its arguments.

A second use of the atlas is to form an operation argument for a
transformer that uses two or more operations. For example, without the
atlas the equivalent of +.×in APL would have to be denoted in Nial as

> \+ INNER \*

which, as an infix form, can take only two operations as arguments. With
the atlas, it is denoted as

> INNER \[+,\*\]

The atlas provides a way for all transformers to take one argument,
namely, an operation or a single atlas. This use of the atlas simplifies
the syntax for transformers and makes the visual parsing of transformer
expressions easier. Because an atlas can contain any number of component
operations, it allows the creation of programmer-defined transformers
that can take any number of operation arguments. For example, we can
define a transformer my\_fork that simulates J's *fork* construct. The J
fork involves *three* functions:

( f g h ) y is equivalent to ( f y ) g ( h y )

i.e., the result is obtained by applying the dyadic function g to the
results of f and h applied individually to argument y. my\_fork gives
the same behavior in Nial. Here is its definition:

> my\_fork IS TRANSFORMER f g h (g\[f,h\])

As with J's fork, my\_fork applies the middle operation to the results
of the first and last operations. If we call my\_fork with an atlas
argument whose component operation arguments are sum, */*, and tally,
the result is an operation that computes the arithmetic mean of its
argument:

> my\_fork\[sum,/,tally\] 1 2 3 4
>
> 2.5

Finally, the atlas allows a list of operations to be applied
element-wise to a list the same length as the atlas. The component
operations of the atlas are applied to the corresponding items of the
argument. In these cases the TEAM transformer must be used. Here is an
example using the my\_atlas operation defined above:

> TEAM my\_atlas 2 3 4
>
> 1.41421 0.33333 --4

In this expression, each operation of my\_atlas (sqrt, recip*,* and
opp*,* respectively) is applied to the corresponding item of the list
argument.

Although an atlas is specified using Nial\'s bracket-comma array
notation, it is syntactically an operation, not an array. As such it is
not a first-class object in Nial. It cannot be passed to an operation as
an argument and it cannot be returned by an operation as a result. The
inability to pass an operation as an argument to another operation is
not a serious restriction because---as shown above---programmers can
define their own transformers, which do take operation arguments.

**5. Additional Data Types**

*Faults*

As Lucas \[6\] points out, "in APL, an expression like ÷A could result
in a DOMAIN ERROR if some elements of A are zero. Yet taken
individually, only some of the elements of  would generate errors, and
frequently one would only want to identify those elements, but still get
the results for the others." This capability would obviously be very
useful during the debugging phase of program development.

To handle such situations, Nial provides a data type called *fault*.
Faults are special values to mark exceptional conditions such as errors
or the end of a file. A fault is designated by a leading question mark
(?). For example, ?div denotes a division-by-zero error and ?address
denotes an out-of-bounds array reference. A set of standard faults is
predefined in the Nial interpreter. Programmers can also define their
own faults.

Users can set fault triggering if they want execution to stop on the
occurrence of a fault. If fault triggering is not set, a fault is
propagated as the result of any operation that has the fault as an
argument. Because faults propagate in characteristic ways through
element-wise operations, inner and outer products, reductions, and
scans, the ability to turn fault triggering off can help the programmer
to identify the source of an error and also to examine the potentially
good results of a computation, which would otherwise simply be
discarded.

Here are some examples of the ?A (arithmetic) fault being transmitted
through various arithmetic operations on lists. In each case, the
non-numeric phrase \"three in array x causes the fault (the Nial
*phrase* data type is discussed in the next section).

> x := 1 2 \"three 4
>
> 1 2 three 4
>
> y := 1 2 3 4
>
> 1 2 3 4

In any element-wise operation, the fault simply appears in the result at
the same location as the bad data in an operand:

> x + y
>
> 2 4 ?A 8

In a reduction, a bad value anywhere in the argument produces the ?A
fault as the result:

> reduce + x
>
> ?A

In a scan, a bad value at the i\'th position in the argument causes the
?A fault to appear at all positions from the i\'th to last in the
result:

> accumulate + x
>
> 1 3 ?A ?A

With outer product, a bad value in the i\'th position of the left
argument causes the ?A fault to occupy the entire i\'th row of the
result:

> x outer \* y
>
> 1 2 3 4
>
> 2 4 6 8
>
> ?A ?A ?A ?A
>
> 4 8 12 16

A bad value at the i\'th position of the right argument causes the ?A
fault to occupy the entire i\'th column of the result:

> y outer \* x
>
> 1 2 ?A 4
>
> 2 4 ?A 8
>
> 3 6 ?A 12
>
> 4 8 ?A 16

With inner product, a single bad value will cause the ?A fault to occupy
an entire row or column of the result. Here, for example, matrix x
contains the non-numeric phrase "six, while matrix y consists entirely
of integers:

> x y
>
> 0 1 2 3 0 4 8 12
>
> 4 5 six 7 1 5 9 13
>
> 8 9 10 11 2 6 10 14
>
> 12 13 14 15 3 7 11 15

When we attempt to form the inner product of these two matrices, the
single bad value in the second row of the *left* argument x causes the
?A fault to occupy the entire second row of the result:

> x inner \[+,\*\] y
>
> 14 38 62 86
>
> ?A ?A ?A ?A
>
> 62 214 366 518
>
> 86 302 518 734

Similarly, the single bad value in the third column of the *right*
argument x causes the ?A fault to occupy the entire third column of the
result:

> y inner \[+,\*\] x
>
> 224 248 ?A 296
>
> 248 276 ?A 332
>
> 272 304 ?A 368
>
> 296 332 ?A 404

In all the cases above, the occurrence (or first occurrence) of the ?A
fault helps to pinpoint the location of the bad data value causing the
error. At the same time, all of the good values of the computation are
preserved.

The original motivation for incorporating faults into Nial is to be
found in More\'s array theory, the theoretical foundation of Nial. In
array theory there is only one kind of object: the nested rectangular
array. As a consequence, each item of an array must also be an array.
All primitive operations in the theory are defined for every array, and
every primitive operation applied to any array produces an array as its
result. These requirements eliminate boundary cases, which the
programmer would otherwise have to know and keep in mind while coding.
However, another problem then arises: when array theory is made the
theoretical foundation of a programming language which manipulates
numbers, truth values, and characters, it is necessary that, for
example, 3.0 / 0.0 give an array result, as must 3 + \`Z, where \`Z is a
literal character constant. The fault data type is the array-theoretic
solution to this problem.

Faults have other important uses. In database applications, for example,
it is often the case that one wants to know *why* missing data are
missing, not simply *that* they are missing. A single value to indicate
missing data is uninformative. As Lucas \[6\] suggests, there should be
different values for "not applicable", "not available", "pending input",
"pending validation", etc. These special values can be created as Nial
faults. For example

> MD := ??missing
>
> ?missing

Nial provides a conversion operation, fault, to convert a character
string to a fault. This is handy if one wants to convert a string
containing blanks into a fault, as with Lucas\' examples above. For
example

> NA := fault \'?not available\'
>
> ?not available

Because fault triggering can be set dynamically in Nial, programs can be
written to control "on the fly" whether or not missing data trigger an
interruption of computation.

*Phrases*

Because of the heavy use of symbolic data in AI applications, another
special data type, *phrase*, was included in Nial to facilitate the
processing of such data. A phrase is an atomic array consisting of zero
or more characters taken as a unit. A phrase is designated by a leading
double quote mark (\"). Here are some examples of phrases: \"dog, \"X37,
\"this\_is\_a\_phrase.

A list of phrases is easily created, e.g.

> Lis := "cat "bird "ant
>
> cat bird ant

Such lists can be manipulated with Lisp-like list processing operations
provided by Nial. For example, the head of the list can be accessed with
first:

> first Lis
>
> cat

and the remainder of the list can be accessed with rest:

> rest Lis
>
> bird ant

A new item can be inserted at the head of the list with the hitch
operation:

> hitch "dog Lis
>
> dog cat bird ant

Lisp programmers will recognize that first, rest, and hitch correspond
to CAR, CDR, and CONS, respectively, in Lisp. Nial also provides
equivalents to ATOM, EQ, NULL and the other fundamental Lisp list
processing operations. Because of Nial's foundation in array theory,
these list processing capabilities harmonize nicely with Nial's
facilities for manipulating rectangular arrays.

Nial provides a conversion operation, phrase, to convert a character
string to a phrase. This is useful if one wants to work with symbols
whose representations contain embedded blanks. For example

> Foo := phrase \'a multi-word symbol\'
>
> a multi-word symbol

By having phrases as unique atomic objects, equality-testing operations
and set theory-like operations can be performed more efficiently. Nial
also provides standard operations for efficient sorting of lists of
phrases.

**6. Control Structures**

It is often said that control structures are not "array-oriented" and
that this can lead to execution inefficiencies. If and when this is
true, the severity of the inefficiencies actually encountered will of
course depend on the particular application for which the programming
language is used, the quality and appropriateness of the algorithms and
programming techniques employed, and the implementation of the language.
These are all pragmatic concerns. In the current debate on programming
language design, the question of whether or not control structures
should be included appears rather to be more a philosophical issue.

Nial includes IF THEN ELSE, CASE, FOR loops, WHILE DO loops, and REPEAT
UNTIL loops. Their presence in the language is the result of a quite
definite view of the nature of programming languages. Jenkins and
Falster \[3, p. 9\] state that "Nial can be viewed as having two
distinct components: the mathematical expression language that describes
array-theoretic computations, and the linguistic mechanisms added to
make it a programming language." In response to the author's query about
this statement, Jenkins wrote \[4\] :

> This was a very deliberate statement. It has two implications:
>
> 1\. that a programming language needs more than just mathematical
> evaluation. It must have choice e.g. if-then-else or CASE or something
> to choose between alternate paths. Needed for example to terminate a
> user-defined recursion. APL has conditional branch. It also must have
> indefinite iteration e.g. WHILE DO or equivalent so that a loop can
> continue until a process converges. Actually you can replace this with
> recursion if the right capabilities are provided.
>
> 2\. that making this separation a conscious one gives clarity on the
> design issues of the expression language. It can be based on a clean
> mathematical theory independent of the needs of the first point \[of my
> answer\].

This approach to computing has a history that reaches back to ancient
times. In a discussion of the conventional, or "von Neumann,"
architecture of digital computers and the languages used to program
them, Halpern \[2, p. 43\] observes that

> the control statements in von Neumann languages, and the jump and test
> instructions in von Neumann machines, are based on the instructions
> that scientists have long given to those who performed long,
> monotonous computations for them on papyrus, parchment, paper, or
> Friden, Marchant, and Monroe calculators long before "computer" came
> to mean a machine.

The separation of expression evaluation from control is thus quite
traditional, at least within the context of mathematical computation.
Control structures naturally took their place in the world of digital
computing and became part of the practice of ordinary programmers. The
Nial design respects this practice while also providing mechanisms to
support other programming styles.

**7. Discussion**

The language features discussed here were all integral parts of the
initial design of Nial, and their interactions with other features of
the language were carefully monitored from the beginning of the
development of the language. Any change to an existing programming
language to accommodate new features such as those discussed here is
likely to have repercussions throughout that language. Because the type
system in particular is one of the most fundamental aspects of any
programming language, one must change it only with great care. Adding
new types to a language may necessitate a complete redesign of the
language. Omitting conventional control structures from a programming
language forces programmers to learn new techniques (e.g., recursive
programming) which may be quite elegant from a theoretical point of view
but which are often difficult for ordinary programmers to master. The
Nial approach of making a clean separation between expression evaluation
and control allows the former to be implemented according to rigorous
axiomatic methods while the latter can be implemented in a form familiar
to the practical programmer.

**8. Acknowledgements**

Thanks to Mike Jenkins, the creator of Q'Nial, for reviewing the
manuscript and making many helpful suggestions. Mike also provided
details of the history of Nial.

**9. References**

\[1\] Backus, John R. "Can Programming be Liberated from the Von Neumann
Style? A Functional Style and its Algebra of Programs," *Communications
of the ACM*, August 1978, pp. 613-641.

\[2\] Halpern, M. Binding Time: 6 Studies in Programming Technology and
Milieu. Norwood, NJ: Ablex Publishing Corporation, 1990.

\[3\] Jenkins, M. and P. Falster. Array Theory and Nial. Nial Systems
Limited, www.nial.com, 1999.

\[4\] Jenkins, M. Private communication. 2001.

\[5\] Jenkins, M. "Q\'Nial: A Portable Interpreter for the Nested
Interactive Array Language, Nial". Software Practice & Experience (19)2,
(1989), 111-126.

\[6\] Lucas, J. An Array-Oriented (APL) Wish List. *APL Quote-Quad*
(31)2, (2001), 37-43.

\[7\] More, T. and M. Jenkins. The APL Workshop Session on General
Arrays. *APL Quote-Quad* (8)2, (1977), 12-13.

\[8\] More, T. The Nested Rectangular Array as a Model of Data. *APL
Quote-Quad* (9)4, (1979), 55-73.

\[9\] More, T. Nested Rectangular Arrays for Measures, Addresses, and
Paths. *APL Quote-Quad* (9)4, (1979), 156-163.

\[10\] More, T. Rectangularly Arranged Collections of Collections. *APL
Quote-Quad* (13)1, (1982), 219-228.

\[11\] Nial Systems Limited. The Q'Nial Manual. www.nial.com, (1998).

\[12\] Nial Systems Limited. Send e-mail to
[[jenkins\@nial.com]{.underline}](mailto:Jenkins@nial.com) to download a
copy of Q'Nial or the documents referenced above.
