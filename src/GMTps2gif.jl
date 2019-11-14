###################################################
"""
make gif for GMT output
"""
function GMTps2gif(prefix_ps::String, filesequence::AbstractVector{Int64};
                   fps::Int64=4, dpi::Int64=300,
                   remove_ps::Bool=true, remove_pdf::Bool=true, remove_png::Bool=false)

    # only linux of OS X
    if !(Sys.islinux() | Sys.isapple() | Sys.isunix())
        println("unsupperted OS \n return nothing")
        return nothing
    end

    checkpath = read(`which ps2pdf pdfcrop convert ffmpeg`, String)
    if length(split(checkpath,"\n", keepempty=false)) != 4
        println("Either ps2pdf, pdfcrop, convert, ffmpeg is not found. \n return nothing")
        return nothing
    end

    prefix_f = replace(basename(prefix_ps), r"\.([a-z,A-Z]|\d)*" => "")
    prefix_ps = joinpath(dirname(prefix_ps), prefix_f)

    for i in filesequence
        step = @sprintf("%03d",i)
        run(`ps2pdf $(prefix_ps)$(step).ps $(prefix_ps)$(step).pdf`)
        run(`pdfcrop $(prefix_ps)$(step).pdf -margins '10 10 10 10' `)

        if remove_ps; rm(prefix_ps*step*".ps", force=true); end
        rm(prefix_ps*step*".pdf", force=true)

        run(`convert -density $dpi $(prefix_ps)$(step)-crop.pdf $(prefix_ps)$(step).png`)
        if remove_pdf; rm(prefix_ps*step*"-crop.pdf", force=true); end
    end

    sn = filesequence[1]
    vf = length(filesequence)
    run(`ffmpeg -y -i $(prefix_ps)%03d.png -vf palettegen palette.png -loglevel error`)
    run(`ffmpeg -y -r $fps -start_number $sn -i $(prefix_ps)%03d.png -i palette.png -filter_complex paletteuse -vframes $vf $(prefix_ps).gif  -loglevel error`)
    rm("palette.png", force=true)

    if remove_pdf; rm(prefix_ps*step*".png", force=true); end

end
###################################################
GMTps2gif(prefix_ps::String, n::Int64; fps::Int64=4, dpi::Int64=300, remove_ps::Bool=true, remove_pdf::Bool=true, remove_png::Bool=false) =
GMTps2gif(prefix_ps, 1:n; fps=fps, dpi=dpi, remove_ps=remove_ps, remove_pdf=remove_pdf, remove_png=remove_png)
###################################################
