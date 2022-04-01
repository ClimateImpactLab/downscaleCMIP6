.. image:: https://zenodo.org/badge/DOI/10.5281/zenodo.6403794.svg
   :target: https://doi.org/10.5281/zenodo.6403794
.. raw :: html

    <div>
    <img src="https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/resources/GDPCIR-sphere.png" style="width: 30%" align="right">
    </div>

==========================================================
Global Downscaled Projections for Climate Impacts Research
==========================================================

This repo contains infrastructure setup, argo workflows, and validation notebooks which together produce the bias corrected and downscaled daily 1/4-degree CMIP6 tasmin, tasmax, and pr data for the Rhodium/Climate Impact Lab Global Downscaled Projections for Climate Impacts Research (R/CIL GDPCIR) project.

See also:

* `ClimateImpactLab/dodola <https://github.com/ClimateImpactLab/dodola>`_: python package containing the full project implementation called by the argo workflows in this repository
* `ClimateImpactLab/xclim <https://github.com/ClimateImpactLab/xclim>`_: Climate Impact Lab fork of the downscaling engine `Ouranosinc/xclim <https://github.com/Ouranosinc/xclim>`_ called by dodola for the Quantile Delta Mapping (QDM) and the Quantile Preserving Localized Analogs Downscaling (QPLAD) steps.

Citing, licensing, and using data produced by this project
==========================================================

Projects making use of the data produced as part of the Rhodium/Climate Impact Lab Global Downscaled Projections for Climate Impacts Research (R/CIL GDPCIR) project are requested to cite both this project and the source datasets from which these results are derived. Additionally, the use of data derived from some GCMs requires citations, and some modeling centers impose licensing restrictions & requirements on derived works. See each GCM's license info in the links below for more information.

R/CIL GDPCIR
------------

Users are requested to cite this project in derived works. This project does not yet have a public DOI or citation - check back for details.

ERA5
----

Additionally, we request you cite the historical dataset used in bias correction and downscaling, ERA5. See the `ECMWF guide to citing a dataset on the Climate Data Store <https://confluence.ecmwf.int/display/CKB/How+to+acknowledge+and+cite+a+Climate+Data+Store+%28CDS%29+catalogue+entry+and+the+data+published+as+part+of+it>`_:

    Hersbach, H, et al. The ERA5 global reanalysis. Q J R Meteorol Soc.2020; 146: 1999–2049. https://doi.org/10.1002/qj.3803

    Muñoz Sabater, J., (2019): ERA5-Land hourly data from 1981 to present. Copernicus Climate Change Service (C3S) Climate Data Store (CDS). (Accessed on June 4, 2021), 10.24381/cds.e2161bac

    Muñoz Sabater, J., (2021): ERA5-Land hourly data from 1950 to 1980. Copernicus Climate Change Service (C3S) Climate Data Store (CDS). (Accessed on June 4, 2021), 10.24381/cds.e2161bac

GCM-specific citations & licenses
---------------------------------


BCC-CSM2-MR
~~~~~~~~~~~

License: `data_licenses/BCC-CSM2-MR.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/BCC-CSM2-MR.txt>`_

Citation:

  Xin, Xiaoge; Wu, Tongwen; Shi, Xueli; Zhang, Fang; Li, Jianglong; Chu, Min; Liu, Qianxia; Yan, Jinghui; Ma, Qiang; Wei, Min (2019). BCC BCC-CSM2MR model output prepared for CMIP6 ScenarioMIP. Historical version 20181126.Earth System Grid Federation; ScenarioMIP version 20190318.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1732

FGOALS-g3
~~~~~~~~~

License: `data_licenses/FGOALS-g3.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/FGOALS-g3.txt>`_

Citation:

  Li, Lijuan (2019). CAS FGOALS-g3 model output prepared for CMIP6 ScenarioMIP. Historical version 20190826.Earth System Grid Federation; SSP2-4.5 version 20190818.Earth System Grid Federation; SSP3-7.0 version 20190820.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2056

ACCESS-ESM1-5
~~~~~~~~~~~~~

License: `data_licenses/ACCESS-ESM1-5.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/ACCESS-ESM1-5.txt>`_

Citation:

  Ziehn, Tilo; Chamberlain, Matthew; Lenton, Andrew; Law, Rachel; Bodman, Roger; Dix, Martin; Wang, Yingping; Dobrohotoff, Peter; Srbinovsky, Jhan; Stevens, Lauren; Vohralik, Peter; Mackallah, Chloe; Sullivan, Arnold; O'Farrell, Siobhan; Druken, Kelsey (2019). CSIRO ACCESS-ESM1.5 model output prepared for CMIP6 ScenarioMIP. Version 20191115.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2291

ACCESS-CM2
~~~~~~~~~~

License: `data_licenses/ACCESS-CM2.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/ACCESS-CM2.txt>`_

Citation:

  Dix, Martin; Bi, Doahua; Dobrohotoff, Peter; Fiedler, Russell; Harman, Ian; Law, Rachel; Mackallah, Chloe; Marsland, Simon; O'Farrell, Siobhan; Rashid, Harun; Srbinovsky, Jhan; Sullivan, Arnold; Trenham, Claire; Vohralik, Peter; Watterson, Ian; Williams, Gareth; Woodhouse, Matthew; Bodman, Roger; Dias, Fabio Boeira; Domingues, Catia; Hannah, Nicholas; Heerdegen, Aidan; Savita, Abhishek; Wales, Scott; Allen, Chris; Druken, Kelsey; Evans, Ben; Richards, Clare; Ridzwan, Syazwan Mohamed; Roberts, Dale; Smillie, Jon; Snow, Kate; Ward, Marshall; Yang, Rui (2019). CSIRO-ARCCSS ACCESS-CM2 model output prepared for CMIP6 CMIP. Version 20191108.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2281

INM-CM4-8
~~~~~~~~~

License: `data_licenses/INM-CM4-8.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/INM-CM4-8.txt>`_

Citation:

  Volodin, Evgeny; Mortikov, Evgeny; Gritsun, Andrey; Lykossov, Vasily; Galin, Vener; Diansky, Nikolay; Gusev, Anatoly; Kostrykin, Sergey; Iakovlev, Nikolay; Shestakova, Anna; Emelina, Svetlana (2019). INM INM-CM4-8 model output prepared for CMIP6 CMIP. Historical version 20190530.Earth System Grid Federation; ScenarioMIP version 20190603.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1422

INM-CM5-0
~~~~~~~~~

License: `data_licenses/INM-CM5-0.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/INM-CM5-0.txt>`_

Citation:

  Volodin, Evgeny; Mortikov, Evgeny; Gritsun, Andrey; Lykossov, Vasily; Galin, Vener; Diansky, Nikolay; Gusev, Anatoly; Kostrykin, Sergey; Iakovlev, Nikolay; Shestakova, Anna; Emelina, Svetlana (2019). INM INM-CM5-0 model output prepared for CMIP6 CMIP. Historical version 20190610.Earth System Grid Federation; SSP2-4.5 version 20190619.Earth System Grid Federation; SSP3.70 version 20190618.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1423

MIROC-ES2L
~~~~~~~~~~

License: `data_licenses/MIROC-ES2L.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/MIROC-ES2L.txt>`_

Citation:

  Tachiiri, Kaoru; Abe, Manabu; Hajima, Tomohiro; Arakawa, Osamu; Suzuki, Tatsuo; Komuro, Yoshiki; Ogochi, Koji; Watanabe, Michio; Yamamoto, Akitomo; Tatebe, Hiroaki; Noguchi, Maki A.; Ohgaito, Rumi; Ito, Akinori; Yamazaki, Dai; Ito, Akihiko; Takata, Kumiko; Watanabe, Shingo; Kawamiya, Michio (2019). MIROC MIROC-ES2L model output prepared for CMIP6 ScenarioMIP. Historical version 20191129.Earth System Grid Federation; ScenarioMIP version 20200318.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.936

MIROC6
~~~~~~

License: `data_licenses/MIROC6.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/MIROC6.txt>`_

Citation:

  Shiogama, Hideo; Abe, Manabu; Tatebe, Hiroaki (2019). MIROC MIROC6 model output prepared for CMIP6 ScenarioMIP. Version 20191016.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.898

NorESM2-LM
~~~~~~~~~~

License: `data_licenses/NorESM2-LM.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/NorESM2-LM.txt>`_

Citation:

  Seland, Øyvind; Bentsen, Mats; Oliviè, Dirk Jan Leo; Toniazzo, Thomas; Gjermundsen, Ada; Graff, Lise Seland; Debernard, Jens Boldingh; Gupta, Alok Kumar; He, Yanchun; Kirkevåg, Alf; Schwinger, Jörg; Tjiputra, Jerry; Aas, Kjetil Schanke; Bethke, Ingo; Fan, Yuanchao; Griesfeller, Jan; Grini, Alf; Guo, Chuncheng; Ilicak, Mehmet; Karset, Inger Helene Hafsahl; Landgren, Oskar Andreas; Liakka, Johan; Moseid, Kine Onsum; Nummelin, Aleksi; Spensberger, Clemens; Tang, Hui; Zhang, Zhongshi; Heinze, Christoph; Iversen, Trond; Schulz, Michael (2019). NCC NorESM2-LM model output prepared for CMIP6 CMIP. Historical version 20190815.Earth System Grid Federation; ScenarioMIP version 20191108.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.502

NorESM2-MM
~~~~~~~~~~

License: `data_licenses/NorESM2-MM.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/NorESM2-MM.txt>`_

Citation:

  Bentsen, Mats; Oliviè, Dirk Jan Leo; Seland, Øyvind; Toniazzo, Thomas; Gjermundsen, Ada; Graff, Lise Seland; Debernard, Jens Boldingh; Gupta, Alok Kumar; He, Yanchun; Kirkevåg, Alf; Schwinger, Jörg; Tjiputra, Jerry; Aas, Kjetil Schanke; Bethke, Ingo; Fan, Yuanchao; Griesfeller, Jan; Grini, Alf; Guo, Chuncheng; Ilicak, Mehmet; Karset, Inger Helene Hafsahl; Landgren, Oskar Andreas; Liakka, Johan; Moseid, Kine Onsum; Nummelin, Aleksi; Spensberger, Clemens; Tang, Hui; Zhang, Zhongshi; Heinze, Christoph; Iversen, Trond; Schulz, Michael (2019). NCC NorESM2-MM model output prepared for CMIP6 CMIP. Version 20191108.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.506

GFDL-CM4
~~~~~~~~

License: `data_licenses/GFDL-CM4.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/GFDL-CM4.txt>`_

Citation:

  Guo, Huan; John, Jasmin G; Blanton, Chris; McHugh, Colleen; Nikonov, Serguei; Radhakrishnan, Aparna; Rand, Kristopher; Zadeh, Niki T.; Balaji, V; Durachta, Jeff; Dupuis, Christopher; Menzel, Raymond; Robinson, Thomas; Underwood, Seth; Vahlenkamp, Hans; Bushuk, Mitchell; Dunne, Krista A.; Dussin, Raphael; Gauthier, Paul PG; Ginoux, Paul; Griffies, Stephen M.; Hallberg, Robert; Harrison, Matthew; Hurlin, William; Lin, Pu; Malyshev, Sergey; Naik, Vaishali; Paulot, Fabien; Paynter, David J; Ploshay, Jeffrey; Reichl, Brandon G; Schwarzkopf, Daniel M; Seman, Charles J; Shao, Andrew; Silvers, Levi; Wyman, Bruce; Yan, Xiaoqin; Zeng, Yujin; Adcroft, Alistair; Dunne, John P.; Held, Isaac M; Krasting, John P.; Horowitz, Larry W.; Milly, P.C.D; Shevliakova, Elena; Winton, Michael; Zhao, Ming; Zhang, Rong (2018). NOAA-GFDL GFDL-CM4 model output. Version 20180701.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1402

GFDL-ESM4
~~~~~~~~~

License: `data_licenses/GFDL-ESM4.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/GFDL-ESM4.txt>`_

Citation:

  Krasting, John P.; John, Jasmin G; Blanton, Chris; McHugh, Colleen; Nikonov, Serguei; Radhakrishnan, Aparna; Rand, Kristopher; Zadeh, Niki T.; Balaji, V; Durachta, Jeff; Dupuis, Christopher; Menzel, Raymond; Robinson, Thomas; Underwood, Seth; Vahlenkamp, Hans; Dunne, Krista A.; Gauthier, Paul PG; Ginoux, Paul; Griffies, Stephen M.; Hallberg, Robert; Harrison, Matthew; Hurlin, William; Malyshev, Sergey; Naik, Vaishali; Paulot, Fabien; Paynter, David J; Ploshay, Jeffrey; Reichl, Brandon G; Schwarzkopf, Daniel M; Seman, Charles J; Silvers, Levi; Wyman, Bruce; Zeng, Yujin; Adcroft, Alistair; Dunne, John P.; Dussin, Raphael; Guo, Huan; He, Jian; Held, Isaac M; Horowitz, Larry W.; Lin, Pu; Milly, P.C.D; Shevliakova, Elena; Stock, Charles; Winton, Michael; Wittenberg, Andrew T.; Xie, Yuanyu; Zhao, Ming (2018). NOAA-GFDL GFDL-ESM4 model output prepared for CMIP6 CMIP. Historical version 20190726.Earth System Grid Federation; ScenarioMIP version 20180701.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.1407

NESM3
~~~~~

License: `data_licenses/NESM3.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/NESM3.txt>`_

Citation:

  Cao, Jian; Wang, Bin (2019). NUIST NESMv3 model output prepared for CMIP6 CMIP. Historical version 20190812.Earth System Grid Federation; ScenarioMIP version 20190805.Earth System Grid Federation. https://doi.org/10.22033/ESGF/CMIP6.2021


