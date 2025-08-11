import std/tables
import strutils
import typing
import data
import ../cli/consoleAPI as consoleAPI

proc checkVarDeclaration*(s: string, t: VarType): string =
    ## Applies syntax rules to the variable declaration
    ## I will perhaps move all the syntax steps to another
    ## seperate file at some point but so far it's working
    ## well.
    ## 
    ## **params:**
    ##      
    ##      s: string
    ##      the variable's value
    ## 
    ##      t: VarType
    ##      The data type of the variable
    ## 
    ## **returns**:
    ##     
    ##       type
    ##      <description>
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
            printWarn("Couldn't parse integer. Returning default value -1 instead")
            return "-1"
    of NONE:
        return str

proc checkIFCall*(args: seq[string]): bool =
    var foundOperator = false
    if high(args) < 2:
        return false
    else:
        if operators.hasKey(args[1]):
            foundOperator = true
    if foundOperator:
        return true
    else:
        return false