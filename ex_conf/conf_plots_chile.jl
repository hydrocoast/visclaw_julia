#### Output
figdir = "./fig/chile2010"
if !isdir(figdir); mkdir(figdir); end

#### basic setup of figure
# color range and color palette
cmap_surf=:coolwarm
clim_surf = (-0.5,0.5)
prefix_surf="plotseta"

# color range and color palette
cmap_current =:isolum
clim_current = (0.0,0.5)
prefix_current="plotsvel"


# lims
xlims=()
ylims=()

### Axes
xlabel = "Longitude"
ylabel = "Latitude"
xticks = ()
yticks = ()
labfont = Plots.font("sans-serif",12)
legfont = Plots.font("sans-serif",10)
tickfont = Plots.font("sans-serif",10)

#### output option
start_number=0
ext=".gif"  # .svg, .png or .gif in Plots
dpi=400 # resolusion dots per inch in case of .png or .gif
fps=4 # frames per second (only gif)
remove_old=true # remove old files
