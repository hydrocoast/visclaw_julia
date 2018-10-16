#########################################
"""
Struct: configuration for Plots
"""
mutable struct PlotsSpec
    dir::String
    cmap::Symbol
    clim::Tuple{Real,Real}
    # Constructor
    Claw.PlotsSpec() = new()
    Claw.PlotsSpec(dir) = new(dir,:coolwarm,(-1.0,1.0))
    Claw.PlotsSpec(dir,cmap,clim) = new(dir,cmap,clim)
end
#########################################

#########################################
"""
Struct: configuration for Plots
"""
mutable struct PlotsAxes
    xlabel::String
    ylabel::String
    xticks::Tuple
    yticks::Tuple
    labfont::Plots.Font
    legfont::Plots.Font
    tickfont::Plots.Font
    # Constructor
    Claw.PlotsAxes() = new("Longitude","Latitude",(),(),Plots.font(12),Plots.font(10),Plots.font(10))
    Claw.PlotsAxes(xlabel,ylabel) = new(xlabel,ylabel,(),(),Plots.font(12),Plots.font(10),Plots.font(10))
    Claw.PlotsAxes(xlabel,ylabel,labfont,legfont,tickfont) = new(xlabel,ylabel,(),(),labfont,legfont,tickfont)
    Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont) = new(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
end
#########################################

#########################################
#"""
#Struct:
#"""

#########################################
