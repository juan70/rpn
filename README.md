A (very) simplistic RPN calculator
==================================

Table of contents
 - [Introduction](#introduction)
 - [Available operations and commands](#available-operations-and-commands)
 - [Building and running](#building-and-running)
     - [OCaml](#ocaml)
 - [Example session](#example-session)


## Introduction

A few weeks ago, I stumbled upon a web page that was called something like "RPN calc in many languages".
I can't find the link right now.  I decided to practice with the [OCaml](http://ocamlorg) language.

Although OCaml has a [Stack](http://caml.inria.fr/pub/docs/manual-ocaml/libref/Stack.html) module
in the [standard library](http://caml.inria.fr/pub/docs/manual-ocaml/libref/index.html),
I decided to implement everything by myself,
using a simple [List](http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html) as the stack.

## Available operations and commands
As shown in the source code, there are a few operations and a couple of commands:

Operator | |
|:--:|:--:|
`+` | add
`-` | subtract
`*` | multiply
`/` | divide
`%` | modulo
`v` | square root
`l` | log

Command | |
|:--:|:--:|
`p` | print out the stack contents (left to right = bottom to top)
`q` | quit, when in interactive mode


## Building and running

### OCaml
#### Interpreted
```
$ ocaml rpn_calc.ml
1 2 3 + +
6.
q
$
```
or
```
$ echo '1 2 3 + +' | ocaml rpn_calc.ml
6.
$
```

#### Compiled
First, comment out or delete the first line in the source that reads `#load str.cma`.
Then, using ocamlbuild :
```
$ cd rpn_calc
$ ocamlbuild -use-ocamlfind rpn_calc.native
$ ./rpn_calc.native
1 2 3 + +
6.
1 2 p 3 p + p + q
1. 2.
1. 2. 3.
1. 5.
6.
$
```

