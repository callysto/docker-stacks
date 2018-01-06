# pims-r

This is our R flavoured notebook, it builds on pims-minimal adding  from anaconda

## Updates

If the minor version of R is updated (e.g. from 3.3 to 3.4) the localPkgDir
variable in RProfile.site should be updated accordingly. This is the location
that will be used for local package installations

# Bugs etc.
Installing packages currently requires the gxx_linux-64 (compiler) packages)
https://github.com/conda/conda/issues/6030
