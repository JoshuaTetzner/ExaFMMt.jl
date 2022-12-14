#using exafmm

# laplace/modifiedhelmholtz
n = 1000
p = rand(Float64, n, 3)
c = rand(Float64, n)

src = init_sources(points, charges)
trg = init_targets(points)
##
# helmholtz
charges = ComplexF64.(charges)

init_sources(points, charges)
init_targets(points, T=ComplexF64)

##
using Base.Libc.Libdl
lib = Libdl.dlopen("/home/jt286/Documents/Code/C++/exafmm-t/build/julia/libExaFMMCInterface.so") # Open the library explicitly.
init_source = Libdl.dlsym(lib, :init_sources_F)
LaplaceFM = Libdl.dlsym(lib, :LaplaceFMM)
ModifiedHelmholtzFM = Libdl.dlsym(lib, :ModifiedHelmholtzFMM)
init_target = Libdl.dlsym(lib, :init_targets_F)
setup_laplace = Libdl.dlsym(lib, :setup_laplace)
evaluate_modifiedhelmholtz = Libdl.dlsym(lib, :evaluate_modifiedhelmholtz)
setup_modifiedhelmholtz = Libdl.dlsym(lib, :setup_modifiedhelmholtz)
evaluate_laplace = Libdl.dlsym(lib, :evaluate_laplace)
verify_l = Libdl.dlsym(lib, :verify_laplace)

update_charges_real = Libdl.dlsym(lib, :update_charges_real)
clear_value = Libdl.dlsym(lib, :clear_values)
freestorage_real = Libdl.dlsym(lib, :freestorage_real)

##
n = 100000
p = rand(Cdouble, n, 3)
c = rand(Cdouble, n);
##

src = ccall(init_source, Ptr{Cvoid}, (Ptr{Cdouble}, Ptr{Cdouble}, Cint), (vec(p)), (c), n) # Use the pointer `sym` instead of the (symbol, library) tuple (remaining arguments are the same).
trg = ccall(init_target, Ptr{Cvoid}, (Ptr{Cdouble}, Cint), p, n)
##
fmm = ccall(LaplaceFM, Ptr{Cvoid}, (Cint, Cint), 8, 100)

fmmstruct = ccall(setup_laplace, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), src, trg, fmm)

val = ccall(evaluate_laplace, Ptr{Cdouble}, (Ptr{Cvoid},), fmmstruct)

unsafe_wrap(Array, val, n)

ver = ccall(verify_l, Ptr{Cdouble}, (Ptr{Cvoid},), fmmstruct)

unsafe_wrap(Array, ver, 2)
##
wavek = 0.0
fmm = ccall(ModifiedHelmholtzFM, Ptr{Cvoid}, (Cint, Cint, Cdouble), 8, 100, wavek)

fmmstruct = ccall(setup_modifiedhelmholtz, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), src, trg, fmm)

val = ccall(evaluate_modifiedhelmholtz, Ptr{Cdouble}, (Ptr{Cvoid},), fmmstruct)

unsafe_wrap(Array, val, n)
##
ccall(update_charges_real, Cvoid, (Ptr{Cvoid}, Ptr{Cdouble}), fmmstruct, c)
ccall(clear_value, Cvoid, (Ptr{Cvoid},), fmmstruct)

val = ccall(evaluate_laplace, Ptr{Cdouble}, (Ptr{Cvoid},), fmmstruct)
unsafe_wrap(Array, val, n)

##
ccall(freestorage_real, Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), fmm, fmmstruct, src, trg)

##
using exafmm_jll

n = 1000
p = (rand(Float64, n, 3))
c = zeros(Float64, n)
#src = ccall((:init_sources_F, exafmmt), Ptr{Cvoid}, (Ptr{Cdouble}, Ptr{Cdouble}, Cint), p, c, n) # Use the pointer `sym` instead of the (symbol, library) tuple (remaining arguments are the same).
#trg = ccall((:init_targets_F, exafmmt), Ptr{Cvoid}, (Ptr{Cdouble}, Cint), p, n)
src = init_sources(p, c)
trg = init_targets(p)
fmm = ccall((:LaplaceFMM, exafmmt), Ptr{Cvoid}, (Cint, Cint), 8, 100)

fmmstruct = ccall((:setup_laplace, exafmmt), Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), src, trg, fmm)

val = ccall((:evaluate_laplace, exafmmt), Ptr{Cdouble}, (Ptr{Cvoid},), fmmstruct)
unsafe_wrap(Array, val, n)
