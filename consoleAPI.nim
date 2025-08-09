proc printError*(msg: string): void =
    ## Prints critical error to the DSL
    ## console line.
    ## 
    ## # When to use this (preferably):
    ## * A command failed entirely, no return value
    ## 
    ## **params:**
    ##      
    ##      msg: string
    ## 
    ## **returns**:
    ##     
    ##       void
    echo "CRITICAL: " & msg

proc printWarn*(msg: string): void =
    ## Prints warning to the DSL 
    ## console line.
    ## 
    ## # When to use this (preferably):
    ## * A command failed but still returned a value
    ## 
    ## Example:
    ## * The user tries to use a command but it 
    ## * fails so you have to use a fallback function
    ## 
    ## **params:**
    ##      
    ##      msg: string
    ## 
    ## **returns**:
    ##     
    ##       void
    echo "WARNING: " & msg

proc externalPrint*(msg: string): void =
    ## Used to print something that wasn't entered
    ## by the user but rather as a response from the
    ## program.
    ## 
    ## **params:**
    ##      
    ##      name: type
    ## 
    ## **returns**:
    ##     
    ##       name: description
    echo ">> " & msg