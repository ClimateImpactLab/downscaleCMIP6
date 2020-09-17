import numpy as np
import pandas as pd 
import xarray as xr

def _convert_lons(ds, lon_name='longitude'):
    '''
    converts longitudes from 0 to 360 to -180 to 180
    '''
    ds_conv_coords = ds.assign_coords(longitude=(((ds[lon_name] + 180) % 360) - 180))
    ds_sort = ds_conv_coords.sel(**{lon_name: np.sort(ds_conv_coords[lon_name].values)})
    return(ds_sort)

def _remove_leap_days(ds):
    '''
    removes all leap days from the time dimension of an xarray dataset
    '''
    if 'time' in ds.dims:
        ds = ds.sel(time=~((ds.time.dt.month == 2) & (ds.time.dt.day == 29)))
        return ds 
    else:
        raise KeyError("dimensions 'time' do not exist in this Dataset")

def compute_daily_climo(da):
    '''
    computes climatology 
    '''
    climatology = da.groupby('time.dayofyear').mean('time')
    
    return climatology

def calculate_anomaly(ds, climo, var_name):
    # Necessary workaround to xarray's check with zero dimensions
    # https://github.com/pydata/xarray/issues/3575
    da = ds[var_name]
    if sum(da.shape) == 0:
        return da
    groupby_type = ds.time.dt.dayofyear
    gb = da.groupby(groupby_type)

    return gb - climo
