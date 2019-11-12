default_masktxt = "topo4mask.txt"
default_maskgrd = "topomask.grd"

function landmask_asc(topo::Claw.geometry, filename::String=default_masktxt)
    xv = vec(repeat(topo.x, inner=(topo.nrows,1)));
    yv = vec(repeat(topo.y, outer=(topo.ncols,1)));
    topov = vec(topo.topo);

    inds = topov .< 0.0 # ocean
    deleteat!(xv, inds)
    deleteat!(yv, inds)
    deleteat!(topov, inds)

    open(filename, "w") do file
        Base.print_array(file, [xv yv topov])
    end
    return filename
end

function landmask_grd(txtfile::String=default_masktxt;
	                  grdfile::String=default_maskgrd, kwargs...)
    # check
    if !isfile(txtfile); error("Not found: $txtfile"); end

    # keyword args
    d = KWARG(kwargs)

    # (part of GMT.jl surface.jl)
    cmd = GMT.parse_common_opts(d, "", [:R :V_params :a :bi :di :e :f :h :i :r :yx])
	#println(cmd)

	# (part of GMT.jl psmask.jl)
	cmd = GMT.parse_common_opts(d, cmd, [:I :UVXY :JZ :c :e :p :r :t :yx :params], true)
	cmd = GMT.parse_these_opts(cmd, d, [[:C :end_clip_path], [:D :dump], [:F :oriented_polygons],
	                [:L :node_grid], [:N :invert], [:Q :cut_number], [:S :search_radius], [:T :tiles]])
	#println(cmd)

    # grid
    GMT.gmt("grdmask \"$txtfile\" $cmd -N0/0/NaN -G\"$grdfile\" ")

    return grdfile
end


###################################################
"""
make a grid file of Claw.Tiles
"""
function tilegrd_mask(tile::Claw.Tiles, maskfile::String=""; spacing_unit::String="", kwargs...)
    # var
    var = Claw.keytile(tile)
    # prameters & options
    R = Claw.getR_tile(tile)
    Δ = tile.dx
    #xvec, yvec, zdata = Claw.tilezcenter(tile, var)
    xvec, yvec, zdata = Claw.tilez(tile, var)
    xmat = repeat(xvec, inner=(length(yvec),1))
    ymat = repeat(yvec, outer=(length(xvec),1))

    tmp_mask = "mask_tile.grd"
	tmp_eta = "eta_tile.grd"
	eta_masked = "eta_masked.grd"

    if !isempty(spacing_unit)
		Δ = "$(Δ)"*spacing_unit
	end

    # makegrd
	# land mask grid
    Claw.landmask_grd(maskfile; grdfile=tmp_mask, R=R, I=Δ, S=Δ, kwargs...)
	# eta grid
	GMT.surface([xmat[:] ymat[:] zdata[:]]; R=R, I=Δ, G=tmp_eta)
	# masking
    GMT.gmt("grdmath $tmp_eta $tmp_mask OR = $eta_masked ")
	# read
	G = GMT.gmt("read -Tg $eta_masked ")

	rm(tmp_mask)
	rm(tmp_eta)
	rm(eta_masked)


    # return value (GMT.GMTgrid)
    return G
end
###################################################

#if !any(.!isnan.(zdata)); return G=nothing; end;
#G = GMT.xyz2grd([xmat[:] ymat[:] zdata[:]], R=R, I=Δ, kwargs...)
#G = GMT.surface([xmat[:] ymat[:] zdata[:]]; R=R, I=Δ, kwargs...)
#G = GMT.nearneighbor([xmat[:] ymat[:] zdata[:]]; R=R, I=Δ, kwargs...)
