### Configuration for Plots
##### output option
figdir = "./fig/chile2010"
## chile2010
maindir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output");
# color range and color palette
cmap_surf=:coolwarm
clim_surf = (-0.5,0.5);
# color range and color palette
cmap_topo =:delta
clim_topo = (-6000,6000);
# color range and color palette
cmap_dtopo =:coolwarm
clim_dtopo = (-2.0,2.0);


### Axes
xlabel = "Longitude"
ylabel = "Latitude"
xticks = ()
yticks = ()
labfont = Plots.font(12)
legfont = Plots.font(10)
tickfont = Plots.font(10)

#### output option
prefix="eta"
start_number=0
ext=".png"  # .svg, .png or .gif in Plots
dpi=400 # resolusion dots per inch in case of .png or .gif
fps=4 # frames per second (only gif)
remove_old=true # remove old files
