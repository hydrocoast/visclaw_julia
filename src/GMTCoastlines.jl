# Functions to draw figures with GMT package
pen_default="0.025" # thinnest

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
function Coast!(coastinfo::Claw.CoastSpec; J="")
    if coastinfo.hascoast
        Claw.Coast!(J=J, D=coastinfo.D,G=coastinfo.G,S=coastinfo.S,W=coastinfo.W,V=coastinfo.V)
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


######################################################################
function AMRCoast!(amrs::Claw.AMR; outinfo::Claw.OutputSpec=Claw.OutputSpec(),
                   J=""::String, R=""::String, D="i", G=""::String, S=""::String,
                   W=pen_default::String, V=true::Bool)
    # prefix
    prefix=joinpath(outinfo.figdir,outinfo.prefix)
    # each figure
    for i = 1:amrs.nstep
        # filename
        filename = prefix*@sprintf("%03d",(i-1)+outinfo.start_number)*".ps"
        if !isfile(filename); println("Not found: $filename"); continue; end;
        Claw.CoastPS!(filename,J=J,R=R,D=D,G=G,S=S,W=W,V=V)
    end
    # end (return nothing)
    return nothing
end
######################################################################
