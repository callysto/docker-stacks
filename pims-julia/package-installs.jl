import Pkg

Pkg.pkg"add BinDeps Calculus Clustering Clp Colors DataArrays DataFrames DataFramesMeta Dates DecisionTree Distributions Distances GLM HypothesisTests IJulia Ipopt JSON KernelDensity Lazy MLBase MultivariateStats NLopt Optim ODE PDMats PGFPlots Plots PyCall PyPlot QuantEcon RDatasets SQLite Stan StatsBase Sundials ZipFile ZMQ; precompile"

#Not compatible yet: Cairo HDF5 IPOPT
