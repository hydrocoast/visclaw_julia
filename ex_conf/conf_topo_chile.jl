## chie2010
#### Output
figdir = "./fig/chile2010"
if !isdir(figdir); mkdir(figdir); end
#### basic setup of figure
maindir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
proj = "X10d" # -J, projection
region = "" # -R, region
B = "a15f15 neSW" # -B
V = true # -V, verbose

### colormap, colorbar
cmap = :earth # color table, makecpt
crange = "-7000/4500"  # -T makecpt
Dscale="jBR+w10.0/0.3+o-1.5/0.0" # Dj<justify>+w<length>/<width>+o<dx>/<dy>
Bcb="a1000f500/:\"(m)\":" # -B, psscale
Dcb=true # -D makecpt
Icb=false # -I makecpt
Vcb=true # -V makecpt
Zcb=false # -Z makecpt, no effect when no -T is used, or when using -Tz_min/z_max

#### Coastline
hascoast = true
resolution = "h" # -D, pscoast
coastpen = "0.01"  # -W, pen attribute,
landfill = "" # -G, fill attribute
seafill = "" # -S, fill attribute
coastV = false # -V, verbose

#### output option
prefix=""
start_number=0
ext=".eps"  # .ps, .eps, .png or .gif
dpi=400 # only .png
remove_old=true
