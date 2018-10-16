#########################################
"""
Struct: configuration for Plots
"""
mutable struct PlotsSpec
    dir::String
    cmap::Symbol
    clim::Tuple{Real,Real}
    xlims::Tuple
    ylims::Tuple
    # Constructor
    Claw.PlotsSpec() = new()
    Claw.PlotsSpec(dir) = new(dir,:coolwarm,(-1.0,1.0),(),())
    Claw.PlotsSpec(dir,arg1,arg2) = isa(arg1,Symbol) ? new(dir,arg1,arg2,(),()) : new(dir,:none,(0.0,0.0),arg1,arg2)
    Claw.PlotsSpec(dir,cmap,clim,xlims,ylims) = new(dir,cmap,clim,xlims,ylims)
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
"""
Struct: Observed data
"""
mutable struct PlotsLineSpec
    width::Float64
    color::Symbol
    style::Symbol
    # Constructor
    Claw.PlotsLineSpec() = new(1.,:auto,:solid)
    Claw.PlotsLineSpec(width) = new(width,:auto,:solid)
    Claw.PlotsLineSpec(width, color, style) = new(width, color, style)
end
#########################################

#########################################
mutable struct MarkerSpec
    msize::Int64
    mcolor::Symbol
    mfont::Plots.Font
    # Constructor
    Claw.MarkerSpec() = new(8,:auto,Plots.font(8,:left,:top,0.0,:black))
    Claw.MarkerSpec(msize,mcolor,mfont) = new(msize,mcolor,mfont)
end
#########################################
