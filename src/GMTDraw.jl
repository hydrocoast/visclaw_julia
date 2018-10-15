# Functions ti draw figures with GMT package
pen_default="0.02"
titlefont_default=16
titleoffset_default="2p"

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

######################################################################
"""
Draw coastalline to default ps file
"""
function Coast!(; J=""::String, R=""::String, D="i", G=""::String, S=""::String,
                W=pen_default::String, V=true::Bool)
    GMT.coast!(J=J,R=R,D=D,G=G,S=S,W=W,V=V)
    return nothing
end
######################################################################
function Coast!(coastinfo::Claw.CoastSpec)
    if coastinfo.hascoast
        Claw.Coast!(D=coastinfo.D,G=coastinfo.G,S=coastinfo.S,W=coastinfo.W,V=coastinfo.V)
    end
    return nothing
end
######################################################################
"""
Draw coastalline to specified ps file
"""
function CoastPS!(filename; J=""::String, R=""::String, D="i", G=""::String, S=""::String,
                  W=pen_default::String, V=true::Bool)
    opt=""
    if V; opt = opt*" -V"; end
    GMT.gmt("pscoast -J$J -R$R -D$D -G$G -S$S -W$W  $opt -K -P -O >> $filename")
    return nothing
end
######################################################################


"""
Set colorbar to default ps file
"""
function Colorbar!(cpt::GMT.GMTcpt; B=""::String, D=""::String, V=true::Bool)
    if !occursin(r"x",D)
        GMT.colorbar!(J="",R="", B=B, C=cpt, D=D, V=V)
    else
        GMT.colorbar!(B=B, C=cpt, D=D, V=V)
    end
    return nothing
end
######################################################################
"""
Set colorbar to specified ps file
"""
function ColorbarPS!(filename::String, cpt::GMT.GMTcpt; B=""::String, D=""::String, V=true::Bool)
    # building options
    opt=""
    if V; opt = opt*" -V"; end
    # make B option
    Bopt = Claw.setBscript(B)
    # palette output
    cptfile = "tmp.cpt";
    GMT.gmt("write $cptfile",cpt);
    # GMT script
    if !occursin(r"x",D)
        GMT.gmt("psscale -J -R $Bopt -C$cptfile -D$D $opt -K -P -O >> $filename")
    else
        GMT.gmt("psscale $Bopt -C$cptfile -D$D $opt -K -P -O >> $filename")
    end
    #run(`rm $cptfile`)
    return nothing
end
######################################################################

"""
place tiltle to specified psfile
"""
function TitlePS!(filename::String, titlestr::String; font=titlefont_default,
                  offset=titleoffset_default, V=true::Bool)
    # building options
    opt=""
    if V; opt = opt*" -V"; end
    fontopt=""
    if !isempty(font)
        fontopt="--FONT_TITLE=$font"
    end
    offsetopt=""
    if !isempty(offset)
        offsetopt="--MAP_TITLE_OFFSET=$offset"
    end
    # GMT script
    GMT.gmt("psbasemap -J -R -Ba -Bnesw+t\"$titlestr\" $opt -K -P -O $fontopt $offsetopt >> $filename")
    return nothing
    #if !isempty(fontsize)
    #    GMT.gmt("gmtset FONT_TITLE $font")
    #end
    #if !isempty(fontsize)
    #    run(`rm -f gmt.conf`)
    #end
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
                    J=""::String, R=""::String, B=""::String, Q=true, V=true::Bool, bgc="white"::String)
    for i = 1:amrs.nstep
        # basemap
        GMT.basemap(J=J, R=R, B="af nesw+g$bgc", V=V)
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
    # each figure
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
function AMRColorbar!(amrs::Claw.AMR, cpt::GMT.GMTcpt;
                      savedir="."::String, savename="eta"::String,
                      B=""::String, D=""::String, V=true::Bool)
    # each figure
    for i = 1:amrs.nstep
        # filename
        filename = joinpath(savedir,savename)*@sprintf("%03d",i-1)*".ps"
        if !isfile(filename); disp("Not found: $filename"); continue; end;
        Claw.ColorbarPS!(filename, cpt, B=B,D=D,V=V)
    end
    # end (return nothing)
    return nothing

end
######################################################################
######################################################################
function AMRTitle!(amrs::Claw.AMR, title::Vector{String}; font=titlefont_default,
                   offset=titleoffset_default, savedir="."::String, savename="eta"::String, V=true::Bool)
    if amrs.nstep != length(title)
        error("Incorrect size")
        return nothing
    end
    # each figure
    for i = 1:amrs.nstep
        # filename
        filename = joinpath(savedir,savename)*@sprintf("%03d",i-1)*".ps"
        if !isfile(filename); disp("Not found: $filename"); continue; end;
        Claw.TitlePS!(filename, title[i], font=font, V=V)
    end
    # end (return nothing)
    return nothing

end
######################################################################
