#### basic setup of figure
maindir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
figdir = "./fig/chile2010"
proj = "X10d"
region = "-120/-60/-60/0"
B = "a15f15 neSW"
V = false

### colormap, colorbar
cmap = :polar
crange = "-1.0/1.0"
Dscale="jBR+w10.0/0.3+o-1.5/0.0" # Dj<justify>+w<length>/<width>+o<dx>/<dy>
Bcb="xa0.2f0.1 y+l(m)" # B option in psscale
Dcb=true
Icb=false
Vcb=false
Zcb=false

#### Coastline
hascoast = true
resolution = "h"
coastpen = "0.01"
landfill = "gray80"
seafill = ""
coastV = false

#### output option
# figdir = #
prefix="eta"
start_number=0
ext=".png"
dpi=400
remove_old=true
