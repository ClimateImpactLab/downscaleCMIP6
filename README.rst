.. raw :: html

    <div>
    <img src="https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/resources/cil-gdpcir-globe.png" style="width: 30%" align="right">
    </div>

==========================================================
Global Downscaled Projections for Climate Impacts Research
==========================================================

.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.6403794.svg
   :target: https://doi.org/10.5281/zenodo.6403794

.. image:: https://mybinder.org/badge_logo.svg
   :target: https://mybinder.org/v2/gh/ClimateImpactLab/downscaleCMIP6-binder-env/main?urlpath=git-pull%3Frepo%3Dhttps%253A%252F%252Fgithub.com%252FClimateImpactLab%252FPlanetaryComputerExamples%26urlpath%3Dlab%252Ftree%252FPlanetaryComputerExamples%252Fdatasets%252Fcil-gdpcir%252FREADME.md%26branch%3Dgdpcir-additional-notebooks

The World Climate Research Programme's `6th Coupled Model Intercomparison Project (CMIP6) <https://www.wcrp-climate.org/wgcm-cmip/wgcm-cmip6>`_ represents an enormous advance in the quality, detail, and scope of climate modeling.

The Global Downscaled Projections for Climate Impacts Research dataset makes this modeling more applicable to understanding the impacts of changes in the climate on humans and society with two key developments: trend-preserving bias correction and downscaling. In this dataset, the `Climate Impact Lab <https://impactlab.org>`_ provides global, daily minimum and maximum air temperature at the surface (``tasmin`` and ``tasmax``) and daily cumulative surface precipitation (``pr``) corresponding to the CMIP6 historical, ssp1-2.6, ssp2-4.5, ssp3-7.0, and ssp5-8.5 scenarios for 25 global climate models on a 1/4-degree regular global grid.

Contents:

* `Accessing the data <#accessing-the-data>`_
* `Data format & contents <#data-format--contents>`_
* `Example use <#example-use>`_
* `Project methods <#project-methods>`_
* `The downscaleCMIP6 repository <#the-downscalecmip6-repository>`_
* `Citing, licensing, and using data produced by this project <#citing-licensing-and-using-data-produced-by-this-project>`_
* `Acknowledgements <#acknowledgements>`_
* `Financial support`_

Additional links:

* CIL GDPCIR project homepage: `github.com/ClimateImpactLab/downscaleCMIP6 <https://github.com/ClimateImpactLab/downscaleCMIP6>`_
* Climate Impact Lab homepage: `impactlab.org <https://impactlab.org>`_
* Project listing on Microsoft Planetary Computer: `planetarycomputer.microsoft.com/dataset/group/cil-gdpcir <https://planetarycomputer.microsoft.com/dataset/group/cil-gdpcir>`_

.. _Accessing the data:

Accessing the data
==================

GDPCIR data can be accessed on the Microsoft Planetary Computer: `planetarycomputer.microsoft.com/dataset/group/cil-gdpcir <https://planetarycomputer.microsoft.com/dataset/group/cil-gdpcir>`_

The dataset is made of of three collections, distinguished by data license:

* `Public domain (CC0-1.0) collection <https://planetarycomputer.microsoft.com/dataset/cil-gdpcir-cc0>`_
* `Attribution (CC BY 4.0) collection <https://planetarycomputer.microsoft.com/dataset/cil-gdpcir-cc-by>`_
* `Attribution-ShareAlike (CC BY SA 4.0) collection <https://planetarycomputer.microsoft.com/dataset/cil-gdpcir-cc-by-sa>`_

Each modeling center with bias corrected and downscaled data in this collection falls into one of these license categories - see the `table below <#available-institutions-models-and-scenarios-by-license-collection>`_ to see which model is in each collection, and see the section below on `Citing, Licensing, and using data produced by this project <#citing-licensing-and-using-data-produced-by-this-project>`_ for citations and additional information about each license. For examples of how to browse the collections and load the data using python, see the `example use <#example-use>`_ section below.

Data format & contents
======================

The data is stored as partitioned zarr stores (see `https://zarr.readthedocs.io <https://zarr.readthedocs.io>`_), each of which includes thousands of data and metadata files covering the full time span of the experiment. Historical zarr stores contain just over 50 GB, while SSP zarr stores contain nearly 70GB. Each store is stored as a 32-bit float, with dimensions time (daily datetime), lat (float latitude), and lon (float longitude). The data is chunked at each interval of 365 days and 90 degree interval of latitude and longitude. Therefore, each chunk is ``(365, 360, 360)``, with each chunk occupying approximately 180MB in memory.

Historical data is daily, excluding leap days, from Jan 1, 1950 to Dec 31, 2014; SSP data is daily, excluding leap days, from Jan 1, 2015 to either Dec 31, 2099 or Dec 31, 2100, depending on data availability in the source GCM.

The spatial domain covers all 0.25-degree grid cells, indexed by the grid center, with grid edges on the quarter-degree, using a -180 to 180 longitude convention. Thus, the “lon” coordinate extends from -179.875 to 179.875, and the “lat” coordinate extends from -89.875 to 89.875, with intermediate values at each 0.25-degree increment between (e.g. -179.875, -179.625, -179.375, etc).

Available institutions, models, and scenarios by license collection
-------------------------------------------------------------------

==================== ================= ==========================================  =========================
Modeling institution Source model      Available experiments                       License collection
==================== ================= ==========================================  =========================
CAS                  FGOALS-g3 [*]_    SSP2-4.5, SSP3-7.0, and SSP5-8.5            `Public domain datasets`_
INM                  INM-CM4-8         SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `Public domain datasets`_
INM                  INM-CM5-0         SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `Public domain datasets`_
BCC                  BCC-CSM2-MR       SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY-4.0`_
CMCC                 CMCC-CM2-SR5      ssp1-2.6, ssp2-4.5, ssp3-7.0, ssp5-8.5      `CC-BY-4.0`_
CMCC                 CMCC-ESM2         ssp1-2.6, ssp2-4.5, ssp3-7.0, ssp5-8.5      `CC-BY-4.0`_
CSIRO-ARCCSS         ACCESS-CM2        SSP2-4.5 and SSP3-7.0                       `CC-BY-4.0`_
CSIRO                ACCESS-ESM1-5     SSP1-2.6, SSP2-4.5, and SSP3-7.0            `CC-BY-4.0`_
MIROC                MIROC-ES2L        SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY-4.0`_
MIROC                MIROC6            SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY-4.0`_
MOHC                 HadGEM3-GC31-LL   SSP1-2.6, SSP2-4.5, and SSP5-8.5            `CC-BY-4.0`_
MOHC                 UKESM1-0-LL       SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY-4.0`_
MPI-M                MPI-ESM1-2-LR     SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY-4.0`_
MPI-M/DKRZ [*]_      MPI-ESM1-2-HR     SSP1-2.6 and SSP5-8.5                       `CC-BY-4.0`_
NCC                  NorESM2-LM        SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY-4.0`_
NCC                  NorESM2-MM        SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY-4.0`_
NOAA-GFDL            GFDL-CM4          SSP2-4.5 and SSP5-8.5                       `CC-BY-4.0`_
NOAA-GFDL            GFDL-ESM4         SSP1-2.6, SSP2-4.5, SSP3-7.0, and SSP5-8.5  `CC-BY-4.0`_
NUIST                NESM3             SSP1-2.6, SSP2-4.5, and SSP5-8.5            `CC-BY-4.0`_
EC-Earth-Consortium  EC-Earth3         ssp1-2.6, ssp2-4.5, ssp3-7.0, and ssp5-8.5  `CC-BY-4.0`_
EC-Earth-Consortium  EC-Earth3-AerChem ssp370                                      `CC-BY-4.0`_
EC-Earth-Consortium  EC-Earth3-CC      ssp245 and ssp585                           `CC-BY-4.0`_
EC-Earth-Consortium  EC-Earth3-Veg     ssp1-2.6, ssp2-4.5, ssp3-7.0, and ssp5-8.5  `CC-BY-4.0`_
EC-Earth-Consortium  EC-Earth3-Veg-LR  ssp1-2.6, ssp2-4.5, ssp3-7.0, and ssp5-8.5  `CC-BY-4.0`_
CCCma                CanESM5           ssp1-2.6, ssp2-4.5, ssp3-7.0, ssp5-8.5      `CC-BY-SA-4.0`_
==================== ================= ==========================================  =========================

*Notes:*

.. [*] At the time of running, no ssp1-2.6 precipitation data was available for the FGOALS-g3 model. Therefore, we provide ``tasmin`` and ``tamax`` for this model and experiment, but not ``pr``. All other model/experiment combinations in the above table include all three variables.

.. [*] The institution which ran MPI-ESM1-2-HR’s historical (CMIP) simulations is `MPI-M`, while the future (ScenarioMIP) simulations were run by `DKRZ`. Therefore, the institution component of `MPI-ESM1-2-HR` filepaths differ between `historical` and `SSP` scenarios.

.. _Example Use:

Example Use
===========

See the following examples on github: `github.com/microsoft/PlanetaryComputerExamples <https://github.com/microsoft/PlanetaryComputerExamples/blob/main/datasets/cil-gdpcir/>`_

* Exploring the GDPCIR dataset with the STAC API: `cil-gdpcir-example.ipynb <https://github.com/microsoft/PlanetaryComputerExamples/blob/main/datasets/cil-gdpcir/cil-gdpcir-example.ipynb>`_
* Selecting STAC collections and building an ensemble: `ensemble.ipynb <https://github.com/microsoft/PlanetaryComputerExamples/blob/main/datasets/cil-gdpcir/ensemble.ipynb>`_
* Computing climate & impact indicators with xclim: `indicators.ipynb <https://github.com/microsoft/PlanetaryComputerExamples/blob/main/datasets/cil-gdpcir/indicators.ipynb>`_

You can try these out in a live example on Binder:

.. image:: https://mybinder.org/badge_logo.svg
   :target: https://mybinder.org/v2/gh/ClimateImpactLab/downscaleCMIP6-binder-env/main?urlpath=git-pull%3Frepo%3Dhttps%253A%252F%252Fgithub.com%252FClimateImpactLab%252FPlanetaryComputerExamples%26urlpath%3Dlab%252Ftree%252FPlanetaryComputerExamples%252Fdatasets%252Fcil-gdpcir%252FREADME.md%26branch%3Dgdpcir-additional-notebooks

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
* `ClimateImpactLab/xclim <https://github.com/ClimateImpactLab/xclim>`_: Climate Impact Lab fork of the downscaling engine `Ouranosinc/xclim <https://github.com/Ouranosinc/xclim>`_ (`DOI: 10.5281/zenodo.2795043 <https://doi.org/10.5281/zenodo.2795043>`_) called by dodola for the Quantile Delta Mapping (QDM) and the Quantile Preserving Localized Analogs Downscaling (QPLAD) steps


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

The following bias corrected and downscaled model simulations are available in the public domain using a `CC0 1.0 Universal Public Domain Declaration <https://creativecommons.org/publicdomain/zero/1.0/>`_. Access the collection on Planetary Computer at https://planetarycomputer.microsoft.com/dataset/cil-gdpcir-cc0.

* **FGOALS-g3**

  License description: `data_licenses/FGOALS-g3.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/FGOALS-g3.txt>`_

  CMIP Citation:

    Li, Lijuan **(2019)**. *CAS FGOALS-g3 model output prepared for CMIP6 CMIP*. Version 20190826. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1783

  ScenarioMIP Citation:

    Li, Lijuan **(2019)**. *CAS FGOALS-g3 model output prepared for CMIP6 ScenarioMIP*. SSP1-2.6 version 20190818; SSP2-4.5 version 20190818; SSP3-7.0 version 20190820; SSP5-8.5 tasmax version 20190819; SSP5-8.5 tasmin version 20190819; SSP5-8.5 pr version 20190818. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2056


* **INM-CM4-8**

  License description: `data_licenses/INM-CM4-8.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/INM-CM4-8.txt>`_

  CMIP Citation:

    Volodin, Evgeny; Mortikov, Evgeny; Gritsun, Andrey; Lykossov, Vasily; Galin, Vener; Diansky, Nikolay; Gusev, Anatoly; Kostrykin, Sergey; Iakovlev, Nikolay; Shestakova, Anna; Emelina, Svetlana **(2019)**. *INM INM-CM4-8 model output prepared for CMIP6 CMIP*. Version 20190530. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1422

  ScenarioMIP Citation:

    Volodin, Evgeny; Mortikov, Evgeny; Gritsun, Andrey; Lykossov, Vasily; Galin, Vener; Diansky, Nikolay; Gusev, Anatoly; Kostrykin, Sergey; Iakovlev, Nikolay; Shestakova, Anna; Emelina, Svetlana **(2019)**. *INM INM-CM4-8 model output prepared for CMIP6 ScenarioMIP*. Version 20190603. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.12321


* **INM-CM5-0**

  License description: `data_licenses/INM-CM5-0.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/INM-CM5-0.txt>`_

  CMIP Citation:

    Volodin, Evgeny; Mortikov, Evgeny; Gritsun, Andrey; Lykossov, Vasily; Galin, Vener; Diansky, Nikolay; Gusev, Anatoly; Kostrykin, Sergey; Iakovlev, Nikolay; Shestakova, Anna; Emelina, Svetlana **(2019)**. *INM INM-CM5-0 model output prepared for CMIP6 CMIP*. Version 20190610. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1423

  ScenarioMIP Citation:

    Volodin, Evgeny; Mortikov, Evgeny; Gritsun, Andrey; Lykossov, Vasily; Galin, Vener; Diansky, Nikolay; Gusev, Anatoly; Kostrykin, Sergey; Iakovlev, Nikolay; Shestakova, Anna; Emelina, Svetlana **(2019)**. *INM INM-CM5-0 model output prepared for CMIP6 ScenarioMIP*. SSP1-2.6 version 20190619; SSP2-4.5 version 20190619; SSP3-7.0 version 20190618; SSP5-8.5 version 20190724. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.12322


.. _CC-BY:

CC-BY-4.0
~~~~~~~~~

The following bias corrected and downscaled model simulations are licensed under a `Creative Commons Attribution 4.0 International License <https://creativecommons.org/licenses/by/4.0/>`_. Note that this license requires citation of the source model output (included here). Please see https://creativecommons.org/licenses/by/4.0/ for more information. Access the collection on Planetary Computer at https://planetarycomputer.microsoft.com/dataset/cil-gdpcir-cc-by.

* **ACCESS-CM2**

  License description: `data_licenses/ACCESS-CM2.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/ACCESS-CM2.txt>`_

  CMIP Citation:

    Dix, Martin; Bi, Doahua; Dobrohotoff, Peter; Fiedler, Russell; Harman, Ian; Law, Rachel; Mackallah, Chloe; Marsland, Simon; O'Farrell, Siobhan; Rashid, Harun; Srbinovsky, Jhan; Sullivan, Arnold; Trenham, Claire; Vohralik, Peter; Watterson, Ian; Williams, Gareth; Woodhouse, Matthew; Bodman, Roger; Dias, Fabio Boeira; Domingues, Catia; Hannah, Nicholas; Heerdegen, Aidan; Savita, Abhishek; Wales, Scott; Allen, Chris; Druken, Kelsey; Evans, Ben; Richards, Clare; Ridzwan, Syazwan Mohamed; Roberts, Dale; Smillie, Jon; Snow, Kate; Ward, Marshall; Yang, Rui **(2019)**. *CSIRO-ARCCSS ACCESS-CM2 model output prepared for CMIP6 CMIP*. Version 20191108. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2281

  ScenarioMIP Citation:

    Dix, Martin; Bi, Doahua; Dobrohotoff, Peter; Fiedler, Russell; Harman, Ian; Law, Rachel; Mackallah, Chloe; Marsland, Simon; O'Farrell, Siobhan; Rashid, Harun; Srbinovsky, Jhan; Sullivan, Arnold; Trenham, Claire; Vohralik, Peter; Watterson, Ian; Williams, Gareth; Woodhouse, Matthew; Bodman, Roger; Dias, Fabio Boeira; Domingues, Catia; Hannah, Nicholas; Heerdegen, Aidan; Savita, Abhishek; Wales, Scott; Allen, Chris; Druken, Kelsey; Evans, Ben; Richards, Clare; Ridzwan, Syazwan Mohamed; Roberts, Dale; Smillie, Jon; Snow, Kate; Ward, Marshall; Yang, Rui **(2019)**. *CSIRO-ARCCSS ACCESS-CM2 model output prepared for CMIP6 ScenarioMIP*. Version 20191108. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2285


* **ACCESS-ESM1-5**

  License description: `data_licenses/ACCESS-ESM1-5.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/ACCESS-ESM1-5.txt>`_

  CMIP Citation:

    Ziehn, Tilo; Chamberlain, Matthew; Lenton, Andrew; Law, Rachel; Bodman, Roger; Dix, Martin; Wang, Yingping; Dobrohotoff, Peter; Srbinovsky, Jhan; Stevens, Lauren; Vohralik, Peter; Mackallah, Chloe; Sullivan, Arnold; O'Farrell, Siobhan; Druken, Kelsey **(2019)**. *CSIRO ACCESS-ESM1.5 model output prepared for CMIP6 CMIP*. Version 20191115. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2288

  ScenarioMIP Citation:

    Ziehn, Tilo; Chamberlain, Matthew; Lenton, Andrew; Law, Rachel; Bodman, Roger; Dix, Martin; Wang, Yingping; Dobrohotoff, Peter; Srbinovsky, Jhan; Stevens, Lauren; Vohralik, Peter; Mackallah, Chloe; Sullivan, Arnold; O'Farrell, Siobhan; Druken, Kelsey **(2019)**. *CSIRO ACCESS-ESM1.5 model output prepared for CMIP6 ScenarioMIP*. Version 20191115. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2291


* **BCC-CSM2-MR**

  License description: `data_licenses/BCC-CSM2-MR.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/BCC-CSM2-MR.txt>`_

  CMIP Citation:

    Xin, Xiaoge; Zhang, Jie; Zhang, Fang; Wu, Tongwen; Shi, Xueli; Li, Jianglong; Chu, Min; Liu, Qianxia; Yan, Jinghui; Ma, Qiang; Wei, Min **(2018)**. *BCC BCC-CSM2MR model output prepared for CMIP6 CMIP*. Version 20181126. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1725

  ScenarioMIP Citation:

    Xin, Xiaoge; Wu, Tongwen; Shi, Xueli; Zhang, Fang; Li, Jianglong; Chu, Min; Liu, Qianxia; Yan, Jinghui; Ma, Qiang; Wei, Min **(2019)**. *BCC BCC-CSM2MR model output prepared for CMIP6 ScenarioMIP*. SSP1-2.6 version 20190315; SSP2-4.5 version 20190318; SSP3-7.0 version 20190318; SSP5-8.5 version 20190318. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1732


* **CMCC-CM2-SR5**

  License description: `data_licenses/CMCC-CM2-SR5.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/CMCC-CM2-SR5.txt>`_

  CMIP Citation:

    Lovato, Tomas; Peano, Daniele **(2020)**. *CMCC CMCC-CM2-SR5 model output prepared for CMIP6 CMIP*. Version 20200616. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1362

  ScenarioMIP Citation:

    Lovato, Tomas; Peano, Daniele **(2020)**. *CMCC CMCC-CM2-SR5 model output prepared for CMIP6 ScenarioMIP*. SSP1-2.6 version 20200717; SSP2-4.5 version 20200617; SSP3-7.0 version 20200622; SSP5-8.5 version 20200622. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1365


* **CMCC-ESM2**

  License description: `data_licenses/CMCC-ESM2.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/CMCC-ESM2.txt>`_

  CMIP Citation:

    Lovato, Tomas; Peano, Daniele; Butenschön, Momme **(2021)**. *CMCC CMCC-ESM2 model output prepared for CMIP6 CMIP*. Version 20210114. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.13164

  ScenarioMIP Citation:

    Lovato, Tomas; Peano, Daniele; Butenschön, Momme **(2021)**. *CMCC CMCC-ESM2 model output prepared for CMIP6 ScenarioMIP*. SSP1-2.6 version 20210126; SSP2-4.5 version 20210129; SSP3-7.0 version 20210202; SSP5-8.5 version 20210126. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.13168


* **EC-Earth3-AerChem**

  License description: `data_licenses/EC-Earth3-AerChem.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/EC-Earth3-AerChem.txt>`_

  CMIP Citation:

    EC-Earth Consortium (EC-Earth) **(2020)**. *EC-Earth-Consortium EC-Earth3-AerChem model output prepared for CMIP6 CMIP*. Version 20200624. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.639

  ScenarioMIP Citation:

    EC-Earth Consortium (EC-Earth) **(2020)**. *EC-Earth-Consortium EC-Earth3-AerChem model output prepared for CMIP6 ScenarioMIP*. Version 20200827. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.724


* **EC-Earth3-CC**

  License description: `data_licenses/EC-Earth3-CC.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/EC-Earth3-CC.txt>`_

  CMIP Citation:

    EC-Earth Consortium (EC-Earth) **(2020)**. *EC-Earth-Consortium EC-Earth-3-CC model output prepared for CMIP6 CMIP*. Version 20210113. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.640

  ScenarioMIP Citation:

    EC-Earth Consortium (EC-Earth) **(2021)**. *EC-Earth-Consortium EC-Earth3-CC model output prepared for CMIP6 ScenarioMIP*. Version 20210113. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.15327


* **EC-Earth3-Veg-LR**

  License description: `data_licenses/EC-Earth3-Veg-LR.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/EC-Earth3-Veg-LR.txt>`_

  CMIP Citation:

    EC-Earth Consortium (EC-Earth) **(2020)**. *EC-Earth-Consortium EC-Earth3-Veg-LR model output prepared for CMIP6 CMIP*. Version 20200217. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.643

  ScenarioMIP Citation:

    EC-Earth Consortium (EC-Earth) **(2020)**. *EC-Earth-Consortium EC-Earth3-Veg-LR model output prepared for CMIP6 ScenarioMIP*. SSP1-2.6 version 20201201; SSP2-4.5 version 20201123; SSP3-7.0 version 20201123; SSP5-8.5 version 20201201. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.728


* **EC-Earth3-Veg**

  License description: `data_licenses/EC-Earth3-Veg.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/EC-Earth3-Veg.txt>`_

  CMIP Citation:

    EC-Earth Consortium (EC-Earth) **(2019)**. *EC-Earth-Consortium EC-Earth3-Veg model output prepared for CMIP6 CMIP*. Version 20200225. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.642

  ScenarioMIP Citation:

    EC-Earth Consortium (EC-Earth) **(2019)**. *EC-Earth-Consortium EC-Earth3-Veg model output prepared for CMIP6 ScenarioMIP*. Version 20200225. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.727


* **EC-Earth3**

  License description: `data_licenses/EC-Earth3.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/EC-Earth3.txt>`_

  CMIP Citation:

    EC-Earth Consortium (EC-Earth) **(2019)**. *EC-Earth-Consortium EC-Earth3 model output prepared for CMIP6 CMIP*. Version 20200310. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.181

  ScenarioMIP Citation:

    EC-Earth Consortium (EC-Earth) **(2019)**. *EC-Earth-Consortium EC-Earth3 model output prepared for CMIP6 ScenarioMIP*. Version 20200310. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.251


* **GFDL-CM4**

  License description: `data_licenses/GFDL-CM4.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/GFDL-CM4.txt>`_

  CMIP Citation:

    Guo, Huan; John, Jasmin G; Blanton, Chris; McHugh, Colleen; Nikonov, Serguei; Radhakrishnan, Aparna; Rand, Kristopher; Zadeh, Niki T.; Balaji, V; Durachta, Jeff; Dupuis, Christopher; Menzel, Raymond; Robinson, Thomas; Underwood, Seth; Vahlenkamp, Hans; Bushuk, Mitchell; Dunne, Krista A.; Dussin, Raphael; Gauthier, Paul PG; Ginoux, Paul; Griffies, Stephen M.; Hallberg, Robert; Harrison, Matthew; Hurlin, William; Lin, Pu; Malyshev, Sergey; Naik, Vaishali; Paulot, Fabien; Paynter, David J; Ploshay, Jeffrey; Reichl, Brandon G; Schwarzkopf, Daniel M; Seman, Charles J; Shao, Andrew; Silvers, Levi; Wyman, Bruce; Yan, Xiaoqin; Zeng, Yujin; Adcroft, Alistair; Dunne, John P.; Held, Isaac M; Krasting, John P.; Horowitz, Larry W.; Milly, P.C.D; Shevliakova, Elena; Winton, Michael; Zhao, Ming; Zhang, Rong **(2018)**. *NOAA-GFDL GFDL-CM4 model output*. Version 20180701. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1402

  ScenarioMIP Citation:

    Guo, Huan; John, Jasmin G; Blanton, Chris; McHugh, Colleen; Nikonov, Serguei; Radhakrishnan, Aparna; Rand, Kristopher; Zadeh, Niki T.; Balaji, V; Durachta, Jeff; Dupuis, Christopher; Menzel, Raymond; Robinson, Thomas; Underwood, Seth; Vahlenkamp, Hans; Dunne, Krista A.; Gauthier, Paul PG; Ginoux, Paul; Griffies, Stephen M.; Hallberg, Robert; Harrison, Matthew; Hurlin, William; Lin, Pu; Malyshev, Sergey; Naik, Vaishali; Paulot, Fabien; Paynter, David J; Ploshay, Jeffrey; Schwarzkopf, Daniel M; Seman, Charles J; Shao, Andrew; Silvers, Levi; Wyman, Bruce; Yan, Xiaoqin; Zeng, Yujin; Adcroft, Alistair; Dunne, John P.; Held, Isaac M; Krasting, John P.; Horowitz, Larry W.; Milly, Chris; Shevliakova, Elena; Winton, Michael; Zhao, Ming; Zhang, Rong **(2018)**. *NOAA-GFDL GFDL-CM4 model output prepared for CMIP6 ScenarioMIP*. Version 20180701. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.9242


* **GFDL-ESM4**

  License description: `data_licenses/GFDL-ESM4.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/GFDL-ESM4.txt>`_

  CMIP Citation:

    Krasting, John P.; John, Jasmin G; Blanton, Chris; McHugh, Colleen; Nikonov, Serguei; Radhakrishnan, Aparna; Rand, Kristopher; Zadeh, Niki T.; Balaji, V; Durachta, Jeff; Dupuis, Christopher; Menzel, Raymond; Robinson, Thomas; Underwood, Seth; Vahlenkamp, Hans; Dunne, Krista A.; Gauthier, Paul PG; Ginoux, Paul; Griffies, Stephen M.; Hallberg, Robert; Harrison, Matthew; Hurlin, William; Malyshev, Sergey; Naik, Vaishali; Paulot, Fabien; Paynter, David J; Ploshay, Jeffrey; Reichl, Brandon G; Schwarzkopf, Daniel M; Seman, Charles J; Silvers, Levi; Wyman, Bruce; Zeng, Yujin; Adcroft, Alistair; Dunne, John P.; Dussin, Raphael; Guo, Huan; He, Jian; Held, Isaac M; Horowitz, Larry W.; Lin, Pu; Milly, P.C.D; Shevliakova, Elena; Stock, Charles; Winton, Michael; Wittenberg, Andrew T.; Xie, Yuanyu; Zhao, Ming **(2018)**. *NOAA-GFDL GFDL-ESM4 model output prepared for CMIP6 CMIP*. Version 20190726. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1407

  ScenarioMIP Citation:

    John, Jasmin G; Blanton, Chris; McHugh, Colleen; Radhakrishnan, Aparna; Rand, Kristopher; Vahlenkamp, Hans; Wilson, Chandin; Zadeh, Niki T.; Dunne, John P.; Dussin, Raphael; Horowitz, Larry W.; Krasting, John P.; Lin, Pu; Malyshev, Sergey; Naik, Vaishali; Ploshay, Jeffrey; Shevliakova, Elena; Silvers, Levi; Stock, Charles; Winton, Michael; Zeng, Yujin **(2018)**. *NOAA-GFDL GFDL-ESM4 model output prepared for CMIP6 ScenarioMIP*. Version 20180701. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1414


* **HadGEM3-GC31-LL**

  License description: `data_licenses/HadGEM3-GC31-LL.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/HadGEM3-GC31-LL.txt>`_

  CMIP Citation:

    Ridley, Jeff; Menary, Matthew; Kuhlbrodt, Till; Andrews, Martin; Andrews, Tim **(2018)**. *MOHC HadGEM3-GC31-LL model output prepared for CMIP6 CMIP*. Version 20190624. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.419

  ScenarioMIP Citation:

    Good, Peter **(2019)**. *MOHC HadGEM3-GC31-LL model output prepared for CMIP6 ScenarioMIP*. SSP1-2.6 version 20200114; SSP2-4.5 version 20190908; SSP5-8.5 version 20200114. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.10845


* **MIROC-ES2L**

  License description: `data_licenses/MIROC-ES2L.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/MIROC-ES2L.txt>`_

  CMIP Citation:

    Hajima, Tomohiro; Abe, Manabu; Arakawa, Osamu; Suzuki, Tatsuo; Komuro, Yoshiki; Ogura, Tomoo; Ogochi, Koji; Watanabe, Michio; Yamamoto, Akitomo; Tatebe, Hiroaki; Noguchi, Maki A.; Ohgaito, Rumi; Ito, Akinori; Yamazaki, Dai; Ito, Akihiko; Takata, Kumiko; Watanabe, Shingo; Kawamiya, Michio; Tachiiri, Kaoru **(2019)**. *MIROC MIROC-ES2L model output prepared for CMIP6 CMIP*. Version 20191129. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.902

  ScenarioMIP Citation:

    Tachiiri, Kaoru; Abe, Manabu; Hajima, Tomohiro; Arakawa, Osamu; Suzuki, Tatsuo; Komuro, Yoshiki; Ogochi, Koji; Watanabe, Michio; Yamamoto, Akitomo; Tatebe, Hiroaki; Noguchi, Maki A.; Ohgaito, Rumi; Ito, Akinori; Yamazaki, Dai; Ito, Akihiko; Takata, Kumiko; Watanabe, Shingo; Kawamiya, Michio **(2019)**. *MIROC MIROC-ES2L model output prepared for CMIP6 ScenarioMIP*. Version 20200318. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.936


* **MIROC6**

  License description: `data_licenses/MIROC6.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/MIROC6.txt>`_

  CMIP Citation:

    Tatebe, Hiroaki; Watanabe, Masahiro **(2018)**. *MIROC MIROC6 model output prepared for CMIP6 CMIP*. Version 20191016. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.881

  ScenarioMIP Citation:

    Shiogama, Hideo; Abe, Manabu; Tatebe, Hiroaki **(2019)**. *MIROC MIROC6 model output prepared for CMIP6 ScenarioMIP*. Version 20191016. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.898


* **MPI-ESM1-2-HR**

  License description: `data_licenses/MPI-ESM1-2-HR.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/MPI-ESM1-2-HR.txt>`_

  CMIP Citation:

    Jungclaus, Johann; Bittner, Matthias; Wieners, Karl-Hermann; Wachsmann, Fabian; Schupfner, Martin; Legutke, Stephanie; Giorgetta, Marco; Reick, Christian; Gayler, Veronika; Haak, Helmuth; de Vrese, Philipp; Raddatz, Thomas; Esch, Monika; Mauritsen, Thorsten; von Storch, Jin-Song; Behrens, Jörg; Brovkin, Victor; Claussen, Martin; Crueger, Traute; Fast, Irina; Fiedler, Stephanie; Hagemann, Stefan; Hohenegger, Cathy; Jahns, Thomas; Kloster, Silvia; Kinne, Stefan; Lasslop, Gitta; Kornblueh, Luis; Marotzke, Jochem; Matei, Daniela; Meraner, Katharina; Mikolajewicz, Uwe; Modali, Kameswarrao; Müller, Wolfgang; Nabel, Julia; Notz, Dirk; Peters-von Gehlen, Karsten; Pincus, Robert; Pohlmann, Holger; Pongratz, Julia; Rast, Sebastian; Schmidt, Hauke; Schnur, Reiner; Schulzweida, Uwe; Six, Katharina; Stevens, Bjorn; Voigt, Aiko; Roeckner, Erich **(2019)**. *MPI-M MPIESM1.2-HR model output prepared for CMIP6 CMIP*. Version 20190710. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.741

  ScenarioMIP Citation:

    Schupfner, Martin; Wieners, Karl-Hermann; Wachsmann, Fabian; Steger, Christian; Bittner, Matthias; Jungclaus, Johann; Früh, Barbara; Pankatz, Klaus; Giorgetta, Marco; Reick, Christian; Legutke, Stephanie; Esch, Monika; Gayler, Veronika; Haak, Helmuth; de Vrese, Philipp; Raddatz, Thomas; Mauritsen, Thorsten; von Storch, Jin-Song; Behrens, Jörg; Brovkin, Victor; Claussen, Martin; Crueger, Traute; Fast, Irina; Fiedler, Stephanie; Hagemann, Stefan; Hohenegger, Cathy; Jahns, Thomas; Kloster, Silvia; Kinne, Stefan; Lasslop, Gitta; Kornblueh, Luis; Marotzke, Jochem; Matei, Daniela; Meraner, Katharina; Mikolajewicz, Uwe; Modali, Kameswarrao; Müller, Wolfgang; Nabel, Julia; Notz, Dirk; Peters-von Gehlen, Karsten; Pincus, Robert; Pohlmann, Holger; Pongratz, Julia; Rast, Sebastian; Schmidt, Hauke; Schnur, Reiner; Schulzweida, Uwe; Six, Katharina; Stevens, Bjorn; Voigt, Aiko; Roeckner, Erich **(2019)**. *DKRZ MPI-ESM1.2-HR model output prepared for CMIP6 ScenarioMIP*. Version 20190710. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2450


* **MPI-ESM1-2-LR**

  License description: `data_licenses/MPI-ESM1-2-LR.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/MPI-ESM1-2-LR.txt>`_

  CMIP Citation:

    Wieners, Karl-Hermann; Giorgetta, Marco; Jungclaus, Johann; Reick, Christian; Esch, Monika; Bittner, Matthias; Legutke, Stephanie; Schupfner, Martin; Wachsmann, Fabian; Gayler, Veronika; Haak, Helmuth; de Vrese, Philipp; Raddatz, Thomas; Mauritsen, Thorsten; von Storch, Jin-Song; Behrens, Jörg; Brovkin, Victor; Claussen, Martin; Crueger, Traute; Fast, Irina; Fiedler, Stephanie; Hagemann, Stefan; Hohenegger, Cathy; Jahns, Thomas; Kloster, Silvia; Kinne, Stefan; Lasslop, Gitta; Kornblueh, Luis; Marotzke, Jochem; Matei, Daniela; Meraner, Katharina; Mikolajewicz, Uwe; Modali, Kameswarrao; Müller, Wolfgang; Nabel, Julia; Notz, Dirk; Peters-von Gehlen, Karsten; Pincus, Robert; Pohlmann, Holger; Pongratz, Julia; Rast, Sebastian; Schmidt, Hauke; Schnur, Reiner; Schulzweida, Uwe; Six, Katharina; Stevens, Bjorn; Voigt, Aiko; Roeckner, Erich **(2019)**. *MPI-M MPIESM1.2-LR model output prepared for CMIP6 CMIP*. Version 20190710. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.742

  ScenarioMIP Citation:

    Wieners, Karl-Hermann; Giorgetta, Marco; Jungclaus, Johann; Reick, Christian; Esch, Monika; Bittner, Matthias; Gayler, Veronika; Haak, Helmuth; de Vrese, Philipp; Raddatz, Thomas; Mauritsen, Thorsten; von Storch, Jin-Song; Behrens, Jörg; Brovkin, Victor; Claussen, Martin; Crueger, Traute; Fast, Irina; Fiedler, Stephanie; Hagemann, Stefan; Hohenegger, Cathy; Jahns, Thomas; Kloster, Silvia; Kinne, Stefan; Lasslop, Gitta; Kornblueh, Luis; Marotzke, Jochem; Matei, Daniela; Meraner, Katharina; Mikolajewicz, Uwe; Modali, Kameswarrao; Müller, Wolfgang; Nabel, Julia; Notz, Dirk; Peters-von Gehlen, Karsten; Pincus, Robert; Pohlmann, Holger; Pongratz, Julia; Rast, Sebastian; Schmidt, Hauke; Schnur, Reiner; Schulzweida, Uwe; Six, Katharina; Stevens, Bjorn; Voigt, Aiko; Roeckner, Erich **(2019)**. *MPI-M MPIESM1.2-LR model output prepared for CMIP6 ScenarioMIP*. Version 20190710. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.793


* **NESM3**

  License description: `data_licenses/NESM3.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/NESM3.txt>`_

  CMIP Citation:

    Cao, Jian; Wang, Bin **(2019)**. *NUIST NESMv3 model output prepared for CMIP6 CMIP*. Version 20190812. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2021

  ScenarioMIP Citation:

    Cao, Jian **(2019)**. *NUIST NESMv3 model output prepared for CMIP6 ScenarioMIP*. SSP1-2.6 version 20190806; SSP2-4.5 version 20190805; SSP5-8.5 version 20190811. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2027


* **NorESM2-LM**

  License description: `data_licenses/NorESM2-LM.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/NorESM2-LM.txt>`_

  CMIP Citation:

    Seland, Øyvind; Bentsen, Mats; Oliviè, Dirk Jan Leo; Toniazzo, Thomas; Gjermundsen, Ada; Graff, Lise Seland; Debernard, Jens Boldingh; Gupta, Alok Kumar; He, Yanchun; Kirkevåg, Alf; Schwinger, Jörg; Tjiputra, Jerry; Aas, Kjetil Schanke; Bethke, Ingo; Fan, Yuanchao; Griesfeller, Jan; Grini, Alf; Guo, Chuncheng; Ilicak, Mehmet; Karset, Inger Helene Hafsahl; Landgren, Oskar Andreas; Liakka, Johan; Moseid, Kine Onsum; Nummelin, Aleksi; Spensberger, Clemens; Tang, Hui; Zhang, Zhongshi; Heinze, Christoph; Iversen, Trond; Schulz, Michael **(2019)**. *NCC NorESM2-LM model output prepared for CMIP6 CMIP*. Version 20190815. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.502

  ScenarioMIP Citation:

    Seland, Øyvind; Bentsen, Mats; Oliviè, Dirk Jan Leo; Toniazzo, Thomas; Gjermundsen, Ada; Graff, Lise Seland; Debernard, Jens Boldingh; Gupta, Alok Kumar; He, Yanchun; Kirkevåg, Alf; Schwinger, Jörg; Tjiputra, Jerry; Aas, Kjetil Schanke; Bethke, Ingo; Fan, Yuanchao; Griesfeller, Jan; Grini, Alf; Guo, Chuncheng; Ilicak, Mehmet; Karset, Inger Helene Hafsahl; Landgren, Oskar Andreas; Liakka, Johan; Moseid, Kine Onsum; Nummelin, Aleksi; Spensberger, Clemens; Tang, Hui; Zhang, Zhongshi; Heinze, Christoph; Iversen, Trond; Schulz, Michael **(2019)**. *NCC NorESM2-LM model output prepared for CMIP6 ScenarioMIP*. Version 20191108. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.604


* **NorESM2-MM**

  License description: `data_licenses/NorESM2-MM.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/NorESM2-MM.txt>`_

  CMIP Citation:

    Bentsen, Mats; Oliviè, Dirk Jan Leo; Seland, Øyvind; Toniazzo, Thomas; Gjermundsen, Ada; Graff, Lise Seland; Debernard, Jens Boldingh; Gupta, Alok Kumar; He, Yanchun; Kirkevåg, Alf; Schwinger, Jörg; Tjiputra, Jerry; Aas, Kjetil Schanke; Bethke, Ingo; Fan, Yuanchao; Griesfeller, Jan; Grini, Alf; Guo, Chuncheng; Ilicak, Mehmet; Karset, Inger Helene Hafsahl; Landgren, Oskar Andreas; Liakka, Johan; Moseid, Kine Onsum; Nummelin, Aleksi; Spensberger, Clemens; Tang, Hui; Zhang, Zhongshi; Heinze, Christoph; Iversen, Trond; Schulz, Michael **(2019)**. *NCC NorESM2-MM model output prepared for CMIP6 CMIP*. Version 20191108. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.506

  ScenarioMIP Citation:

    Bentsen, Mats; Oliviè, Dirk Jan Leo; Seland, Øyvind; Toniazzo, Thomas; Gjermundsen, Ada; Graff, Lise Seland; Debernard, Jens Boldingh; Gupta, Alok Kumar; He, Yanchun; Kirkevåg, Alf; Schwinger, Jörg; Tjiputra, Jerry; Aas, Kjetil Schanke; Bethke, Ingo; Fan, Yuanchao; Griesfeller, Jan; Grini, Alf; Guo, Chuncheng; Ilicak, Mehmet; Karset, Inger Helene Hafsahl; Landgren, Oskar Andreas; Liakka, Johan; Moseid, Kine Onsum; Nummelin, Aleksi; Spensberger, Clemens; Tang, Hui; Zhang, Zhongshi; Heinze, Christoph; Iversen, Trond; Schulz, Michael **(2019)**. *NCC NorESM2-MM model output prepared for CMIP6 ScenarioMIP*. Version 20191108. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.608


* **UKESM1-0-LL**

  License description: `data_licenses/UKESM1-0-LL.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/UKESM1-0-LL.txt>`_

  CMIP Citation:

    Tang, Yongming; Rumbold, Steve; Ellis, Rich; Kelley, Douglas; Mulcahy, Jane; Sellar, Alistair; Walton, Jeremy; Jones, Colin **(2019)**. *MOHC UKESM1.0-LL model output prepared for CMIP6 CMIP*. Version 20190627. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1569

  ScenarioMIP Citation:

    Good, Peter; Sellar, Alistair; Tang, Yongming; Rumbold, Steve; Ellis, Rich; Kelley, Douglas; Kuhlbrodt, Till; Walton, Jeremy **(2019)**. *MOHC UKESM1.0-LL model output prepared for CMIP6 ScenarioMIP*. SSP1-2.6 version 20190708; SSP2-4.5 version 20190715; SSP3-7.0 version 20190726; SSP5-8.5 version 20190726. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1567

.. _CC-BY-SA:

CC-BY-SA-4.0
~~~~~~~~~~~~

The following bias corrected and downscaled model simulations are licensed under a `Creative Commons Attribution-ShareAlike 4.0 International License <https://creativecommons.org/licenses/by-sa/4.0/>`_. Note that this license requires citation of the source model output (included here) and requires that derived works be shared under the same license. Please see https://creativecommons.org/licenses/by-sa/4.0/ for more information. Access the collection on Planetary Computer at https://planetarycomputer.microsoft.com/dataset/cil-gdpcir-cc-by-sa.

* **CanESM5**

  License description: `data_licenses/CanESM5.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/CanESM5.txt>`_

  CMIP Citation:

    Swart, Neil Cameron; Cole, Jason N.S.; Kharin, Viatcheslav V.; Lazare, Mike; Scinocca, John F.; Gillett, Nathan P.; Anstey, James; Arora, Vivek; Christian, James R.; Jiao, Yanjun; Lee, Warren G.; Majaess, Fouad; Saenko, Oleg A.; Seiler, Christian; Seinen, Clint; Shao, Andrew; Solheim, Larry; von Salzen, Knut; Yang, Duo; Winter, Barbara; Sigmond, Michael **(2019)**. *CCCma CanESM5 model output prepared for CMIP6 CMIP*. Version 20190429. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1303

  ScenarioMIP Citation:

    Swart, Neil Cameron; Cole, Jason N.S.; Kharin, Viatcheslav V.; Lazare, Mike; Scinocca, John F.; Gillett, Nathan P.; Anstey, James; Arora, Vivek; Christian, James R.; Jiao, Yanjun; Lee, Warren G.; Majaess, Fouad; Saenko, Oleg A.; Seiler, Christian; Seinen, Clint; Shao, Andrew; Solheim, Larry; von Salzen, Knut; Yang, Duo; Winter, Barbara; Sigmond, Michael **(2019)**. *CCCma CanESM5 model output prepared for CMIP6 ScenarioMIP*. Version 20190429. Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1317

Acknowledgements
================

This work is the result of many years worth of work by members of the `Climate Impact Lab <https://impactlab.org>`_, but would not have been possible without many contributions from across the wider scientific and computing communities.

Specifically, we would like to acknowledge the World Climate Research Programme's Working Group on Coupled Modeling, which is responsible for CMIP, and we would like to thank the climate modeling groups for producing and making their model output available. We would particularly like to thank the modeling institutions whose results are included as an input to this repository (listed above) for their contributions to the CMIP6 project and for responding to and granting our requests for license waivers.

We would also like to thank Lamont-Doherty Earth Observatory, the `Pangeo Consortium <https://github.com/pangeo-data>`_ (and especially the `ESGF Cloud Data Working Group <https://pangeo-data.github.io/pangeo-cmip6-cloud/#>`_) and Google Cloud and the Google Public Datasets program for making the `CMIP6 Google Cloud collection <https://console.cloud.google.com/marketplace/details/noaa-public/cmip6>`_ possible. In particular we're extremely grateful to `Ryan Abernathey <https://github.com/rabernat>`_, `Naomi Henderson <https://github.com/naomi-henderson>`_, `Charles Blackmon-Luca <https://github.com/charlesbluca>`_, `Aparna Radhakrishnan <https://github.com/aradhakrishnanGFDL>`_, `Julius Busecke <https://github.com/jbusecke>`_, and `Charles Stern <https://github.com/cisaacstern>`_ for the huge amount of work they've done to translate the ESGF CMIP6 netCDF archives into consistently-formattted, analysis-ready zarr stores on Google Cloud.

We're also grateful to the `xclim developers <https://github.com/Ouranosinc/xclim/graphs/contributors>`_ (`DOI: 10.5281/zenodo.2795043 <https://doi.org/10.5281/zenodo.2795043>`_), in particular `Pascal Bourgault <https://github.com/aulemahal>`_, `David Huard <https://github.com/huard>`_, and `Travis Logan <https://github.com/tlogan2000>`_, for implementing the QDM bias correction method in the xclim python package, supporting our QPLAD implementation into the package, and ongoing support in integrating dask into downscaling workflows. For method advice and useful conversations, we would like to thank Keith Dixon, Dennis Adams-Smith, and `Joe Hamman <https://github.com/jhamman>`_.

Financial support
=================

This research has been supported by The Rockefeller Foundation and the Microsoft AI for Earth Initiative.
