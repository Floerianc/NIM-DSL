from std/tables import 
    initTable, 
    Table
import typing

var stack*: seq[StackItem]
var variables*: Table[string, Variable] = initTable[string, Variable]()

proc popStack*(): (StackItem, StackItem) =
    ## Pops the top two values from the top of
    ## the DSL stack
    ## 
    ## **params:**
    ##      
    ##      none
    ## 
    ## **returns**:
    ##     
    ##       (StackItem, StackItem): Top two values from DSL stack
    if stack.len() < 2:
        stack.setLen(2)
    var popped: (StackItem, StackItem) = (stack[^2], stack[^1])
    stack.setLen(stack.len() - 2)
    return popped