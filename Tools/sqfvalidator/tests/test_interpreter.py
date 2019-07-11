from unittest import TestCase

from sqf.exceptions import SQFParserError
from sqf.types import String, Number, Array, Boolean, Nothing, Number as N
from sqf.interpreter import interpret


class TestInterpreter(TestCase):

    def test_one_statement(self):
        test = '_y = 2; _x = (_y == 3);'
        interpreter, outcome = interpret(test)
        self.assertEqual(Boolean(False), interpreter['_x'])
        self.assertEqual(Nothing(), outcome)

    def test_negative(self):
        test = '_x = -2;'
        interpreter, outcome = interpret(test)
        self.assertEqual(Number(-2), interpreter['_x'])
        self.assertEqual(Nothing(), outcome)

    def test_precedence(self):
        test = '1 - 1 - 1'
        interpreter, outcome = interpret(test)
        self.assertEqual(Number(-1), outcome)

    def test_precedence2(self):
        test = '3 * 2 + 1'
        interpreter, outcome = interpret(test)
        self.assertEqual(Number(7), outcome)

    def test_var_not_defined(self):
        with self.assertRaises(SQFParserError):
            interpret('_y == 3;')

    def test_one_statement2(self):
        test = '(3 - 1) == (3 + 1)'
        interpreter, outcome = interpret(test)
        self.assertEqual(Boolean(False), outcome)

    def test_cant_compare_booleans(self):
        with self.assertRaises(SQFParserError):
            interpret('true == false;')

    def test_wrong_type_arithmetic(self):
        interpret('_x = true;')
        with self.assertRaises(SQFParserError):
            interpret('_x = true; _x + 2;')

    def test_code_dont_execute(self):
        interpreter, outcome = interpret('_x = true; {_x = false};')
        self.assertEqual(Boolean(True), interpreter['_x'])
        self.assertEqual(Nothing(), outcome)

    def test_one_statement1(self):
        test = '_y = 2; (_y == 3)'
        interpreter, outcome = interpret(test)
        self.assertEqual(Boolean(False), outcome)

    def test_floor(self):
        _, outcome = interpret('floor 5.25')
        self.assertEqual(Number(5), outcome)

        _, outcome = interpret('2 + floor -5.25')
        self.assertEqual(Number(-4), outcome)

    def test_leq(self):
        _, outcome = interpret('_x = 10; _x <= 10')
        self.assertEqual(Boolean(True), outcome)

    def test_private_eq(self):
        interpreter, outcome = interpret('private _x = 2')
        self.assertEqual(Number(2), interpreter['_x'])
        self.assertEqual(Number(2), outcome)

    def test_private_eq1(self):
        interpreter, outcome = interpret('private _x = 1 < 2;')
        self.assertEqual(Boolean(True), interpreter['_x'])

    def test_private_single(self):
        interpreter, outcome = interpret('private "_x";')
        self.assertTrue('_x' in interpreter)

    def test_private_many(self):
        interpreter, outcome = interpret('private ["_x", "_y"];')
        self.assertTrue('_x' in interpreter)
        self.assertTrue('_y' in interpreter)

    def test_ignore_comment(self):
        interpreter, outcome = interpret('_x = 2; // the two\n_y = 3;')

        self.assertEqual(N(2), interpreter['_x'])
        self.assertEqual(N(3), interpreter['_y'])

    def test_get_variable(self):
        with self.assertRaises(SQFParserError) as cm:
            interpret('missionnamespace getVariable ["x"]')
        self.assertEqual((1, 29), cm.exception.position)

        with self.assertRaises(SQFParserError) as cm:
            interpret('missionnamespace getVariable [1, 2]')
        self.assertEqual((1, 31), cm.exception.position)

    def test_set_variable(self):
        with self.assertRaises(SQFParserError) as cm:
            interpret('missionnamespace setVariable ["x"]')
        self.assertEqual((1, 29), cm.exception.position)

        with self.assertRaises(SQFParserError) as cm:
            interpret('missionnamespace setVariable [1, 2]')
        self.assertEqual((1, 31), cm.exception.position)


class TestInterpretArray(TestCase):

    def test_assign(self):
        interpreter, outcome = interpret('_x = [1, 2];')
        self.assertEqual(Array([N(1), N(2)]), interpreter['_x'])

    def test_add(self):
        test = '_x = [1, 2]; _y = [3, 4]; _z = _x + _y'
        _, outcome = interpret(test)

        self.assertEqual(Array([N(1), N(2), N(3), N(4)]), outcome)

    def test_append(self):
        interpreter, outcome = interpret('_x = [1,2]; _x append [3,4]')
        self.assertEqual(Nothing(), outcome)
        self.assertEqual(Array([N(1), N(2), N(3), N(4)]), interpreter['_x'])

    def test_subtract(self):
        test = '_x = [1, 2, 3, 2, 4]; _y = [2, 3]; _z = _x - _y'
        _, outcome = interpret(test)

        self.assertEqual(Array([N(1), N(4)]), outcome)

    def test_set(self):
        test = '_x = [1, 2]; _x set [0, 2];'
        interpreter, _ = interpret(test)
        self.assertEqual(Array([N(2), N(2)]), interpreter['_x'])

        test = '_x = [1, 2]; _x set [2, 3];'
        interpreter, _ = interpret(test)
        self.assertEqual(Array([N(1), N(2), N(3)]), interpreter['_x'])

    def test_in(self):
        _, outcome = interpret('2 in [1, 2]')
        self.assertEqual(Boolean(True), outcome)

        _, outcome = interpret('0 in [1, 2]')
        self.assertEqual(Boolean(False), outcome)

        _, outcome = interpret('[0, 1] in [1, [0, 1]]')
        self.assertEqual(Boolean(True), outcome)

    def test_select(self):
        _, outcome = interpret('[1, 2] select 0')
        self.assertEqual(N(1), outcome)

        # alternative using floats
        _, outcome = interpret('[1, 2] select 0.5')
        self.assertEqual(N(1), outcome)

        _, outcome = interpret('[1, 2] select 0.6')
        self.assertEqual(N(2), outcome)

        # alternative using booleans
        _, outcome = interpret('[1, 2] select true')
        self.assertEqual(N(2), outcome)

        _, outcome = interpret('[1, 2] select false')
        self.assertEqual(N(1), outcome)

        # alternative using [start, count]
        _, outcome = interpret('[1, 2, 3] select [1, 2]')
        self.assertEqual(Array([N(2), N(3)]), outcome)

        _, outcome = interpret('[1, 2, 3] select [1, 10]')
        self.assertEqual(Array([N(2), N(3)]), outcome)

        with self.assertRaises(SQFParserError):
            _, outcome = interpret('[1, 2, 3] select [4, 10]')

        with self.assertRaises(SQFParserError):
            _, outcome = interpret('[1, 2, 3] select 10')

    def test_find(self):
        _, outcome = interpret('[1, 2] find 2')
        self.assertEqual(N(1), outcome)

        _, outcome = interpret('[1, 2] find 3')
        self.assertEqual(N(-1), outcome)

    def test_pushBack(self):
        interpreter, outcome = interpret('_x = [1]; _x pushBack 2')
        self.assertEqual(Array([N(1), N(2)]), interpreter['_x'])
        self.assertEqual(N(1), outcome)

    def test_pushBackUnique(self):
        interpreter, outcome = interpret('_x = [1]; _x pushBackUnique 2')
        self.assertEqual(Array([N(1), N(2)]), interpreter['_x'])
        self.assertEqual(N(1), outcome)

        interpreter, outcome = interpret('_x = [1, 2]; _x pushBackUnique 2')
        self.assertEqual(Array([N(1), N(2)]), interpreter['_x'])
        self.assertEqual(N(-1), outcome)

    def test_reverse(self):
        interpreter, outcome = interpret('_x = [1, 2]; reverse _x')
        self.assertEqual(Nothing(), outcome)
        self.assertEqual(Array([N(2), N(1)]), interpreter['_x'])

    def test_reference(self):
        # tests that changing _x affects _y when _y = _x.
        interpreter, _ = interpret('_x = [1, 2]; _y = _x; _x set [0, 2];')
        self.assertEqual(Array([N(2), N(2)]), interpreter['_x'])
        self.assertEqual(Array([N(2), N(2)]), interpreter['_y'])

        interpreter, _ = interpret('_x = [1, 2]; _y = _x; reverse _x;')
        self.assertEqual(Array([N(2), N(1)]), interpreter['_y'])

    def test_params(self):
        # tests that changing _x affects _y when _y = _x.
        interpreter, _ = interpret('params [["_x", 2]]')
        self.assertEqual(Number(2), interpreter['_x'])


class TestInterpretString(TestCase):
    def test_assign(self):
        test = '_x = "ABA";'
        interpreter, outcome = interpret(test)

        self.assertEqual(String('"ABA"'), interpreter['_x'])

    def test_add(self):
        test = '_x = "ABA"; _y = "BAB"; _x + _y'
        _, outcome = interpret(test)
        self.assertEqual(String('"ABABAB"'), outcome)

    def test_find(self):
        _, outcome = interpret('"Hello world!" find "world!"')
        self.assertEqual(N(6), outcome)


class IfThen(TestCase):
    def test_then(self):
        interpreter, outcome = interpret('_x = 1; if (true) then {_x = 2}')
        self.assertEqual(N(2), outcome)
        self.assertEqual(N(2), interpreter['_x'])

        interpreter, outcome = interpret('_x = 1; if (false) then {_x = 2}')
        self.assertEqual(Nothing(), outcome)
        self.assertEqual(N(1), interpreter['_x'])

    def test_then_array(self):
        interpreter, outcome = interpret('if (true) then [{_x = 2}, {_x = 3}]')
        self.assertEqual(N(2), outcome)
        self.assertEqual(N(2), interpreter['_x'])

        interpreter, outcome = interpret('if (false) then [{_x = 2}, {_x = 3}]')
        self.assertEqual(N(3), outcome)
        self.assertEqual(N(3), interpreter['_x'])

    def test_then_else(self):
        interpreter, outcome = interpret('if (true) then {_x = 2} else {_x = 3}')
        self.assertEqual(N(2), outcome)
        self.assertEqual(N(2), interpreter['_x'])

        interpreter, outcome = interpret('if (false) then {_x = 2} else {_x = 3}')
        self.assertEqual(N(3), outcome)
        self.assertEqual(N(3), interpreter['_x'])

    def test_exceptions(self):
        with self.assertRaises(SQFParserError):
            interpret('if (false) then (_x = 2) else {_x = 3}')

        with self.assertRaises(SQFParserError):
            interpret('if (1) then {_x = 2} else {_x = 3}')


class Loops(TestCase):
    def test_while(self):
        interpreter, outcome = interpret('_x = 0; while {_x != 10} do {_x = _x + 1};')
        self.assertEqual(N(10), interpreter['_x'])

    def test_forspec(self):
        interpreter, outcome = interpret('_y = 0; for [{_x = 1},{_x <= 10},{_x = _x + 1}] do {_y = _y + 2}')
        self.assertEqual(N(20), interpreter['_y'])
        self.assertEqual(N(11), interpreter['_x'])
        self.assertEqual(N(20), outcome)

    def test_forspec_exit_with_bool(self):
        test = '''
        a = 0;
        b = true;
        for [{_i = 0}, {_i < 10 && b}, {_i = _i + 1}] do {
            a = a + 1;
            if (a >= 7) then {b = false}
        }
                 '''

        interpreter, outcome = interpret(test)
        self.assertEqual(Boolean(False), outcome)
        self.assertEqual(N(7), interpreter['a'])

    def test_for_var(self):
        test = 'y = []; for "_i" from 1 to 10 do {y pushBack _i;};'
        interpreter, outcome = interpret(test)
        self.assertEqual(Array([N(i) for i in range(1, 11)]), interpreter['y'])

    def test_for_var_step(self):
        test = 'y = []; for "_i" from 1 to 10 step 2 do {y pushBack _i;};'
        interpreter, outcome = interpret(test)
        self.assertEqual(Array([N(1), N(3), N(5), N(7), N(9)]), interpreter['y'])

    def test_forvar_edges(self):
        # see comments on https://community.bistudio.com/wiki/for_var

        # start = end => runs once
        test = 'y = -10; for "_i" from 0 to 0 do {y = _i;};'
        interpreter, _ = interpret(test)
        self.assertEqual(N(0), interpreter['y'])

        # start < end => never runs
        interpreter, _ = interpret('y = -10; for "_i" from 0 to -1 do {y = _i;};')
        self.assertEqual(N(-10), interpreter['y'])

        # do not overwrite globals
        interpreter, _ = interpret('for "x" from 0 to 0 do {};')
        self.assertEqual(Nothing(), interpreter['x'])

        # nested
        test = '_array = []; for "_i" from 0 to 1 do {for "_i" from 0 to 1 do {_array pushBack _i;}; _array pushBack _i;};'
        interpreter, _ = interpret(test)
        self.assertEqual(Array([N(0), N(1), N(0), N(0), N(1), N(1)]), interpreter['_array'])

    def test_foreach(self):
        test = 'y = 0; {y = y + _x + _foreachindex} forEach [1,2]'
        interpreter, _ = interpret(test)
        self.assertEqual(N(1 + 0 + 2 + 1), interpreter['y'])


class Switch(TestCase):

    def test_basic(self):
        code = 'switch ("blue") do {case "blue": {true}; case "red": {false}}'
        interpreter, outcome = interpret(code)
        self.assertEqual(Boolean(True), outcome)

        code = 'switch ("red") do {case "blue": {true}; case "red": {false}}'
        interpreter, outcome = interpret(code)
        self.assertEqual(Boolean(False), outcome)

    def test_return_true(self):
        code = 'switch (0) do {case (1): {"one"};}'
        interpreter, outcome = interpret(code)
        self.assertEqual(Boolean(True), outcome)

    def test_default_and_or(self):
        code = '''
        switch %s do {
            case "0";
            default {"default"};
            case "3": {"3"};
            case "1";
            case "4";
            case "2": {"2"};
        }'''
        self.assertEqual(String('"3"'), interpret(code % '"0"')[1])
        self.assertEqual(String('"default"'), interpret(code % '"5"')[1])
        self.assertEqual(String('"2"'), interpret(code % '"1"')[1])
        self.assertEqual(String('"3"'), interpret(code % '"3"')[1])

    def test_syntax_error(self):
        # 2 defaults error
        with self.assertRaises(SQFParserError) as cm:
            interpret('switch (0) do {case (1): {"one"}; default {"as"}; default {"ass"}}')
        self.assertEqual((1, 14), cm.exception.position)

        # more than one code
        with self.assertRaises(SQFParserError) as cm:
            interpret('switch (0) do {case 1: {}')
        self.assertEqual((1, 15), cm.exception.position)

        # more than one code
        with self.assertRaises(SQFParserError) as cm:
            interpret('switch (0) do {1 + 1}')
        self.assertEqual((1, 16), cm.exception.position)

        # case without arguments
        with self.assertRaises(SQFParserError) as cm:
            interpret('switch (0) do {case;')
        self.assertEqual((1, 15), cm.exception.position)

        # case without arguments
        with self.assertRaises(SQFParserError) as cm:
            interpret('switch (0) do {1}')
        self.assertEqual((1, 16), cm.exception.position)

        # default without argument
        with self.assertRaises(SQFParserError) as cm:
            interpret('switch (0) do {default: {}}')
        self.assertEqual((1, 16), cm.exception.position)


class Scopes(TestCase):

    def test_assign(self):
        interpreter, outcome = interpret('x = 2; _x = 1;')

        self.assertEqual(N(1), interpreter['_x'])
        self.assertEqual(N(2), interpreter['x'])

    def test_one_scope(self):
        interpreter, outcome = interpret('_x = 1;')
        self.assertEqual(N(1), interpreter['_x'])

        interpreter, outcome = interpret('_x = 1; if true then {_x}')
        self.assertEqual(N(1), outcome)

        interpreter, outcome = interpret('_x = 1; if (true) then {private "_x"; _x}')
        self.assertEqual(Nothing(), outcome)

        interpreter, outcome = interpret('_x = 1; if (true) then {private "_x"; _x = 2}')
        self.assertEqual(N(2), outcome)
        self.assertEqual(N(1), interpreter['_x'])

        # without private, set it to the outermost scope
        interpreter, outcome = interpret('_x = 1; if (true) then {_x = 2}')
        self.assertEqual(N(2), outcome)
        self.assertEqual(N(2), interpreter['_x'])

    def test_private_global_error(self):
        with self.assertRaises(SQFParserError):
            interpret('private "x"')

    def test_function(self):
        scope, outcome = interpret('_max = {(_this select 0) max (_this select 1)};'
                                   '_maxValue = [3,5] call _max;')
        self.assertEqual(N(5), scope['_maxValue'])

    def test_global(self):
        interpreter, _ = interpret('x = 1; if (true) then {x = 2;}')
        self.assertEqual(N(2), interpreter['x'])


class Namespaces(TestCase):

    def test_setvariable(self):
        interpreter, outcome = interpret('missionNamespace setVariable ["_x", 2];')

        self.assertEqual(N(2), interpreter.namespace('missionNamespace')['_x'])

        interpreter, outcome = interpret('uiNamespace setVariable ["_x", 2];')
        self.assertEqual(N(2), interpreter.namespace('uiNamespace')['_x'])
        self.assertTrue('_x' not in interpreter.namespace('missionNamespace'))
        self.assertEqual(Nothing(), interpreter['_x'])

    def test_getvariable(self):
        interpreter, outcome = interpret('uiNamespace setVariable ["_x", 2]; uiNamespace getVariable "_x"')
        self.assertEqual(N(2), outcome)

        interpreter, outcome = interpret('uiNamespace getVariable ["_x", 2]')
        self.assertEqual(N(2), outcome)


class Operators(TestCase):

    def test_to_array_string(self):
        outcome = interpret('toArray("AaŒ")')[1]
        self.assertEqual(Array([N(65), N(97), N(338)]), outcome)

        outcome = interpret('toString([65,97,338])')[1]
        self.assertEqual(String('"AaŒ"'), outcome)

    def test_resize_array(self):
        interpreter = interpret('_x = [1,2]; _x resize 4')[0]
        self.assertEqual(Array([N(1), N(2), Nothing(), Nothing()]), interpreter['_x'])

        interpreter = interpret('_x = [1,2,3,4]; _x resize 2')[0]
        self.assertEqual(Array([N(1), N(2)]), interpreter['_x'])

    def test_assign_array(self):
        interpreter = interpret('_y = [];')[0]
        self.assertEqual(Array([]), interpreter['_y'])
