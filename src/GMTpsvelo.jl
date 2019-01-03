"""
psvelo
"""
###################################################
function psvelo(filename::String, psname::String=GMT.fname_out(Dict())[1];
                J="", R="", B="", A="", G="", S="",
                V::Bool=true, P::Bool=true, O::Bool=true, K::Bool=true)

    # TF options
    opts=""
    V ? opts = opts*" -V" : nothing
    P ? opts = opts*" -P" : nothing
    O ? opts = opts*" -O" : nothing
    K ? opts = opts*" -K" : nothing

    # -O option
    O ? operator=" >> " : operator=" > "

    # -B option
    if isempty(B)
        Bopt=""
    else
        if occursin(r"\s+",B)
            B = split(B)
        end
        if length(B) == 1
            Bopt = "-B"*B
        elseif length(B) == 2
            Bopt = "-B"*B[1]*" -B"*B[2]
        end
    end

    # GMT command
    GMT.gmt("psvelo $filename -J$J -R$R $Bopt -A$A -G$G -S$S $opts $operator $psname")

    return nothing
end
###################################################
psvelo!(filename::String, psname::String=GMT.fname_out(Dict())[1];
        J="", R="", B="", A="", G="", S="",
        V::Bool=true, P::Bool=true, K::Bool=true) =
psvelo(filename,psname,J=J,R=R,B=B,A=A,G=G,S=S,V=V,P=P,K=K,O=true)
###################################################
