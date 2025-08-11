import ../core/typing as typing
import options
import ../cli/consoleAPI as consoleAPI
import ../core/syntax as syntax
import ../core/utils as utils
import strutils
import std/tables
from ../core/data import variables

proc getValueType*(s: string): VarType =
    try:
        discard parseInt(s)
        return VarType.INT
    except:
        if s[0] == '"' and s[^1] == '"':
            return VarType.STR
        else:
            return VarType.NONE

proc toVarType(s: string): VarType =
    ## Converts a string value to a VarType
    ## to declare the data type of a by the user
    ## initialised variable.
    ## 
    ## Example:
    ## STR --> VarType.STR
    ## INT --> VarType.INT
    ## 
    ## **params:**
    ##      
    ##      s: string
    ##      string to be converted
    ## 
    ## **returns**:
    ##     
    ##       VarType
    ##       The data type of the variable
    var upperS: string = s.toUpper()
    var map: Table[string, VarType] = initTable[string, VarType]()
    map["INT"] = VarType.INT
    map["STR"] = VarType.STR

    if map.hasKey(upperS):
        return map[upperS]
    else:
        return VarType.STR

proc toVar(args: seq[string]): Variable =
    ## Turns the arguments of a VAR declaration
    ## into a Variable that can be added to the
    ## vars sequence in `data.nim`
    ## 
    ## **params:**
    ## 
    ##      args: seq[string]
    ##      List of strings (args)
    ## 
    ## **returns**:
    ##     
    ##      Variable
    ##      A for the DSL comprehensible Variable instance
    if args.len() < 3:
        consoleAPI.printError("Not enough arguments for variable! Returning void")
        return

    let typ: VarType = toVarType(args[0])
    let name: string = args[1]

    var text: string = join(args[2..high(args)], sep=" ")
    let value: string = checkVarDeclaration(text, typ)

    return Variable(name: name, varType: typ, value: value)

proc addVariable*(args: seq[string]): void =
    ## Adds a varaible to the variables sequence
    ## in `data.nim`.
    ## 
    ## **params:**
    ##      
    ##      args: seq[string]
    ##      Arguments to create a Variable instance
    ## 
    ## **returns**:
    ##     
    ##       void
    let variable: Variable = toVar(args)
    variables[variable.name] = variable

proc getVariable*(arg: string): Option[Variable] =
    ## Returns an Option[Variable] object by looking
    ## for a Variable in the variables table.
    ## 
    ## To check if it's not none, try Option.isSome()
    ## and then Option.get()
    ## 
    ## **params:**
    ##      
    ##      arg: string
    ##      String we use to search the table
    ## 
    ## **returns**:
    ##     
    ##      Option[Variable]
    ##      Option mayhaps containing a Variable object.
    if arg.isEmptyOrWhitespace():
        return none(Variable)

    if variables.hasKey(arg):
        return some(variables[arg])
    else:
        return none(Variable)

proc createVariable*(name: string, kind: VarType, value: string): Variable =
    var value: string = checkVarDeclaration(value, kind)
    return Variable(name: name, varType: kind, value: value)

proc createOrGetVariable*(name: string, kind: VarType, value: string): Variable =
    if variables.hasKey(value):
        return variables[value]
    else:
        return createVariable(utils.rndStr(), kind, value)

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