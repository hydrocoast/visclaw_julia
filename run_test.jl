using Printf

filelist = readdir()
filter!(x->occursin(".jl", x), filelist)
filter!(x->occursin("chile", x), filelist)
filter!(x->!occursin("check", x), filelist)

filter!(x->occursin("watersurface_GMT", x), filelist)

nf = length(filelist)
println(@sprintf("%d", nf)*" files are found")
for i = 1:nf
    println("$i/$nf \t run "*filelist[i]*" ...")
    @time include(filelist[i])
    println("")
end
