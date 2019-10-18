#### output option
figdir = "./fig/chile2010"
if !isdir(figdir); mkdir(figdir); end

#### basic setup of figure
proj = "X10d" # -J option
region = "-120/-60/-60/0" # -R option
B = "a15f15 neSW" # -B option
V = false # -V option (verbose)

### colormap, colorbar
cmap = :polar
crange = "-1.0/1.0"
Dscale="jBR+w10.0/0.3+o-1.5/0.0" # Dj<justify>+w<length>/<width>+o<dx>/<dy>
Bcb="xa0.2f0.1 y+l(m)" # B option in psscale
Dcb=true # -D makecpt
Icb=false # -I makecpt
Vcb=false # -V makecpt
Zcb=false # -Z makecpt, no effect when no -T is used, or when using -Tz_min/z_max

#### Coastline
hascoast = true
resolution = "h" # -D, pscoast
coastpen = "thinnest"  # -W, pen attribute,
landfill = "gray80" # -G, fill attribute
seafill = "" # -S, fill attribute
coastV = false # -V, verbose

#### output option
prefix="eta"
start_number=0
ext=".gif" # .ps, .eps, .png or .gif
dpi=400 # only .png
remove_old=true
fps=4 # only gif

### Time
#origin = "minute" # time origin or unit in String
#format = "%5.0f" # format
#origin = DateTime("2010-02-27T08:01:23")
#format = "yyyy/mm/dd HH:MM" # format
origin = DateTime(2000,1,1)
format = "HH:MM:SS" # format
