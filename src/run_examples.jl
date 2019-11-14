function run_examples(directory="examples"; kw_exclude=["check", "fgmax"], kw_include=[""])
    if !isdir(directory); println("$directory is not found"); end

    filelist = readdir(directory)
    filter!(x->occursin(".jl", x), filelist)
    filter!(x->!occursin("run_examples.jl", x), filelist)
    map(s->filter!(x->!occursin(s, x), filelist), kw_exclude)
    map(s->filter!(x->occursin(s, x), filelist), kw_include)

    nf = length(filelist)
    println(@sprintf("%d", nf)*" files are found")
    for i = 1:nf
        println("$i/$nf   run "*filelist[i]*" ...")
        @time include(joinpath(directory, filelist[i]))
        println()
    end
end
