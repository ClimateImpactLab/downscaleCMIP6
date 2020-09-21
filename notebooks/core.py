import numpy as np
import pandas as pd
import xarray as xr

class SpatialDisaggregator:
    """ 
    Spatial disaggregation model class 
    Apply spatial disaggregation algorithm to an xarray Dataset with fit 
    and predict methods using NASA-NEX method for spatial disaggregation 
    (see Thrasher et al, 2012).

    Parameters
    ----------
    var : str
          specifies the variable being downscaled. Default is 
          temperature and other option is precipitation. 
    """

    def __init__(self, var='temperature'):
        self._var = var

    def fit_scaling_factor(self, ds_bc, climo_coarse, var_name,  
                           lat_name='lat', lon_name='lon'):
        """
        Fit the scaling factor used in spatial disaggregation

        Parameters
        -----------
        ds_bc : xarray.Dataset 
                Daily bias corrected data at the model resolution
        climo_coarse : xarray.DataArray or xarray.Dataset
                Observed climatology that has been regridded (coarsened) 
                to the model resolution
        var_name : str
                  Specifies the data variable name within ds_bc of the 
                  daily bias corrected data
        lat_name : str
                  Name of the latitude dimension of ds_bc and climo_coarse,
                  default is 'lat'. 
        lon_name : str
                  Name of the longitude dimension of ds_bc and climo_coarse,
                  default is 'lon'. 
        """
        
        # check that climo has been regridded to model res 
        xr.testing.assert_equal(ds_bc[lat_name], climo_coarse[lat_name])
        xr.testing.assert_equal(ds_bc[lon_name], climo_coarse[lon_name])

        scf = self._calculate_scaling_factor(ds_bc, climo_coarse, var_name, self._var)

        return scf 
    
    def apply_scaling_factor(self, scf, climo_fine, var_name,
                             lat_name='lat', lon_name='lon'):
        """
        Predict (apply) the scaling factor to the observed climatology. 

        Parameters 
        -----------
        scf : xarray.Dataset
              Scale factor that has been regridded to the resolution of 
              the observed data. 
        climo_fine : xarray.DataArray or xarray.Dataset
                     Observed climatology at its native resolution 
        var_name : str
                   Specifies the data variable name within ds_bc of the 
                   daily bias corrected data
        lat_name : str
                   Name of the latitude dimension of ds_bc and climo_coarse,
                   default is 'lat'. 
        lon_name : str
                   Name of the longitude dimension of ds_bc and climo_coarse,
                   default is 'lon'
        """

        # check that scale factor has been regridded to obs res
        xr.testing.assert_equal(scf[lat_name], climo_fine[lat_name])
        xr.testing.assert_equal(scf[lon_name], climo_fine[lon_name])

        downscaled = self._apply_scaling_factor(scf, climo_fine, var_name, self._var)

        return downscaled 

    def _calculate_scaling_factor(self, ds_bc, climo, var_name, var):
        '''
        compute scaling factor
        '''
        # Necessary workaround to xarray's check with zero dimensions
        # https://github.com/pydata/xarray/issues/3575
        da = ds_bc[var_name]
        if sum(da.shape) == 0:
            return da
        groupby_type = ds_bc.time.dt.dayofyear
        gb = da.groupby(groupby_type)

        if var == 'temperature':
            return gb - climo
        elif var == 'precipitation':
            return gb / climo

    def _apply_scaling_factor(self, scf, climo, var_name, var):
        '''
        apply scaling factor
        '''
        groupby_type = scf.time.dt.dayofyear
        da = scf[var_name]
        sff_daily = da.groupby(groupby_type)

        if var == 'temperature':
            return sff_daily + climo
        elif var == 'precipitation':
            return sff_daily / climo
