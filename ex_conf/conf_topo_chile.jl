## chie2010
#### basic setup of figure
maindir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
figdir = "./fig/chile2010"
proj = "X10d"
region = ""
B = "a15f15 neSW"
V = true

### colormap, colorbar
cmap = :earth
crange = "-7000/4500"
Dscale="jBR+w10.0/0.3+o-1.5/0.0" # Dj<justify>+w<length>/<width>+o<dx>/<dy>
Bcb="a1000f500/:\"(m)\":" # B option in psscale
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
