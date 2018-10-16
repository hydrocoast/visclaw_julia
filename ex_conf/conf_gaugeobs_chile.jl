### gauges
#gaugeobs = []
nobs = 1 # the number of observation gauge data
gaugeobs = Vector{Claw.gauge}(undef,nobs)
# gauge 32412
obsfile=joinpath(maindir,"../32412_notide.txt")
obs = readdlm(obsfile)
# Constructor, gauge(label,id,nt,time,eta)
gaugeobs[1]=Claw.gauge("Gauge 32412 Obs.",32412,size(obs,1),obs[:,1],obs[:,2])

### PlotsLine
lwobs = 0.5
lcobs = :black
lsobs = :dash
