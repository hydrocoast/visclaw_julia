# Functions to draw figures with GMT package
titlefont_default=16
titleoffset_default="2p"

######################################################################
"""
place tiltle to specified psfile
"""
function TitlePS!(filename::String, titlestr::String; J=""::String, font=titlefont_default,
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
    GMT.gmt("psbasemap -J$J -R -Ba -Bnesw+t\"$titlestr\" $opt -K -P -O $fontopt $offsetopt >> $filename")
    return nothing
end
######################################################################

######################################################################
function AMRTitle!(amrs::Claw.AMR, title::Vector{String}; outinfo::Claw.OutputSpec=Claw.OutputSpec(),
                   J=""::String, font=titlefont_default, offset=titleoffset_default,  V=true::Bool)
    # prefix
    prefix=joinpath(outinfo.figdir,outinfo.prefix)
    if amrs.nstep != length(title)
        error("Incorrect size")
        return nothing
    end
    # each figure
    for i = 1:amrs.nstep
        # filename
        filename = prefix*@sprintf("%03d",(i-1)+outinfo.start_number)*".ps"
        if !isfile(filename); println("Not found: $filename"); continue; end;
        Claw.TitlePS!(filename, title[i], J=J, font=font, V=V)
    end
    # end (return nothing)
    return nothing

end
######################################################################
