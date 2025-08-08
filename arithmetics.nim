import strutils
import options
import typing
from data import
    stack,
    popStack
from vars import getVariable

## This module is a wrapper for all the interpreter commands
##  Offers the following functions for the interpreter:
##      add()
##      sub()
##      mul()
##      divide()
##      modulo()
##      swap()
##      negate()
##      duplicate()
##      clear()
##      push()
##      getCommands()

proc pushInt(val: int): void =
    ## Pushes an integer as StackItem to the stack
    ## 
    ## **params**:
    ##  val: int
    ## 
    ## **returns**:
    ##  void
    stack.add(StackItem(kind: StackItemType.siInt, intVal: val))

proc pushStr(val: string): void =
    ## Pushes a string as StackItem to the stack
    ## 
    ## **params**:
    ##  val: int
    ## 
    ## **returns**:
    ##  void
    stack.add(StackItem(kind: StackItemType.siStr, strVal: val))

proc push*(value: seq[string]): void =
    ## Pushes an integer or string into the
    ## stack of StackItems by converting the
    ## pushed input into a StackItem.
    ## 
    ## **params**:
    ##  val: seq[string]
    ## 
    ## **returns**:
    ##  void
    var arg: string = value[^1]
    let variable: Option[Variable] = getVariable(arg)

    if variable.isSome():
        arg = variable.get().value
    
    if isDigit(arg[0]):
        pushInt(parseInt(arg))
    else:
        pushStr(arg)

proc add*(): void =
    ## Adds the top 2 values together, popping
    ## both from the stack and adding the result
    ## to the stack.
    ## 
    ## **params**:
    ##  none
    ## 
    ## **returns**:
    ##  void
    var a: (StackItem, StackItem) = popStack()
    pushInt(a[0].intVal + a[1].intVal)

proc sub*(): void =
    ## Subtracts the top 2 values together, popping
    ## both from the stack and adding the result
    ## to the stack.
    ## 
    ## **params**:
    ##  none
    ## 
    ## **returns**:
    ##  void
    var a: (StackItem, StackItem) = popStack()
    pushInt(a[0].intVal - a[1].intVal)

proc mul*(): void =
    ## Multiplies the top 2 values together, popping
    ## both from the stack and adding the result
    ## to the stack.
    ## 
    ## **params**:
    ##  none
    ## 
    ## **returns**:
    ##  void
    var a: (StackItem, StackItem) = popStack()
    pushInt(a[0].intVal * a[1].intVal)

proc modulo*(): void =
    ## Performs a modulo calculation of 
    ## the top 2 values together, popping
    ## both from the stack and adding the result
    ## to the stack.
    ## 
    ## **params**:
    ##  none
    ## 
    ## **returns**:
    ##  void
    var a: (StackItem, StackItem) = popStack()
    pushInt(a[0].intVal mod a[1].intVal)

proc divide*(): void =
    ## Divides the top 2 values from each other, popping
    ## both from the stack and adding the result
    ## to the stack.
    ## 
    ## **params**:
    ##  none
    ## 
    ## **returns**:
    ##  void
    var a: (StackItem, StackItem) = popStack()
    var res: float = a[0].intVal / a[1].intVal
    pushInt(toInt(res))

proc swap*(): void =
    ## Swaps the top two values
    ## 
    ## **params**:
    ##  none
    ## 
    ## **returns**:
    ##  void
    var x: (StackItem, StackItem) = popStack()
    stack.add(x[1])
    stack.add(x[0])

proc negate*(): void =
    ## Negates the top value
    ## 
    ## **params**:
    ##  none
    ## 
    ## **returns**:
    ##  void
    stack[^1].intVal = -stack[^1].intVal

proc duplicate*(): void =
    ## Duplicates the top value
    ## 
    ## **params**:
    ##  none
    ## 
    ## **returns**:
    ##  void
    stack.add(stack[^1])

proc clear*(): void =
    ## Clears the whole stack
    ## 
    ## **params**:
    ##  none
    ## 
    ## **returns**:
    ##  void
    stack.setLen(0)

proc print*(arg: seq[string]): void =
    ## Prints a given variable and
    ## the whole stack
    ## 
    ## **params**:
    ##  none
    ## 
    ## **returns**:
    ##  void
    var variable: Option[Variable] = getVariable(arg[^1])
    if variable.isSome():
        echo variable.get()
    
    for idx in 0..high(stack):
        let represent: string = typing.`$`(stack[idx])
        echo represent

proc help*(): void =
    echo """
    Commands:
        PUSH <int> | <VAR>          PUSHes integer to stack (max of 2)
        ADD                         ADDs integers of stack of size 2 together
        SUB                         SUBtracts integers of stack of size 2
        MUL                         MULtiplies integers of stack together
        DIV                         DIVides integers of stack with each other
        MOD                         MODulo operation between first 2 integers
        NEGATE                      NEGATEs top value
        DUPLIC                      DUPLICates the top value
        CLEAR                       CLEARs the stack
        SWAP                        SWAPs the top 2 integers
        PRINT Option[VAR]           PRINTs stack
    """