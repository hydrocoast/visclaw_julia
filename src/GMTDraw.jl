# Functions ti draw figures with GMT package
pen_default="0.02"

######################################################################
"""
Fill colors to topography and bathymetry surface
"""
function TopoMap(geo::Claw.geometry, cpt::GMT.GMTcpt; J=""::String, R=""::String,
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
function Coast!(; J=""::String, R=""::String, D="i", G=""::String, S=""::String,
                W=pen_default::String, V=true::Bool)
    GMT.coast!(J=J,R=R,D=D,G=G,S=S,W=W,V=V)
    return nothing
end
######################################################################
"""
Draw coastalline to ps file
"""
function CoastPS!(filename; J=""::String, R=""::String, D="i", G=""::String, S=""::String,
                  W=pen_default::String, V=true::Bool)
    opt=""
    if V; opt = opt*" -V"; end
    GMT.gmt("pscoast -J$J -R$R -D$D -G$G -S$S -W$W  $opt -K -O >> $filename")
    return nothing
end
######################################################################


"""
Set Colorbar
"""
function Colorbar!(cpt::GMT.GMTcpt; B=""::String, D=""::String, V=true::Bool)
    GMT.colorbar!(B=B, C=cpt, D=D, V=V)
    return nothing
end
######################################################################


"""
Draw the spatial distribution of sea surface elevation in a snapshot
"""
function Surface!(G::GMT.GMTgrid, cpt::GMT.GMTcpt; J=""::String, R=""::String,
                     B=""::String, Q=true, V=true::Bool)
    GMT.grdimage!(G, J=J, R=R, B=B, C=cpt, Q=Q, V=V)
    return nothing
end
######################################################################
function SurfTiles!(Gall::Vector{GMT.GMTgrid}, cpt::GMT.GMTcpt; J=""::String, R=""::String,
                       B=""::String, Q=true, V=true::Bool)
    for i = 1:length(Gall)
        G = Gall[i]
        Claw.Surface!(G,cpt,J=J,R=R,B=B,Q=Q,V=V)
    end
    return nothing
end
######################################################################
function AMRSurf(amrs::Claw.AMR, cpt::GMT.GMTcpt; savedir="."::String, savename="eta"::String,
                    J=""::String, R=""::String, B=""::String, Q=true, V=true::Bool)
    for i = 1:amrs.nstep
        # basemap
        GMT.basemap(J=J, R=R, B="af nesw", V=V)
        # makegrd
        tiles = amrs.amr[i]
        G = Claw.tilegrd.(tiles, V=V);
        # surface
        Claw.SurfTiles!(G,cpt,R=R,V=V)
        # add frame if exists
        if !isempty(B); GMT.basemap!(J="", R="", B=B, V=V); end;
        # filename
        filename = joinpath(savedir,savename)*@sprintf("%03d",i-1)*".ps"
        # move ps tile
        Claw.moveps(filename)
    end
    return nothing
end
######################################################################
function AMRCoast!(amrs::Claw.AMR; savedir="."::String, savename="eta"::String,
                   J=""::String, R=""::String, D="i", G=""::String, S=""::String,
                   W=pen_default::String, V=true::Bool)
    # each
    for i = 1:amrs.nstep
        # filename
        filename = joinpath(savedir,savename)*@sprintf("%03d",i-1)*".ps"
        if !isfile(filename); disp("Not found: $filename"); continue; end;
        Claw.CoastPS!(filename,J=J,R=R,D=D,G=G,S=S,W=W,V=V)
    end
    # end (return nothing)
    return nothing
end
######################################################################
