### Configuration for Plots
##### output option
figdir = "./fig/chile2010"
## chile2010
maindir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output");
# color range and color palette
clim_surf = (-0.5,0.5);
cmap_surf=:coolwarm
# color range and color palette
clim_topo = (-6000,6000);
cmap_topo =:delta
# color range and color palette
clim_dtopo = (-2.0,2.0);
cmap_dtopo =:dcoolwarm


### Axes
xlabel = "Longitude"
ylabel = "Latitude"

#### output option
prefix="eta"
start_number=0
ext=".gif"  # .svg, .png or .gif in Plots
dpi=400 # resolusion dots per inch in case of .png or .gif
remove_old=true # remove old files
fps=4 # frames per second (only gif)
