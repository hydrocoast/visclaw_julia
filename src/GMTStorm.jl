Annnot_default = "20"
Contour_default = "10"
Level_default = "960/1020"
pen_default = "thinnest"

######################################################################
"""
Colored contours of the air pressure
"""
function Pressure!(G::GMT.GMTgrid, cpt::GMT.GMTcpt;
                   J=""::String, R=""::String, B=""::String, Q=true:Bool,
                   V=true::Bool)
    GMT.grdimage!(G, J=J, R=R, B=B, C=cpt, Q=true, V=V)
    return nothing
end
######################################################################
"""
Contour lines of the air pressure
"""
function PresContour!(G::GMT.GMTgrid;
                      J=""::String, R=""::String, B=""::String,
                      A=Annnot_default, C=Contour_default, L=Level_default::String, W=pen_default,
                      V=true::Bool)
    # grdcontour
    # GMT.grdcontour!(G, J=J, R=R, B="",A=A, C=C, L=L, W=W, V=V)
    GMT.grdcontour!(G, J=J, R=R, B="", C=C, L=L, W=W, V=V)
    return nothing
end
######################################################################

#=
######################################################################
"""
Wind field with arrows
"""
function Wind!(storm::Claw.stormgrid)

end
######################################################################
=#


######################################################################
function PresTiles!(Gall::Vector{GMT.GMTgrid}, cpt::GMT.GMTcpt;
                    J=""::String, R=""::String, B=""::String, Q=true::Bool, 
                    A=Annnot_default, C=Contour_default, L=Level_default::String, W=pen_default,
                    V=true::Bool)
    for i = 1:length(Gall)
        G = Gall[i]
        Claw.Pressure!(G, cpt, J=J, R=R, B=B, Q=Q, V=V)
    end
    for i = 1:length(Gall)
        G = Gall[i]
        # Claw.PresContour!(G, J=J, R=R, A=A, C=C, L=L, W=W, V=V)
        Claw.PresContour!(G, J=J, R=R, C=C, L=L, W=W, V=V)
    end
    return nothing
end
######################################################################
function AMRPres(amrs::Claw.AMR, cpt::GMT.GMTcpt; outinfo::Claw.OutputSpec=Claw.OutputSpec(),
                 J=""::String, R=""::String, B=""::String, Q=true::Bool,
                 A=Annnot_default, C=Contour_default, L=Level_default::String, W=pen_default,
                 V=true::Bool, bgc="white"::String)
    # prefix
    prefix=joinpath(outinfo.figdir,outinfo.prefix)
    # plot every step
    # for i = 1:1
    for i = 1:amrs.nstep
        # basemap
        GMT.basemap(J=J, R=R, B="af nesw+g$bgc", V=V)
        # makegrd
        tiles = amrs.amr[i]
        G = Claw.tilegrd.(tiles, J=J, V=V);
        # surface
        Claw.PresTiles!(G, cpt, J=J, R=R, Q=Q, A=A, C=C, L=L, W=W, V=V)
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

