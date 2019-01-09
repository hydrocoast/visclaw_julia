"""
Make txt file for psvelo (vector field)
"""
function txtvelo_center(LON,LAT,Ux,Uy; skip=1::Int, offset=0::Int, fname="tmpvelo.txt")
    ## count the element
    numel = length(vec(LON[1:skip:end,1:skip:end]))

    ## round
    Ux = round.(Ux, digits=2)
    Uy = round.(Uy, digits=2)

    ## matrix
    outdat = hcat(vec(LON[1:skip:end,1:skip:end]),
                  vec(LAT[1:skip:end,1:skip:end]),
                  vec(Ux[1:skip:end,1:skip:end]) ,
                  vec(Uy[1:skip:end,1:skip:end]) ,
                  repeat([0.0], inner=(numel,4)) )

    ## output to file
    isfile(fname) ? mode="a" : mode="w"
    open(fname,mode) do file
        mode=="a" ? print(file,"\n") : nothing
        Base.print_array(file, outdat)
    end
    ## return
    return nothing
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
