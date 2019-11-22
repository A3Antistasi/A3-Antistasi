/**
	Logs to the Arma log file.
	
	Params:
		Log level: number - Error, Info or Debug. Levels 1, 2 and 3 respectively.
		Log Message: string - Message to log
		File (optional): string - File in which the log message originated
		Log to server (optional): bool - true for logging to server RPT instead of client
**/

params ["_logLevel", "_message", ["_file", "No File Specified"], ["_toServer", false]];

if (_logLevel > LogLevel) exitwith {};

// Sets up the actual log event.
_typex = "";
switch (_logLevel) do {
    case 1: {
        _typex = format ["%1: [Antistasi] | ERROR | %2 | %3", servertime, _file, _message];
    };
    case 2: {
        _typex = format ["%1: [Antistasi] | INFO | %2 | %3", servertime, _file, _message];
    };
    case 3: {
        _typex = format ["%1: [Antistasi] | DEBUG | %2 | %3", servertime, _file, _message];
    };
    default {
        _typex = format ["%1: [Antistasi] | Unknown Log Level Specified, please use 1= Errors, 2= Info, 3= Debug. Original error: %2", servertime, _message]
    };
};

if (_toServer && !isServer) then {
	_typex remoteExec ["diag_log", 2];
} else {
	diag_log _typex;
};

