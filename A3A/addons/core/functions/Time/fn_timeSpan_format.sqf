/*
Maintainer: Caleb Serafin
    Prints the given timeSpan as human readable text (Requires UTF-8 compliance).
    This removes the need to re-design a duration formatter for every mission info, logging systems, and notifications.
    Provides numerous formatting options out the box to fit whatever is desired in one line (No multi-line code on receiving end.).
    Execution time in microseconds ≃ 15 + 10 • (No. printed fields);
    Note: Days are the largest unit used, because months and years are not fixed amounts and rely on time information to be accurate, and Weeks are not big-enough of a change from days.
    Note: Sub seconds are used instead of fractions due to float's limited precision.

Arguments:
    <Timespan> Timespan.    isNegative is index 0, days are index 1, hours are index 2, and smaller units follow in order. May be any amount of fields as long as it starts with isNegative and is in order.
    <SCALAR> Symbol Set.    0 are full names. 1 are abbreviations. 2 are condensed colons & en-dash.                                                        [DEFAULT=0]
    <SCALAR> Show Zeros.    0 will only show non-zero fields. 1 will show in-between zeros between non-zeros. 2 will show all zeros.                        [DEFAULT=0]
    <BOOLEAN> Show Positive.false will hide the positive sign. true will allow the positive sign all fields                                                 [DEFAULT=false]
    <SCALAR> Fields Amount | <SCALAR,SCALAR> Slice   Number of significant fields to display. | First & last Index to be displayed. Days #1, hours #2 ect.. [DEFAULT=1e7]
    <BOOLEAN> Pad.          All fields will be padded, Days will be padded to 2 characters.                                                                 [DEFAULT=false]
    <BOOLEAN> Localise.     false for Great British English symbols, true for localised symbols.                                                            [DEFAULT=false]

Return Value:
    <STRING> Timespan as human readable text.

Scope: Any, Clients if specific localisation is required.
Environment: Any
Public: Yes

Example:
    // Negatives.
    DEV_timeSpan = [true,0,0,21,0,0,69,420];
    [DEV_timeSpan]                      call A3A_fnc_timeSpan_format;  // "(-) 21 Minutes 69 Microseconds 420 Nanoseconds"
    [DEV_timeSpan,1]                    call A3A_fnc_timeSpan_format;  // "(-) 21m 69µs 420ns"
    [DEV_timeSpan,2,2]                  call A3A_fnc_timeSpan_format;  // "-0:0:21:0–0:69:420"

    // Zeros. Note the negative marker in DEV_timeSpan.
    DEV_timeSpan = [true];
    [DEV_timeSpan]                      call A3A_fnc_timeSpan_format;  // "(Now)"
    [DEV_timeSpan,0,0,true]             call A3A_fnc_timeSpan_format;  // "(+) (Now)"
    [DEV_timeSpan,1]                    call A3A_fnc_timeSpan_format;  // "0"
    [DEV_timeSpan,1,0,true]             call A3A_fnc_timeSpan_format;  // "(+) 0"
    [DEV_timeSpan,0,2,false]            call A3A_fnc_timeSpan_format;  // "0 Days 0 Hours 0 Minutes 0 Seconds 0 Milliseconds 0 Microseconds 0 Nanoseconds"
    [DEV_timeSpan,0,2,false,nil,true]   call A3A_fnc_timeSpan_format;  // "00 Days 00 Hours 00 Minutes 00 Seconds 000 Milliseconds 000 Microseconds 000 Nanoseconds"
    [DEV_timeSpan,1,2,false]            call A3A_fnc_timeSpan_format;  // "0d 0h 0m 0s 0ms 0µs 0ns"
    [DEV_timeSpan,2,2,false]            call A3A_fnc_timeSpan_format;  // "0:0:0:0–0:0:0"
    [DEV_timeSpan,2,2,true,nil,true]    call A3A_fnc_timeSpan_format;  // "+00:00:00:00–000:000:000"

    // Field visibility.
    DEV_timeSpan = [false,0,3,54,0,152,0];
    [DEV_timeSpan,0]                    call A3A_fnc_timeSpan_format;  // "3 Hours 54 Minutes 152 Milliseconds"
    [DEV_timeSpan,0,1]                  call A3A_fnc_timeSpan_format;  // "3 Hours 54 Minutes 0 Seconds 152 Milliseconds"
    [DEV_timeSpan,0,2]                  call A3A_fnc_timeSpan_format;  // "0 Days 3 Hours 54 Minutes 0 Seconds 152 Milliseconds 0 Microseconds 0 Nanoseconds"
    [DEV_timeSpan,0,2,true]             call A3A_fnc_timeSpan_format;  // "(+) 0 Days 3 Hours 54 Minutes 0 Seconds 152 Milliseconds 0 Microseconds 0 Nanoseconds"

    // Slicing.
    DEV_timeSpan = [false,0,3,54,0,152,0];
    [DEV_timeSpan,0,1,false,2]          call A3A_fnc_timeSpan_format;  // "3 Hours 54 Minutes"
    [DEV_timeSpan,0,2,false,[1,1e7]]    call A3A_fnc_timeSpan_format;  // "3 Hours 54 Minutes 0 Seconds 152 Milliseconds 0 Microseconds 0 Nanoseconds"
    [DEV_timeSpan,0,2,false,[0,4]]      call A3A_fnc_timeSpan_format;  // "0 Days 3 Hours 54 Minutes 0 Seconds"
    [DEV_timeSpan,0,2,false,[1,4]]      call A3A_fnc_timeSpan_format;  // "3 Hours 54 Minutes 0 Seconds"

    // Slicing to get digital time.
    DEV_timeSpan = [false,0,3,54,0,152,0];
    [DEV_timeSpan,2,2,false,[1,4]]      call A3A_fnc_timeSpan_format;  // "3:54:0"
    [DEV_timeSpan,2,2,false,[1,4],true] call A3A_fnc_timeSpan_format;  // "03:54:00"

    // Localised all places on machine
    DEV_timeSpan = [false,1,2,3,4,5,6,7];
    [nil,0,0,false,nil,false,true]          call A3A_fnc_timeSpan_format;  // "(Now)"
    [DEV_timeSpan,0,2,false,nil,false,true] call A3A_fnc_timeSpan_format;  // "1 Days 2 Hours 3 Minutes 4 Seconds 5 Milliseconds 6 Microseconds 7 Nanoseconds"
    [DEV_timeSpan,1,2,false,nil,false,true] call A3A_fnc_timeSpan_format;  // "1d 2h 3m 4s 5ms 6µs 7ns"
*/

// A3A_fnc_timeSpan_format = {

params [
    ["_timeSpan",[], [ [] ]],
    ["_symbolSet", 0, [ 0 ]],
    ["_showZeros", 0, [ 0 ]],
    ["_showPositive", false, [ false ]],
    ["_slice", 1e7, [ 0, [] ], [2]],
    ["_pad", false, [ false ]],
    ["_localise", false, [ false ]]
];

// Note the lack of front spacing on abbreviations.
// Note: Micro sign (µ) U+00B5, is completely different from Greek Mu (μ) U+03BC
private _sizeFieldList = if (_localise && (_symbolSet != 2)) then {
    private _preSpace = [" ",""] #_symbolSet;
    private _postSpace = [" "," "] #_symbolSet;
    [
        ["STR_antistasi_timeSpan_days","STR_antistasi_timeSpan_hours","STR_antistasi_timeSpan_minutes","STR_antistasi_timeSpan_seconds","STR_antistasi_timeSpan_milliseconds","STR_antistasi_timeSpan_microseconds","STR_antistasi_timeSpan_nanoseconds"],
        ["STR_antistasi_timeSpan_days_abbr","STR_antistasi_timeSpan_hours_abbr","STR_antistasi_timeSpan_minutes_abbr","STR_antistasi_timeSpan_seconds_abbr","STR_antistasi_timeSpan_milliseconds_abbr","STR_antistasi_timeSpan_microseconds_abbr","STR_antistasi_timeSpan_nanoseconds_abbr"]
    ] #_symbolSet apply {_preSpace + (localize _x) + _postSpace};
} else {
    [
        [" Days "," Hours "," Minutes "," Seconds "," Milliseconds "," Microseconds "," Nanoseconds "],
        ["d ","h ","m ","s ","ms ","µs ","ns "],
        [":",":",":","–",":",":",":"]  // Note En-Dash U+2013 (toString[8211]) is used to separate seconds from smaller parts.
    ] #_symbolSet;
};
private _showInBetweenZeros = _showZeros > 0;
private _showAllZeros = _showZeros > 1;
// Copy timeSpan to avoid resizes changing input array.
_timeSpan = +_timeSpan;
if (_showAllZeros) then {
    _timeSpan resize 8;
} else {
    //  Prevent trailing zeros.
    private _lastNonZero = 8;
    {
        if (_x isNotEqualTo 0) then {
            _lastNonZero = _forEachIndex;
        };
    } forEach _timeSpan;
    _timeSpan resize (_lastNonZero + 1);
};

// Determine whether a slice between two indices is desired, or a maximum amount of significant fields is desired.
private _sliceIndexBased = _slice isEqualType [];
private _fieldsAmount = if (_sliceIndexBased) then {1e7} else {_slice};
private _sliceStart = if (_sliceIndexBased) then {_slice param [0,0,[0]]} else {0};
private _sliceEnd = if (_sliceIndexBased) then {_slice param [1,1e7,[0]]} else {1e7};

private _formattedText = "";
private _foundNonZero = false;
{
    // If past slice range, or desired amount of fields have been printed, exit.
    if (_sliceEnd <= _forEachIndex || _fieldsAmount <= 0) exitWith { continue };
    // If before slice range, skip.
    if (_forEachIndex < _sliceStart) then { continue };
    // If nil field, from input or resize due to printAllZeros, allow it to be printed.
    if (isNil {_x}) then { _x = 0; };
    if (_x != 0 || _showInBetweenZeros && _foundNonZero || _showAllZeros) then {
        _foundNonZero = _foundNonZero || _x != 0;
        // Decrement amount of fields to be printed.
        _fieldsAmount = _fieldsAmount - 1;
        private _amount = _x toFixed 0;
        if (_pad) then {
            if (_forEachIndex < 4) then {
                _amount = _amount call A3A_fnc_pad_2Digits;
            } else {
                _amount = _amount call A3A_fnc_pad_3Digits;
            };
        };
        _formattedText = _formattedText + (_amount + (_sizeFieldList #_forEachIndex));
    };
// Exclude the positive/negative sign
} forEach (_timeSpan select [1,1e7]);
// If all displayed fields are empty, then display now without any other symbol.
if (_formattedText isEqualTo "") then {
    if (_localise && (_symbolSet == 0)) then {
        _formattedText = (localize "STR_antistasi_timeSpan_now") + " ";
    } else {
        _formattedText = ["(Now) ","0 ","0 "] #_symbolSet;
    };
};

// Prevent negative zeros.
private _negative = (_timeSpan param [0,false]) && _foundNonZero;
if (_negative || _showPositive) then {
    // Wrapping in parenthesise prevents misidentification as hyphen or dash.
    private _signSet = [["(+) ", "(-) "], ["(+) ", "(-) "], ["+","-"]] #_symbolSet;
    _formattedText = (_signSet select _negative) + _formattedText;
};

// Trim the end space (or ending colon).
// Needs toArray to avoid cutting unicode characters in thirds.
_formattedText = toArray _formattedText;
toString (_formattedText select [0, count _formattedText -1]);
// };
