metadata_packages = [
    "BinDeps",
    "Cairo",
    "Calculus",
    "Clustering",
    "Clp",
    "Colors",
    "DataArrays",
    "DataFrames",
    "DataFramesMeta",
    "Dates",
    "DecisionTree",
    "Distributions",
    "Distances",
    "GLM",
    "GraphLayout",
    "HDF5",
    "HypothesisTests",
    "Ipopt",
    "JSON",
    "KernelDensity",
    "Lazy",
    "Lora",
    "MLBase",
    "MultivariateStats",
    "NLopt",
    "NMF",
    "Optim",
    "ODE",
    "Patchwork",
    "PDMats",
    "PGFPlots",
    "Plots",
    "PyCall",
    "PyPlot",
    "Quandl",
    "QuantEcon",
    "RDatasets",
    "SQLite",
    "Stan",
    "StatsBase",
    "Sundials",
    "TextAnalysis",
    "TimeSeries",
    "ZipFile"]


Pkg.init()
Pkg.update()

for package=metadata_packages
    Pkg.add(package)
end

# need to build XGBoost version for it to work
Pkg.clone("https://github.com/antinucleon/XGBoost.jl.git")
Pkg.build("XGBoost")

Pkg.clone("https://github.com/benhamner/MachineLearning.jl")
Pkg.pin("MachineLearning")

Pkg.resolve()
