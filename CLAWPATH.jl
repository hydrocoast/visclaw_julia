### Define your own clawpack path ###
if Sys.islinux() || Sys.isunix()
    CLAW=ENV["CLAW"]
else
    ## CLAW="/path/to/top/level/clawpack"
    CLAW="../clawpack"
    if !isdir(CLAW); error("CLAW=$CLAW is not correct."); end
end
