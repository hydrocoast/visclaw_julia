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
cmap = :wysiwyg
crange = "960/1020/5"
Dscale="jBR+w9.0/0.3+o-1.0/0.0" # Dj<justify>+w<length>/<width>+o<dx>/<dy>
Bcb="xa10g10 y+lhPa" # B option in psscale
Dcb=true # -D makecpt
Icb=true # -I makecpt
# Ncb=false # -N makecpt
Vcb=false # -V makecpt
Zcb=false # -Z makecpt, no effect when no -T is used, or when using -Tz_min/z_max

### vector
# -A
Vlw = 0.01 # LineWidth
Vhl = 0.10 # HeadLength
Vhs = 0.05 # HeadSize
# -Se <velscale> / <confidence> / <fontsize>
Vscale = 0.025 # velscale
Vconf = 0.0   # confidence
Vfs = 12    # fontsize
# -G
Vcolor = "black"


#### Coastline
hascoast = true
resolution = "h" # -D, pscoast
coastpen = "thinnest,gray80"  # -W, pen attribute,
landfill = "" # -G, fill attribute
seafill = "" # -S, fill attribute
coastV = false # -V, verbose

#### output option
prefix="puv"
start_number=0
ext=".png"  # .ps, .eps, .png or .gif
dpi=400 # only .png
remove_old=true
fps=4 # only gif

### Time
origin = Dates.DateTime(2008,1,1) # time origin or unit in String
format = "yyyy/mm/dd HH:MM" # format
