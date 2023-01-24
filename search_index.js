var documenterSearchIndex = {"docs":
[{"location":"gettingstarted/#Installation","page":"Getting Started","title":"Installation","text":"","category":"section"},{"location":"gettingstarted/","page":"Getting Started","title":"Getting Started","text":"The package can be installed with the package manager by ","category":"page"},{"location":"gettingstarted/","page":"Getting Started","title":"Getting Started","text":"import Pkg\nPkg.add(\"https://github.com/JoshuaTetzner/ExaFMMt.jl.git\")","category":"page"},{"location":"gettingstarted/#First-steps","page":"Getting Started","title":"First steps","text":"","category":"section"},{"location":"gettingstarted/","page":"Getting Started","title":"Getting Started","text":"A simple Laplace FMM of a random distribution of charges is computed by the following code:","category":"page"},{"location":"gettingstarted/","page":"Getting Started","title":"Getting Started","text":"using ExaFMMt\nsources = rand(Float64, 100, 3)\ntargets = rand(Float64, 100, 3)\ncharges = rand(Float64, 100)\n\nA = setup(sources, targets, LaplaceFMMOptions())\ny = A * charges","category":"page"},{"location":"gettingstarted/","page":"Getting Started","title":"Getting Started","text":"The variable A resembles the FMM-matrix and can be multiplied by a vector of Float64 charges with 100 elements. ","category":"page"},{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"The FMM evaluates per default in 64 bits representation. If the input values are all given in 32 bit representation the code changes to 32 bit calculations. Errors may occur if 32 and 64 bit representations are mixed.","category":"page"},{"location":"examples/#Laplace-FMM","page":"Examples","title":"Laplace FMM","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using ExaFMMt\n\n# 64 bit representation\nn = 10000\nsources = rand(Float64, n, 3)\ntargets = rand(Float64, n, 3)\ncharges = rand(Float64, n)\n\nA = setup(sources, targets, LaplaceFMMOptions())\ny = A * charges\n\n# 32 bit representation\nsources = rand(Float32, n, 3)\ntargets = rand(Float32, n, 3)\ncharges = rand(Float32, n)\n\nA = setup(sources, targets, LaplaceFMMOptions())\ny = A * charges","category":"page"},{"location":"examples/#Helmholtz-FMM","page":"Examples","title":"Helmholtz FMM","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using ExaFMMt\n\n# 64 bit representation\nn = 10000\nsources = rand(Float64, n, 3)\ntargets = rand(Float64, n, 3)\ncharges = rand(ComplexF64, n)\nwavek = ComplexF64.(1.0 + 1.0*im)\n\nA = setup(sources, targets, HelmholtzFMMOptions(wavek))\ny = A * charges\n\n# 32 bit representation\nsources = rand(Float32, n, 3)\ntargets = rand(Float32, n, 3)\ncharges = rand(ComplexF32, n)\nwavek = ComplexF32.(1.0 + 1.0*im)\n\nA = setup(sources, targets, HelmholtzFMMOptions(wavek))\ny = A * charges","category":"page"},{"location":"examples/#Modified-Helmholtz-FMM","page":"Examples","title":"Modified-Helmholtz FMM","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using ExaFMMt\n\n# 64 bit representation\nn = 10000\nsources = rand(Float64, n, 3)\ntargets = rand(Float64, n, 3)\ncharges = rand(Float64, n)\nwavek = Float64(1.0)\n\nA = setup(sources, targets, ModifiedHelmholtzFMMOptions(wavek))\ny = A * charges\n\n# 32 bit representation\nsources = rand(Float32, n, 3)\ntargets = rand(Float32, n, 3)\ncharges = rand(Float32, n)\nwavek = Float32(1.0)\n\nA = setup(sources, targets, ModifiedHelmholtzFMMOptions(wavek))\ny = A * charges","category":"page"},{"location":"advancedtopics/#Advanced-Topics","page":"Avanced Topics","title":"Advanced Topics","text":"","category":"section"},{"location":"advancedtopics/#FMM_BEM","page":"Avanced Topics","title":"Fast Multipole Methode(FMM) with the Boundary Element Method (BEM)","text":"","category":"section"},{"location":"advancedtopics/","page":"Avanced Topics","title":"Avanced Topics","text":"There are different ways to use a FMM with a BEM. Most approaches require an internal modification of the FMM. Since an implementation of a high performance FMM is quiet difficult and is required when changing the internal structure, using highly optimized implementation such as exafmm-t is often the best approach.","category":"page"},{"location":"advancedtopics/","page":"Avanced Topics","title":"Avanced Topics","text":"In such an approach the FMM is used as a black box to compute point to point interactions. The points are quadrature points on each triangle of the mesh. Additionally the test and trail functions functions must be considered, which is done by weighted sums over both functions.","category":"page"},{"location":"advancedtopics/","page":"Avanced Topics","title":"Avanced Topics","text":"Integrating with a quadrature only works out for far triangles which are well separated. For close interactions the function becomes singular and the integral inaccurate. This inaccuracy must be corrected by subtraction of a correction matrix containing all close interactions from the FMM evaluation. The close interactions can afterwards be computed directly and added to the rest. ","category":"page"},{"location":"advancedtopics/","page":"Avanced Topics","title":"Avanced Topics","text":"As a formula this reads as follows","category":"page"},{"location":"advancedtopics/","page":"Avanced Topics","title":"Avanced Topics","text":"Ax = B_2^T(G-C)B_1x + Sx","category":"page"},{"location":"advancedtopics/","page":"Avanced Topics","title":"Avanced Topics","text":"where G is the evaluation done by the FMM, C the correction matrix of the close interaction, P_1 and P_2 the matrices resembling the test and trail functions and S the directly computed close interactions. ","category":"page"},{"location":"advancedtopics/","page":"Avanced Topics","title":"Avanced Topics","text":"More detailed information on this topic can be found in ","category":"page"},{"location":"advancedtopics/","page":"Avanced Topics","title":"Avanced Topics","text":"Wang, Tingyu, Christopher D. Cooper, Timo Betcke, and Lorena A. Barba. “High-Productivity, High-Performance Workflow for Virus-Scale Electrostatic Simulations with Bempp-Exafmm.” arXiv, March 20, 2021. http://arxiv.org/abs/2103.01048.\nAdelman, Ross, Nail A. Gumerov, and Ramani Duraiswami. “FMM/GPU-Accelerated Boundary Element Method for Computational Magnetics and Electrostatics.” IEEE Transactions on Magnetics 53, no. 12 (December 2017): 1–11. https://doi.org/10.1109/TMAG.2017.2725951.","category":"page"},{"location":"functions_types/#Functions-and-Types","page":"Types and Functions","title":"Functions and Types","text":"","category":"section"},{"location":"functions_types/#Types","page":"Types and Functions","title":"Types","text":"","category":"section"},{"location":"functions_types/","page":"Types and Functions","title":"Types and Functions","text":"ExaFMMt.HelmholtzFMMOptions{I, C}\nExaFMMt.ModifiedHelmholtzFMMOptions{I, F}\nExaFMMt.LaplaceFMMOptions{I}\nExaFMMt.ExaFMM{K}","category":"page"},{"location":"functions_types/#ExaFMMt.HelmholtzFMMOptions","page":"Types and Functions","title":"ExaFMMt.HelmholtzFMMOptions","text":"HelmholtzFMMOptions{I, C} <: FMMOptions\n\nHelmoltz-initializer for setup function.  \n\nFields\n\np::I: Multipole expansion order.\nncrit::I: Minimum number of points in each box of the tree.\nwavek::C: Wavenumber.\n\n\n\n\n\n","category":"type"},{"location":"functions_types/#ExaFMMt.ModifiedHelmholtzFMMOptions","page":"Types and Functions","title":"ExaFMMt.ModifiedHelmholtzFMMOptions","text":"ModifiedHelmholtzFMMOptions{I, F} <: FMMOptions\n\nModified-Helmoltz-initializer for setup function. \n\nFields\n\np::I: Multipole expansion order.\nncrit::I: Minimum number of points in each box of the tree.\nwavek::F: Wavenumber.\n\n\n\n\n\n","category":"type"},{"location":"functions_types/#ExaFMMt.LaplaceFMMOptions","page":"Types and Functions","title":"ExaFMMt.LaplaceFMMOptions","text":"LaplaceFMMOptions{I} <: FMMOptions\n\nLaplace-initializer for setup function. \n\nFields\n\np::I: Multipole expansion order.\nncrit::I: Minimum number of points in each box of the tree.\n\n\n\n\n\n","category":"type"},{"location":"functions_types/#ExaFMMt.ExaFMM","page":"Types and Functions","title":"ExaFMMt.ExaFMM","text":"ExaFMM{K} <: LinearMaps.LinearMap{K}\n\nIs an type resembling the fmm matrix and can be multipied by a vector resembling for example the charges of the source points. This type is necassary for the garbage collector to free the allocated storage of the C++ part.\n\nFields\n\nfmmoptions::FMMOptions: Initializer either LaplaceFMMOptions, HelmholtzFMMOptions or ModifiedHelmholtzFMMOptions.\nnsources::Int: Number of sources.\nntargets::Int: Number of targets.\nfmm::Ptr{Cvoid}: Pointer to the fmm sruct generated by the C++ part.\nfmmstruct::Ptr{Cvoid}: Pointer to an struct with all necassary substructs of the fmm. This pointer is mandatory for the comunication with the C++ part.\nsources::Ptr{Cvoid}: Pointer to the C++ struct of the sources.\ntargets::Ptr{Cvoid}: Pointer to the C++ struct of the targets. \n\n\n\n\n\n","category":"type"},{"location":"functions_types/#Functions","page":"Types and Functions","title":"Functions","text":"","category":"section"},{"location":"functions_types/","page":"Types and Functions","title":"Types and Functions","text":"ExaFMMt.init_sources(points::Matrix{F}, charges::Vector{F}) where F <: Real\nExaFMMt.init_sources(points::Matrix{F}, charges::Vector{C}) where {F <: Real, C <: Complex}\nExaFMMt.init_targets(points::Matrix{F}, ::Type) where F <: Real\nExaFMMt.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{Float64})\nExaFMMt.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{Float32})\nExaFMMt.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{ComplexF64})\nExaFMMt.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{ComplexF32})\nExaFMMt.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{Float64})\nExaFMMt.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{Float32})\nExaFMMt.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{ComplexF64})\nExaFMMt.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{ComplexF32})\nExaFMMt.freeF!(x::ExaFMMt.ExaFMM{Float64})\nExaFMMt.freeF!(x::ExaFMMt.ExaFMM{Float32})\nExaFMMt.freeC!(x::ExaFMMt.ExaFMM{ComplexF64})\nExaFMMt.freeC!(x::ExaFMMt.ExaFMM{ComplexF32})","category":"page"},{"location":"functions_types/#ExaFMMt.init_sources-Union{Tuple{F}, Tuple{Matrix{F}, Vector{F}}} where F<:Real","page":"Types and Functions","title":"ExaFMMt.init_sources","text":"init_sources(points::Matrix{F}, charges::Vector{F}) where F <: Real\n\nCreates struct for sources and charges in the C++ part from the Julia matrix. Real charges are used and mandatory for the Laplace- and Modified-Helmholtz-FMM.\n\nArguments\n\npoints::Matrix{F}: 3d-coordinates of sources.\ncharges::Vector{F}: Values of for example the charge at each source location.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.init_sources-Union{Tuple{C}, Tuple{F}, Tuple{Matrix{F}, Vector{C}}} where {F<:Real, C<:Complex}","page":"Types and Functions","title":"ExaFMMt.init_sources","text":"init_sources(points::Matrix{F}, charges::Vector{C}) where {F <: Real, C <: Complex}\n\nCreates struct for sources and charges in the C++ part from the Julia matrix. Complex charges are used and mandatory for the Laplace- and Modified-Helmholtz-FMM.\n\nArguments\n\npoints::Matrix{C}: 3d-coordinates of sources.\ncharges::Vector{C}: Values of for example the charge at each source location.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.init_targets-Union{Tuple{F}, Tuple{Matrix{F}, Type}} where F<:Real","page":"Types and Functions","title":"ExaFMMt.init_targets","text":"init_targets(points::Matrix{F}, T::Type) where F <: Real\n\nCreates struct for targets in the C++ part from a Julia matrix of points. \n\nArguments\n\npoints::Matrix{C}: 3d-coordinates of targets.\nT: Type must be set for the Helmholtz-FMM to ComplexF32 or ComplexF64.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.update_charges-Tuple{Ptr{Nothing}, Vector{Float64}}","page":"Types and Functions","title":"ExaFMMt.update_charges","text":"update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{Float64})\n\nUpdates charges in already generated Lapalce or Modified-Helmholtz-FMM. Requires a Float64 array of charges.  \n\nArguments\n\nfmmstruct::Ptr{Cvoid}: Pointer to an struct with all necassary substructs of the fmm. This pointer is mandatory for the comunication with the C++ part.\ncharges::Vector{Float64}: Values of for example the charge at each source location. \n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.update_charges-Tuple{Ptr{Nothing}, Vector{Float32}}","page":"Types and Functions","title":"ExaFMMt.update_charges","text":"update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{Float32})\n\nUpdates charges in already generated Lapalce or Modified-Helmholtz-FMM. Requires a Float32 array of charges.  \n\nArguments\n\nfmmstruct::Ptr{Cvoid}: Pointer to an struct with all necassary substructs of the fmm. This pointer is mandatory for the comunication with the C++ part.\ncharges::Vector{Float32}: Values of for example the charge at each source location. \n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.update_charges-Tuple{Ptr{Nothing}, Vector{ComplexF64}}","page":"Types and Functions","title":"ExaFMMt.update_charges","text":"update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{ComplexF64})\n\nUpdates charges in already generated Helmholtz-FMM. Requires a ComplexF64 array of charges.\n\nArguments\n\nfmmstruct::Ptr{Cvoid}: Pointer to an struct with all necassary substructs of the fmm. This pointer is mandatory for the comunication with the C++ part.\ncharges::Vector{ComplexF64}: Values of for example the charge at each source location. \n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.update_charges-Tuple{Ptr{Nothing}, Vector{ComplexF32}}","page":"Types and Functions","title":"ExaFMMt.update_charges","text":"update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{ComplexF32})\n\nUpdates charges in already generated Helmholtz-FMM. Requires a ComplexF32 array of charges.\n\nArguments\n\nfmmstruct::Ptr{Cvoid}: Pointer to an struct with all necassary substructs of the fmm. This pointer is mandatory for the comunication with the C++ part.\ncharges::Vector{ComplexF32}: Values of for example the charge at each source location. \n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.clear_values-Tuple{Ptr{Nothing}, Type{Float64}}","page":"Types and Functions","title":"ExaFMMt.clear_values","text":"clear_values(fmmstruct::Ptr{Cvoid}, T::Type{Float64})\n\nClears the soultion values in the FMM structure.\n\nArguments\n\nfmmstruct::Ptr{Cvoid}: Pointer to an struct with all necassary substructs of the fmm. This pointer is mandatory for the comunication with the C++ part.\nT: Type must be set for the Helmholtz-FMM to ComplexF32 or ComplexF64, for Laplace and Modifed-Helmholz-FMM Float64 or Flot32.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.clear_values-Tuple{Ptr{Nothing}, Type{Float32}}","page":"Types and Functions","title":"ExaFMMt.clear_values","text":"clear_values(fmmstruct::Ptr{Cvoid}, T::Type{Float32})\n\nClears the soultion values in the FMM structure.\n\nArguments\n\nfmmstruct::Ptr{Cvoid}: Pointer to an struct with all necassary substructs of the fmm. This pointer is mandatory for the comunication with the C++ part.\nT: Type must be set for the Helmholtz-FMM to ComplexF32 or ComplexF64, for Laplace and Modifed-Helmholz-FMM Float64 or Flot32.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.clear_values-Tuple{Ptr{Nothing}, Type{ComplexF64}}","page":"Types and Functions","title":"ExaFMMt.clear_values","text":"clear_values(fmmstruct::Ptr{Cvoid}, T::Type{ComplexF64})\n\nClears the soultion values in the FMM structure.\n\nArguments\n\nfmmstruct::Ptr{Cvoid}: Pointer to an struct with all necassary substructs of the fmm. This pointer is mandatory for the comunication with the C++ part.\nT: Type must be set for the Helmholtz-FMM to ComplexF32 or ComplexF64, for Laplace and Modifed-Helmholz-FMM Float64 or Flot32.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.clear_values-Tuple{Ptr{Nothing}, Type{ComplexF32}}","page":"Types and Functions","title":"ExaFMMt.clear_values","text":"clear_values(fmmstruct::Ptr{Cvoid}, T::Type{ComplexF32})\n\nClears the soultion values in the FMM structure.\n\nArguments\n\nfmmstruct::Ptr{Cvoid}: Pointer to an struct with all necassary substructs of the fmm. This pointer is mandatory for the comunication with the C++ part.\nT: Type must be set for the Helmholtz-FMM to ComplexF32 or ComplexF64, for Laplace and Modifed-Helmholz-FMM Float64 or Flot32.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.freeF!-Tuple{ExaFMM{Float64}}","page":"Types and Functions","title":"ExaFMMt.freeF!","text":"freeF!(x::ExaFMM{Float64})\n\nFrees the storage which is allocated by the C++ part for the Laplace-FMM and Modified-Helmholtz-FMM. \n\nArguments\n\nx::ExaFMM{Float64}: ExaFMM structure with pointers to all allocated variables.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.freeF!-Tuple{ExaFMM{Float32}}","page":"Types and Functions","title":"ExaFMMt.freeF!","text":"freeF!(x::ExaFMM{Float32})\n\nFrees the storage which is allocated by the C++ part for the Laplace-FMM and Modified-Helmholtz-FMM. \n\nArguments\n\nx::ExaFMM{Float32}: ExaFMM structure with pointers to all allocated variables.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.freeC!-Tuple{ExaFMM{ComplexF64}}","page":"Types and Functions","title":"ExaFMMt.freeC!","text":"freeC!(x::ExaFMM{ComplexF64})\n\nFrees the storage which is allocated by the C++ part for Helmholtz-FMM. \n\nArguments\n\nx::ExaFMM{ComplexF64}: ExaFMM structure with pointers to all allocated variables.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.freeC!-Tuple{ExaFMM{ComplexF32}}","page":"Types and Functions","title":"ExaFMMt.freeC!","text":"freeC!(x::ExaFMM{ComplexF32})\n\nFrees the storage which is allocated by the C++ part for Helmholtz-FMM. \n\nArguments\n\nx::ExaFMM{ComplexF64}: ExaFMM structure with pointers to all allocated variables.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#Laplace-FMM","page":"Types and Functions","title":"Laplace FMM","text":"","category":"section"},{"location":"functions_types/","page":"Types and Functions","title":"Types and Functions","text":"ExaFMMt.LaplaceFMM64(;ncrit=100, p=8)\nExaFMMt.LaplaceFMM32(;ncrit=100, p=8)\nExaFMMt.setup(sources::Matrix{F}, targets::Matrix{F}, fmmoptions::ExaFMMt.LaplaceFMMOptions{I}) where {I, F <: Real}\nExaFMMt.evaluate(A::ExaFMMt.ExaFMM{F}, x::Vector{F}, fmmoptions::ExaFMMt.LaplaceFMMOptions{I}) where {I, F <: Real}\nExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{Float64}, fmmoptions::ExaFMMt.LaplaceFMMOptions{I}) where I\nExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{Float32}, fmmoptions::ExaFMMt.LaplaceFMMOptions{I}) where I","category":"page"},{"location":"functions_types/#ExaFMMt.LaplaceFMM64-Tuple{}","page":"Types and Functions","title":"ExaFMMt.LaplaceFMM64","text":"LaplaceFMM64(;ncrit=100, p=8)\n\nInitializer for the Laplace-FMM in the C++ part. \n\nArguments\n\np::Int: Multipole expansion order.\nncrit::Int: Minimum number of points in each box of the tree.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.LaplaceFMM32-Tuple{}","page":"Types and Functions","title":"ExaFMMt.LaplaceFMM32","text":"LaplaceFMM32(;ncrit=100, p=8)\n\nInitializer for the Laplace-FMM in the C++ part.\n\nArguments\n\np::Int: Multipole expansion order.\nncrit::Int: Minimum number of points in each box of the tree.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.setup-Union{Tuple{F}, Tuple{I}, Tuple{Matrix{F}, Matrix{F}, LaplaceFMMOptions{I}}} where {I, F<:Real}","page":"Types and Functions","title":"ExaFMMt.setup","text":"setup(\n    sources::Matrix{F},\n    targets::Matrix{F}, \n    fmmoptions::LaplaceFMMOptions{I}\n) where {I, F <: Real}\n\nSets FMM structure up in the C++ part and allocates all madatory storage.\n\nArguments\n\nsources::Matrix{F}: 3d-coordinates of sources.\ntargets::Matrix{F}: 3d-coordinates of targets.\nfmmoptions::LaplaceFMMOptions{I}: Julia Laplace-initializer for setup function.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.evaluate-Union{Tuple{F}, Tuple{I}, Tuple{ExaFMM{F}, Vector{F}, LaplaceFMMOptions{I}}} where {I, F<:Real}","page":"Types and Functions","title":"ExaFMMt.evaluate","text":"evaluate(\n    A::ExaFMM{F},\n    x::Vector{F},\n    fmmoptions::LaplaceFMMOptions{I}\n) where {I, F <: Real}\n\nEvaluates prebuild FMM structure A for new values x.\n\nArguments\n\nA::ExaFMM{F}: ExaFMM structure with pointers to all allocated variables.\nx::Vector{F}: Values of for example the charge at each source location.\nfmmoptions::LaplaceFMMOptions{I}: Julia Laplace-initializer for setup function, used as identifier.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.verify-Union{Tuple{I}, Tuple{ExaFMM{Float64}, LaplaceFMMOptions{I}}} where I","page":"Types and Functions","title":"ExaFMMt.verify","text":"verify(exafmm::ExaFMM{Float64}, fmmoptions::LaplaceFMMOptions{I}) where I\n\nFunction compute accuracy of evaluated FMM exafmm.\n\nArguments\n\nexafmmm::ExaFMM{Float64}: ExaFMM structure with pointers to all allocated variables.\nfmmoptions::LaplaceFMMOptions{I}: Julia Laplace-initializer for setup function, used as identifier.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.verify-Union{Tuple{I}, Tuple{ExaFMM{Float32}, LaplaceFMMOptions{I}}} where I","page":"Types and Functions","title":"ExaFMMt.verify","text":"verify(exafmm::ExaFMM{Float32}, fmmoptions::LaplaceFMMOptions{I}) where I\n\nFunction compute accuracy of evaluated FMM exafmm.\n\nArguments\n\nexafmmm::ExaFMM{Float32}: ExaFMM structure with pointers to all allocated variables.\nfmmoptions::LaplaceFMMOptions{I}: Julia Laplace-initializer for setup function, used as identifier.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#Helmholtz-FMM","page":"Types and Functions","title":"Helmholtz FMM","text":"","category":"section"},{"location":"functions_types/","page":"Types and Functions","title":"Types and Functions","text":"ExaFMMt.HelmholtzFMM(wavek::ComplexF64; p=8, ncrit=100)\nExaFMMt.HelmholtzFMM(wavek::ComplexF32; p=8, ncrit=100)\nExaFMMt.setup(sources::Matrix{F}, targets::Matrix{F}, fmmoptions::ExaFMMt.HelmholtzFMMOptions{I, C}) where {I, F <: Real, C <: Complex}\nExaFMMt.evaluate(A::ExaFMMt.ExaFMM{C}, x::Vector{C}, fmmoptions::ExaFMMt.HelmholtzFMMOptions{I, C}) where {I, C <: Complex}\nExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{ComplexF64}, fmmoptions::ExaFMMt.HelmholtzFMMOptions{I, ComplexF64}) where I\nExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{ComplexF32}, fmmoptions::ExaFMMt.HelmholtzFMMOptions{I, ComplexF32}) where I","category":"page"},{"location":"functions_types/#ExaFMMt.HelmholtzFMM-Tuple{ComplexF64}","page":"Types and Functions","title":"ExaFMMt.HelmholtzFMM","text":"HelmholtzFMM(wavek::ComplexF64; p=8, ncrit=100)\n\nInitializer for the Helmholtz-FMM in the C++ part. \n\nArguments\n\nwavek::ComplexF64: Wavenumber.\np::Int: Multipole expansion order.\nncrit::Int: Minimum number of points in each box of the tree.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.HelmholtzFMM-Tuple{ComplexF32}","page":"Types and Functions","title":"ExaFMMt.HelmholtzFMM","text":"HelmholtzFMM(wavek::ComplexF32; p=8, ncrit=100)\n\nInitializer for the Helmholtz-FMM in the C++ part. \n\nArguments\n\nwavek::ComplexF32: Wavenumber.\np::Int: Multipole expansion order.\nncrit::Int: Minimum number of points in each box of the tree.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.setup-Union{Tuple{C}, Tuple{F}, Tuple{I}, Tuple{Matrix{F}, Matrix{F}, HelmholtzFMMOptions{I, C}}} where {I, F<:Real, C<:Complex}","page":"Types and Functions","title":"ExaFMMt.setup","text":"setup(\n    sources::Matrix{F},\n    targets::Matrix{F},\n    fmmoptions::HelmholtzFMMOptions{I, C}\n) where {I, F <: Real, C <: Complex}\n\nSets FMM structure up in the C++ part and allocates all madatory storage.\n\nArguments\n\nsources::Matrix{F}: 3d-coordinates of sources.\ntargets::Matrix{F}: 3d-coordinates of targets.\nfmmoptions::HelmholtzFMMOptions{I, C}: Julia Helmoltz-initializer for setup function.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.evaluate-Union{Tuple{C}, Tuple{I}, Tuple{ExaFMM{C}, Vector{C}, HelmholtzFMMOptions{I, C}}} where {I, C<:Complex}","page":"Types and Functions","title":"ExaFMMt.evaluate","text":"evaluate(\n    A::ExaFMM{C},\n    x::Vector{C},\n    fmmoptions::HelmholtzFMMOptions{I, C}\n) where {I, C <: Complex}\n\nEvaluates prebuild FMM structure A for new values x.\n\nArguments\n\nA::ExaFMM{C}: ExaFMM structure with pointers to all allocated variables.\nx::Vector{C}: Values of for example the charge at each source location.\nfmmoptions::HelmholtzFMMOptions{I, C}: Julia Helmoltz-initializer for setup function, used as identifier.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.verify-Union{Tuple{I}, Tuple{ExaFMM{ComplexF64}, HelmholtzFMMOptions{I, ComplexF64}}} where I","page":"Types and Functions","title":"ExaFMMt.verify","text":"verify(exafmm::ExaFMM{ComplexF64}, fmmoptions::HelmholtzFMMOptions{I, ComplexF64}) where I\n\nFunction compute accuracy of evaluated FMM exafmm.\n\nArguments\n\nexafmmm::ExaFMM: ExaFMM structure with pointers to all allocated variables.\nfmmoptions::HelmholtzFMMOptions{I, ComplexF64}: Julia Helmoltz-initializer for setup function, used as identifier.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.verify-Union{Tuple{I}, Tuple{ExaFMM{ComplexF32}, HelmholtzFMMOptions{I, ComplexF32}}} where I","page":"Types and Functions","title":"ExaFMMt.verify","text":"verify(exafmm::ExaFMM{ComplexF32}, fmmoptions::HelmholtzFMMOptions{I, ComplexF32}) where I\n\nFunction compute accuracy of evaluated FMM exafmm.\n\nArguments\n\nexafmmm::ExaFMM: ExaFMM structure with pointers to all allocated variables.\nfmmoptions::HelmholtzFMMOptions{I, ComplexF32}: Julia Helmoltz-initializer for setup function, used as identifier.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#Modified-Helmholtz-FMM","page":"Types and Functions","title":"Modified-Helmholtz FMM","text":"","category":"section"},{"location":"functions_types/","page":"Types and Functions","title":"Types and Functions","text":"ExaFMMt.ModifiedHelmholtzFMM(wavek::Float64; ncrit=100, p=8)\nExaFMMt.ModifiedHelmholtzFMM(wavek::Float32; ncrit=100, p=8)\nExaFMMt.setup(sources::Matrix{F}, targets::Matrix{F}, fmmoptions::ExaFMMt.ModifiedHelmholtzFMMOptions{I, F}) where {I, F <: Real}\nExaFMMt.evaluate(A::ExaFMMt.ExaFMM{F}, x::Vector{F}, fmmoptions::ExaFMMt.ModifiedHelmholtzFMMOptions{I, F}) where {I, F <: Real} \nExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{Float64}, fmmoptions::ExaFMMt.ModifiedHelmholtzFMMOptions{I, Float64}) where I\nExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{Float32}, fmmoptions::ExaFMMt.ModifiedHelmholtzFMMOptions{I, Float32}) where I","category":"page"},{"location":"functions_types/#ExaFMMt.ModifiedHelmholtzFMM-Tuple{Float64}","page":"Types and Functions","title":"ExaFMMt.ModifiedHelmholtzFMM","text":"ModifiedHelmholtzFMM(wavek::Float64; ncrit=100, p=8)\n\nInitializer for the modified-Helmholtz-FMM in the C++ part. \n\nArguments\n\nwavek::Float64: Wavenumber.\np::Int: Multipole expansion order.\nncrit::Int: Minimum number of points in each box of the tree.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.ModifiedHelmholtzFMM-Tuple{Float32}","page":"Types and Functions","title":"ExaFMMt.ModifiedHelmholtzFMM","text":"ModifiedHelmholtzFMM(wavek::Float32; ncrit=100, p=8)\n\nInitializer for the modified-Helmholtz-FMM in the C++ part. \n\nArguments\n\nwavek::Float32: Wavenumber.\np::Int: Multipole expansion order.\nncrit::Int: Minimum number of points in each box of the tree.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.setup-Union{Tuple{F}, Tuple{I}, Tuple{Matrix{F}, Matrix{F}, ModifiedHelmholtzFMMOptions{I, F}}} where {I, F<:Real}","page":"Types and Functions","title":"ExaFMMt.setup","text":"setup(\n    sources::Matrix{F},\n    targets::Matrix{F},\n    fmmoptions::ModifiedHelmholtzFMMOptions{I, F}\n) where {I, F <: Real}\n\nSets FMM structure up in the C++ part and allocates all madatory storage.\n\nArguments\n\nsources::Matrix{F}: 3d-coordinates of sources.\ntargets::Matrix{F}: 3d-coordinates of targets.\nfmmoptions::ModifiedHelmholtzFMMOptions{I, F}: Julia modified-Helmholtz-initializer for setup function.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.evaluate-Union{Tuple{F}, Tuple{I}, Tuple{ExaFMM{F}, Vector{F}, ModifiedHelmholtzFMMOptions{I, F}}} where {I, F<:Real}","page":"Types and Functions","title":"ExaFMMt.evaluate","text":"evaluate(\n    A::ExaFMM{F},\n    x::Vector{F},\n    fmmoptions::ModifiedHelmholtzFMMOptions{I, F}\n) where {I, F <: Real}\n\nEvaluates prebuild FMM structure A for new values x.\n\nArguments\n\nA::ExaFMM{F}: ExaFMM structure with pointers to all allocated variables.\nx::Vector{F}: Values of for example the charge at each source location.\nfmmoptions::ModifiedHelmholtzFMMOptions{I, F}: Julia modified-Helmoltz-initializer for setup function, used as identifier.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.verify-Union{Tuple{I}, Tuple{ExaFMM{Float64}, ModifiedHelmholtzFMMOptions{I, Float64}}} where I","page":"Types and Functions","title":"ExaFMMt.verify","text":"verify(exafmm::ExaFMM{Float64}, fmmoptions::ModifiedHelmholtzFMMOptions{I, Float64})\n\nFunction compute accuracy of evaluated FMM exafmm.\n\nArguments\n\nexafmmm::ExaFMM{Float64}: ExaFMM structure with pointers to all allocated variables.\nfmmoptions::ModifiedHelmholtzFMMOptions{I, Float64}: Julia modified-Helmholtz-initializer for setup function, used as identifier.\n\n\n\n\n\n","category":"method"},{"location":"functions_types/#ExaFMMt.verify-Union{Tuple{I}, Tuple{ExaFMM{Float32}, ModifiedHelmholtzFMMOptions{I, Float32}}} where I","page":"Types and Functions","title":"ExaFMMt.verify","text":"verify(exafmm::ExaFMM{Float32}, fmmoptions::ModifiedHelmholtzFMMOptions{I, Float32})\n\nFunction compute accuracy of evaluated FMM exafmm.\n\nArguments\n\nexafmmm::ExaFMM{Float32}: ExaFMM structure with pointers to all allocated variables.\nfmmoptions::ModifiedHelmholtzFMMOptions{I, Float32}: Julia modified-Helmholtz-initializer for setup function, used as identifier.\n\n\n\n\n\n","category":"method"},{"location":"#ExaFMM","page":"Home","title":"ExaFMM","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package wraps the exafmm-t library for Julia. Since Julia can not natively call C++ functions an C interface was added to the exafmm-t which can be found in the fork of the library at JoshuaTetzner/exafmm-t. The Binary of this library is build and published via Yggdrasil and registered as Exafmmt_jll in JuliaBinaryWrappers. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"Since exafmm-t uses Unix only functions a Windows build is not available. Recommendations on how to get Windows builds working are always welcome. Please open therefore an issue on this repository.  ","category":"page"},{"location":"#Fast-Multipole-Method-(FMM)","page":"Home","title":"Fast Multipole Method (FMM)","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The FMM is an algorithm to improves the complexity of the matrix-vector product ","category":"page"},{"location":"","page":"Home","title":"Home","text":"Ax = y","category":"page"},{"location":"","page":"Home","title":"Home","text":"from mathcalO(N²) to mathcalO(N), where A is the interaction matrix of points that evaluates the Green's function for a Laplace, Helmholtz or modified Helmholtz kernel. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"A common application is combining the FMM with the Boundary Element Method (BEM). Further information concerning this topic can be found in Advanced Topics","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The package can be installed by ","category":"page"},{"location":"","page":"Home","title":"Home","text":"import Pkg\nPkg.add(\"https://github.com/JoshuaTetzner/ExaFMMt.jl.git\")","category":"page"}]
}
