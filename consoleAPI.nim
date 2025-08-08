proc printError*(msg: string): void =
    echo "CRITICAL: " & msg

proc printWarn*(msg: string): void =
    echo "WARNING: " & msg

proc externalPrint*(msg: string): void =
    echo ">> " & msg