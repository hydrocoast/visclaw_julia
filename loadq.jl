# Functions to load and print out the clawpack output
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

###################################
## Struct: data container for AMR
###################################
mutable struct amrdata
	gridnumber::Int
    AMRlevel::Int
    mx::Int
    my::Int
    xlow::Float64
    ylow::Float64
    dx::Float64
    dy::Float64
    eta::AbstractArray{Float64, 2}
    #amrdata() = new()
end
###################################

#################################
## Function: fort.qxxxx reader
#################################
function LoadFortq(filename::String; ncol=4::Int)
    ## file open
    f = open(filename,"r")
    txtorg = readlines(f)
    close(f) #close

    ## count the number of lines and grids
    nlineall = length(txtorg)
	idx = contains.(txtorg,"grid_number")
	ngrid = length(txtorg[idx])
    #ngrid = sum()

    ## preallocate
    amr = Array{amrdata}(ngrid)

    l = 1
	i = 1
    while l < nlineall
        ## read header
        #header = txtorg[1:8]
        header = txtorg[l:l+7]
        gridnumber = parse(Int64, header[1][1:6])
        AMRlevel = parse(Int64, header[2][1:6])
        mx = parse(Int64, header[3][1:6])
        my = parse(Int64, header[4][1:6])
        xlow = parse(Float64, header[5][1:18])
        ylow = parse(Float64, header[6][1:18])
        dx = parse(Float64, header[7][1:18])
        dy = parse(Float64, header[8][1:18])
        ## read variables
        body = txtorg[l+9:l+9+(mx+1)*my-1]
        vars = [parse(Float64, body[(i-1)*(mx+1)+j][26*(ncol-1)+1:26*ncol]) for i=1:my, j=1:mx]

        ## array
        amr[i] = amrdata(gridnumber,AMRlevel,mx,my,xlow,ylow,dx,dy,vars)

        ## print
        #@printf("%d, ",gridnumber)

        ## counter; go to the next grid
		i += 1
        l = l+9+(mx+1)*my
    end
    ## return
    return amr
end
#################################
## Function: load time
#################################
function LoadFortt(filename::String)
	## file open
    f = open(filename,"r")
    txtorg = readlines(f)
    close(f) #close
    ## parse timelaps from the 1st line
	timelaps = parse(Float64, txtorg[1][1:18])
	## return
	return timelaps
end
#################################
## Function: pseudocolor
#################################
function DrawAMR2D!(plt, amr::T, cmap::Symbol; showtile=false::Bool, annots=false::Bool) where T<:Array{amrdata,1}
	### using Plots; gr(); clibrary(:colorcet)
	## the number of tiles
	ntile = length(amr)
	## preallocate
	xp = zeros(ntile,2);
	yp = zeros(ntile,2);
	## display each tile
    for j = 1:ntile
		## set the boundary
		xp[j,:] = [amr[j].xlow, amr[j].xlow+amr[j].dx*amr[j].mx]
		yp[j,:] = [amr[j].ylow, amr[j].ylow+amr[j].dy*amr[j].my]

		## grid info
		xvec = collect(Float64, xp[j,1]-0.5amr[j].dx:amr[j].dx:xp[j,2]+0.5amr[j].dx+1e-4);
		yvec = collect(Float64, yp[j,1]-0.5amr[j].dy:amr[j].dy:yp[j,2]+0.5amr[j].dy+1e-4);
		## adjust data
        val = zeros(amr[j].my+2,amr[j].mx+2)
		val[2:end-1,2:end-1] = amr[j].eta
		val[2:end-1,1] = val[2:end-1,2]
		val[2:end-1,end] = val[2:end-1,end-1]
		val[1,:] = val[2,:]
		val[end,:] = val[end-1,:]

		## plot
	    plt = contour!(plt,xvec,yvec,val, c=(cmap), fill=true,
   	                   clims=(-0.5,0.5), colorbar=false, tickfont=12)

		### colorbar ?????
	    #if j==ntile; plt=plot!(plt,colorbar=true); end
    end

	## Boundaries
	if showtile
		for j = 1:ntile
			plt = plot!([xp[j,1],xp[j,1],xp[j,2],xp[j,2],xp[j,1]],
			            [yp[j,1],yp[j,2],yp[j,2],yp[j,1],yp[j,1]],
			            c=(:black), linestyle=:solid, label="")
		end
    end
	## Annotations of the grid number
	if annots
		for j = 1:ntile
			plt = annotate!([(mean(xp[j,:]), mean(yp[j,:]),
			                  @sprintf("%02d", amr[j].gridnumber))], fontsize=10)
		end
	end
	## Appearances
	plt = plot!(plt, axis_ratio=:equal, xlabel="Longitude", ylabel="Latitude",
                guidefont=font("sans-serif",10), titlefont=font("sans-serif",10))
	#plt = plot!(plt, xlims=(xp[1,1], xp[1,2]),ylims=(yp[1,1], yp[1,2]))

	## return value
    return plt
end

#################################

#################################
## Function: save figures as svg
#################################
function  PlotTimeSeries(loaddir::String, cmap::Symbol; col=4::Int, tile=false::Bool, ann=false::Bool)

	 ## define the filepath & filename
	 fnamekw = "fort.q"

	 ## make a list
	 if !isdir(loaddir); error("Directory $loaddir doesn't exist"); end
	 flist = readdir(loaddir)
	 idx = contains.(flist,fnamekw)
	 if sum(idx)==0; error("Not found"); end
	 flist = flist[idx]

	 ## the number of files
	 nfile = length(flist)
	 ## load all files
	 amr = Array{AbstractArray{amrdata,1}}(nfile)
	 tlap = zeros(nfile,1)
	 for it = 1:nfile
	     amr[it] = LoadFortq(joinpath(loaddir,flist[it]), ncol=col)
	 	tlap[it] = LoadFortt(replace(joinpath(loaddir,flist[it]), "\.q","\.t"))
	 end

	 ## plot time-series
	 plt = Array{Plots.Plot}(nfile)
	 for i = 1:nfile
	 #for i = 1:1
	 	plt[i] = plot(title=@sprintf("%8.1f",tlap[i])*" s", layout=(1,1))
	 	plt[i] = DrawAMR2D!(plt[i],amr[i], cmap, showtile=tile, annots=ann)
	 end

	 ## return plots
	 return amr, plt, nfile
end
#################################
