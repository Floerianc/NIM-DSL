import std/tables
import strutils
import ../core/base as base
import ../core/utils as utils
import ../core/syntax as syntax
import ../core/typing as typing
import ../cli/consoleAPI as consoleAPI
import vars
from ../core/data import 
    labels,
    variables,
    stack,
    instructions,
    operators,
    programCounter

proc nextKey(startIdx: int, key: string): int =
    for i in startIdx..high(instructions):
        let command: string = instructions[i].command
        if command.split(" ")[0] == key:
            return i
    return -1

proc checkStructure(endIdx: int): bool =
    endIdx >= 0

proc ELSE*(args: seq[string]): void =
    return

proc END*(args: seq[string]): void =
    return

proc compVars(a, b: Variable, operator: string): bool =
    if a.varType != b.varType: return false
    if operators.hasKey(operator):
        return operators[operator](a, b)
    else:
        printError("Unknown operator \"" & operator & "\"")

proc IFZERO*(args: seq[string]): void =
    let elseIdx = nextKey(programCounter+1, "ELSE")
    let endIdx = nextKey(programCounter+1, "END")
    if checkStructure(endIdx) == false:
        printError("Flow control block was never closed. Expected \"END\" after block.")
        return

    if stack[^1].intVal == 0:
        executeLines(programCounter+1, elseIdx-1)
        programCounter = endIdx
        return
    else:
        executeLines(elseIdx+1, endIdx-1)
        programCounter = endIdx
        return

proc IF*(args: seq[string]): void =
    if not checkIFCall(args):
        printError("IF Keyword was not used correctly. Check documentation for more info")
        return
    var variable: string = args[0]
    var operator: string = args[1]
    var targetVal: string = args[2]
    let elseIdx = nextKey(programCounter+1, "ELSE")
    let endIdx = nextKey(programCounter+1, "END")

    if checkStructure(endIdx) == false:
        printError("Flow control block was never closed. Expected \"END\" after block.")
        return

    let left = createOrGetVariable(rndStr(), getValueType(variable), variable)
    let right = createOrGetVariable(rndStr(), getValueType(targetVal), targetVal)

    if compVars(left, right, operator):
        executeLines(programCounter+1, elseIdx-1)
        programCounter = endIdx
    else:
        executeLines(elseIdx+1, endIdx-1)
        programCounter = endIdx

proc addLabel*(cmd: Command): void =
    labels.add((cmd.command, programCounter))

proc help*(): void =
    echo """ --- FLOW CONTROL
    
    Flow control keywords have a very basic structure:
        <keyword>
        <instructions>
        ELSE
        <instructions> (or empty)
        END

    - IFZERO
    Checks if top value is zero.

    Examples:
        > IFZERO
        > PUSH 500
        > PUSH 750

    - IF <x> <operator> <y>

    Compares two values with each other and then
    acts accordingly.

    <x> and <y> can be any literal value or variable.
    So you could replace <x> with:
        350         (integer value)
        "Hello"     (string value)
        variable    (variable pointer)
    
    The operator field supports any logical comparison operator.
    Operators:
        ==      >=
        <=      !=
        <       >
    
    Examples:
        > PUSH 10
        > IF 350 <= 250
        > PUSH 6
        > ELSE
        > PUSH 2
        > END
        > MUL
        > PRINT
        >> 20
    """