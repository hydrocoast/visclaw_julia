### Configuration for Plots
#### Output
figdir = "./fig/ike"
if !isdir(figdir); mkdir(figdir); end
#### basic setup of figure
maindir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
### Time
origin = Dates.DateTime(2008,1,1) # time origin or unit in String
landfall = Dates.DateTime(2008,9,13,7,0,0) # landfall time
landtime = convert(Float64, Dates.value(Dates.Second(landfall - origin)));

format = "yyyy/mm/dd HH:MM" # format

### lims
sec1h = 3600.
sec1d = 24*sec1h
xlims = (-3*sec1d, 1*sec1h) .+ landtime
ylims = ()

### Axes
xlabel = "Hours relative to landfall"
ylabel = "Surface (m)"
xtickv= -3*sec1d+landtime:0.5*sec1d:1*sec1d+landtime
xtickl=[@sprintf("%d",i) for i=-3*24:12:1*24] # hours
xticks = (xtickv,xtickl)
yticks = ()
labfont = Plots.font(12)
legfont = Plots.font(10)
tickfont = Plots.font(10)

### PlotsLine
lw = 1.0
lc = :auto
ls = :solid

#### output option
prefix="eta"
start_number=0
ext=".svg"  # .svg, .png or .gif in Plots
dpi=400 # resolusion dots per inch in case of .png or .gif
fps=4 # frames per second (only gif)
remove_old=true # remove old files
