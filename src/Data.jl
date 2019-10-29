# Read configration files

###################################
"""
Function: geoclaw.data reader
"""
function GeoData(dirname::String)
    # definition of filename
    fname = joinpath(dirname,"geoclaw.data")
    # check whether exist
    if !isfile(fname); error("File $fname is not found."); end
    # read all lines
    open(fname,"r") do f
        global txt = readlines(f)
    end
    # parse parameters
    cs = parse(Float64,split(txt[occursin.("coordinate",txt)][1],r"\s+")[1])
    p0 = parse(Float64,split(txt[occursin.("ambient_pressure",txt)][1],r"\s+")[1])
    R = parse(Float64,split(txt[occursin.("earth_radius",txt)][1],r"\s+")[1])
    eta0 = parse(Float64,split(txt[occursin.("sea_level",txt)][1],r"\s+")[1])
    n = parse(Float64,split(txt[occursin.("manning_coefficient",txt)][1],r"\s+")[1])
    dmin = parse(Float64,split(txt[occursin.("dry_tolerance",txt)][1],r"\s+")[1])
    # instance
    params = Claw.param(cs,p0,R,eta0,n,dmin)
    # return values
    return params
end
###################################

###################################
"""
Function: surge.data reader
"""
function SurgeData(dirname::String)
    # definition of filename
    fname = joinpath(dirname,"surge.data")
    # check whether exist
    if !isfile(fname); error("File $fname is not found."); end
    # read all lines
    open(fname,"r") do f
        global txt = readlines(f)
    end
    # parse parameters
    windindex = parse(Int64,split(txt[occursin.("wind_index",txt)][1],r"\s+")[1])
    slpindex = parse(Int64,split(txt[occursin.("pressure_index",txt)][1],r"\s+")[1])
    stormtype = parse(Int64,split(txt[occursin.("storm_type",txt)][1],r"\s+")[1])
    landfall = parse(Float64,split(txt[occursin.(" landfall ",txt)][1],r"\s+")[1])
    # instance
    surgedata = Claw.surge(windindex,slpindex,stormtype,landfall)
    # return values
    return surgedata
end
###################################

###################################
"""
Function: gauges.data reader
"""
function GaugeData(dirname::String)
    # definition of filename
    fname = joinpath(dirname,"gauges.data")
    # check whether exist
    if !isfile(fname); error("File $fname is not found."); end
    # read all lines
    open(fname,"r") do f
        global txt = readlines(f)
    end
    # parse parameters
    ngauges = parse(Int64, split(txt[occursin.("ngauges",txt)][1],r"\s+")[1])
    # preallocate
    gaugedata = Vector{Claw.gauge}(undef,ngauges)

    # read gauge info
    baseline = findfirst(x->occursin("ngauges", x), txt)
    for i = 1:ngauges
        txtline = split(txt[baseline+i],r"\s+")
        if isempty(txtline[1]); txtline = txtline[2:end]; end
        label = txtline[1]
        id = parse(Int64,txtline[1])
        loc = [parse(Float64,txtline[2]), parse(Float64,txtline[3])]
        time = [parse(Float64,txtline[4]), parse(Float64,txtline[5])]
        # instance
        gaugedata[i] = Claw.gauge(label,id,0,loc,[],time,[])
    end

    # return values
    return gaugedata
end
###################################
