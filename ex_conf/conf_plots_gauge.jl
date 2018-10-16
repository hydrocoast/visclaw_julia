### Configuration for Plots
##### output option
figdir = "./fig/chile2010"
## chile2010
maindir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output");

### lims
sec1h = 3600.
duration = 9. # hour
xlims = (-0.5*sec1h, (duration+0.5)*sec1h)
ylims = (-0.15,0.25)

### Axes
xlabel = "Time since earthquake (hour)"
ylabel = "Amplitude (m)"
xtickv=0:sec1h:sec1h*duration
xtickl=[@sprintf("%d",i) for i=0:duration]
xticks = (xtickv,xtickl)
yticks = ()
labfont = Plots.font(12)
legfont = Plots.font(10)
tickfont = Plots.font(10)

### PlotsLine
lw = 1.0
lc = :auto
ls = :solid

#=
### gauges
#gaugeobs = []
nobs = 1 # the number of observation gauge data
gaugeobs = Vector{Claw.gauge}(undef,nobs)
# gauge 32412
obsfile=joinpath(maindir,"../32412_notide.txt")
obs = readdlm(obsfile)
# Constructor, gauge(label,id,nt,loc,time,eta)
gaugeobs[1]=Claw.gauge("Gauge 32412 Obs.",32412,size(obs,1),gauges[1].loc,obs[:,1],obs[:,2])
=#

#### output option
prefix="eta"
start_number=0
ext=".png"  # .svg, .png or .gif in Plots
dpi=400 # resolusion dots per inch in case of .png or .gif
fps=4 # frames per second (only gif)
remove_old=true # remove old files
