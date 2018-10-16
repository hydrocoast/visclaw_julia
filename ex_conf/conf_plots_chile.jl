#### Output
figdir = "./fig/chile2010"
if !isdir(figdir); mkdir(figdir); end
#### basic setup of figure
maindir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output");
# color range and color palette
cmap_surf=:coolwarm
clim_surf = (-0.5,0.5);
# color range and color palette
cmap_topo =:delta
clim_topo = (-6000,6000);
# color range and color palette
cmap_dtopo =:coolwarm
clim_dtopo = (-3.0,3.0);
# lims
xlims=()
ylims=()

### Axes
xlabel = "Longitude"
ylabel = "Latitude"
xticks = ()
yticks = ()
labfont = Plots.font(12)
legfont = Plots.font(10)
tickfont = Plots.font(10)

#### output option
prefix="plotseta"
start_number=0
ext=".gif"  # .svg, .png or .gif in Plots
dpi=400 # resolusion dots per inch in case of .png or .gif
fps=4 # frames per second (only gif)
remove_old=true # remove old files

### Marker
msize = 4 # markersilze
mcolor = :black # marker face color
mfont = Plots.font(8,:left,:top,0.0,:black) # text font
