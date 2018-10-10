# Functions ti draw figures with GMT package
pen_default="0.02"

######################################################################
"""
GMTTopo: Topography & bathymetry
"""
function GMTTopo(geo::Claw.geometry, cpt::GMT.GMTcpt; J=""::String, R=""::String,
                 B=""::String, Q=true, V=true::Bool)
    # makegrd
    G = Claw.geogrd(geo)
    # Topography with grdimage
    GMT.grdimage(G, J=J, R=R, B=B, C=cpt, Q=Q, V=V)

    return nothing
end
######################################################################

"""
Draw coastalline
"""
function GMTCoastLine!(; J=""::String, R=""::String, W=pen_default::String, V=true::Bool)
    GMT.coast!(J=J, R=R, W=W, V=V)
    return nothing
end
######################################################################
"""
Draw coastalline to ps file
"""
function GMTCoastLinePS!(filename; J=""::String, R=""::String, W=pen_default::String, V=true::Bool)
    opt=""
    if V; opt = opt*" -V"; end
    GMT.gmt("pscoast -J$J -R$R -W$W $opt -K -O >> $filename")
    return nothing
end
######################################################################


"""
Set Colorbar
"""
function GMTColorbar!(cpt::GMT.GMTcpt; B=""::String, D=""::String, V=true::Bool)
    GMT.colorbar!(B=B, C=cpt, D=D, V=V)
    return nothing
end
######################################################################



"""
Draw the spatial distribution of sea surface elevation in a snapshot
"""
function GMTSurface!(G::GMT.GMTgrid, cpt::GMT.GMTcpt; J=""::String, R=""::String,
                     B=""::String, Q=true, V=true::Bool)
    GMT.grdimage!(G, J=J, R=R, B=B, C=cpt, Q=Q, V=V)
    return nothing
end
######################################################################
function GMTSurfTiles!(Gall::Vector{GMT.GMTgrid}, cpt::GMT.GMTcpt; J=""::String, R=""::String,
                       B=""::String, Q=true, V=true::Bool)
    for i = 1:length(Gall)
        G = Gall[i]
        Claw.GMTSurface!(G,cpt,J=J,R=R,B=B,Q=Q,V=V)
    end
    return nothing
end
######################################################################
function GMTAMRSurf(amrs::Claw.AMR, cpt::GMT.GMTcpt; savedir="."::String, savename="eta"::String,
                    J=""::String, R=""::String, B=""::String, Q=true, V=true::Bool)
    for i = 1:amrs.nstep
        # basemap
        GMT.basemap(J=J, R=R, B=B, V=V)
        # makegrd
        tiles = amrs.amr[i]
        G = Claw.tilegrd.(tiles, V=V);
        # surface
        Claw.GMTSurfTiles!(G,cpt,R=R,V=V)
        # filename
        filename = joinpath(savedir,savename)*@sprintf("%03d",i-1)*".ps"
        # move ps tile
        Claw.moveps(filename)
    end
    return nothing
end
######################################################################
function GMTAMRCoast!(amrs::Claw.AMR; savedir="."::String, savename="eta"::String,
                      J=""::String, R=""::String, W=pen_default::String, V=true::Bool)
    for i = 1:amrs.nstep
        # filename
        filename = joinpath(savedir,savename)*@sprintf("%03d",i-1)*".ps"
        Claw.GMTCoastLinePS!(filename, J=J,R=R,W=W,V=V)
    end
    return nothing
end
######################################################################
