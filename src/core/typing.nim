type 
    Command* = object
        command*: string
        args*: seq[string]
    CommandProc* = proc(args: seq[string]) {.nimcall.}
    CompareProc* = proc(a, b: Variable): bool
    VarType* = enum 
        INT, STR, NONE
    Variable* = object
        name*: string
        varType*: VarType = VarType.STR
        value*: string = ""
    StackItemType* = enum
        siInt, siStr
    StackItem* = object
        kind*: StackItemType = siStr
        intVal*: int = 0
        strVal*: string = ""

proc `$`*(si: StackItem): string =
    ## A custom repr string for the StackItem
    ## type. This returns a different string depending
    ## on the type of variable.
    ## 
    ## **params:**
    ##      
    ##      si: StackItem
    ##      The StackItem instance you want to convert
    ##      to a string
    ## 
    ## **returns**:
    ##     
    ##       string
    ##       repr string for the StackItem instance
    case si.kind:
    of StackItemType.siInt:
        result = "SI(type=\"" & $si.kind & "\", value=" & $si.intVal & ")"
    of StackItemType.siStr:
        result = "SI(type=\"" & $si.kind & "\", value=\"" & $si.strVal & "\")"

proc createSI*(sit: StackItemType, intVal: int = 0, strVal: string = ""): StackItem =
    ## Returns a StackItem instance
    ## 
    ## **params:**
    ##      
    ##      sit: StackItemType
    ##      Data type for the StackItem
    ## 
    ##      intVal: int
    ##      Integer value of the StackItem. Defaults to 0
    ## 
    ##      strVal: string
    ##      String value of the StackItem. Defaults to ""
    ## 
    ## **returns**:
    ##     
    ##       StackItem
    ##       The StackItem, lol
    StackItem(kind: sit, intVal: intVal, strVal: strVal)