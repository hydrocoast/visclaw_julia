epsout_default = "topogmt.eps"
###############################################################################################
"""
Draw Topography map in GMT
"""
function GMTTopo(topoinfo::Claw.FigureSpec, cptinfo::Claw.ColorSpec; coastinfo::Claw.CoastSpec=Claw.CoastSpec(), fileout::String=epsout_default)
    # load
    topofile, _ = Claw.topodata(topoinfo.dir)
    geo = Claw.LoadTopo(topofile);

    # options
    J=Claw.geoJ(geo, proj_base=topoinfo.proj)
    R=Claw.geoR(geo)

    # makecpt
    cpt = Claw.geocpt(cptinfo)

    # draw topogpahy with colors
    Claw.TopoMap(geo, cpt, J=J, R=R, B=topoinfo.B, V=topoinfo.V)
    # colorbar option
    Dj= Claw.cboptDj(loc=cptinfo.loc, cbwid=cptinfo.cbsize[1], cblen=cptinfo.cbsize[2],
                     xoff=cptinfo.offset[1],yoff=cptinfo.offset[2])
    # set colorbar
    Claw.Colorbar!(cpt, B=cptinfo.B, D=Dj, V=cptinfo.V)
    # draw coastline if coastinfo.hascoast is true
    Claw.Coast!(coastinfo)

    # output
    output = joinpath(topoinfo.figdir,fileout)
    Claw.saveaseps(output)
    println("Successfully saved to $output")

    # return value
    return geo, J, R, cpt
end
###############################################################################################
function GMTTopo(conf::String="conf_topo.jl"; fileout::String=epsout_default)
    # load configuration - FigureSpec
    include(conf)
    topoinfo = Claw.FigureSpec(maindir,figdir,proj,B,V)
    cptinfo = Claw.ColorSpec(cmap,crange,loc,cbsize,offset,Bcb,Dcb,Icb,Vcb,Zcb)
    coastinfo = Claw.CoastSpec(hascoast,resolution,coastpen,landfill,seafill,coastV)
    # Draw
    geo, J, R, cpt = Claw.GMTTopo(topoinfo, cptinfo, coastinfo=coastinfo, fileout=fileout)

    # return value
    return geo, J, R, cpt
end
###############################################################################################
