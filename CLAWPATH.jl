### Define my own clawpack path ###
## CLAW="/path/to/top/level/clawpack"
CLAW="../clawpack"
if !isdir(CLAW); error("CLAW=$CLAW is not correct."); end
