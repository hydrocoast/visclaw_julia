"""
Make txt file for psvelo (vector field)
"""
function txtvelo(LON,LAT,Ux,Uy; skip=1::Real)
    tmpname = "tmpwind.txt"
    numel = length(LON[2:skip:end-1,2:skip:end-1])
    outdat = [vec(LON[2:skip:end-1,2:skip:end-1]) vec(LAT[2:skip:end-1,2:skip:end-1]) vec(Ux[2:skip:end-1,2:skip:end-1]) vec(Uy[2:skip:end-1,2:skip:end-1]) repeat([0.0], inner=(numel,4)) ]
    open(tmpname,"w") do file
        Base.print_array(file, outdat)
    end

    return tmpname
end


"""
Make txt file for scale (psvelo)
"""
function txtveloscale(X,Y,Uscale; unit::String="m/s")
    tmpname = "tmpscale.txt"

    #Long. Lat. Evel Nvel Esig Nsig CorEN SITE
    outdat = "$X $Y $Uscale 0.0  0.0 0.0 0.0 $Uscale $unit"
    open(tmpname,"w") do file
        @printf(file, "%s",outdat)
    end

    return tmpname
end
