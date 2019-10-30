### Configuration for Plots
#### Output
figdir = "./fig/ike"
if !isdir(figdir); mkdir(figdir); end

#### basic setup of figure
### Time
#origin = Dates.DateTime(2008,1,1) # time origin or unit in String
#landfall = Dates.DateTime(2008,9,13,7,0,0) # landfall time
#landtime = convert(Float64, Dates.value(Dates.Second(landfall - origin)));
#format = "yyyy/mm/dd HH:MM" # format

### lims
sec1h = 3600.
sec1d = 24*sec1h
xlims = (-3*sec1d, 1*sec1d)
ylims = (-0.5,4.0)

### Axes
xlabel = "Hours relative to landfall"
xtickv= -3*sec1d:0.5*sec1d:1*sec1d
xtickl=[@sprintf("%d",i) for i=-3*24:12:1*24] # hours
xticks = (xtickv,xtickl)

ylabel = "Surface (m)"
yticks = ()

labfont = Plots.font("sans-serif",12)
legfont = Plots.font("sans-serif",10)
tickfont = Plots.font("sans-serif",10)

#### output option
prefix="waveform_gauge"
start_number=0
ext=".svg"  # .svg, .png or .gif in Plots
dpi=400 # resolusion dots per inch in case of .png or .gif
fps=4 # frames per second (only gif)
remove_old=true # remove old files
