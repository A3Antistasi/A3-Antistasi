from unittest import TestCase, expectedFailure

from sqf.types import Number, String, Boolean, Array, Code, Anything, Nothing
from sqf.parser import parse
from sqf.analyzer import analyze, Analyzer


class GeneralTestCase(TestCase):

    def test_insensitive_variables(self):
        code = 'private "_x"; a = _X'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_warn_not_in_scope(self):
        analyzer = analyze(parse('_z;'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((1, 1), errors[0].position)

    def test_evaluate(self):
        code = 'x = 2;'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number(), analyzer['x'])

    def test_assign_wrong(self):
        analyzer = analyze(parse('1 = 2;'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((1, 1), errors[0].position)

    def test_private_eq1(self):
        analyzer = analyze(parse('private _x = 1 < 2; _x'))
        self.assertEqual(analyzer.exceptions, [])

    def test_private_single(self):
        code = 'private "_x"; private _z = _x; _z'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_private_many(self):
        analyzer = analyze(parse('private ["_x", "_y"]; _x; _y'))
        self.assertTrue('_x' in analyzer)
        self.assertTrue('_y' in analyzer)
        self.assertEqual(analyzer.exceptions, [])

    def test_private_wrong(self):
        # private argument must be a string
        analyzer = analyze(parse('private _x; _x'))
        errors = analyzer.exceptions

        self.assertEqual(len(errors), 1)

    def test_private_wrong_exp(self):
        # private argument must be a string
        analyzer = analyze(parse('private {_x};'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_private_no_errors(self):
        code = "private _x = x call AS_fnc_location_position; _x"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_private_empty(self):
        code = "private [];"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_private_global(self):
        code = 'private pic = 2'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((1, 9), errors[0].position)

    def test_private_var_error(self):
        code = 'private [x,y];'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test__this(self):
        analyzer = analyze(parse('_this select 0;'))
        self.assertEqual(len(analyzer.exceptions), 0)

    def test_global(self):
        # global variables have no error
        analyzer = analyze(parse('global select 0;'))
        self.assertEqual(len(analyzer.exceptions), 0)

    def test_set_and_get_together(self):
        # because _x is assigned to the outer scope, reading it is also from
        # the outer scope.
        analyzer = analyze(parse('_x = x; _x'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_wrong_semi_colon(self):
        code = 'if; (false) then {x = 0.95;};'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)
        self.assertEqual((1, 1), errors[0].position)

    def test_undefined_sum(self):
        code = 'y = x + 1'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_wrong_sum(self):
        code = 'y = x + z'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'y = x + do'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_missing_semi_colon(self):
        code = "d = 0\nif (not onoff) then {d = 0.95;};"
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)
        self.assertEqual((2, 3), errors[0].position)

    def test_statement(self):
        code = 'x=2 y=3;'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)
        self.assertEqual((1, 6), errors[0].position)

    def test_missing_op(self):
        code = 'x 2'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_if_then(self):
        code = 'if (false) then {_damage = 0.95;};'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_if_then_else(self):
        code = 'if (false) then\n {_damage = 0.95}\n\telse\n\t{_damage = 1};'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_if_then_specs(self):
        code = 'if (false) then [{_damage = 0.95},{_damage = 1}]'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_if(self):
        code = 'if (not _onoff) then {_damage = 0.95;};'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_while(self):
        code = 'while {true} do {_x = 2}'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_for_specs(self):
        code = 'for [{_x = 1},{_x <= 10},{_x = _x + 1}] do {_y = _y + 2}'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 6)

    def test_for_code(self):
        code = 'private _x = {hint str _y}; for "_i" from 0 to 10 do _x'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_foreach_error(self):
        code = '{hint str _y} forEach [1,2]'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_foreach_variable(self):
        code = '{hint str _y} forEach _d;'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_foreach_no_error(self):
        code = "{sleep 1} forEach lamps;"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_foreach(self):
        code = 'y = {if (_x == 1) exitWith{1};} forEach x;'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(type(analyzer['y']), Anything)

    def test_getConfig(self):
        code = 'configFile >> "CfgWeapons" >> x >> "WeaponSlotsInfo" >> "mass"'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_custom_function(self):
        code = 'a = createMarker ["a", [0,0,0]];'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_get_variable_unknown_first_element(self):
        code = 'missionNamespace getVariable[format["x_%1",x],[]];'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_lowercase(self):
        code = 'mapa = "MapBoard_altis_F" createvehicle [0,0,0];'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_for_missing_do(self):
        code = 'for "_i" from 1 to 10 {y pushBack _i;};'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 3)
        self.assertEqual((1, 23), errors[0].position)

    def test_if_missing_then(self):
        code = 'if (true) {1}'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)
        self.assertEqual((1, 11), errors[0].position)
        self.assertEqual((1, 1), errors[1].position)

    def test_while_no_errors(self):
        code = 'while {count x > 0} do {}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_foreach_no_errors(self):
        code = '{} foreach [];'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_wrong_if(self):
        code = 'if ;'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_negation_priority(self):
        code = '!isNull x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_priority(self):
        code = '(x) isEqualTo -1'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_precedence_nullary(self):
        code = 'x = !isServer;'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_error_message_unary(self):
        code = 'parseNumber 1'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual(errors[0].message,
                         'error:Unary operator "parsenumber" only accepts argument '
                         'of types [String,Boolean] (rhs is Number)')

    def test_error_message_binary(self):
        code = '1 + "2"'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertTrue(errors[0].message.startswith('error:Binary operator "+" arguments must be ['))

    def test_error_in(self):
        code = '_door ()'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_change_types(self):
        code = 'private _x = ""; private _m = handgunMagazine player; _x = _m select 0; _x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'isNull attachedTo player;'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_multiple_returns_is_nothing(self):
        # Regression for issue #13
        code = 'private _debug = getMissionConfigValue ["enableDebugConsole", 0];(_debug == 1)'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_count_with_config_and_minus(self):
        code = 'x = missionConfigFile >> "CfgInteractionMenus"; for "_n" from 0 to count(x) - 1 do {}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_error_bla(self):
        code = '() ()'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_error_double(self):
        code = 'private["_x","_y"];\n_x _y'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_missing_while_bracket(self):
        code = 'while ((count x) < y) do {}'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_throw(self):
        analyzer = analyze(parse('if (true) throw false'))
        self.assertEqual(analyzer.exceptions, [])

    def test_precedence_various(self):
        code = 'surfaceIsWater getPos player'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'str floor x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'floor random 3'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'floor -2'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'x lbSetCurSel -1'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_getset_variable_undefined(self):
        code = 'missionNamespace getVariable x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'missionNamespace getVariable [x,2]'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'x = str y; missionNamespace getVariable x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'missionNamespace setVariable [x,2]'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'missionNamespace setVariable x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_precedence_fail(self):
        code = 'x % floor x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_logical_with_nothing(self):
        code = '{true || x} forEach [1,2]'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_call_recursive(self):
        code = 'x = {call x}; call x'
        analyzer = analyze(parse(code))
        self.assertEqual(Code(), analyzer['x'])

    def test_recursive_assign(self):
        code = 'private _x = {call _x}'
        analyzer = analyze(parse(code))
        self.assertEqual(Code(), analyzer['_x'])
        self.assertEqual(analyzer.exceptions, [])

    def test_with_namespace_simple(self):
        code = 'with uinamespace do {x = 2}'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(Anything(), analyzer['x'])  # missionnamespace is empty
        self.assertEqual(Number(), analyzer.namespace('uinamespace')['x'])

    def test_with_namespace(self):
        code = 'with uinamespace do {with missionnamespace do {x = 2}}'
        analyzer = analyze(parse(code))
        self.assertEqual(Number, type(analyzer['x']))  # missionnamespace was used
        self.assertNotIn('x', analyzer.namespace('uinamespace'))

    def test_call(self):
        code = "x=((call y)==2)"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Boolean, type(analyzer['x']))


class PreprocessorDefine(TestCase):

    def test_define_no_error(self):
        code = "#define A 2\n"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_simple(self):
        code = "#define A 2\nx = A"
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(analyzer['x'], Number())

    def test_define_array(self):
        code = "#define A 1,2\nx = [A,3]"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Array, type(analyzer['x']))

    def test_define_fnc(self):
        code = "#define A(_x) (_x == 2)\nx = A(3)"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Boolean, type(analyzer['x']))

    def test_define_of_define(self):
        code = "#define A (call y)\n#define B (A==2)\nx=B;"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Boolean, type(analyzer['x']))

        code = "#define A(y) (call y)\n#define B (2==A({}))\nx=B;"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Boolean, type(analyzer['x']))

    def test_define_replace_in_statement(self):
        code = '#define A 2\n'
        code += 'z=((2)min A)max 1'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number, type(analyzer['z']))

    def test_define_complex(self):
        code = '#define CHECK_CATEGORY(_category) (if !(_category in AS_AAFarsenal_categories) then { \\\n' \
               '\tdiag_log format ["[AS] AS_AAFarsenal: category %1 does not exist.", _category];} \\\n    );\n'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_define_with_args_usage(self):
        code = "#define __CHECK_CATEGORY(_x) (_x)\n"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_define_with_define(self):
        code = "#define PASS(x) PUSH(x,y)\n"
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_defines(self):
        # ignore "macros" (not correct since CHECK may not be defined, but for that we need a pre-processor)
        code = 'CHECK(x)'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_define_correct(self):
        # ignore "macros" (not correct since CHECK may not be defined, bot for that we need a pre-processor)
        code = '#define A'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_defines_underscored(self):
        code = '#define __TRACKINTERVAL 0\n x ctrlCommit __TRACKINTERVAL'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_define_expression(self):
        code = '#define X (1 == 2)\n x = X'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Boolean(), analyzer['x'])

    def test_defines_in_unexecuted_code(self):
        code = '#define __VALUE 1\n{X = __VALUE}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_defines_in_array(self):
        code = '#define x 1\ny=[x,x]'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Array(), analyzer['y'])

    def test_defines_in_array2(self):
        code = '#define x  (0.1)\n#define y  (0.02)\nz = [2 * x, 2 * y, 2 * x];'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(Array(), analyzer['z'])

    def test_define_unused(self):
        code = '\n#define x false\n'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)


class Preprocessor(TestCase):

    def test_include(self):
        code = '#include "macros.hpp"\nx = 1;'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_include_error(self):
        code = '#include _x\n'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((1, 1), errors[0].position)

    def test_include_error_len(self):
        code = '#include\n'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((1, 1), errors[0].position)

    def test_include_with_semi_colon(self):
        code = '#include "a.sqf";\n'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_macros(self):
        code = 'x call EFUNC(api,setMultiPushToTalkAssignment)'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_ifdef_endif(self):
        code = '#define A\n#ifdef A\na=1\n#endif'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(type(analyzer['a']), Number)

    def test_ifdef_endif_with_defines(self):
        code = '#ifdef A\n#define DEBUG true\n#else\n#define DEBUG false\n#endif\nenableSaving [false, false];'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_double_ifdef(self):
        code = '#ifdef A\n#include "A"\n#endif\n' \
               '#ifdef B\n#include "B"\n#endif\n' \
               'a = "";'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(type(analyzer['a']), String)

    def test_nested(self):
        code = '''
        #ifdef A
        x=
        #ifndef B
        2
        #else
        ""
        #endif
        #endif
        '''
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(type(analyzer['x']), Anything)

        code = '#define A\n' + code
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(type(analyzer['x']), Number)

        code = '#define B\n' + code
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(type(analyzer['x']), String)

    def test_sequential(self):
        code = '''
        #ifndef A
        x=
        #else
        y=
        #endif
        #ifndef B
        2
        #else
        ""
        #endif
        '''
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(type(analyzer['x']), Number)
        self.assertEqual(type(analyzer['y']), Anything)

        code = '#define A\n' + code
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(type(analyzer['x']), Anything)
        self.assertEqual(type(analyzer['y']), Number)

        code = '#define B\n' + code
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(type(analyzer['x']), Anything)
        self.assertEqual(type(analyzer['y']), String)

    def test_some_cases(self):
        code = 'call {\n#ifndef A\nx=2\n#endif\n}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = '{\nx=1;\n\n    #ifdef A\nx=1;\n#endif\n} forEach z;\nz\n'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_undef_else(self):
        code = '\n#ifndef A\nx=1;\n#else\nx="";\n#endif\n'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(type(analyzer['x']), Number)

        code = '#define A\n' + code
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(type(analyzer['x']), String)

    def test_undef_else_2(self):
        code = '#ifndef A\n' \
               'x=\n' \
               '#else\n' \
               'y=\n' \
               '#endif\n' \
               '2'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(type(analyzer['x']), Number)
        self.assertEqual(type(analyzer['y']), Anything)

        code = '#define A\n' + code
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(type(analyzer['x']), Anything)
        self.assertEqual(type(analyzer['y']), Number)

    def test_ifdef_with_error_pos_in(self):
        code = '#ifndef A\n' \
               '2\n' \
               '#else\n' \
               '3\n' \
               '#endif\n' \
               '2'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((4, 1), errors[0].position)

    def test_ifdef_with_error_pos_out(self):
        code = '#ifndef A\n' \
               '[sadasdsa]\n' \
               '#endif\n' \
               ' + 2'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((4, 2), errors[0].position)

    def test_ifdef_with_error_in_code(self):
        code = '{#ifndef A\n' \
               '[sadasdsa]\n' \
               '#endif\n' \
               ' + 2}'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((4, 2), errors[0].position)

    def test_same_name(self):
        analyzer = analyze(parse('LOG("")'))
        self.assertEqual(analyzer.exceptions, [])

    def test_assign_to_global(self):
        code = 'AA(x) = 2'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'AA(x,y) = 2'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_assign_to_global_after_space(self):
        code = '\n\nGVAR(pipeCode) = "0";'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_upper_cased_keywords(self):
        # cargo is a keyword, but if it is upper-cased, we treat it as a define
        code = 'x = CARGO'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_undefined_define_with_space(self):
        code = ' AS_Pset("destroyedLocations", x - y);'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])


class Arrays(TestCase):

    def test_basic(self):
        code = 'a=[_x,\n_y]'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)
        self.assertEqual((1, 4), errors[0].position)
        self.assertEqual((2, 1), errors[1].position)

    def test_error_inside_array(self):
        code = 'x=[1, _x select 0];'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual(errors[0].position, (1, 7))

    def test_no_space(self):
        code = 'x set[_cIndex, 2]'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((1, 7), errors[0].position)

    def test_strange(self):
        code = '{\n\tformat ["",\n\t\t\t_z, _y];\n} forEach a;\n'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions

        self.assertEqual(len(errors), 2)
        self.assertEqual((3, 8), errors[1].position)

    def test_position_of_array(self):
        code = 'y = if (x) then[{hint _x}, {damage _y}];'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 2)
        self.assertEqual((1, 36), analyzer.exceptions[1].position)
        self.assertEqual((1, 23), analyzer.exceptions[0].position)

    def test_array_from_function(self):
        code = '("" configClasses configFile)'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)

        code = '("" configClasses configFile) select 2'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)


class Switch(TestCase):

    def test_case_not_code(self):
        code = 'switch (x) do {case 1: 2}'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((1, 22), errors[0].position)

    def test_incomplete_case(self):
        code = 'switch (x) do {case 1: }'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 1)
        self.assertEqual((1, 22), analyzer.exceptions[0].position)

    def test_case_by_variable(self):
        code = 'switch (a) do {case "blue": x; case "red": {false}}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_error_in_case(self):
        code = 'switch (a) do {case "blue": {hint _x}; case "red": {false}}'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_case_with_variable_code(self):
        code = 'switch (x) do {case 1: _y}'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 1)

    def test_default(self):
        code = 'switch (x) do {default {[]}}'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)

    def test_default_error(self):
        code = 'switch (x) do {default : {[]}}'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 3)
        self.assertEqual((1, 23), errors[0].position)

    def test_switch_statement_without_parenthesis(self):
        code = 'switch 1 do {case 1: {"one"};}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_not_statement(self):
        code = 'switch (1) do {case 1: {"one"};}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_missing_do(self):
        code = 'switch (1) {case 1: {"one"};}'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((1, 12), errors[0].position)

    def test_switch_alone(self):
        code = 'switch (x) do {case "ACRE_PRC343";};'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])


class NestedCode(TestCase):
    def test_code(self):
        code = "x = {\ncall {x=1 y = 2;}\n}"
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 3)
        self.assertEqual((2, 12), errors[0].position)

    def test_array_after_then(self):
        code = 'if (x) then[{},{}];'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_array(self):
        code = '[{\n3 2},0,0];'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((2, 3), errors[0].position)

    def test_code_with_private(self):
        code = "x = {\ncall {private _x; _x}\n}"
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((2, 15), errors[0].position)

    def test_code_with_expression(self):
        code = "x = {\ncall {1 + _x;}\n}"
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((2, 11), errors[0].position)

    def test_code_with_if(self):
        code = "x = {\ncall {if y;}\n}"
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertEqual((2, 7), errors[0].position)

    def test_private(self):
        code = 'private _x = 2; while {_x < 1} do {}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_private_in_exitwith(self):
        code = 'private _x = 2; if (true) exitWith {x = _x}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_call_within(self):
        analyzer = analyze(parse('x = 0; call {call {x = x + 1; call {x = x + 2}}}'))
        self.assertEqual(analyzer.exceptions, [])

    def test_call_within_this(self):
        analyzer = analyze(parse('x = {if (call _this) exitWith {call _this}}'))
        self.assertEqual(analyzer.exceptions, [])


class Params(TestCase):
    def test_single(self):
        analyzer = analyze(parse('0 params ["_x"]; _x'))
        self.assertEqual(analyzer.exceptions, [])
        self.assertTrue('_x' in analyzer)
        self.assertTrue('"_x"' not in analyzer)

    def test_single_array(self):
        analyzer = analyze(parse('[0] params ["_x"]; _x'))
        self.assertEqual(analyzer.exceptions, [])
        self.assertTrue('_x' in analyzer)
        self.assertTrue('"_x"' not in analyzer)

    def test_many(self):
        analyzer = analyze(parse('[1,2] params ["_x", "_y"]; _x;_y'))
        self.assertEqual(analyzer.exceptions, [])

    def test_many_call(self):
        analyzer = analyze(parse('x = {params ["_x", "_y"]; _x;_y}; [1,2] call x'))
        self.assertEqual(analyzer.exceptions, [])

    def test_with_default(self):
        analyzer = analyze(parse('x = [] call {params [["_x", 0]]; _x}'))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number(), analyzer['x'])

    def test_with_default_unused(self):
        analyzer = analyze(parse('[""] params [["_x", 0]]; _x'))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(String('""'), analyzer['_x'])

    def test_rhs_larger_lhs(self):
        analyzer = analyze(parse('[0,1] params ["_x"]; _x'))
        self.assertEqual(len(analyzer.exceptions), 1)

    def test_missing_arg(self):
        analyzer = analyze(parse('[0] params ["_x", "_y"]; _x; _y'))
        self.assertEqual(len(analyzer.exceptions), 1)
        self.assertEqual(Nothing(), analyzer['_y'])

    def test_missing_default_arg(self):
        analyzer = analyze(parse('[0] params ["_x", ["_y", 2]]; _x + _y'))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number(2), analyzer['_y'])

    def test_with_empty_string(self):
        analyzer = analyze(parse('params [""]'))
        self.assertEqual(analyzer.exceptions, [])

    def test_other(self):
        code = 'params [["_x",objNull,[objNull]]];_x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_array_wrong(self):
        analyzer = analyze(parse('params [["_x"]];'))
        self.assertEqual(len(analyzer.exceptions), 1)

    def test_wrong_array_element(self):
        analyzer = analyze(parse('params [1]'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_wrong_argument(self):
        analyzer = analyze(parse('params {1}'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_lhs_rhs_single_var(self):
        analyzer = analyze(parse('x=2; x params ["_x"]; _x'))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number(), analyzer['_x'])

    def test_params_select(self):
        code = 'x = [2] call {private _x = _this select 0; params ["_y"]; _x + _y}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        # `_this select 0` is Anything because `_this` only has the type
        self.assertEqual(Anything(), analyzer['x'])

    def test_undefined_array(self):
        code = '(boundingBoxReal x) params ["_x", "_y"]; _x + _y'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])


class SpecialContext(TestCase):
    def test_insensitive__foreachindex(self):
        code = '{_foreachindex} forEach [0]'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_findif(self):
        code = '[unit1, unit2, unit3] findIf {not alive _x};'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_try_catch(self):
        code = 'try {hint _x} catch {hint _y; hint str _exception}'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_for_scope(self):
        code = 'for "_i" from 0 to 10 do {_i}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_for_scope_new(self):
        code = 'for "_x" from 0 to 10 do {private _y = ACRE_STACK_TRACE select _x; _y}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_foreach(self):
        code = '{hint str _x} forEach [1,2]'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_select_count_apply(self):
        code = '{_x == 2} count x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'x select {_x == 2}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'x apply {_x == 2}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = 'x select {_x == _y}'  # _y is undefined
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_hash(self):
        code = 'x # 2'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)

        code = 'x # {_x == 2}'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 2)

    def test_code_not_executed_in_loop(self):
        code = '{if ((_x select 0) == r && {(_x select 1) == r}) exitWith {};} forEach t;'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

        code = '(allVariables _this) select {!(isNil {x getVariable _x})};'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_issue5(self):
        code = 'private _view = cameraView;if (!isNull objectParent player && {_view == "GUNNER"}) then {};'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_double_code(self):
        code = 'x apply {_x select 0}; y apply {_x select 0}'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_spawn_thisScript(self):
        code = '[] spawn {x = _thisScript}'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)

    def test_spawn_this_typing_correct(self):
        code = '"" spawn {hint _this}'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)

    def test_spawn_this_typing_error(self):
        code = '[] spawn {hint _this}'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 1)

    def test_spawn_local_vars(self):
        # spawn should not use local variables because they may become undefined (error 1). Likewise,
        # the local variable becomes unused (error 2).
        code = 'private _x = 1; [] spawn {x = _x}'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 2)


class UndefinedValues(TestCase):
    """
    Test what happens when a value is not defined.
    """
    def test_anything(self):
        code = 'y = (count x)'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number(), analyzer['y'])

    def test_anything_for_undecided(self):
        # x could be different things and select would return different types, so select returns Anything
        code = 'y = (x select 0)'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Anything(), analyzer['y'])

    def test_number(self):
        analyzer = Analyzer()
        scope = analyzer.get_scope('x')
        scope['x'] = Number()

        code = "y = 2 + x"
        analyze(parse(code), analyzer)
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(analyzer['y'], Number())

    def test_nothing_is_not_anything(self):
        code = 'sleep 1 + 5'  # in-game, this is (sleep 1) + 5
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_string(self):
        code = "y = 'x' + x"
        analyzer = Analyzer()
        scope = analyzer.get_scope('x')
        scope['x'] = String()

        analyze(parse(code), analyzer)
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(analyzer['y'], String())

    def test_boolean(self):
        code = "y = true || x"
        analyzer = Analyzer()
        scope = analyzer.get_scope('x')
        scope['x'] = Boolean()

        analyze(parse(code), analyzer)
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(analyzer['y'], Boolean())

    def test_array(self):
        code = "y = x select 2"

        analyzer = Analyzer()
        scope = analyzer.get_scope('x')
        scope['x'] = Array()

        analyze(parse(code), analyzer)
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(analyzer['y'], Anything())

    def test_array2(self):
        analyzer = analyze(parse('allPlayers select [1,2];'))
        self.assertEqual(analyzer.exceptions, [])

    def test_if1(self):
        # undefined -> do neither and invalidate any assigment
        analyzer = analyze(parse('x=2; if (y) then {x=1} else {x=2}'))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number(), analyzer['x'])

        # undefined -> test then
        analyzer = analyze(parse('if (y) then {!1}'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

        # undefined -> test both
        analyzer = analyze(parse('if (y) then {!1} else {!2}'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)

    def test_if(self):
        # assign in one branch is independent of the other
        code = 'if (a == "") then {a = {true};} else {a = compile a;};'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Anything(), analyzer['a'])

    def test_while(self):
        # undefined -> do not iterate
        analyzer = analyze(parse('while {x != 0} do {x = 1}'))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Anything(), analyzer['x'])

        # undefined -> test
        analyzer = analyze(parse('while {x != 0} do {! 1}'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_for(self):
        # undefined -> do not execute
        analyzer = analyze(parse('x = 0; for "_i" from 0 to y do {x = x + 1}'))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number(), analyzer['x'])

    def test_for1(self):
        # undefined -> test
        analyzer = analyze(parse('x = 0; for "_i" from 0 to y do {!1}'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_forspecs(self):
        # undefined -> do not execute
        analyzer = analyze(parse('y = 0; for [{x = 1},{x <= z},{x = x + 1}] do {y = y + 1}'))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number(), analyzer['y'])

        # undefined -> test
        analyzer = analyze(parse('y = 0; for [{x = 1},{x <= z},{x = x + 1}] do {!1}'))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_code_in_namespace(self):
        code = 'with uiNamespace do {private _y = 1;{_y = _x} forEach GVAR(completedAreas); _y}'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)

    def test_unexecuted_code_in_namespace(self):
        code = 'with uiNamespace do {private _x = 1;x = {_x = y}; _x}'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)

    def test_two_scopes(self):
        code = 'private _x=1;if(a=="")then{_x=2} else {private _x = ""; _x}; _x'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
        self.assertEqual(Number(), analyzer['_x'])

    def test_many_scopes(self):
        code = 'private _x=1;if(a=="")then{_x=2} else {private "_x"; if(true)then{_x=""}; _x}; _x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number(), analyzer['_x'])

    def test_many_scopes2(self):
        code = 'private _x=1;if(a=="")then{_x=2} else {if(true)then{_x=""}}; _x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Anything(), analyzer['_x'])

    def test_if_with_global(self):
        code = 'x = 1; if (y) then {x = ""};'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Anything, type(analyzer['x']))

    def test_if_else_with_global(self):
        code = 'x = 1; if (y) then {x = ""} else {x = "string"};'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Anything, type(analyzer['x']))

    def test_if_then_private(self):
        code = 'private _x = 1; if (y) then {_x = ""}; _x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Anything, type(analyzer['_x']))

        code = 'private "_x"; if (y) then {_x = ""}; _x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Anything, type(analyzer['_x']))

    def test_if_else_private(self):
        code = 'private _a = ""; if (_a == "") then {_a = {true};} else {_a = compile _a;};'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Anything, type(analyzer['_a']))

        code = 'private _a = ""; if (_a == "") then {_a = {true};} else {_a = compile _a;};'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Anything, type(analyzer['_a']))

    def test_private_undefined(self):
        code = 'private (y apply {x select 0});'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)
        self.assertTrue('Obfuscated statement.' in errors[0].message)

    def test_private_is_nothing(self):
        code = 'private "_a";'
        analyzer = analyze(parse(code))
        self.assertEqual(Nothing(), analyzer['_a'])

    @expectedFailure
    def test_if_else_error(self):
        # this may lead to `compile 1`, which is wrong
        code = 'private _a = 1; if (y == "") then {_a = {true};} else {_a = compile _a;};'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_delayed_execution(self):
        code = '[0, {private _x = "";if(true)then{_x = compile _x;}else{_x = missionNamespace getVariable _x;};}]'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_if_with_private_with_scoping(self):
        """
        Changing on a scope does not alter the type of the other scope
        """
        code = 'private _x = 1; if (y) then {private _x = ""; _x}; _x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])
        self.assertEqual(Number, type(analyzer['_x']))

    def test_assign_if(self):
        code = 'x = if (true) then {1} else {0}; 1 - x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_if_then(self):
        code = 'if false then x;'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_if_then_else(self):
        code = 'if false then x else y;'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])


class SpecialComment(TestCase):
    def test_string1(self):
        code = '//IGNORE_PRIVATE_WARNING ["_x"];\n_x = 2; _x'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)

    def test_string2(self):
        code = '//USES_VARIABLES ["_x"];\n_x = 2; _x'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_string2_fail(self):
        code = '//USES_VARIABLES["_unit"];\n_unit = 2'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 2)
        self.assertEqual(errors[0].message, 'warning:USES_VARIABLES comment must be `//USES_VARIABLES ["var1",...]`')

    def test_var_type(self):
        code = '//USES_VARIABLES ["_x"];\n' \
               '_x isKindOf "sdas"'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_with_space(self):
        code = '//USES_VARIABLES ["_x", "_y"];'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])


class UnusedVariables(TestCase):
    def test_simple(self):
        code = 'private _unit = 2;'
        analyzer = analyze(parse(code))
        errors = analyzer.exceptions
        self.assertEqual(len(errors), 1)

    def test_nested(self):
        code = 'private _x = {}; private _y = {call _x}; call _y'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_with_globals(self):
        code = 'private _x = ""; AF(_x)'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])


class StringAsCodeFunctions(TestCase):
    """
    Tests functions that are passed a string which is compiled to code.
    """
    def test_isNil(self):
        code = 'private _var = A getVariable "x"; x = isNil "_var";'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)

    def test_isNil_undefined(self):
        code = 'x = isNil "_var";'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 1)

    def test_isNil_error(self):
        code = 'x = isNil "(_var";'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 1)
        self.assertTrue('Parenthesis "(" not closed' in analyzer.exceptions[0].message)

    def test_isNil_function(self):
        code = 'x = isNil format []\n'
        analyzer = analyze(parse(code))
        self.assertEqual(analyzer.exceptions, [])

    def test_configClass(self):
        code = 'private _defaultCrew = getText (configFile >> "cfgVehicles" >> "All" >> "crew");' \
               '"isClass _x && {getNumber (_x >> \'scope\') == 2} && {getText (_x >> \'crew\') != _defaultCrew}" configClasses (configFile >> "cfgVehicles")'
        analyzer = analyze(parse(code))
        self.assertEqual(len(analyzer.exceptions), 0)
