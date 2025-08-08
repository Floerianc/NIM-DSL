type 
    Command* = object
        command*: string
        args*: seq[string]
    CommandType* = proc(args: seq[string]) {.nimcall.}
    VarType* = enum 
        INT, STR
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
    case si.kind:
    of StackItemType.siInt:
        result = "SI(type=\"" & $si.kind & "\", value=" & $si.intVal & ")"
    of StackItemType.siStr:
        result = "SI(type=\"" & $si.kind & "\", value=\"" & $si.strVal & "\")"

proc createSI(sit: StackItemType, intVal: int = 0, strVal: string = ""): StackItem =
    StackItem(kind: sit, intVal: intVal, strVal: strVal)