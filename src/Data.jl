# Read configration files

###################################
## Function: geoclaw.data reader
###################################
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
