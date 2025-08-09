import typing
import options
import consoleAPI
import strutils
import std/tables
from data import variables

proc checkSyntax(s: string, t: VarType): string =
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
    let value: string = checkSyntax(text, typ)

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
    ##      Option mayhaps containing a Variable instance.
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