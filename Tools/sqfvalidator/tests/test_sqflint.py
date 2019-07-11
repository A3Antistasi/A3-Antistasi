import sys
import os
import io
from contextlib import contextmanager
from unittest import TestCase

from sqflint import parse_args, entry_point


@contextmanager
def captured_output():
    new_out, new_err = io.StringIO(), io.StringIO()
    old_out, old_err = sys.stdout, sys.stderr
    try:
        sys.stdout, sys.stderr = new_out, new_err
        yield sys.stdout, sys.stderr
    finally:
        sys.stdout, sys.stderr = old_out, old_err


class ParseCode(TestCase):

    def test_stdin(self):
        with captured_output() as (out, err):
            sys.stdin = io.StringIO()
            sys.stdin.write('hint _x')
            sys.stdin.seek(0)
            entry_point([])

        self.assertEqual(
            out.getvalue(),
            '[1,5]:warning:Local variable "_x" is not from this scope (not private)\n')

    def test_parser_error(self):
        with captured_output() as (out, err):
            sys.stdin = io.StringIO()
            sys.stdin.write('hint (_x')
            sys.stdin.seek(0)
            entry_point([])

        self.assertEqual(
            out.getvalue(),
            '[1,5]:error:Parenthesis "(" not closed\n')

    def test_directory(self):
        args = parse_args(['--directory', 'tests/test_dir'])
        self.assertEqual('tests/test_dir', args.directory)

    def test_directory_invalid(self):
        with self.assertRaises(Exception) as context:
            parse_args(['--directory', 'i_dont_exist'])
        self.assertTrue('is not a valid path' in str(context.exception))

    def test_exclude(self):
        args = parse_args(['--exclude', 'tests/test_dir', '--exit', 'w', '--exclude', 'tests/test_dir/test.sqf'])
        self.assertEqual(['tests/test_dir', 'tests/test_dir/test.sqf'], args.exclude)

    def test_exit_code(self):
        with captured_output():
            exit_code = entry_point(['tests/test_dir/test.sqf'])
        self.assertEqual(exit_code, 0)

        # there are no errors, only a warning
        with captured_output():
            exit_code = entry_point(['tests/test_dir/test.sqf', '-e', 'e'])
        self.assertEqual(exit_code, 0)

        with captured_output():
            exit_code = entry_point(['tests/test_dir/test.sqf', '-e', 'w'])
        self.assertEqual(exit_code, 1)

    def test_filename_run(self):
        with captured_output() as (out, err):
            entry_point(['tests/test_dir/test.sqf'])

        self.assertEqual(out.getvalue(),
                         '[1,5]:warning:Local variable "_0" is not from this scope (not private)\n')

    def test_directory_run(self):
        with captured_output() as (out, err):
            entry_point(['--directory', 'tests/test_dir'])

        self.assertEqual(
            out.getvalue(),
            'test.sqf\n\t[1,5]:warning:Local variable "_0" is not from this scope (not private)\n'
            'test1.sqf\n\t[1,5]:warning:Local variable "_1" is not from this scope (not private)\n'
            'subdir/test2.sqf\n\t[1,5]:warning:Local variable "_2" is not from this scope (not private)\n'
            'subdir/test3.sqf\n\t[1,5]:warning:Local variable "_3" is not from this scope (not private)\n')

    def test_directory_run_with_exclusion(self):
        with captured_output() as (out, err):
            entry_point(['--directory', 'tests/test_dir', '--exclude', 'subdir', '-x', 'test.\.sqf'])

        self.assertEqual(
            out.getvalue(),
            'test.sqf\n\t[1,5]:warning:Local variable "_0" is not from this scope (not private)\n'
            'tests/test_dir/test1.sqf EXCLUDED\n'
            'tests/test_dir/subdir EXCLUDED\n')

    def test_directory_run_to_file(self):
        entry_point(['--directory', 'tests/test_dir', '-o', 'tests/result.txt'])

        with open('tests/result.txt') as f:
            result = f.read()

        try:
            os.remove('tests/result.txt')
        except OSError:
            pass

        self.assertEqual(
            result,
            'test.sqf\n\t[1,5]:warning:Local variable "_0" is not from this scope (not private)\n'
            'test1.sqf\n\t[1,5]:warning:Local variable "_1" is not from this scope (not private)\n'
            'subdir/test2.sqf\n\t[1,5]:warning:Local variable "_2" is not from this scope (not private)\n'
            'subdir/test3.sqf\n\t[1,5]:warning:Local variable "_3" is not from this scope (not private)\n')
