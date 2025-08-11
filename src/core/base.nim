import strutils
import ../commands/vars as vars
import ../cli/consoleAPI as consoleAPI
import data
import options
import typing
import std/tables

proc print*(arg: seq[string]): void =
    ## Prints a given variable and
    ## the whole stack
    ## 
    ## **params**:
    ## 
    ##  none
    ## 
    ## **returns**:
    ## 
    ##  void
    var variable: Option[Variable] = getVariable(arg[^1])
    if variable.isSome():
        echo variable.get()
        return
    
    for idx in 0..high(stack):
        let represent: string = typing.`$`(stack[idx])
        echo represent

proc pushInt*(val: int): void =
    ## Pushes an integer as StackItem to the stack
    ## 
    ## **params**:
    ## 
    ##  val: int
    ## 
    ## **returns**:
    ## 
    ##  void
    stack.add(StackItem(kind: StackItemType.siInt, intVal: val))

proc pushStr*(val: string): void =
    ## Pushes a string as StackItem to the stack
    ## 
    ## **params**:
    ## 
    ##  val: int
    ## 
    ## **returns**:
    ## 
    ##  void
    stack.add(StackItem(kind: StackItemType.siStr, strVal: val))

proc push*(value: seq[string]): void =
    ## Pushes an integer or string into the
    ## stack of StackItems by converting the
    ## pushed input into a StackItem.
    ## 
    ## **params**:
    ## 
    ##  val: seq[string]
    ## 
    ## **returns**:
    ## 
    ##  void
    var arg: string = value[^1]
    let variable: Option[Variable] = getVariable(arg)

    if variable.isSome():
        arg = variable.get().value
    
    if isDigit(arg[0]):
        pushInt(parseInt(arg))
    else:
        pushStr(arg)

proc clear*(): void =
    ## Clears the whole stack
    ## 
    ## **params**:
    ## 
    ##  none
    ## 
    ## **returns**:
    ## 
    ##  void
    stack.setLen(0)

proc isEof*(cmd: string): bool = cmd == "EOF" or cmd == "EOSF"

proc safeExecute*(stackInput: Command): bool =
    # extend later
    if data.commands.hasKey(stackInput.command):
        return true
    else:
        return false

proc execute*(stackInput: Command): void =
    ## Communicates with DSL command table to
    ## make changes to stack or other data structures.
    ## 
    ## Due to loadAllCommands() being called way before
    ## the initialisation of this function there 
    ## (hopefully) won't be any issues with the way this
    ## function looks up the function in the commands table.
    ## 
    ## **params:**
    ##      
    ##      stackInput: Command
    ## 
    ## **returns**:
    ##     
    ##       void
    let command: string = stackInput.command
    var cmds: Table[string, CommandProc] = data.commands

    if cmds.hasKey(command):
        var cmd: CommandProc = cmds[command]
        cmd(stackInput.args)
    else:
        printError("Couldn't find command \"" & command & "\"")

proc executeLines*(start, stop: int): void =
    for i in start..stop:
        execute(instructions[i])

proc help*(): void =
    echo """ --- BASE
        PUSH <int> | <VAR>          PUSHes integer to stack (max of 2)
        PRINT Option[VAR]           PRINTs stack
        CLEAR                       CLEARs the stack
    """