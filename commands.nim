import typing
import std/tables
import arithmetics
import vars

var commands = initTable[string, CommandType]()

proc getCommands*(): Table[string, CommandType] =
    return commands

proc printAllHelp(): void =
    ## Prints every help string for each
    ## component of this DSL.
    ## 
    ## params:
    ## 
    ##      none
    ## 
    ## returns:
    ## 
    ##      void
    arithmetics.help()
    vars.help()

proc loadArithmetics(): void =
    ## Loads all the arithmetics commands
    ## to the DSL command table
    ## 
    ## **params:**
    ##      
    ##      none
    ## 
    ## **returns**:
    ##     
    ##       void
    commands["PUSH"] = CommandType(proc(value: seq[string]) = push(value))
    commands["ADD"] = CommandType(proc(value: seq[string]) = add())
    commands["SUB"] = CommandType(proc(value: seq[string]) = sub())
    commands["MUL"] = CommandType(proc(value: seq[string]) = mul())
    commands["DIV"] = CommandType(proc(value: seq[string]) = divide())
    commands["MOD"] = CommandType(proc(value: seq[string]) = modulo())
    commands["NEGATE"] = CommandType(proc(value: seq[string]) = negate())
    commands["DUPLIC"] = CommandType(proc(value: seq[string]) = duplicate())
    commands["CLEAR"] = CommandType(proc(value: seq[string]) = clear())
    commands["SWAP"] = CommandType(proc(value: seq[string]) = swap())
    commands["HELP"] = CommandType(proc(value: seq[string]) = printAllHelp())

proc loadVariables(): void =
    ## Loads all the commands from the 
    ## variables component to the DSL
    ## command table
    ## 
    ## **params:**
    ##      
    ##      none
    ## 
    ## **returns**:
    ##     
    ##       void
    commands["VAR"] = CommandType(proc(value: seq[string]) = addVariable(value))

proc loadMain(): void =
    ## Loads all the commands from the
    ## main file to the DSL command
    ## table
    ## 
    ## **params:**
    ##      
    ##      none
    ## 
    ## **returns**:
    ##     
    ##       void
    commands["PRINT"] = CommandType(proc(value: seq[string]) = print(value))

proc loadAllCommands(): void =
    ## Loads every command from every component
    ## of this DSL to the DSL command table
    ## 
    ## **params:**
    ##      
    ##      name: type
    ## 
    ## **returns**:
    ##     
    ##       name: description
    loadArithmetics()
    loadVariables()
    loadMain()

loadAllCommands()