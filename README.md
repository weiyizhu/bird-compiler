# Bird Compiler

## Overview

- A compiler written in OCaml that parses, transforms, and compiles ".bird" files into x86-84 assembly code.
- The assembly code produced by the bird compiler is converted into an object file using the nasm assembler.
- Some C code is utilized to facilitate and simplify interactions with the operating system (e.g. initialize a process, heap memory management, I/O printing operations). These C files are compiled into object files and and can be found in the "resources" folder.
- The final executable "hatch.exe" is produced by linking the object file compiled by the bird compiler and the C object files from the "resources" folder using clang.
- This project is part of the [Compiler](https://www.cs.swarthmore.edu/~zpalmer/cs75/s23/) course taught by Professor [Zachary Palmer](https://www.cs.swarthmore.edu/~zpalmer/). Implementation details of the bird compiler are intentionally hidden to prevent plagiarism from future students of the class.

## System Requirements

- The compiler (hatch.exe), the instructions provided in the Makefile and setup.sh assume that you are using the Ubuntu operating system and have "make" installed. You are welcome to try running on other Linux distributions.

## Set up

- Run `make setup`

## Create and Test Bird Programs

- To create a bird program, write bird code to a file ending in ".bird".
- To compile a bird program: run `./hatch.exe [yourBirdProgram].bird`
  - If compiled successfully, three files will be created in the "output" folder: `[yourBirdProgram].o`, `[yourBirdProgram].run`, `[yourBirdProgram].s`
  - If compiled unsuccessfully, one of the four types of error could happen:
    - There is an error when converting the bird assembly code to the bird object file. More information could be found in `logs/nasm_[yourBirdProgram].stderr.log` and `logs/nasm_[yourBirdProgram].stdout.log`
    - There is an error when linking the bird object file with the C object files. More information could be found in `logs/clang_link_[yourBirdProgram].stderr.log` and `logs/clang_link_[yourBirdProgram].stdout.log`
    - There is a parser error. The terminal will print out error message in the form of "Parser error in [yourBirdProgram].bird at ..."
    - One of the following compile-time errors occurs:
      - "Unbound variable [variable]."
      - "Function [function_name] declares a duplicate parameter [variable]."
      - "Duplicate definition of function [function_name]."
- To run the compiled bird executable: run `output/[yourBirdProgram].run`
  - If ran successfully, the evaluated result should be printed on the terminal.
  - If ran unsuccessfully, one of the following run-time errors occurs:
    - "Expected an int."
    - "Expected a bool."
    - "Expected a tuple."
    - "Invalid index for accessing a tuple."
    - "Expected a closure."
    - "Out of memory."
    - "Unknown error [error_message] occurred."
- To clean up your bird programs, run `make clean`

## Bird Language Syntax

```
<declaration> ::=
  | def <identifier> <parameter_list> = <expression> end

<parameter_list> ::=
  | <identifier> <parameter_list>
  | <identifier>

<expression> ::=
  | <integer>
  | true
  | false
  | <identifier>
  | let <identifier> = <expression> in <expression>
  | if <expression> then <expression> else <expression>
  | after(<expression>)
  | before(<expression>)
  | print(<expression>)
  | isbool(<expression>)
  | isint(<expression>)
  | istuple(<expression>)
  | <expression> + <expression>
  | <expression> - <expression>
  | <expression> * <expression>
  | <expression> < <expression>
  | <expression> > <expression>
  | <expression> = <expression>
  | <expression> && <expression>
  | <expression> || <expression>
  | <expression>[<expression>]
  | <expression> <expression>
  | (<expression>)
  | (<expression>, <expression_list>)
  | <expression>[<expression>] := <expression>

<expression_list> ::=
  | <expression> , <expression_list>
  | <expression>
```

## Bird Features and Examples
| Feature | Bird Program | Evaluated Result |
| --- | --- | --- |
| Arithmetic | <code>3 * (1 + (4 - 2) - (3 * 2))</code> | -9 |
| Conditionals, <br>let-in, <br>unary and boolean <br>operations | <code>let x = <br>&nbsp;&nbsp;&nbsp;&nbsp;let y = 2 in <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;after(y) <br>in <br>let y = 3 in<br>if (x = y \|\| true) then <br>&nbsp;&nbsp;&nbsp;&nbsp;isbool(x) <br>else <br>&nbsp;&nbsp;&nbsp;&nbsp;isint(y)</code> | false |
| First-order functions | <code>def g x =<br>&nbsp;&nbsp;&nbsp;&nbsp;x + 1<br>end<br><br>def f x y =<br>&nbsp;&nbsp;&nbsp;&nbsp;x y<br>end<br><br>f g 5</code> | 6 |
| Tuples | <code>let t = (1,false,4) in<br>let n = 5 in<br>(istuple(t), istuple(n))</code> | (true, false) |
| First-class functions | <code>def f x y =<br>&nbsp;&nbsp;x + y<br>end<br><br>let g = f in<br>g 2 4</code> | 6 | 
| Partial application | <code>def multiply x y =<br>&nbsp;&nbsp;&nbsp;&nbsp;x * y<br>end<br><br>let double = multiply 2 in<br>double 3| 6 | 
| Mark-Compact <br>garbage collection | <code>def cycle_tuple_memory n =<br>&nbsp;&nbsp;&nbsp;&nbsp;let x = (4, 5) in<br>&nbsp;&nbsp;&nbsp;&nbsp;if n &lt; 1 then<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1<br>&nbsp;&nbsp;&nbsp;&nbsp;else<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cycle_tuple_memory (n-1) +<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cycle_tuple_memory (n-1)<br>end<br><br>cycle_tuple_memory 20</code> | 1048576 |
| Tail-call optimization | <code>def f x =<br>&nbsp;&nbsp;if x = 1 then 1 else f (x-1)<br>end<br><br>f 10000000</code> | 1 |
