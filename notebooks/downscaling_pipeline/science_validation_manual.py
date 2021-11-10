import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
from cartopy import config
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import os 
from matplotlib import cm
import gcsfs
    
def plot_diagnostic_climo_periods(ds_future, ssp, years, variable, metric, data_type, units, ds_hist=None, vmin=240, vmax=320, transform = ccrs.PlateCarree()):    
    """
    plot mean, max, min tasmax, dtr, precip for CMIP6, bias corrected and downscaled data 
    """
    fig, axes = plt.subplots(1, 5, figsize=(20, 6), subplot_kw={'projection': ccrs.PlateCarree()})
    cmap = cm.cividis 
    
    for i, key in enumerate(years): 
        
        # if ds_hist is None, no historical data, skip 
        if ds_hist == None:
            i = 1
        
        # different dataset for historical, select years 
        if i == 0:
            da = ds_hist[variable].sel(time=slice(years[key]['start_yr'], years[key]['end_yr']))
        else:
            da = ds_future[variable].sel(time=slice(years[key]['start_yr'], years[key]['end_yr']))
    
        if metric == 'mean': 
            data = da.mean(dim='time').load()
        elif metric == 'max':
            data = da.max(dim='time').load()
        elif metric == 'min':
            data = da.min(dim='time').load()
        
        
        im = data.plot(ax=axes[i], 
                  cmap=cmap,
                  transform=ccrs.PlateCarree(), add_colorbar=False, vmin=vmin, vmax=vmax)

        axes[i].coastlines()
        axes[i].add_feature(cfeature.BORDERS, linestyle=":")
        if i == 2:
            axes[i].set_title('{} {}, {} \n {}'.format(metric, data_type, ssp, key))
        else: 
            axes[i].set_title("{}".format(key))
    
    # Adjust the location of the subplots on the page to make room for the colorbar
    fig.subplots_adjust(bottom=0.02, top=0.9, left=0.05, right=0.95,
                        wspace=0.1, hspace=0.01)

    # Add a colorbar axis at the bottom of the graph
    cbar_ax = fig.add_axes([0.2, 0.2, 0.6, 0.06])

    # Draw the colorbar
    cbar_title = '{} ({})'.format(variable, units[variable])
    cbar=fig.colorbar(im, cax=cbar_ax, label=cbar_title, orientation='horizontal')
    
def _compute_gmst(da, lat_name='lat', lon_name='lon'):
    lat_weights = np.cos(da[lat_name] * np.pi/180.)
    ones = xr.DataArray(np.ones(da.shape), dims=da.dims, coords=da.coords)
    weights = ones * lat_weights
    masked_weights = weights.where(~da.isnull(), 0)
    
    gmst = (
        (da * masked_weights).sum(dim=(lat_name, lon_name))
        / (masked_weights).sum(dim=(lat_name, lon_name)))
    
    return gmst

def plot_gmst_diagnostic(ds_fut_cmip6, ds_fut_bc, variable='tasmax', 
                         ssp='370', ds_hist_cmip6=None, ds_hist_bc=None, ds_hist_downscaled=None, ds_fut_downscaled=None):
    """
    plot GMST diagnostic for cmip6, bias corrected and downscaled data. Downscaled is usually not included since there is not much added benefit
    of computing it on the downscaled data.
    Takes in annual mean DataArray of the above, eager. 
    """
    
    if ds_hist_cmip6 is not None:
        da_cmip6_hist = ds_hist_cmip6[variable].groupby('time.year').mean()
        gmst_hist_cmip6 = _compute_gmst(da_cmip6_hist.load())
    
    da_cmip6_fut = ds_fut_cmip6[variable].groupby('time.year').mean()
    gmst_fut_cmip6 = _compute_gmst(da_cmip6_fut.load())
    
    if ds_hist_bc is not None:
        da_bc_hist = ds_hist_bc[variable].groupby('time.year').mean()
        gmst_hist_bc = _compute_gmst(da_bc_hist.load())
    
    da_bc_fut = ds_fut_bc[variable].groupby('time.year').mean()
    gmst_fut_bc = _compute_gmst(da_bc_fut.load())
    
    if ds_hist_downscaled is not None: 
        da_ds_hist = ds_hist_downscaled[variable].groupby('time.year').mean()
        gmst_hist_ds = _compute_gmst(da_ds_hist.load())
        
        da_ds_fut = ds_fut_downscaled[variable].groupby('time.year').mean()
        gmst_fut_ds = _compute_gmst(da_ds_fut.load())
        
    fig = plt.figure(figsize=(12, 4))
    if ds_hist_cmip6 is not None:
        gmst_hist_cmip6.plot(linestyle=':', color='black')
    gmst_fut_cmip6.plot(linestyle=':', color='black', label='cmip6')

    if ds_hist_bc is not None:
        gmst_hist_bc.plot(color='green')
    gmst_fut_bc.plot(color='green', label='bias corrected')
    
    if ds_hist_downscaled is not None: 
        gmst_hist_ds.plot(color='blue')
        gmst_fut_ds.plot(color='blue', label='downscaled')
    
    plt.legend()
    plt.title('Global Mean {} {}'.format(variable, ssp))

def plot_bias_correction_downscale_differences(da_hist_bc, da_hist_ds, da_future_bc, da_future_ds, plot_type, data_type, variable,
                                               ssp='370', time_period='2080_2100'):
    """
    plot differences between bias corrected historical and future, downscaled historical and future, or bias corrected and downscaled. 
    produces two subplots, one for historical and one for the specified future time period 
    plot_type options: downscaled_minus_biascorrected, change_from_historical (takes bias corrected or downscaled)
    data_type options: bias_corrected, downscaled
    """
    fig, axes = plt.subplots(1, 2, figsize=(20, 6), subplot_kw={'projection': ccrs.PlateCarree()})

    if plot_type == 'change_from_historical':
        if data_type == 'bias_corrected':
            diff1 = da_hist_bc
            diff2 = da_future_bc - da_hist_bc
        elif data_type == 'downscaled':
            diff1 = da_hist_ds
            diff2 = da_future_ds - da_hist_ds
        suptitle = "{} change from historical: {}".format(ssp, data_type)
        cmap = cm.viridis
    elif plot_type == 'downscaled_minus_biascorrected':
        diff1 = da_hist_ds - da_hist_bc
        diff2 = da_future_ds - da_future_bc
        suptitle = "{} downscaled minus bias corrected".format(ssp)
        cmap = cm.bwr

    cbar_label = "{} ({})".format(variable, units[variable])
    diff1.plot(ax=axes[0], cmap=cmap, transform=ccrs.PlateCarree(), robust=True, cbar_kwargs={'label': cbar_label})
    diff2.plot(ax=axes[1], cmap=cmap, transform=ccrs.PlateCarree(), robust=True, cbar_kwargs={'label': cbar_label})

    axes[0].coastlines()
    axes[0].add_feature(cfeature.BORDERS, linestyle=":")
    axes[0].set_title('historical (1995 - 2014)')
    axes[1].set_title(time_period)
    plt.suptitle(suptitle)

    axes[1].coastlines()
    axes[1].add_feature(cfeature.BORDERS, linestyle=":")

    plt.tight_layout()

def read_gcs_zarr(zarr_url, token='/opt/gcsfuse_tokens/impactlab-data.json', check=False):
    """
    takes in a GCSFS zarr url, bucket token, and returns a dataset 
    Note that you will need to have the proper bucket authentication. 
    """
    fs = gcsfs.GCSFileSystem(token=token)
    
    store_path = fs.get_mapper(zarr_url, check=check)
    ds = xr.open_zarr(store_path)
    
    return ds 
    
