import ../core/base as base
import ../core/typing as typing
from ../core/data import
    stack,
    popStack

## This module is a wrapper for all the interpreter commands

proc add*(): void =
    ## Adds the top 2 values together, popping
    ## both from the stack and adding the result
    ## to the stack.
    ## 
    ## **params**:
    ## 
    ##  none
    ## 
    ## **returns**:
    ## 
    ##  void
    var a: (StackItem, StackItem) = popStack()
    pushInt(a[0].intVal + a[1].intVal)

proc sub*(): void =
    ## Subtracts the top 2 values together, popping
    ## both from the stack and adding the result
    ## to the stack.
    ## 
    ## **params**:
    ## 
    ##  none
    ## 
    ## **returns**:
    ## 
    ##  void
    var a: (StackItem, StackItem) = popStack()
    pushInt(a[0].intVal - a[1].intVal)

proc mul*(): void =
    ## Multiplies the top 2 values together, popping
    ## both from the stack and adding the result
    ## to the stack.
    ## 
    ## **params**:
    ## 
    ##  none
    ## 
    ## **returns**:
    ## 
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
    ## 
    ##  none
    ## 
    ## **returns**:
    ## 
    ##  void
    var a: (StackItem, StackItem) = popStack()
    pushInt(a[0].intVal mod a[1].intVal)

proc divide*(): void =
    ## Divides the top 2 values from each other, popping
    ## both from the stack and adding the result
    ## to the stack.
    ## 
    ## **params**:
    ## 
    ##  none
    ## 
    ## **returns**:
    ## 
    ##  void
    var a: (StackItem, StackItem) = popStack()
    var res: float = a[0].intVal / a[1].intVal
    pushInt(toInt(res))

proc swap*(): void =
    ## Swaps the top two values
    ## 
    ## **params**:
    ## 
    ##  none
    ## 
    ## **returns**:
    ## 
    ##  void
    var x: (StackItem, StackItem) = popStack()
    stack.add(x[1])
    stack.add(x[0])

proc negate*(): void =
    ## Negates the top value
    ## 
    ## **params**:
    ## 
    ##  none
    ## 
    ## **returns**:
    ## 
    ##  void
    stack[^1].intVal = -stack[^1].intVal

proc duplicate*(): void =
    ## Duplicates the top value
    ## 
    ## **params**:
    ## 
    ##  none
    ## 
    ## **returns**:
    ## 
    ##  void
    stack.add(stack[^1])

proc help*(): void =
    echo """ --- ARITHMETICS
    Commands:
        ADD                         ADDs integers of stack of size 2 together
        SUB                         SUBtracts integers of stack of size 2
        MUL                         MULtiplies integers of stack together
        DIV                         DIVides integers of stack with each other
        MOD                         MODulo operation between first 2 integers
        NEGATE                      NEGATEs top value
        DUPLIC                      DUPLICates the top value
        SWAP                        SWAPs the top 2 integers                        
    """