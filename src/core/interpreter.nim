import strutils
import ../commands/fs as fs
import ../commands/commands as commands
import ../commands/flow as flow
import ../commands/vars as vars
import ../cli/consoleAPI as consoleAPI
import typing
import data
import base
import options

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
    var variable: Option[Variable] = vars.getVariable(arg[^1])
    if variable.isSome():
        echo variable.get()
        return
    
    for idx in 0..high(stack):
        let represent: string = typing.`$`(stack[idx])
        echo represent

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

proc runInstructions(): void =
    while programCounter < instructions.len():
        execute(instructions[programCounter])
        programCounter += 1

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

    commands.loadAllCommands()

    echo "Nim DSL - v0.5 - github.com/floerianc"
    echo "Enter \"HELP\" to see help for all commands"
    echo "nimsh [0] > START"
    while true:
        stdout.write("nimsh " & "[" & $(programCounter + 1) & "]" & " > ")
        
        let userInput = stdin.readLine()
        let parsedInput = parseInput(userInput)
        var cmd = Command(
            command: parsedInput[0].toUpper(),
            args: parsedInput[1]
        )

        # Early check for HELP
        if cmd.command == "HELP":
            
            continue

        # Checking for EOF or EOSF
        if isEof(cmd.command):
            programCounter = 0
            runInstructions()
            if cmd.command == "EOSF":
                writeInstructions(cmd.args)
            break
        
        # Actually adding instruction to sequence
        if safeExecute(cmd):
            if cmd.command in flowControls:
                addLabel(cmd)
                echo labels
            instructions.add(cmd)
            programCounter += 1
        else:
            printWarn("Couldn't find command \"" & cmd.command & "\"")

main()

# TODO:
#   More C64-ish execution style        (X)
#       - Live-Debugger while writing   (X)
#   Colored Terminal                    (WORKING ON...)
#   MOD                                 (X)
#   NEG                                 (X)
#   DUP                                 (X)
#   CLEAR                               (X)
#   Support more than 2 integers        (X)
#   Better typing                       (X)
#   Modular                             (X)
#   StackItemType to VarType            (X)
#   Create base file for push etc       (X)
#   Variable support                    (X)
#   Documentation                       (WORKING ON...)
#   Control flow                        (WORKING ON...)
#       Supported:
#           IF (Literal / Variable)     (X)
#           IFZERO                      (X)
#           ELSE                        (X)
#           END                         (X)
#   Load and save files                 (X)