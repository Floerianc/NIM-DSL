import ../core/data as data
import ../core/typing as typing
import strutils

proc writeInstructions*(args: seq[string]): void =
    let f = open(join([args[0], ".dsl"], sep=""), fmWrite)
    defer: f.close()

    for instruction in instructions:
        var cmd = instruction.command
        cmd.add(" ")
        cmd.add(join(instruction.args, sep = " "))
        f.writeLine(cmd)

proc loadInstructions*(args: seq[string]): void =
    var filename = args[0]
    var f: File

    if filename.endsWith(".dsl"):
        f = open(filename)
    else:
        filename = join([filename, ".dsl"])
        f = open(filename)
    defer: f.close()

    for line in f.lines:
        let splittedLine = line.split(" ")
        let cmd: Command = Command(
            command: splittedLine[0],
            args: splittedLine[1..high(splittedLine)]
        )
        instructions.add(cmd)

proc help*(): void =
    echo """ --- FS (FileSystem)
    Commands:
        EOSF (End of save-file)
        LOAD
    
    - EOSF <filename>
    Ends the file editing and runs the script. 
    However, it also immediately saves a .dsl file containing
    the script. The filename parameter is the path it will be
    saved to.

    For example, you could say:
        EOSF Hello.dsl
        EOSF Hello
        EOSF myContent/Hello.dsl
        or
        EOSF myContent/Hello
    
    - LOAD <filename>

    Same usage as the EOSF keyword. However, instead of saving
    a script in a file it will load all the instructions from
    a file into the DSL client. However, this will not affect
    the line count on the left. So practically, this is more like
    the "import" keyword in Python.
    """