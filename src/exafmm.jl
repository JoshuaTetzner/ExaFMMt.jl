module exafmm

include("common.jl")
include("helmholtz.jl")
include("laplace.jl")
include("modifiedhelmholtz.jl")

export init_sources
export init_targets
export update_charges
export clear_values

export LaplaceFMM
export setup_laplace
export evaluate_laplace

export HelmholtzFMM
export setup_helmholtz
export evaluate_helmholtz

export ModifiedHelmholtzFMM
export setup_modifiedhelmholtz
export evaluate_modifiedhelmholtz

end 
