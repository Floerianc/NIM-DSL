import std/tables
import ../core/typing as typing
import ../core/base as base
import ../core/data as data
import flow
import fs
import arithmetics
import vars

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
    base.help()
    arithmetics.help()
    vars.help()
    flow.help()
    fs.help()

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
    commands["ADD"] = CommandProc(proc(value: seq[string]) = add())
    commands["SUB"] = CommandProc(proc(value: seq[string]) = sub())
    commands["MUL"] = CommandProc(proc(value: seq[string]) = mul())
    commands["DIV"] = CommandProc(proc(value: seq[string]) = divide())
    commands["MOD"] = CommandProc(proc(value: seq[string]) = modulo())
    commands["NEGATE"] = CommandProc(proc(value: seq[string]) = negate())
    commands["DUPLIC"] = CommandProc(proc(value: seq[string]) = duplicate())
    commands["SWAP"] = CommandProc(proc(value: seq[string]) = swap())
    commands["HELP"] = CommandProc(proc(value: seq[string]) = printAllHelp())

proc loadBase(): void =
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
    commands["CLEAR"] = CommandProc(proc(value: seq[string]) = clear())
    commands["PRINT"] = CommandProc(proc(value: seq[string]) = print(value))
    commands["PUSH"] = CommandProc(proc(value: seq[string]) = push(value))

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
    commands["VAR"] = CommandProc(proc(value: seq[string]) = addVariable(value))

proc loadFlow(): void =
    commands["IF"] = CommandProc(proc(value: seq[string]) = IF(value))
    commands["IFZERO"] = CommandProc(proc(value: seq[string]) = IFZERO(value))
    commands["ELSE"] = CommandProc(proc(value: seq[string]) = ELSE(value))
    commands["END"] = CommandProc(proc(value: seq[string]) = END(value))
    flowControls.add("IF")
    flowControls.add("IFZERO")
    flowControls.add("ELSE")
    flowControls.add("END")

proc loadOperators(): void =
    operators["=="] = CompareProc(proc(a, b: Variable): bool = a.value == b.value)
    operators[">="] = CompareProc(proc(a, b: Variable): bool = a.value >= b.value)
    operators["<="] = CompareProc(proc(a, b: Variable): bool = a.value <= b.value)
    operators["!="] = CompareProc(proc(a, b: Variable): bool = a.value != b.value)
    operators[">"] =  CompareProc(proc(a, b: Variable): bool = a.value >  b.value)
    operators["<"] =  CompareProc(proc(a, b: Variable): bool = a.value <  b.value)

proc loadFS(): void =
    commands["EOSF"] = CommandProc(proc(value: seq[string]) = writeInstructions(value))
    commands["LOAD"] = CommandProc(proc(value: seq[string]) = loadInstructions(value))

proc loadAllCommands*(): void =
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
    loadOperators()
    loadBase()
    loadArithmetics()
    loadVariables()
    loadFlow()
    loadFS()