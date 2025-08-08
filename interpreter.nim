import strutils
import typing
import data
import commands
import consoleAPI
import std/tables

proc parseInput(input: string): (string, seq[string]) =
    let splitted_string: seq[string] = input.split(" ")
    let command: string = splitted_string[0]
    var args: seq[string]

    if splitted_string.len() > 1:
        args = splitted_string[1..^1]
    else:
        args.setLen(1)
    return (command, args)

proc toStack(stack_input: Command): void =
    let command: string = stack_input.command
    var cmds: Table[string, CommandType] = commands.getCommands()

    if cmds.hasKey(command):
        var cmd: CommandType = cmds[command]
        cmd(stack_input.args)
    else:
        printError("Couldn't find command \"" & command & "\"")

proc main(): void =
    echo "Nim DSL - v0.4 - github.com/floerianc"
    echo "Enter \"HELP\" to see help for all commands"
    while true:
        let index: int = stack.len()
        stdout.write("nimsh " & "[" & $index & "]" & " > ")
        
        let userInput = stdin.readLine()
        let parsesInput: (string, seq[string]) = parseInput(userInput)
        var cmd: Command = Command(
            command: parsesInput[0].toUpper(),
            args: parsesInput[1]
        )
        toStack(cmd)

main()

# TODO:
#   MOD                             (X)
#   NEG                             (X)
#   DUP                             (X)
#   CLEAR                           (X)
#   Support more than 2 integers    (X)
#   Better typing                   (X)
#   Modular                         (X)
#   Create base file for push etc   (WORKING ON...)
#   Variable support                (X)
#   Documentation                   (WORKING ON...)
#   Control flow
#   Load and save files    