---
title: Notes on Nial REPL (eval,parse,scan)
---


In a conventional compiler e.g. *yacc+lex* the compiler is getting the next token from 
the lexer on demand. The Nial interpreter does't doing this. The parser and the scanner 
are completely separate and are both visible as Nial operators (*parse* & *scan*) and both
work with Nial arrays.

The scanner takes a character array as input and returns a standard Nial vector e.g.

       s := scan 'x := 123'
    99 2 X 1 := 16 123

The value *99* is the code for a token stream. The values *2,1,16* are token 
types and the elements *X*, *:=*, and *123* are phrases. 

The parser takes a vector of the above form and returns a nested array for evaluation

        p := parse s
    +---+-------------------------------------+
    |100|+-+---------------------------------+|
    |   ||9|+--+------------------+---------+||
    |   || ||13|+--+-------------+|1 123 123|||
    |   || ||  ||22|2 20680 58955||         |||
    |   || ||  |+--+-------------+|         |||
    |   || |+--+------------------+---------+||
    |   |+-+---------------------------------+|
    +---+-------------------------------------+

Note the nesting of this array. The number *100* is the code for a 
parse tree, *9* indicates an expression sequence, *13* indicates 
an assign expression, *22* is an id list and *2* indicates a variable etc. 

Finally *eval* is used to evaluate the expression

        eval p
    123

The value is assigned to *x* and also returned as the value of the expression.

All of this operates on standard Nial data types. So in essence you could rewrite the scanner 
or the parser/eval pair to build your own repl.

So where does the original character array come from? 

When you are in an interactive Nial session the interpreter prompts for input and returns the 
character array that you type in (*readscreen*). 

When you are loading a file with *loaddefs* the 
code in *loaddefs* splits the lines of the file into blocks that are separated by either an
empty line or a line consisting only of whitespace characters. The lines of each block are then
joined together into a single character array.

The following Nial code show the basic behaviour of *loaddefs*.  The 4th and 5th lines offer two different
behaviours. As it stands the behaviour is that of standard *loaddefs* but if you comment out the
4th line and uncomment the 5th then empty lines delimit the blocks and you can have lines
with blanks and tabs in function definitions.


    comment_block is op s {
      `# = first ((`  < s) sublist s)
    }
    
    
    whitespace_line is (and (`  >=));
    
    
    nreader is op fn {
      ot := settrigger o;
      lines := getfile fn;
      lineblks := (each whitespace_line lines) cut lines;
      %lineblks := (0 match each tally lines) cut lines;
      for lblk with lineblks do
        cv := reduce (op x y (link x (char 13) y)) lblk;
        if not comment_block cv then
          res :=  eval parse scan cv;
          if string res ~= '?noexpr' then write res end
        end;
      end;
      settrigger ot;
      }
  
