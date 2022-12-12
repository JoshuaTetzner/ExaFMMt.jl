#using exafmm

n = 1000
points = rand(Float64, n, 3)
charges = rand(Float64, n)

init_sources(points, charges)