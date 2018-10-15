
if !(@isdefined CLAW); include("./CLAWPATH.jl"); end

## chie2010
#### topography
maindir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
figdir = "./fig/ike"
proj = "X12d"
B = "a10f10 neSW"
V = true

### colormap, colorbar
cmap = :earth
crange = "-7000/4500"
loc="BR"
cbsize=(0.2,5.5) # width, length
offset=(-1.0,0.0) # dx, dy
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
