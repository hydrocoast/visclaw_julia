# Functions ti draw figures with GMT package

######################################################################
"""
GMTTopo: Topography & bathymetry
"""
function GMTTopo(geo::Claw.geometry, cpt::GMT.GMTcpt; J=""::String, R=""::String,
                 B=""::String, V=true::Bool)
    # makegrd
    G = Claw.geogrd(geo)
    # Topography with grdimage
    GMT.grdimage(G, J=J, R=R, B=B, C=cpt, V=V)

    return nothing
end
######################################################################

"""
Draw coastalline
"""
function GMTCoastLine!(; J=""::String, R=""::String, B=""::String, W="0.05"::String, V=true::Bool)
    GMT.coast!(J=J, R=R, B=B, W=W, V=V)
    return nothing
end
######################################################################

"""
Set Colorbar
"""
function GMTColorbar!(cpt::GMT.GMTcpt; B=""::String, D=""::String, V=true::Bool)
    GMT.colorbar!(B=B, C=cpt, D=D, V=V)
end
######################################################################


#=
"""
Draw the spatial distribution of sea surface elevation in a snapshot
"""
function GMTSurface(amr::Claw.Tiles; palette="polar"::String, crange="-1.0/1.0"::String)
end
######################################################################
=#
