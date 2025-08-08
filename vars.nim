import typing
import options
import consoleAPI
import strutils
import std/tables
from data import variables

proc checkSyntax(s: string, t: VarType): string =
    var str: string = s
    case t:
    of VarType.STR:
        if (s[0] == '\"') and (s[^1] == '\"'):
            return s.strip(chars = {'"'})
        else:
            return str
    of VarType.INT:
        try:
            discard parseInt(str)
            return str
        except:
            return "-1"

proc toVarType(s: string): VarType =
    var upperS: string = s.toUpper()
    var map: Table[string, VarType] = initTable[string, VarType]()
    map["INT"] = VarType.INT
    map["STR"] = VarType.STR

    if map.hasKey(upperS):
        return map[upperS]
    else:
        return VarType.STR

proc toVar(s: seq[string]): Variable =
    if s.len() < 3:
        consoleAPI.printError("Not enough arguments for variable! Returning void")
        return

    let typ: VarType = toVarType(s[0])
    let name: string = s[1]

    var text: string = join(s[2..high(s)], sep=" ")
    let value: string = checkSyntax(text, typ)

    return Variable(name: name, varType: typ, value: value)

proc addVariable*(args: seq[string]): void =
    let variable: Variable = toVar(args)
    variables[variable.name] = variable

proc getVariable*(arg: string): Option[Variable] =
    if arg.isEmptyOrWhitespace():
        return none(Variable)

    if variables.hasKey(arg):
        return some(variables[arg])
    else:
        return none(Variable)

proc help*(): void =
    echo """ --- VARIABLES
    VAR <type> <name> <value>

    Types:
        STR
        INT
    
    Syntax:
        value:
            STR: Must start and end with ""
            INT: Must be digits-only
    
    Examples:
        VAR STR string "Hello world!"
        VAR INT integer 123456789
    """