import strutils
import typing
import data
import commands
import consoleAPI
import std/tables

proc parseInput(input: string): (string, seq[string]) =
    ## Parses user input into the command and it's args
    ## If there are no args it returns an empty sequence
    ## of strings
    ## 
    ## **params:**
    ##      
    ##      input: string
    ## 
    ## **returns**:
    ##     
    ##       (string, seq[string]): Command and args
    let splitted_string: seq[string] = input.split(" ")
    let command: string = splitted_string[0]
    var args: seq[string]

    if splitted_string.len() > 1:
        args = splitted_string[1..^1]
    else:
        args.setLen(1)
    return (command, args)

proc toStack(stackInput: Command): void =
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
    var cmds: Table[string, CommandType] = commands.getCommands()

    if cmds.hasKey(command):
        var cmd: CommandType = cmds[command]
        cmd(stackInput.args)
    else:
        printError("Couldn't find command \"" & command & "\"")

proc main(): void =
    ## This is the main procedure of the program
    ## this is where the main loop of the user sending
    ## commands and arguments to the backend starts
    ## 
    ## **params:**
    ##      
    ##      none
    ##      
    ## **returns**:
    ##     
    ##       void

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
#   StackItemType to VarType        (X)
#   Create base file for push etc   (WORKING ON...)
#   Variable support                (X)
#   Documentation                   (WORKING ON...)
#   Control flow
#   Load and save files    