# Functions to draw figures with GMT package

######################################################################
"""
Set colorbar to default ps file
"""
function Colorbar!(cpt::GMT.GMTcpt; J=""::String, B=""::String, D=""::String, V=true::Bool)
    if !occursin(r"x",D)
        GMT.colorbar!(J=J, R="", B=B, C=cpt, D=D, V=V)
    else
        GMT.colorbar!(J=J, B=B, C=cpt, D=D, V=V)
    end
    return nothing
end
######################################################################
"""
Set colorbar to specified ps file
"""
function ColorbarPS!(filename::String, cpt::GMT.GMTcpt; J=""::String, B=""::String, D=""::String, V=true::Bool)
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
        GMT.gmt("psscale -J$J -R $Bopt -C$cptfile -D$D $opt -K -P -O >> $filename")
    else
        GMT.gmt("psscale -J$J $Bopt -C$cptfile -D$D $opt -K -P -O >> $filename")
    end
    #run(`rm $cptfile`)
    return nothing
end
######################################################################


######################################################################
function AMRColorbar!(amrs::Claw.AMR, cpt::GMT.GMTcpt; outinfo::Claw.OutputSpec=Claw.OutputSpec(),
                      J=""::String, B=""::String, D=""::String, V=true::Bool)
    # prefix
    prefix=joinpath(outinfo.figdir,outinfo.prefix)
    # each figure
    for i = 1:amrs.nstep
        # filename
        filename = prefix*@sprintf("%03d",(i-1)+outinfo.start_number)*".ps"
        if !isfile(filename); println("Not found: $filename"); continue; end;
        Claw.ColorbarPS!(filename, cpt, J=J, B=B,D=D,V=V)
    end
    # end (return nothing)
    return nothing

end
######################################################################

