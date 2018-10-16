#### Output
figdir = "./fig/ike"
if !isdir(figdir); mkdir(figdir); end
#### basic setup of figure
maindir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
proj = "X12/9.6"
region = "d-100/-70/8/32"
B = "a10f10 neSW"
V = false # -V option (verbose)

### colormap, colorbar
cmap = :jet
crange = "0.0/2.0"
Dscale="jBR+w9.0/0.3+o-1.0/0.0" # Dj<justify>+w<length>/<width>+o<dx>/<dy>
Bcb="xa0.5f0.25 y+l(m)" # B option in psscale
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
prefix="eta"
start_number=0
ext=".png"  # .ps, .eps, .png (, .svg, .gif)
dpi=400 # only .png
remove_old=true
fps=4

### Time
origin = Dates.DateTime(2008,1,1) # time origin or unit in String
format = "yyyy/mm/dd HH:MM" # format
