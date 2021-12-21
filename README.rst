==============
downscaleCMIP6
==============

This repo contains infrastructure setup, argo workflows, and validation notebooks which together produce the bias corrected and downscaled daily 1/4-degree CMIP6 tasmin, tasmax, and pr data for the Rhodium/Climate Impact Lab Global Downscaled Projections for Climate Impacts Research (R/CIL GDPCIR) project.

See also:

* `ClimateImpactLab/dodola <https://github.com/ClimateImpactLab/dodola>`_: python package containing the full project implementation called by the argo workflows in this repository
* `ClimateImpactLab/xclim <https://github.com/ClimateImpactLab/xclim>`_: Climate Impact Lab fork of the downscaling engine `Ouranosinc/xclim <https://github.com/Ouranosinc/xclim>`_ called by dodola for the Quantile Delta Mapping (QDM) and the Quantile Preserving Localized Analogs Downscaling (QPLAD) steps.
