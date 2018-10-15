output_default = "topogmt"
###############################################################################################
"""
Draw Topography map in GMT
"""
function bathtopo(topoinfo::Claw.FigureSpec, cptinfo::Claw.ColorSpec;
                  outinfo::Claw.OutputSpec=Claw.OutputSpec(),
                  coastinfo::Claw.CoastSpec=Claw.CoastSpec(),
                  fileout::String=output_default)
    # load
    topofile, _ = Claw.topodata(topoinfo.dir)
    geo = Claw.LoadTopo(topofile);

    # options
    J=Claw.geoJ(geo, proj_base=topoinfo.J)
    if isempty(topoinfo.R)
        R=Claw.geoR(geo)
    else
        R=topoinfo.R
    end

    # makecpt
    cpt = Claw.geocpt(cptinfo)

    # draw topogpahy with colors
    Claw.TopoMap(geo, cpt, J=J, R=R, B=topoinfo.B, V=topoinfo.V)
    #=
    # colorbar option
    Dscale= Claw.cboptDj(loc=cptinfo.loc, cbwid=cptinfo.cbsize[1], cblen=cptinfo.cbsize[2],
                     xoff=cptinfo.offset[1],yoff=cptinfo.offset[2])
    =#
    # set colorbar
    Claw.Colorbar!(cpt, B=cptinfo.B, D=cptinfo.Dscale, V=cptinfo.V)
    # draw coastline if coastinfo.hascoast is true
    Claw.Coast!(coastinfo)

    # output
    output = joinpath(outinfo.figdir,fileout*outinfo.ext)
    if outinfo.ext == ".ps"
        Claw.moveps(output)
    elseif outinfo.ext == ".eps"
        Claw.saveaseps(output)
    elseif outinfo.ext == ".png"
        Claw.saveaspng(output, dpi=outinfo.dpi)
    else
        error("Unacceptable file format: $output")
    end
    println("Successfully saved to $output")

    # return value
    return geo, J, R, cpt
end
###############################################################################################
function bathtopo(conf::String="./conf_topo.jl"; fileout::String=output_default)
    # load configuration - FigureSpec
    include(conf)
    topoinfo = Claw.FigureSpec(maindir,proj,region,B,V)
    cptinfo = Claw.ColorSpec(cmap,crange,Dscale,Bcb,Dcb,Icb,Vcb,Zcb)
    outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,remove_old)
    coastinfo = Claw.CoastSpec(hascoast,resolution,coastpen,landfill,seafill,coastV)
    # Draw
    geo, J, R, cpt = Claw.bathtopo(topoinfo, cptinfo, outinfo=outinfo, coastinfo=coastinfo, fileout=fileout)

    # return value
    return topoinfo, cptinfo, outinfo, coastinfo
end
###############################################################################################
