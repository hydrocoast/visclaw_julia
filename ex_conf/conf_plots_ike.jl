#### Output
figdir = "./fig/ike"
if !isdir(figdir); mkdir(figdir); end

#### basic setup of figure
# color range and color palette
cmap_surf=:rainbow
clim_surf = (0.0,2.0)
prefix_surf="plotseta"

# color range and color palette
cmap_current =:isolum
clim_current = (0.0,2.0)
prefix_current="plotsvel"

# color range and color palette
cmap_slp =:isolum_r
clim_slp = (960,1000)
prefix_slp="plotsstorm"

# lims
xlims=(-99,-85)
ylims=(22.,32)

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
