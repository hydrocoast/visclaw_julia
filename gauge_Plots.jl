include("./addpath.jl")
using Claw

### Waveform plots from gauges

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")

# conf obs data
conffile = "./ex_conf/conf_plots_gaugeobs_chile.jl"
include(conffile)
lineobs = Claw.PlotsLineSpec(lwobs,lcobs,lsobs)

# conf simulation result
conffile = "./ex_conf/conf_plots_gauge_chile.jl"
pltinfo, axinfo, outinfo, linespec = Claw.PlotsGaugesConf(conffile)

# plot
plt, gauges = Claw.PlotsGaugeEach(simdir, pltinfo, axinfo, outinfo,
                                  linespec=linespec, gaugeobs=gaugeobs, lineobs=lineobs)
# -----------------------------


# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")

# conf simulation result
conffile ="./ex_conf/conf_plots_gauge_ike.jl"
pltinfo, axinfo, outinfo, linespec = Claw.PlotsGaugesConf(conffile)

# plot
plt, gauges = Claw.PlotsGauges(simdir, pltinfo, axinfo, outinfo, linespec=linespec)
# -----------------------------
