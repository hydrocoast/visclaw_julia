include("./addpath.jl")
using Claw

# topography image with GMT

# -----------------------------
# chile 2010
# -----------------------------
Claw.bathtopo("./ex_conf/conf_gmttopo_chile.jl")
# -----------------------------

# -----------------------------
# ike
# -----------------------------
#Claw.bathtopo("./ex_conf/conf_gmttopo_ike.jl")
# -----------------------------
