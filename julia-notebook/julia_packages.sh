#!/bin/bash
PKGDIR=/opt/julia-0.5.0/share/julia/site

DEFAULT_PACKAGES="RDatasets Distributions SVM Clustering GLM \
	Optim JuMP GLPKMathProgInterface Clp NLopt Ipopt \
	ODE Sundials LinearLeastSquares \
	BayesNets PGFPlots GraphLayout \
	Stan Patchwork Quandl Lazy QuantEcon \
	IJulia PyPlot Colors Sympy PyCall Gadfly HDF5"

BUILD_PACKAGES="PyPlot IJulia Gadfly"

JULIA_PKGDIR=$PKGDIR julia -e "Pkg.init()"

IMPORT_PACKAGES="PyPlot IJulia DataFrames KernelDensity Gadfly"
for pkg in ${DEFAULT_PACKAGES}
do
    echo ""
    echo "Adding default package $pkg"
	JULIA_PKGDIR=$PKGDIR julia -e "Pkg.add(\"$pkg\")"
done
julia -e "Pkg.checkout(\"Interact\")"

for pkg in ${BUILD_PACKAGES}
do
    echo ""
    echo "Adding default package $pkg"
	JULIA_PKGDIR=$PKGDIR julia -e "Pkg.build(\"$pkg\")"
done

for pkg in ${IMPORT_PACKAGES}
do
    echo ""
    echo "Adding default package $pkg"
	JULIA_PKGDIR=/opt/julia-0.5.0/share/julia/site julia -e "importall $pkg"
done
