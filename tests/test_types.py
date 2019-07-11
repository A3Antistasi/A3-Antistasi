from unittest import TestCase

from sqf.types import Statement, Array, Boolean, Code, Nothing, \
    Variable as V, Number as N, Keyword
from sqf.parser_types import Space, Comment, EndOfLine


class TestTypesToString(TestCase):

    def test_bool(self):
        self.assertEqual('true', str(Boolean(True)))
        self.assertEqual('false', str(Boolean(False)))

    def test_number(self):
        self.assertEqual('1', str(N(1)))
        self.assertEqual('1.10', str(N(1.1)))

    def test_array(self):
        self.assertEqual('[1,1]', str(Array([N(1), N(1)])))

    def test_reservedtoken(self):
        self.assertEqual('for', str(Keyword('for')))

    def test_nothing(self):
        self.assertEqual('Nothing', str(Nothing()))

    def test_code(self):
        self.assertEqual('{_x=2;}', str(Code([Statement([V('_x'), Keyword('='), N(2)], ending=';')])))


class CaseInsensitiveTests(TestCase):

    def test_keyword(self):
        self.assertEqual(Keyword('forEach'), Keyword('foreach'))


class TestGetPosition(TestCase):

    def test_keyword(self):
        s = Statement([Space(), Keyword('for')])
        s.set_position((1, 1))
        self.assertEqual((1, 2), s[1].position)

    def test_with_comments(self):
        # _x=2;/* the two
        #  the three
        #  the four
        #  */
        # _x=3'
        s = Statement([
                Statement([
                    V('_x'),
                    Keyword('='),
                    N(2)], ending=';'),
                Statement([
                    Statement([Comment('/* the two \n the three\n the four\n */'),
                               EndOfLine('\n'),
                               V('_x')]),
                    Keyword('='),
                    N(3)
                ])
        ])

        s.set_position((1,1))

        self.assertEqual(Keyword('='), s[1][1])
        self.assertEqual((5, 3), s[1][1].position)
