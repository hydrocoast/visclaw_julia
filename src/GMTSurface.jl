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
        Claw.Surface!(G, cpt, J=J, R=R, B=B, Q=Q, V=V)
    end
    return nothing
end
######################################################################
function AMRSurf(amrs::Claw.AMR, cpt::GMT.GMTcpt; outinfo::Claw.OutputSpec=Claw.OutputSpec(),
                 J=""::String, R=""::String, B=""::String, Q=true, V=true::Bool, bgc="white"::String)
    # prefix
    prefix=joinpath(outinfo.figdir,outinfo.prefix)
    # plot every step
    for i = 1:amrs.nstep
        # basemap
        GMT.basemap(J=J, R=R, B="af nesw+g$bgc", V=V)
        # makegrd
        tiles = amrs.amr[i]
        G = Claw.tilegrd.(tiles, J=J, V=V)
        # surface
        Claw.SurfTiles!(G, cpt, J=J, R=R, V=V)
        # add frame if exists
        if !isempty(B); GMT.basemap!(J=J, R="", B=B, V=V); end;
        # filename
        filename = prefix*@sprintf("%03d",(i-1)+outinfo.start_number)*".ps"
        # move ps tile
        Claw.moveps(filename)
    end
    return nothing
end
######################################################################
