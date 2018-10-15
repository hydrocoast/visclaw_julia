## ike
#### Output
figdir = "./fig/ike"
#### basic setup of figure
maindir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
proj = "X12d"
region = ""
B = "a15f15 neSW"
V = true

### colormap, colorbar
cmap = :earth
crange = "-7000/4500"
Dscale="jBR+w5.5/0.2+o-1.0/0.0" # Dj<justify>+w<length>/<width>+o<dx>/<dy>
Bcb="a2000f1000/:\"(m)\":" # B option in psscale
Dcb=true
Icb=false
Vcb=true
Zcb=false

#### Coastline
hascoast = true
resolution = "h"
coastpen = "0.01"
landfill = ""
seafill = ""
coastV = false

#### output option
prefix=""
start_number=0
ext=".png"  # .ps, .eps, .png (, .svg, .gif)
dpi=400 # only .png
remove_old=true
