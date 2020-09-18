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

def _convert_ds_longitude(ds, lon_name='longitude'):
    ds_new = ds.assign_coords(lon=(((ds[lon_name] + 180) % 360) - 180)).sortby(lon_name)
    return ds_new

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

def calculate_scaling_factor(ds, climo, var_name, var='temperature'):
    '''
    compute scaling factor 
    '''
    # Necessary workaround to xarray's check with zero dimensions
    # https://github.com/pydata/xarray/issues/3575
    da = ds[var_name]
    if sum(da.shape) == 0:
        return da
    groupby_type = ds.time.dt.dayofyear
    gb = da.groupby(groupby_type)

    if var == 'temperature':
        return gb - climo
    elif var == 'precipitation':
        return gb / climo 

def apply_scale_factor(da, climo, groupby_type, var='temperature'):
    '''
    apply scaling factor
    '''
    sff_daily = da.groupby(groupby_type)
    if var == 'temperature':
        return sff_daily + climo
    elif var == 'precipitation':
        return sff_daily / climo
