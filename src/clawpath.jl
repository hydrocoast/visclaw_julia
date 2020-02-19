### Define your own clawpack path ###
if Sys.islinux() || Sys.isunix()
    const CLAW = ENV["CLAW"]
else
    ## CLAW="/path/to/top/level/clawpack"
    disp("VisClaw.CLAW is not defined. set")
    disp("VisClaw.CLAW = \"/path/to/top/level/clawpack\" ")
    const CLAW = "../clawpack"
    #if !isdir(CLAW); error("CLAW=$CLAW is not correct."); end
end
