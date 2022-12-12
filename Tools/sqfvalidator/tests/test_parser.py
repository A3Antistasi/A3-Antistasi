from unittest import TestCase

from sqf.base_type import get_coord
from sqf.parser_exp import parse_exp
from sqf.exceptions import SQFParenthesisError, SQFParserError
from sqf.types import String, Statement, Code, Array, Boolean, Variable as V, \
    Number as N, BaseTypeContainer, Keyword, Preprocessor, Nothing
from sqf.interpreter_types import DefineStatement, IfDefStatement, DefineResult, IfDefResult
from sqf.parser_types import Comment, Space, Tab, EndOfLine, BrokenEndOfLine, ParserKeyword
from sqf.parser import parse, parse_strings_and_comments, identify_token
from sqf.base_tokenizer import tokenize


def build_indexes(string):
    indexes = {}
    for i in range(len(string)):
        coord = get_coord(string[:i])
        indexes[coord] = i

    return indexes


class Element:
    def __init__(self, string, coordinates):
        self.string = string
        self.coordinates = coordinates

    def __repr__(self):
        return '<%s|%d,%d>' % tuple((self.string,) + self.coordinates)


def _get_elements(statement1):
    positions = []

    for token in statement1.tokens:
        if isinstance(token, BaseTypeContainer):
            positions.append(_get_elements(token))
        else:
            positions.append([Element(str(token), token.position)])

    # flatten
    return [item for sublist in positions for item in sublist]


class TestExpParser(TestCase):

    def test_binary_simple(self):
        # a+b
        test = ['a', '+', 'b']
        self.assertEqual(['a', '+', 'b'], parse_exp(test))

        # a=b+c*d
        test = ['a', '=', 'b', '+', 'c', '*', 'd']
        self.assertEqual(['a', '=', ['b', '+', ['c', '*', 'd']]], parse_exp(test))

        # a+b=c
        test = ['a', '*', 'b', '+', 'c']
        self.assertEqual([['a', '*', 'b'], '+', 'c'], parse_exp(test))

    def test_unary(self):
        # a=!b||c
        test = ['a', '=', '!', 'b', '||', 'c']
        self.assertEqual(['a', '=', [['!', 'b'], '||', 'c']], parse_exp(test))

    def test_with_statement(self):
        test = [V('a'), Keyword('+'), V('b'), Keyword('='), V('c')]
        expected = Statement([Statement([V('a'), Keyword('+'), V('b')]), Keyword('='), V('c')])
        self.assertEqual(expected, parse_exp(test, container=Statement))

    def test_same_priority(self):
        # floor -x
        test = ['floor', '-', 'x']
        result = parse_exp(test)
        self.assertEqual(['floor', ['-', 'x']], result)

        # - floor x
        test = ['-', 'floor', 'x']
        result = parse_exp(test)
        self.assertEqual(['-', ['floor', 'x']], result)

        # x - floor x
        test = ['x', '-', 'floor', 'x']
        result = parse_exp(test)
        self.assertEqual(['x', '-', ['floor', 'x']], result)

        # 1 - 1 - 1 = -1
        test = ['1', '-', '1', '-', '1']
        self.assertEqual([['1', '-', '1'], '-', '1'], parse_exp(test))

    def test_power_precedence(self):
        test = ['a', '*', 'b', '^', 'c']
        self.assertEqual(['a', '*', ['b', '^', 'c']], parse_exp(test))

    def test_hash_precedence(self):
        test = ['a', '#', 'b', '^', 'c']
        self.assertEqual(['a', '#', ['b', '^', 'c']], parse_exp(test))


class ParserTestCase(TestCase):
    
    def assertEqualStatement(self, expected, result, code):
        self.assertEqual(expected, result)
        self.assertEqual(code, str(result))
        self.assertCorrectPositions(result, code)

    def assertCorrectPositions(self, result, code):
        indexes = build_indexes(code)
        for element in _get_elements(result):
            index = indexes[element.coordinates]
            lenght = len(element.string)
            self.assertEqual(code[index:index+lenght], element.string)


class ParseCode(ParserTestCase):

    def test_with_spaces(self):
        code = '1 + 1'
        result = parse(code)
        expected = Statement([Statement([Statement([N(1), Space()]), Keyword('+'), Statement([Space(), N(1)])])])
        self.assertEqualStatement(expected, result, code)

    def test_parse_string(self):
        code = 'if (_n == 1) then {"Air support called to pull away" SPAWN HINTSAOK;} else ' \
               '{"You have no called air support operating currently" SPAWN HINTSAOK;};'
        result = [identify_token(x) for x in parse_strings_and_comments(tokenize(code))]
        self.assertTrue(isinstance(result[13], String))
        self.assertTrue(isinstance(result[24], String))

        self.assertEqual(str(parse('_n = "This is bla";')), '_n = "This is bla";')

    def test_parse_double_quote(self):
        code = '_string = "my string ""with"" quotes"'
        result = [identify_token(x) for x in parse_strings_and_comments(tokenize(code))]
        self.assertTrue(isinstance(result[4], String))
        self.assertEqual('my string ""with"" quotes', result[4].value)

    def test_parse_empty_string(self):
        code = '_string = ""'
        result = [identify_token(x) for x in parse_strings_and_comments(tokenize(code))]
        self.assertTrue(isinstance(result[4], String))
        self.assertEqual('', result[4].value)

    def test_end_comment_with_windows_eol(self):
        code = '// \r\n_x;\r\n'
        result = parse_strings_and_comments(tokenize(code))
        self.assertEqual([Comment('// \r\n'),'_x',';','\r\n'], result)

    def test_parse_windows_eol(self):
        code = '_x\r\n'
        result = parse(code)
        expected = Statement([Statement([V('_x'), EndOfLine('\r\n')])])
        self.assertEqualStatement(expected, result, code)

    def test_parse_bool(self):
        code = '_x=true;'
        result = parse(code)
        expected = Statement([Statement([V('_x'), Keyword('='), Boolean(True)], ending=';')])

        self.assertEqualStatement(expected, result, code)

    def test_parse_tab(self):
        code = '\t_x;'
        result = parse(code)
        expected = Statement([Statement([Tab(), V('_x')], ending=';')])

        self.assertEqualStatement(expected, result, code)

    def test_one(self):
        code = '_x=2;'
        result = parse(code)
        expected = Statement([Statement([V('_x'), Keyword('='), N(2)], ending=';')])

        self.assertEqualStatement(expected, result, code)

    def test_eol(self):
        code = '1\n2'
        self.assertCorrectPositions(parse(code), code)

    def test_windows_eol(self):
        code = '1\r\n2'
        result = parse(code)
        self.assertCorrectPositions(parse(code), code)
        self.assertEqual(result[0][1].position, (2, 1))

    def test_with_code_in_code(self):
        code = "x = {\ncall {private _x;}\n}"
        self.assertCorrectPositions(parse(code), code)

    def test_namespace_position(self):
        code = 'with uiNamespace do {private _mapCtrl = 1;x = {_mapCtrl = y}}'
        self.assertCorrectPositions(parse(code), code)

    def test_one_bracketed(self):
        code = '{_x="AirS";}'
        result = parse(code)
        expected = Statement([Statement([Code([Statement([V('_x'), Keyword('='), String('"AirS"')], ending=';')])])])

        self.assertEqualStatement(expected, result, code)

    def test_not_delayed(self):
        code = '(_x="AirS";)'
        result = parse(code)
        expected = Statement([Statement([
            Statement([V('_x'), Keyword('='), String('"AirS"')], ending=';')], parenthesis=True)])
        
        self.assertEqualStatement(expected, result, code)

        code = '(_x="AirS";);'
        result = parse(code)
        expected = Statement([Statement([Statement([V('_x'), Keyword('='), String('"AirS"')], ending=';')],
                                        parenthesis=True, ending=';')
                              ])
        self.assertEqualStatement(expected, result, code)

    def test_assign(self):
        code = '_x=(_x=="AirS");'
        result = parse(code)
        expected = Statement([Statement([V('_x'), Keyword('='),
                              Statement([Statement([V('_x'), Keyword('=='), String('"AirS"')])], parenthesis=True)], ending=';')])
        self.assertEqualStatement(expected, result, code)

    def test_assign_array(self):
        code = '_y = [];'
        result = parse(code)
        expected = Statement([Statement([
            Statement([V('_y'), Space()]),
            Keyword('='),
            Statement([Space(), Array([])])], ending=';')])
        self.assertEqualStatement(expected, result, code)

    def test_two_statements(self):
        code = '_x=true;_x=false'
        result = parse(code)
        expected = Statement([Statement([V('_x'), Keyword('='), Boolean(True)], ending=';'),
                              Statement([V('_x'), Keyword('='), Boolean(False)])])

        self.assertEqualStatement(expected, result, code)

    def test_parse_bracketed_4(self):
        code = '_x=true;{_x=false}'
        result = parse(code)
        expected = Statement([
            Statement([V('_x'), Keyword('='), Boolean(True)], ending=';'),
            Statement([Code([Statement([V('_x'), Keyword('='), Boolean(False)])])])
        ])

        self.assertEqualStatement(expected, result, code)

    def test_two(self):
        code = '_x=2;_y=3;'
        result = parse(code)
        expected = Statement([Statement([V('_x'), Keyword('='), N(2)], ending=';'),
                         Statement([V('_y'), Keyword('='), N(3)], ending=';')])

        self.assertEqualStatement(expected, result, code)

    def test_two_bracketed(self):
        code = '{_x=2;_y=3;};'
        result = parse(code)
        expected = Statement([Statement([Code([
            Statement([V('_x'), Keyword('='), N(2)], ending=';'),
            Statement([V('_y'), Keyword('='), N(3)], ending=';')])], ending=';')])

        self.assertEqualStatement(expected, result, code)

    def test_assign_with_parenthesis(self):
        code = "_x=(_y==2);"
        result = parse(code)

        s1 = Statement([V('_y'), Keyword('=='), N(2)])
        expected = Statement([Statement([V('_x'), Keyword('='), Statement([s1], parenthesis=True)], ending=';')])

        self.assertEqualStatement(expected, result, code)

    def test_no_open_parenthesis(self):
        with self.assertRaises(SQFParenthesisError):
            parse('_a = x + 2)')
        with self.assertRaises(SQFParenthesisError):
            parse('_a = x + 2}')
        with self.assertRaises(SQFParenthesisError):
            parse('_a = x + 2]')

    def test_wrong_parenthesis(self):
        with self.assertRaises(Exception):
            parse('{(_a = 2;});')
        with self.assertRaises(Exception):
            parse('({_a = 2);};')

    def test_no_close_parenthesis(self):
        with self.assertRaises(SQFParenthesisError):
            parse('_a = (x + 2')

    def test_analyze_expression(self):
        code = '_h = _civs spawn _fPscareC;'
        result = parse(code)
        expected = Statement([Statement([
            Statement([V('_h'), Space()]),
            Keyword('='),
            Statement([
                Statement([Space(), V('_civs'), Space()]),
                Keyword('spawn'),
                Statement([Space(), V('_fPscareC')])
            ])], ending=';')])

        self.assertEqualStatement(expected, result, code)

    def test_analyze_expression2(self):
        code = 'isNil{_x getVariable "AirS"}'
        result = parse(code)
        expected = Statement([Statement([
            Keyword('isNil'),
            Code([Statement([
                Statement([V('_x'), Space()]),
                Keyword('getVariable'),
                Statement([Space(), String('"AirS"')])])])
            ])])
        self.assertEqualStatement(expected, result, code)

    def test_count_minus(self):
        code = 'count(x)-1'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    Statement([
                        Keyword('count'),
                        Statement([Statement([V('x')])], parenthesis=True)
                    ]),
                    Keyword('-'), N(1)
                ])
            ])
        self.assertEqualStatement(expected, result, code)

    def test_code(self):
        code = '_is1={_x==1};'
        result = parse(code)
        expected = Statement([Statement([V('_is1'), Keyword('='),
                                         Code([Statement([V('_x'), Keyword('=='), N(1)])])], ending=';')])
        
        self.assertEqualStatement(expected, result, code)

    def test_signed_precedence(self):
        code = "_x = -1"
        result = parse(code)
        # S<S<S<V<_x>' '>K<=>S<' 'K<->N1>>> !=
        # S<S<S<V<_x>' '>K<=>S<' 'S<K<->N1>>>>
        expected = \
            Statement([
                Statement([
                    Statement([V('_x'), Space()]),
                    Keyword('='),
                    Statement([Space(), Statement([Keyword('-'), N(1)])])
                ])
            ])
        self.assertEqualStatement(expected, result, code)

    def test_precedence_str(self):
        code = 'str true || false'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    Statement([
                        Keyword('str'),
                        Statement([Space(), Boolean(True), Space()])
                    ]),
                    Keyword('||'), Statement([Space(), Boolean(False)
                    ])
                ])
            ])
        self.assertEqualStatement(expected, result, code)

    def test_precedence_isequalto(self):
        code = 'x getVariable "x" isEqualTo ""'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    Statement([
                        Statement([
                            V('x'), Space()
                        ]),
                        Keyword('getVariable'),
                        Statement([Space(), String('"x"'), Space()])
                    ]),
                    Keyword('isEqualTo'), Statement([Space(), String('""')])
                ])
            ])
        self.assertEqualStatement(expected, result, code)

    def test_parse_keyword_constant(self):
        code = '_x = west'
        expected = Statement([Statement([Statement([
            V('_x'), Space()]),
            Keyword('='), Statement([Space(), Keyword('west'),
            ])])])
        self.assertEqualStatement(expected, parse(code), code)

    def test_private(self):
        code = 'private _x = 2'
        expected = \
            Statement([
                Statement([
                    Statement([
                        Keyword('private'), Statement([Space(), V('_x'), Space()])
                    ]),
                    Keyword('='), Statement([Space(), N(2)])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_params_simple(self):
        code = 'params ["_x"]'
        expected = \
            Statement([
                Statement([
                    Keyword('params'),
                    Statement([Space(), Array([Statement([String('"_x"')])])])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_params_call(self):
        code = '[1] params ["_x"]'
        expected = \
            Statement([
                Statement([
                    Statement([Array([Statement([N(1)])]), Space()]),
                    Keyword('params'),
                    Statement([Space(), Array([Statement([String('"_x"')])])
                    ])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_exa(self):
        code = '1,2'
        expected = \
            Statement([
                Statement([
                    N(1)], ending=','),
                Statement([N(2)])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_parse_multi_operator(self):
        code = '1+2+3'
        # S<S<N1K<+>S<N2K<+>N3>>> !=
        # S<S<S<N1K<+>N2>K<+>N3>>
        expected = \
            Statement([
                Statement([
                    Statement([
                        N(1), Keyword('+'), N(2)
                    ]), Keyword('+'), N(3)])
                ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_parse_multi_operator2(self):
        code = 'configFile>>"CfgWeapons">>x'
        expected = \
            Statement([
                Statement([
                    Statement([Keyword('configFile'), Keyword('>>'), String('"CfgWeapons"')]),
                    Keyword('>>'), V('x')
                    ]),
                ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_parse_multi_mixed(self):
        code = 'x=configFile>>"CfgWeapons">>"name"'
        expected = \
            Statement([
                Statement([
                    V('x'), Keyword('='),
                    Statement([
                        Statement([Keyword('configFile'), Keyword('>>'), String('"CfgWeapons"')]),
                        Keyword('>>'), String('"name"')
                    ]),
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)


class Precedence(ParserTestCase):
    # both => keyword that is both an unary and binary operator
    def test_binary_binary_diff(self):
        code = '_i < 10 && b'
        expected = \
            Statement([
                Statement([
                    Statement([
                        Statement([
                            V('_i'), Space()
                        ]),
                        Keyword('<'),
                        Statement([Space(), N(10), Space()])
                    ]),
                    Keyword('&&'),
                    Statement([Space(), V('b')])
                    ])
                ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_unary_nullary(self):
        code = 'alive player'
        expected = \
            Statement([
                Statement([
                    Keyword('alive'),
                    Statement([Space(), Keyword('player')])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_binary_both(self):
        # + has precedence over binaries, (this is syntactically correct but fails to run)
        code = '5+{_x}count x'
        expected = \
            Statement([
                Statement([
                    Statement([
                        N(5), Keyword('+'), Code([Statement([V('_x')])])
                    ]),
                    Keyword('count'),
                    Statement([Space(), V('x')])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

        # both binary, evaluate from left to right
        code = 'if()then{}params[]'
        expected = \
            Statement([
                Statement([
                    Statement([
                        Statement([
                            Keyword('if'), Statement([], parenthesis=True)
                        ]),
                        Keyword('then'), Code([])
                    ]),
                    Keyword('params'), Array([])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

        # same, but + has higher binding power
        code = '"A"+"B"params[]'
        expected = \
            Statement([
                Statement([
                    Statement([String('"A"'), Keyword('+'), String('"B"')]),
                    Keyword('params'),
                    Array([])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

        # same, but = has lower binding power
        code = 'a="B"params[]'
        expected = \
            Statement([
                Statement([
                    V('a'), Keyword('='),
                    Statement([
                        String('"B"'),
                        Keyword('params'),
                        Array([])
                    ])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_unary_both(self):
        code = 'call{_x}count x'
        expected = \
            Statement([
                Statement([
                    Statement([Keyword('call'), Code([Statement([V('_x')])])]),
                    Keyword('count'),
                    Statement([Space(), V('x')])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_both_binary(self):
        code = 'a ctrlSetText"A"+"B"'
        expected = \
            Statement([
                Statement([
                    Statement([V('a'), Space()]),
                    Keyword('ctrlSetText'),
                    Statement([
                        String('"A"'),
                        Keyword('+'),
                        String('"B"')
                    ]),
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_both_unary(self):
        code = 'a ctrlSetText alive"B"'
        expected = \
            Statement([
                Statement([
                    Statement([V('a'), Space()]),
                    Keyword('ctrlSetText'),
                    Statement([
                        Space(),
                        Statement([
                            Keyword('alive'),
                            String('"B"')
                        ])
                    ])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

        code = 'ctrlSetText alive"B"'
        expected = \
            Statement([
                Statement([
                    Keyword('ctrlSetText'),
                    Statement([
                        Space(),
                        Statement([
                            Keyword('alive'),
                            String('"B"')
                        ])
                    ])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

        code = 'count[1]+[1]'  # => (count[1]) + [1]
        expected = \
            Statement([
                Statement([
                    Statement([
                        Keyword('count'), Array([Statement([N(1)])])
                    ]),
                    Keyword('+'),
                    Array([Statement([N(1)])]),
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

        code = '{true}count[1]+[1]'  # => {true}count([1] + [1])
        expected = \
            Statement([
                Statement([
                    Code([Statement([Boolean(True)])]), Keyword('count'),
                    Statement([
                        Array([Statement([N(1)])]),
                        Keyword('+'),
                        Array([Statement([N(1)])]),
                    ])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_both_both(self):
        code = '"a"ctrlSetText"A"params"B"'
        expected = \
            Statement([
                Statement([
                    Statement([
                        String('"a"'),
                        Keyword('ctrlSetText'),
                        String('"A"')
                    ]),
                    Keyword('params'),
                    String('"B"')
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)


class ControlStatements(ParserTestCase):
    def test_for(self):
        code = 'for "_i" from 0 to 10 do {}'
        expected = \
            Statement([
                Statement([
                    Statement([
                        Statement([
                            Statement([
                                Keyword('for'),
                                Statement([Space(), String('"_i"'), Space()])
                            ]),
                            Keyword('from'),
                            Statement([Space(), N(0), Space()]),
                        ]),
                        Keyword('to'),
                        Statement([Space(), N(10), Space()]),
                    ]),
                    Keyword('do'),
                    Statement([Space(), Code([])])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_while(self):
        code = 'while {} do {}'
        expected = \
            Statement([
                Statement([
                    Statement([
                        Keyword('while'),
                        Statement([
                            Space(), Code([]), Space()
                        ])
                    ]),
                    Keyword('do'),
                    Statement([
                        Space(), Code([])
                    ])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_try_catch(self):
        code = 'try {} catch {}'
        expected = \
            Statement([
                Statement([
                    Statement([
                        Keyword('try'),
                        Statement([Space(), Code([]), Space()]),
                    ]),
                    Keyword('catch'),
                    Statement([Space(), Code([])]),
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_if_then_else(self):
        code = 'if(true)then{1}else{2}'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    Statement([
                        Keyword('if'),
                        Statement([
                            Statement([Boolean(True)])], parenthesis=True),
                    ]),
                    Keyword('then'),
                    Statement([
                        Code([Statement([N(1)])]),
                        Keyword('else'),
                        Code([Statement([N(2)])]),
                    ])
                ])
            ])
        self.assertEqualStatement(expected, result, code)

    def test_switch(self):
        code = 'switch (0) do {}'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    Statement([
                        Keyword('switch'),
                        Statement([Space(), Statement([Statement([N(0)])], parenthesis=True), Space()]),
                    ]),
                    Keyword('do'),
                    Statement([
                        Space(), Code([])
                    ])
                ])
            ])
        self.assertEqualStatement(expected, result, code)

    def test_closeby(self):
        code = 'if()exitWith{};'
        # S<S<S<K<if>S<()>>K<exitwith>{};>> !=
        # S<S<K<if>S<S<()>K<exitWith>{}>;>>
        expected = \
            Statement([
                Statement([
                    Statement([
                        Keyword('if'),
                        Statement([], parenthesis=True)
                    ]),
                    Keyword('exitwith'),
                    Code([]),
                ], ending=';')
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_parse_case(self):
        code = '{case 1: {true}}'
        expected = \
            Statement([
                Statement([
                    Code([
                        Statement([
                            Statement([
                                Keyword('case'),
                                Statement([Space(), N(1)]),
                            ]),
                            Keyword(':'),
                            Statement([Space(), Code([Statement([Boolean(True)])])])
                        ])
                    ])
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)


class ParseArray(ParserTestCase):

    def test_basic(self):
        test = '["AirS", nil];'
        result = parse(test)
        expected = Statement([Statement([
            Array([Statement([String('"AirS"')]), Statement([Space(), Keyword('nil')])])], ending=';')])

        self.assertEqual(expected, result)

    def test_exceptions(self):
        with self.assertRaises(SQFParserError):
            parse('["AirS"; nil];')

        with self.assertRaises(SQFParserError):
            parse('[,];')

        with self.assertRaises(SQFParserError):
            parse('["AirS",];')

        with self.assertRaises(SQFParserError):
            parse('[nil,,nil];')

    def test_empty(self):
        code = '[];'
        result = parse(code)
        expected = Statement([Statement([Array([])], ending=';')])

        self.assertEqualStatement(expected, result, code)

    def test_array_with_space(self):
        code = '["",\n_z, _y]'
        self.assertCorrectPositions(parse(code), code)

    def test_parse_3(self):
        code = '[1, 2, 3]'
        result = parse(code)
        expected = Statement([Statement([
            Array([Statement([N(1)]), Statement([Space(), N(2)]), Statement([Space(), N(3)])])
        ])])

        self.assertEqual(expected, result, code)

    def test_or_together(self):
        code = '||isNull'
        result = parse(code)
        expected = Statement([Statement([
            Keyword('||'), Keyword('isNull')
        ])])
        self.assertEqualStatement(expected, result, code)


class ParseLineComments(ParserTestCase):

    def test_inline(self):
        code = '_x = 2 // the two'
        result = parse(code)
        expected = Statement([Statement([
            Statement([V('_x'), Space()]),
            Keyword('='),
            Statement([Space(), N(2), Space(), Comment('// the two')])])
        ])

        self.assertEqualStatement(expected, result, code)

    def test_inline_no_eof(self):
        code = '_x = 2; // the two'
        result = parse(code)
        expected = Statement([Statement([
            Statement([V('_x'), Space()]),
            Keyword('='),
            Statement([Space(), N(2)])], ending=';'),
            Statement([Space(), Comment('// the two')])
        ])

        self.assertEqualStatement(expected, result, code)

    def test_inline_with_eol(self):
        code = '_x=2;// the two\n_x=3;'
        result = parse(code)
        expected = Statement([
            Statement([V('_x'), Keyword('='), N(2)], ending=';'),
            Statement([Statement([Comment('// the two\n'), V('_x')]), Keyword('='), N(3)], ending=';')])

        self.assertEqualStatement(expected, result, code)

    def test_comment_with_string(self):
        code = '//"x"'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    Comment('//"x"')
                ])
            ])
        self.assertEqualStatement(expected, result, code)


class ParseBlockComments(ParserTestCase):

    def test_inline(self):
        code = '_x=2/* the two */'
        result = parse(code)
        expected = Statement([Statement([
            V('_x'),
            Keyword('='),
            Statement([N(2), Comment('/* the two */')])])])

        self.assertEqualStatement(expected, result, code)

    def test_inline_with_string(self):
        code = '_x=2/* pieces\' do */'
        result = parse(code)
        expected = Statement([Statement([
            V('_x'),
            Keyword('='),
            Statement([N(2), Comment('/* pieces\' do */')])])])

        self.assertEqualStatement(expected, result, code)

    def test_with_lines(self):
        code = '_x=2;/* the two \n the three\n the four\n */\n_x=3'
        result = parse(code)
        expected = Statement([Statement([
            V('_x'),
            Keyword('='),
            N(2)], ending=';'),
            Statement([Statement([Comment('/* the two \n the three\n the four\n */'),
                                  EndOfLine('\n'), V('_x')]), Keyword('='), N(3)])
        ])

        self.assertEqualStatement(expected, result, code)

    def test_with_other_comment(self):
        code = '_x=2;/* // two four\n */\n_x=3'
        result = parse(code)
        expected = Statement([Statement([
            V('_x'),
            Keyword('='),
            N(2)], ending=';'),
            Statement(
                [Statement([Comment('/* // two four\n */'), EndOfLine('\n'), V('_x')]), Keyword('='), N(3)])
        ])

        self.assertEqualStatement(expected, result, code)

    def test_comment_with_string(self):
        code = '/*"x"*/'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    Comment('/*"x"*/')
                ])
            ])
        self.assertEqualStatement(expected, result, code)


class ParseStrings(ParserTestCase):

    def test_single_double(self):
        code = '_x=\'"1"\''
        result = parse(code)
        self.assertEqual(str(result[0][2]), "'\"1\"'")

    def test_double_single(self):
        code = '_x="\'1\'"'
        result = parse(code)
        self.assertEqual(str(result[0][2]), "\"'1'\"")

    def test_double_escape(self):
        code = '_x="""1"""'
        result = parse(code)
        self.assertEqual(str(result[0][2]), '"""1"""')

    def test_single_escape(self):
        code = "_x='''1'''"
        result = parse(code)
        self.assertEqual(str(result[0][2]), "'''1'''")

    def test_error(self):
        code = "_x='1111"
        with self.assertRaises(Exception) as cm:
            parse(code)
        self.assertEqual((1, 4), cm.exception.position)

    def test_string_with_comment(self):
        code = '"//a"'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    String('"//a"')
                ])
            ])
        self.assertEqualStatement(expected, result, code)


class ParsePreprocessor(ParserTestCase):

    def test_include(self):
        code = '#include "macros.hpp"\n_x = 1'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    Statement([
                        Preprocessor('#include'),
                        Statement([Space(), String('"macros.hpp"')]),
                    ])
                ]),
                Statement([
                    Statement([EndOfLine('\n'), V("_x"), Space()]), Keyword('='), Statement([Space(), N(1)])
                ])
            ])

        self.assertEqualStatement(expected, result, code)

    def test_call(self):
        code = 'x call FUN(a)'
        expected = \
            Statement([
                Statement([
                    Statement([V('x'), Space()]),
                    Keyword('call'),
                    Statement([
                        Space(),
                        Statement([V('FUN'), Statement([Statement([V('a')])], parenthesis=True)])
                    ]),
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_def(self):
        code = 'A = 1'
        expected = \
            Statement([
                Statement([
                    Statement([V('A'), Space()]),
                    Keyword('='),
                    Statement([Space(), N(1)]),
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_assign(self):
        code = 'VAR(a) = 0'
        expected = \
            Statement([
                Statement([
                    Statement([
                        V('VAR'),
                        Statement([
                            Statement([
                                Statement([V('a')])], parenthesis=True), Space()
                        ])
                    ]),
                    Keyword('='),
                    Statement([Space(), N(0)]),
                ])
            ])
        self.assertEqualStatement(expected, parse(code), code)


class TestIfDefStatement(ParserTestCase):

    def test_basic(self):
        code = '#ifdef A\n#endif'
        result = parse(code)

        tokens = [Preprocessor('#ifdef'), Space(), V('A'), EndOfLine('\n'), Preprocessor('#endif')]

        expression = IfDefStatement(tokens)

        expected = Statement([IfDefResult(expression, [])])
        self.assertEqualStatement(expected, result, code)

    def test_not_closed(self):
        with self.assertRaises(SQFParenthesisError) as m:
            parse('\n\n#ifdef A\n2 + 1\n\n\n')
        self.assertEqual((3, 1), m.exception.position)
        self.assertEqual('error:#ifdef statement not closed', m.exception.message)

    def test_if_def_wrong(self):
        with self.assertRaises(SQFParserError) as m:
            parse('\n\n#ifdef\nx=2\n#endif\n')
        self.assertEqual((3, 1), m.exception.position)
        self.assertEqual('error:#ifdef statement must contain a variable', m.exception.message)

    def test_statement(self):
        code = '1+\n#ifdef A\n-\n#endif\n2'
        result = parse(code)

        tokens = [N(1), Keyword('+'), EndOfLine('\n'), Preprocessor('#ifdef'),
                  Space(), V('A'), EndOfLine('\n'), Keyword('-'), EndOfLine('\n'), Preprocessor('#endif'),
                  EndOfLine('\n'), N(2)]

        expression = IfDefStatement(tokens)

        result_exp = Statement([
            Statement([
                N(1), Keyword('+'),
                Statement([
                    EndOfLine('\n'), EndOfLine('\n'), N(2)
                ])
            ])
        ])

        expected = Statement([IfDefResult(expression, result_exp.tokens)])
        self.assertEqualStatement(expected, result, code)

    def test_nested(self):
        code = '#ifdef A\n#ifdef B\n1\n#endif\n#endif'
        original = code
        result = parse(code)

        statementB = IfDefStatement([
                      Preprocessor('#ifdef'), Space(), V('B'), EndOfLine('\n'), N(1),
                      EndOfLine('\n'), Preprocessor('#endif')
                  ])

        tokens = [Preprocessor('#ifdef'), Space(), V('A'), EndOfLine('\n'),
                  statementB,
                  EndOfLine('\n'), Preprocessor('#endif')
                  ]

        statementA = IfDefStatement(tokens)

        expected = Statement([IfDefResult(statementA, [])])
        self.assertEqualStatement(expected, result, code)

        # A is defined, B is not
        code = '#define A\n' + original
        result = parse(code)
        statementB1 = \
            IfDefStatement([
                EndOfLine('\n'), EndOfLine('\n'), Preprocessor('#ifdef'), Space(), V('B'), EndOfLine('\n'), N(1),
                EndOfLine('\n'), Preprocessor('#endif')
        ])
        expected_exp = [
            IfDefResult(statementB1, [Statement([EndOfLine('\n'), EndOfLine('\n')])])
        ]
        self.assertEqual(expected_exp, result[1].result)

        # both defined
        code = '#define B\n#define A\n' + original
        result = parse(code)
        expectedA = [Statement([EndOfLine('\n'), EndOfLine('\n'), EndOfLine('\n'), N(1), EndOfLine('\n')])]
        expected_exp = [IfDefResult(statementB1, expectedA)]
        self.assertEqual(expected_exp, result[3].result)

    def test_if_else(self):
        code = '#ifdef A\n#else\nB\n#endif'
        result = parse(code)

        tokens = [Preprocessor('#ifdef'), Space(), V('A'), EndOfLine('\n'),
                  Preprocessor('#else'), EndOfLine('\n'), V('B'), EndOfLine('\n'), Preprocessor('#endif')]

        expression = IfDefStatement(tokens)

        expected_exp = [Statement([EndOfLine('\n'), V('B'), EndOfLine('\n')])]

        expected = Statement([IfDefResult(expression, expected_exp)])
        self.assertEqualStatement(expected, result, code)

    def test_if_with_define(self):
        code = '#ifdef A3W_DEBUG\n#define DEBUG true\n#else\n#define DEBUG false\n#endif\n[1,2];s;'
        result = parse(code)
        self.assertEqual([
            Statement([EndOfLine('\n')]),
            Statement([DefineStatement(
                [Preprocessor('#define'), Space(), V('DEBUG'), Space(), Boolean(False)], 'DEBUG',
                expression=[Boolean(False)]
                )]),
            Statement([EndOfLine('\n'), EndOfLine('\n'), Array([Statement([N(1)]), Statement([N(2)])])], ending=';')
        ], result[0].result)

    def test_if_with_include(self):
        code = '#ifdef A\n#include "A"\n#endif\nx="1";'
        result = parse(code)
        self.assertEqual(result[0].result, [
            Statement([
                Statement([EndOfLine('\n'), V('x')]), Keyword('='), String('"1"')], ending=';')
        ])

    def test_sequential_if(self):
        code = '#ifdef A\n#include "A"\n#endif\n' \
               '#ifdef B\n#include "B"\n#endif\n' \
               'x = "1";'
        result = parse(code)

        tokensB = [
            Preprocessor('#ifdef'), Space(), V('B'), EndOfLine('\n'),
            Preprocessor('#include'), Space(), String('"B"'), EndOfLine('\n'),
            Preprocessor('#endif'),
            EndOfLine('\n'), V('x'), Space(), Keyword('='), Space(), String('"1"'), ParserKeyword(';')
        ]
        statementB = IfDefStatement(tokensB)

        tokensA = [
            Preprocessor('#ifdef'), Space(), V('A'), EndOfLine('\n'),
            Preprocessor('#include'), Space(), String('"A"'), EndOfLine('\n'),
            Preprocessor('#endif'), EndOfLine('\n'),
            statementB,
        ]
        statementA = IfDefStatement(tokensA)

        self.assertEqual(code, str(result))
        self.assertEqual(tokensA, result[0].tokens)

        expectedB = [Statement([
            Statement([EndOfLine('\n'), V('x'), Space()]),
            Keyword('='),
            Statement([Space(), String('"1"')])
        ], ending=';')]

        expectedA = Statement([IfDefResult(statementA, [IfDefResult(statementB, expectedB)])])
        self.assertEqualStatement(expectedA, result, code)

    def test_with_define_and_next(self):
        code = '#ifdef A\n' \
               '#define DEBUG true\n' \
               '#else\n' \
               '#define DEBUG false\n' \
               '#endif\n' \
               'enableSaving [false, false];'
        self.assertEqual(code, str(parse(code)))

    def test_with_statement(self):
        code = '#ifdef call FUNC(x);\n#endif'
        self.assertEqual(code, str(parse(code)))

    def test_with_code(self):
        code = '{\n#ifndef A\nx=2\n#endif\n}'
        self.assertEqual(code, str(parse(code)))

    def test_with_previous_statement(self):
        code = '{x=1;\n#ifdef A\nx=2;\n#endif\n} forEach _pathData; bla1'
        self.assertEqual(code, str(parse(code)))

    def test_spacing(self):
        code = '{\nx=1;\n\n    #ifdef A\nx=1;\n#endif\n} forEach z;\nz\n'
        self.assertEqual(code, str(parse(code)))

    def test_code_with_statement_after(self):
        code = '{\n#ifdef A\nx=2;\n#endif\nx=1;\n}'
        self.assertEqual(code, str(parse(code)))

    def test_with_empty_array(self):
        code = '#ifdef A\n{{};\n};\n#endif\n[];'
        self.assertEqual(code, str(parse(code)))

    def test_code_in(self):
        code = '#ifdef A\n{ []; {}; };\n#endif\n{};'
        self.assertEqual(code, str(parse(code)))

    def test_ifdef_with_code(self):
        # formally, this is correct, but we currently do not parse it.
        # Regardless, the error is a SQF error which is better than crash.
        code = 'if x then {\n#ifdef A\n} else {\n#endif\n};'
        with self.assertRaises(SQFParenthesisError):
            parse(code)

    def test_ifdef_array_multiple(self):
        code = '#ifndef A\n[];\n#endif\n[true, true, true];'
        self.assertEqual(code, str(parse(code)))


class TestDefineStatement(ParserTestCase):

    def test_define_unknown(self):
        code = '#define a\n'
        expected = \
            Statement([
                Statement([
                    DefineStatement([
                        Preprocessor('#define'),
                        Space(), V('a')
                    ], 'a'),
                ]),
                Statement([EndOfLine('\n')])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_define_with_value(self):
        code = '#define a 1\n'
        expected = \
            Statement([
                Statement([
                    DefineStatement([
                        Preprocessor('#define'),
                        Space(), V('a'), Space(), N(1)
                    ], 'a', [N(1)]),
                ]),
                Statement([EndOfLine('\n')])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_define_with_parenthesis(self):
        code = '#define a ();\n'

        expression = [Statement([], parenthesis=True), ParserKeyword(';')]
        expected = \
            Statement([
                Statement([
                    DefineStatement([
                        Preprocessor('#define'),
                        Space(), V('a'), Space(),
                    ] + expression, 'a', expression)]),
                Statement([EndOfLine('\n')])
                ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_define_with_line_break(self):
        code = "#define CHECK \\\n1"
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    DefineStatement([
                        Preprocessor('#define'),
                        Space(), V('CHECK'), Space(), BrokenEndOfLine(),
                        N(1)
                    ], 'CHECK', expression=[N(1)])
                ])
            ])
        self.assertEqualStatement(expected, result, code)

    def test_define_with_argument_and_line_break(self):
        code = "#define a(_x) \\\n(_x==2)"
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    DefineStatement([
                        Preprocessor('#define'),
                        Space(), V('a'),
                        Statement([
                            Statement([V('_x')])
                        ], parenthesis=True),
                        Space(), BrokenEndOfLine(),
                        Statement([
                            Statement([V('_x'), Keyword('=='), N(2)])
                        ], parenthesis=True)
                    ], variable_name='a',
                        expression=[Statement([Statement([V('_x'), Keyword('=='), N(2)])], parenthesis=True)],
                        args=['_x'])
                ])
            ])
        self.assertEqualStatement(expected, result, code)

    def test_define_with_comment(self):
        code = "a\n// 1.\n#define a\n"
        result = parse(code)
        self.assertEqual(str(result), code)

    def test_define_with_keyword(self):
        # "IN" is a Keyword which would break the statement
        code = '#define IN 2\n'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    DefineStatement([
                        Preprocessor('#define'), Space(), Keyword('IN'), Space(), N(2)], 'IN',
                        [N(2)]
                    )
                ]),
                Statement([EndOfLine('\n')])
            ])
        self.assertEqualStatement(expected, result, code)

    def test_define2(self):
        code = '#define a (if (true) then { \\\n\t} \\\n);\n'

        expression = Statement([
                            Statement([
                                Statement([
                                    Keyword('if'),
                                    Statement([
                                        Space(),
                                        Statement([
                                            Statement([
                                                Boolean(True)
                                            ])
                                        ], parenthesis=True),
                                        Space()
                                    ]),
                                ]),
                                Keyword('then'),
                                Statement([
                                    Space(),
                                    Code([
                                        Statement([
                                            Space(), BrokenEndOfLine(), Tab()
                                        ]),
                                    ]),
                                    Space(), BrokenEndOfLine()
                                ]),
                            ]),
                        ], parenthesis=True)
        expression = [expression, ParserKeyword(';')]

        expected = \
            Statement([
                Statement([
                    DefineStatement([
                        Preprocessor('#define'),
                        Space(), V('a'), Space()] + expression,
                                    'a', expression),
                ]),
                Statement([EndOfLine('\n')])
            ])
        self.assertEqualStatement(expected, parse(code), code)

    def test_define_with_comment_after(self):
        code = '#define A 2 // foo\nx = a'
        result = parse(code)
        expected = \
            Statement([
                Statement([
                    DefineStatement([
                        Preprocessor('#define'), Space(), V('A'), Space(), N(2), Space()], 'A',
                        expression=[N(2), Space()]),
                ]),
                Statement([
                    Statement([Comment('// foo\n'), V('x'), Space()]),
                    Keyword('='),
                    Statement([Space(), V('a')])
                ])
            ])
        self.assertEqualStatement(expected, result, code)


class TestDefineResult(ParserTestCase):

    def test_undefined(self):
        define = DefineStatement([
            Preprocessor('#define'), Space(), V('A')], 'A')

        # the code with the define
        code = str(Statement([define])) + '\nx=A'

        result = parse(code)

        # the expected statement after replacing the define
        expected_statement = Statement([Statement([EndOfLine('\n'), V('x')]), Keyword('='), Nothing()])

        expected = \
            Statement([
                Statement([define]),
                DefineResult([EndOfLine('\n'), V('x'), Keyword('='), V('A')], define, expected_statement)])
        self.assertEqualStatement(expected, result, code)

    def test_constant_literal(self):
        define = DefineStatement([
                        Preprocessor('#define'), Space(), V('A'), Space(), N(2)], 'A',
                        expression=[N(2)])

        # the code with the define
        code = str(Statement([define])) + '\nx = A'

        result = parse(code)

        # the expected statement after replacing the define
        expected_statement = Statement([
            Statement([EndOfLine('\n'), V('x'), Space()]),
            Keyword('='),
            Statement([Space(), N(2)])
        ])

        expected = Statement([
            Statement([define]),
            DefineResult([EndOfLine('\n'), V('x'), Space(), Keyword('='), Space(), V('A')], define, expected_statement)])
        self.assertEqualStatement(expected, result, code)

    def test_constant_op(self):
        define = DefineStatement([
                        Preprocessor('#define'), Space(), V('P'), Space(), Keyword('+')], 'P',
                        expression=[Keyword('+')])

        # the code with the define
        code = str(Statement([define])) + '\n1 P 1'

        result = parse(code)

        # the expected statement after replacing the define
        expected_statement = Statement([
            Statement([EndOfLine('\n'), N(1), Space()]),
            Keyword('+'),
            Statement([Space(), N(1)])
        ])
        expected = Statement([Statement([define]),
                              DefineResult([EndOfLine('\n'), N(1), Space(), V('P'), Space(), N(1)], define, expected_statement)])

        self.assertEqualStatement(expected, result, code)

    def test_constant_fnc(self):
        # define with parenthesis
        define_code = '#define A (x+2)'

        define = parse(define_code)[0][0]
        assert (isinstance(define, DefineStatement))

        # the code with the define
        code = define_code + '\nx*A'

        result = parse(code)

        # the expected statement after replacing the define
        expected_statement = Statement([
            Statement([EndOfLine('\n'), V('x')]),
            Keyword('*'),
            Statement([
                Statement([
                    V('x'),
                    Keyword('+'),
                    N(2)])], parenthesis=True)
        ])

        expected = Statement([Statement([define]),
                              DefineResult([EndOfLine('\n'), V('x'), Keyword('*'), V('A')], define, expected_statement)])
        self.assertEqualStatement(expected, result, code)

    def test_parenthesis_after(self):
        code = '#define A 1\n{X = A}'
        parse(code)
        # no error

    def test_define_empty_error(self):
        code = '#define\n'
        with self.assertRaises(SQFParserError):
            parse(code)

    def test_define_array_bit(self):
        define = parse('#define A 1,2')[0][0]
        assert (isinstance(define, DefineStatement))

        # the code with the define
        code = str(Statement([define])) + '\nx=[A]'
        result = parse(code)

        # the expected statement after replacing the define
        expected_statement = Array([Statement([N(1)]), Statement([N(2)])
        ])
        expected = \
            Statement([
                Statement([define]),
                Statement([
                    Statement([EndOfLine('\n'), V('x')]),
                    Keyword('='),
                    DefineResult([Array([Statement([V('A')])])], define, expected_statement)
                ])
            ])

        self.assertEqualStatement(expected, result, code)

    def test_define_fnc_1(self):
        define = parse('#define A(x) x==2')[0][0]
        assert(isinstance(define, DefineStatement))

        # the code with the define
        code = str(Statement([define])) + '\nx=A(3)'

        result = parse(code)

        # the expected statement after replacing the define
        expected_statement = Statement([
            Statement([EndOfLine('\n'), V('x')]),
            Keyword('='),
            Statement([N(3), Keyword('=='), N(2)])
        ])
        expected = \
            Statement([
                Statement([define]),
                DefineResult([EndOfLine('\n'), V('x'), Keyword('='), V('A'), ParserKeyword('('), N(3), ParserKeyword(')')],
                    define, expected_statement)
            ])

        self.assertEqualStatement(expected, result, code)

    def test_define_fnc_2(self):
        define = parse('#define A(x,y) x==y')[0][0]
        assert(isinstance(define, DefineStatement))

        # the code with the define
        code = str(Statement([define])) + '\nx=A(3,2)'

        result = parse(code)

        # the expected statement after replacing the define
        expected_statement = Statement([
            Statement([EndOfLine('\n'), V('x')]),
            Keyword('='),
            Statement([N(3), Keyword('=='), N(2)])
        ])
        expected = \
            Statement([
                Statement([define]),
                DefineResult([EndOfLine('\n'), V('x'), Keyword('='), V('A'), ParserKeyword('('), N(3), ParserKeyword(','), N(2), ParserKeyword(')')],
                    define, expected_statement)
            ])

        self.assertEqualStatement(expected, result, code)

    def test_define_in_define(self):
        define = parse('#define A (call y)')[0][0]
        define1 = parse(str(Statement([define])) + '\n#define B (A==2)')[2][0]
        assert(isinstance(define, DefineStatement))
        assert (isinstance(define1, DefineStatement))

        # the code with the defines
        code = str(Statement([define])) + '\n' + str(Statement([define1])) + '\nz||B'
        result = parse(code)

        self.assertEqual(code, str(result))

        # the expected statement on the second define after replacing the first define
        expected_statement = \
            Statement([
                Statement([
                    Statement([
                        Keyword('call'),
                        Statement([Space(), V('y')])])
                ], parenthesis=True),
                Keyword('=='), N(2)
            ])

        # the expected statement on the expression after replacing by the second define
        expected_statement1 = \
            Statement([
                Statement([EndOfLine('\n'), V('z')]), Keyword('||'),
                Statement([
                    DefineResult([V('A'), Keyword('=='), N(2)],
                                 define, expected_statement)], parenthesis=True)
            ])

        self.assertEqual(result[2][0], define1)

        expected = \
            Statement([
                Statement([define]),
                Statement([EndOfLine('\n')]),
                Statement([define1]),
                DefineResult([EndOfLine('\n'), V('z'), Keyword('||'), V('B')],
                             define1, expected_statement1),
            ])

        self.assertEqualStatement(expected, result, code)

    def test_define_fnc_with_statement(self):
        define = parse('#define A(_x) (_x==2)')[0][0]

        # the code with the define
        code = str(Statement([define])) + '\nx=A(3)'

        result = parse(code)

        # the expected statement after replacing the define
        expected_statement = Statement([
            Statement([EndOfLine('\n'), V('x')]),
            Keyword('='),
            Statement([
                Statement([N(3), Keyword('=='), N(2)])
            ], parenthesis=True)
        ])

        expected = \
            Statement([
                Statement([define]),
                DefineResult([EndOfLine('\n'), V('x'), Keyword('='), V('A'), ParserKeyword('('), N(3), ParserKeyword(')')],
                             define, expected_statement)
            ])

        self.assertEqualStatement(expected, result, code)
