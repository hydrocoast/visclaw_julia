### Define my own clawpack path ###
if Sys.islinux()
    CLAW=ENV["CLAW"]
else
    ## CLAW="/path/to/top/level/clawpack"
    CLAW="../clawpack"
    if !isdir(CLAW); error("CLAW=$CLAW is not correct."); end
end
