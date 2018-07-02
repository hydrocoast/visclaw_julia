# Functions to load and print out the clawpack output
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

module AMR
    ###################################
    ## Struct:
    ##  data container of single patch
    ###################################
    mutable struct patchdata
        gridnumber::Int
        AMRlevel::Int
        mx::Int
        my::Int
        xlow::Float64
        ylow::Float64
        dx::Float64
        dy::Float64
        eta::AbstractArray{Float64,2}
        #AMRData() = new()
    end
    ###################################
    ## Struct:
    ##  time-seies of AMR data
    ###################################
    mutable struct amrdata
        nstep::Int
        timelap::AbstractArray{Float64,1}
        amr::AbstractArray{AbstractArray{AMR.patchdata,1},1}
    end
    ###################################
end
