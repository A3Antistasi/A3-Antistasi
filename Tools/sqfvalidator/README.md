[![Build Status](https://travis-ci.org/LordGolias/sqf.svg?branch=master)](https://travis-ci.org/LordGolias/sqf)
[![Coverage Status](https://coveralls.io/repos/github/LordGolias/sqf/badge.svg)](https://coveralls.io/github/LordGolias/sqf)

# SQF linter

This project contains a parser, static analyzer and interpreter for
SQF (Arma scripting language), written in Python.
It can be used to:

* syntax-check and static analyze SQF files and projects
* execute SQF on a limited virtual environment

## Problem it solves

One of the major bottlenecks of scripting in SQF is the time spent
testing it in-game, by running the game.

Often, these scripts contain errors (missing ";", wrong usage of `params`) that everyone would
love to find without restarting the mission.

This package allows to parse SQF to check for syntactic errors,
wrong types, problems in variables scopes, and many more subtle issues of SQF.

### Analyzer examples

    >>> code = 'if (true) {1}'
    >>> errors = sqf.analyzer.analyze(sqf.parser.parse(code))
    >>> errors[0]
    SQFParserError((1, 11), "'(true)' can't preceed '{1}' (missing ';'?)")

    >>> code = 'private _y = _z'
    >>> analyzer = sqf.scope_analyzer.interpret(sqf.parser.parse(code))
    >>> analyzer.exceptions[0]
    SQFWarning((1, 14), 'Local variable "_z" is not from this scope (not private)')

### Parser example

Behind the curtains, the analyzer uses a parser to convert SQF code in a set of statements:

    >>> code = '[1, 2, 3]'
    >>> sqf.parser.parse(code)
    Statement([Statement([
        Array([Statement([N(1)]), Statement([Space(), N(2)]), Statement([Space(), N(3)])])
    ])])

### Interpreter example

The interpreter is able to run scripts on an emulated (and limited) environment.
The interpreter is obviously *not intended* to run Arma simulation; it is
aimed for you, moder, run tests of your scripts (e.g. Unit Tests)
without having to run the game.

    from sqf.interpreter import interpret
    interpreter, outcome = interpret('_x = [1, 2]; _y = _x; reverse _y;')
    # outcome equals to "Nothing"
    # interpreter['_y'] equals to Array([Number(2), Number(1)])
    # interpreter['_x'] equals to Array([Number(2), Number(1)])  # <= _y is a reference

## Requirements and installation

This code is written in Python 3 and has no dependencies. You can install it using 

    pip3 install sqflint

## Tests and coverage

The code is heavily tested (coverage 98%+), and the tests
can be found in `tests`. Run them using standard Python unittest:

    python -m unittest discover

## Compatibility with editors

This package is compatible with known editors, and can be used to efficiently write SQF
with them. See the respective projects for more details:

* [atom-linter](https://atomlinter.github.io/): [linter-sqf](https://github.com/LordGolias/linter-sqf)
* [sublimeLinter](http://www.sublimelinter.com/en/latest/): [SublimeLinter-contrib-sqflint](https://github.com/LordGolias/SublimeLinter-contrib-sqflint)

## Code organization

This code contains essentially 4 components, a **tokenizer**, 
a **parser**, **analyzer** and **interpreter**:

### Interpreter

The interpreter is a class that executes parsed scripts. It receives a 
`Statement` and executes it as per described in the [Arma 3' wiki](https://community.bistudio.com/wiki).
To automatically initialise the interpreter and execute code, run `interpret`: 
 
    >>> from sqf.interpreter import interpret
    >>> script = '''
    a = 0;
    b = true;
    for [{_i = 0}, {_i < 10 && b}, {_i = _i + 1}] do {
        a = a + 1;
        if (a >= 7) then {b = false}
    }
    '''
    >>> interpreter, outcome = interpret(script)
    >>> interpreter['a']
    Number(7)
    >>> outcome
    Boolean(False)

The call `interpreter['a']` returns the outermost `Scope`
of the `Namespace` `"missionNamespace"`, but you can use `setVariable`
and `getVariable` to interact with other namespaces.
`sqf.tests.test_interpreter` contains the tests of the implemented functionality.

The source is in `sqf/interpreter.py`, the tests in `tests/test_interpreter.py`.
The main loop of the interpreter is defined in `sqf/interpreter.py`, and the 
expressions it evaluates are defined in `sqf/expressions.py`.

### Analyzer

The analyzer consumes the result of the parser and checks for static errors.
The source is in `sqf/analyzer.py`, the tests in `tests/test_analyzer.py`.

### Parser

The parser transforms a string into a nested `Statement`, i.e. 
a nested list of instances of `types`, operators, and keywords defined in SQF.
For example,

    >>> from sqf.parser import parser
    >>> script = '_x=2;'
    >>> result = parse(script)
    >>> result
    Statement([Statement([Variable('_x'), Keyword('='), Number(2)], ending=';')])
    >>> script == str(result) # True

This rather convolved `result` takes into account operator precedence and
the meaning of the different parenthesis (`[]`, `{}`, `()`).
To transform the script into tokens used in the parser, the tokenizer is called.
`sqf.tests.test_parser` contains the tests.

### Tokenizer

The tokenizer transforms a string into a list of tokens split by the 
relevant tokens of SQF. E.g.

    >>> from sqf.base_tokenizer import tokenize
    >>> tokenize('/*_x = 1;*/')
    ['/*', '_x', ' ', '=', ' ', '1', ';', '*/']

The source can be found in `sqf.base_tokenizer`.

## Licence

This code is licenced under BSD.

## Author

This code was written by Lord Golias, lord.golias1@gmail.com
