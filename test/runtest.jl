if !any(occursin.("gmt/lib", Base.DL_LOAD_PATH))
    push!(Base.DL_LOAD_PATH, joinpath(ENV["HOME"],"gmt/lib")
end

using VisClaw
using Test

@testset "VisClaw.jl" begin
    if isempty(CLAW)
    exdir_chile = joinpath(ENV["HOME"],"clawpack-v5.6.1/geoclaw/examples/tsunami/chile2010/_output")
    exdir_ike = joinpath(ENV["HOME"],"clawpack-v5.6.1/geoclaw/examples/storm-surge/ike/_output")

    @test 1==1
end
