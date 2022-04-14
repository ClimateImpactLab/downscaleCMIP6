.. raw :: html

    <div>
    <img src="https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/resources/cil-gdpcir-globe.png" style="width: 30%" align="right">
    </div>

==========================================================
Global Downscaled Projections for Climate Impacts Research
==========================================================

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.6403794.svg
   :target: https://doi.org/10.5281/zenodo.6403794

The World Climate Research Programme's `6th Coupled Model Intercomparison Project (CMIP6) <https://www.wcrp-climate.org/wgcm-cmip/wgcm-cmip6>`_ represents an enormous advance in the quality, detail, and scope of climate modeling.

The Global Downscaled Projections for Climate Impacts Research dataset makes this modeling more applicable to understanding the impacts of changes in the climate on humans and society with two key developments: trend-preserving bias correction and downscaling. In this dataset, we provide global, daily minimum and maximum air temperature at the surface (``tasmin`` and ``tasmax``) and daily cumulative surface precipitation (``pr``) corresponding to the CMIP6 historical, ssp1-2.6, ssp2-4.5, ssp3-7.0, and ssp5-8.5 scenarios for 25 global climate models on a 1/4-degree regular global grid.

Contents:

* `Accessing the data`_
* `Example use`_
* `Project methods`_
* `The downscaleCMIP6 repository`_
* `Citing, licensing, and using data produced by this project`_
* `Acknowledgements`_
* `Financial support`_

.. _Accessing the data:

Accessing the data
==================

GDPCIR data will be hosted for free public access by the Microsoft Planetary computer. Details of the release and instructions/examples for how to access and use the data are coming soon. Stay tuned!

Data format & contents
======================

The data is stored as partitioned zarr stores (see `https://zarr.readthedocs.io <https://zarr.readthedocs.io>`_), each of which includes thousands of data and metadata files covering the full time span of the experiment. Historical zarr stores contain just over 50 GB, while SSP zarr stores contain nearly 70GB. Each store is stored as a 32-bit float, with dimensions time (daily datetime), lat (float latitude), and lon (float longitude). The data is chunked at each interval of 365 days and 90 degree interval of latitude and longitude. Therefore, each chunk is ``(365, 360, 360)``, with each chunk occupying approximately 180MB in memory.

Historical data is daily, excluding leap days, from Jan 1, 1950 to Dec 31, 2014; SSP data is daily, excluding leap days, from Jan 1, 2015 to either Dec 31, 2099 or Dec 31, 2100, depending on data availability in the source GCM.

The spatial domain covers all 0.25-degree grid cells, indexed by the grid center, with grid edges on the quarter-degree, using a -180 to 180 longitude convention. Thus, the “lon” coordinate extends from -179.875 to 179.875, and the “lat” coordinate extends from -89.875 to 89.875, with intermediate values at each 0.25-degree increment between (e.g. -179.875, -179.625, -179.375, etc).

The set of available scenarios varies by model, as shown in the following table:

==================== ================= ==========================================  ==================
Modeling institution Source model      Available experiments                       License collection
==================== ================= ==========================================  ==================
CAS                  FGOALS-g3 [*]_    SSP2-4.5, SSP3-7.0, and SSP5-8.5            `CC0`_
INM                  INM-CM4-8         SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC0`_
INM                  INM-CM5-0         SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC0`_
BCC                  BCC-CSM2-MR       SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY`_
CMCC                 CMCC-CM2-SR5      ssp1-2.6, ssp2-4.5, ssp3-7.0, ssp5-8.5      `CC-BY`_
CMCC                 CMCC-ESM2         ssp1-2.6, ssp2-4.5, ssp3-7.0, ssp5-8.5      `CC-BY`_
CSIRO-ARCCSS         ACCESS-CM2        SSP2-4.5 and SSP3-7.0                       `CC-BY`_
CSIRO                ACCESS-ESM1-5     SSP1-2.6, SSP2-4.5, and SSP3-7.0            `CC-BY`_
MIROC                MIROC-ES2L        SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY`_
MIROC                MIROC6            SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY`_
MOHC                 HadGEM3-GC31-LL   SSP1-2.6, SSP2-4.5, and SSP5-8.5            `CC-BY`_
MOHC                 UKESM1-0-LL       SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY`_
MPI-M                MPI-ESM1-2-LR     SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY`_
MPI-M/DKRZ [*]_      MPI-ESM1-2-HR     SSP1-2.6 and SSP5-8.5                       `CC-BY`_
NCC                  NorESM2-LM        SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY`_
NCC                  NorESM2-MM        SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY`_
NOAA-GFDL            GFDL-CM4          SSP2-4.5 and SSP5-8.5                       `CC-BY`_
NOAA-GFDL            GFDL-ESM4         SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY`_
NUIST                NESM3             SSP1-2.6, SSP2-4.5, and SSP5-8.5            `CC-BY`_
EC-Earth-Consortium  EC-Earth3         ssp1-2.6, ssp2-4.5, ssp3-7.0, and ssp5-8.5  `CC-BY`_
EC-Earth-Consortium  EC-Earth3-AerChem ssp370                                      `CC-BY`_
EC-Earth-Consortium  EC-Earth3-CC      ssp245 and ssp585                           `CC-BY`_
EC-Earth-Consortium  EC-Earth3-Veg     ssp1-2.6, ssp2-4.5, ssp3-7.0, and ssp5-8.5  `CC-BY`_
EC-Earth-Consortium  EC-Earth3-Veg-LR  ssp1-2.6, ssp2-4.5, ssp3-7.0, and ssp5-8.5  `CC-BY`_
CCCma                CanESM5           ssp1-2.6, ssp2-4.5, ssp3-7.0, ssp5-8.5      `CC-BY-SA`_
==================== ================= ==========================================  ==================

*Notes:*

.. [*] At the time of running, no ssp1-2.6 precipitation data was available. Therefore, we provide ``tasmin`` and ``tamax`` for this model and experiment, but not ``pr``. All other model/experiment combinations in the above table include all three variables.

.. [*] The institution which ran MPI-ESM1-2-HR’s historical (CMIP) simulations is `MPI-M`, while the future (ScenarioMIP) simulations were run by `DKRZ`. Therefore, the institution component of `MPI-ESM1-2-HR` filepaths differ between `historical` and `SSP` scenarios.

.. _Example Use:

Example Use
===========

* `Microsoft Planetary Computer Examples: Querying the STAC API and loading data <https://github.com/microsoft/PlanetaryComputerExamples/blob/main/datasets/cil-gdpcir/cil-gdpcir-example.ipynb>`_

.. _Project methods:

Project methods
===============

This project makes use of statistical bias correction and downscaling algorithms, which are specifically designed to accurately represent changes in the extremes. For this reason, we selected Quantile Delta Mapping (QDM), following the method introduced by `Cannon et al. (2015) <https://doi.org/10.1175/JCLI-D-14-00754.1>`_, which preserves quantile-specific trends from the GCM while fitting the full distribution for a given day-of-year to a reference dataset (ERA5).

We then introduce a similar method tailored to increase spatial resolution while preserving extreme behavior, Quantile-Preserving Localized-Analog Downscaling (QPLAD).

Together, these methods provide a robust means to handle both the central and tail behavior seen in climate model output, while aligning the full distribution to a state-of-the-art reanalysis dataset and providing the spatial granularity needed to study surface impacts.

A publication providing additional detail is in process and will be linked here as soon as it is available.

.. _The downscaleCMIP6 Repository:

The downscaleCMIP6 Repository
=============================

The `ClimateImpactLab/downscaleCMIP6 <https://github.com/ClimateImpactLab/downscaleCMIP6>`_ repository contains infrastructure setup, argo workflows, and validation notebooks which together produce the bias corrected and downscaled daily 1/4-degree CMIP6 tasmin, tasmax, and pr data for the Climate Impact Lab Global Downscaled Projections for Climate Impacts Research (CIL GDPCIR) project.

See also:

* `ClimateImpactLab/dodola <https://github.com/ClimateImpactLab/dodola>`_: python package containing the full project implementation called by the argo workflows in this repository
* `ClimateImpactLab/xclim <https://github.com/ClimateImpactLab/xclim>`_: Climate Impact Lab fork of the downscaling engine `Ouranosinc/xclim <https://github.com/Ouranosinc/xclim>`_ called by dodola for the Quantile Delta Mapping (QDM) and the Quantile Preserving Localized Analogs Downscaling (QPLAD) steps.


.. _Citing, licensing, and using data produced by this project:

Citing, licensing, and using data produced by this project
==========================================================

Projects making use of the data produced as part of the Climate Impact Lab Global Downscaled Projections for Climate Impacts Research (CIL GDPCIR) project are requested to cite both this project and the source datasets from which these results are derived. Additionally, the use of data derived from some GCMs *requires* citations, and some modeling centers impose licensing restrictions & requirements on derived works. See each GCM's license info in the links below for more information.


.. _CIL GDPCIR:

CIL GDPCIR
----------

Users are requested to cite this project in derived works. This project does not yet have a public DOI or citation - check back for details.


.. _ERA5:

ERA5
----

Additionally, we request you cite the historical dataset used in bias correction and downscaling, ERA5. See the `ECMWF guide to citing a dataset on the Climate Data Store <https://confluence.ecmwf.int/display/CKB/How+to+acknowledge+and+cite+a+Climate+Data+Store+%28CDS%29+catalogue+entry+and+the+data+published+as+part+of+it>`_:

    Hersbach, H, et al. The ERA5 global reanalysis. Q J R Meteorol Soc.2020; 146: 1999–2049. https://doi.org/10.1002/qj.3803

    Muñoz Sabater, J., (2019): ERA5-Land hourly data from 1981 to present. Copernicus Climate Change Service (C3S) Climate Data Store (CDS). (Accessed on June 4, 2021), 10.24381/cds.e2161bac

    Muñoz Sabater, J., (2021): ERA5-Land hourly data from 1950 to 1980. Copernicus Climate Change Service (C3S) Climate Data Store (CDS). (Accessed on June 4, 2021), 10.24381/cds.e2161bac


.. _GCM-specific citations & licenses:

GCM-specific citations & licenses
---------------------------------

The CMIP6 simulation data made available through the Earth System Grid Federation (ESGF) are subject to Creative Commons `BY-SA 4.0 <https://creativecommons.org/licenses/by-sa/4.0/>`_ or `BY-NC-SA 4.0 <https://creativecommons.org/licenses/by-nc-sa/4.0/>`_ licenses. We have reached out to each of the modeling institutions to request waivers from these terms so the outputs of this project may be used with fewer restrictions, and have been granted permission to release our data using the licenses listed here.

.. _CC0:

Public Domain Datasets
~~~~~~~~~~~~~~~~~~~~~~

.. include:: citations_cc0.rst

.. _CC-BY:

CC-BY-4.0
~~~~~~~~~

.. include:: citations_cc_by.rst

.. _CC-BY-SA:

CC-BY-SA-4.0
~~~~~~~~~~~~

.. include:: citations_cc_by_sa.rst
