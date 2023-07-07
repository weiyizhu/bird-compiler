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
<table>
        <tr>
            <th>Feature</th>
            <th>Bird Program</th>
            <th>Evaluated Result</th>
        </tr>
        <tr>
            <td>Arithmetic</td>
            <td>
              <pre>3 * (1 + (4 - 2) - (3 * 2))</pre>
            </td>
            <td>-9</td>
        </tr>
        <tr>
            <td>Conditionals, <br>let...in, <br>unary and boolean operations</td>
            <td>
              <pre>
let x =
    let y = 2 in after(y)
in
let y = 3 in
if (x = y || true) then
    isbool(x)
else
    isint(y)
              </pre>
            </td>
            <td>false</td>
        </tr>
        <tr>
            <td>First-order functions</td>
            <td>
              <pre>
def g x =
    x + 1
end
&nbsp;&nbsp;&nbsp;&nbsp;
def f x y =
    x y
end
f g 5
              </pre>
            </td>
            <td>6</td>
        </tr>
        <tr>
            <td>Tuples</td>
            <td>
              <pre>let t = (1,false,4) in
let n = 5 in
(istuple(t), istuple(n))
              </pre>
            </td>
            <td>(true, false)</td>
        </tr>
        <tr>
            <td>First-class functions</td>
            <td>
              <pre>
def f x y =
    x + y
end
&nbsp;&nbsp;&nbsp;&nbsp;
let g = f in
g 2 4
              </pre>
            </td>
            <td>6</td>
        </tr>
        <tr>
            <td>Partial application</td>
            <td>
              <pre>
def multiply x y =
&nbsp;&nbsp;&nbsp;&nbsp;x * y
end
&nbsp;&nbsp;&nbsp;&nbsp;
let double = multiply 2 in
double 3
              </pre>
            </td>
            <td>6</td>
        </tr>
        <tr>
            <td>Mark-Compact<br>garbage collection</td>
            <td>
              <pre>
def cycle_tuple_memory n =
&nbsp;&nbsp;&nbsp;&nbsp;let x = (4, 5) in
&nbsp;&nbsp;&nbsp;&nbsp;if n < 1 then
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1
&nbsp;&nbsp;&nbsp;&nbsp;else
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cycle_tuple_memory (n-1) + 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cycle_tuple_memory (n-1)
end
&nbsp;&nbsp;&nbsp;&nbsp;
cycle_tuple_memory 20
              </pre>
            </td>
            <td>1048576</td>
        </tr>
        <tr>
            <td>Tail-call optimization</td>
            <td>
              <pre>
def f x =
&nbsp;&nbsp;&nbsp;&nbsp;if x = 1 then 1 else f (x-1)
end
&nbsp;&nbsp;&nbsp;&nbsp;
f 10000000
              </pre>
            </td>
            <td>1</td>
        </tr>
</table>
