import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
from cartopy import config
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import os 
from matplotlib import cm

from matplotlib.backends.backend_pdf import PdfPages
from PyPDF2 import PdfFileMerger

def test_for_nans(ds, var):
    """
    test for presence of NaNs
    """
    assert ds[var].isnull().sum() == 0, "there are nans!"

def test_timesteps(ds, data_type, time_period="future"):
    """
    correct number of timesteps 
    data_type options: cmip6 or other (cmip6 has concatenation for historical/ssps)
    time_period: hist or future
    """
    if time_period == 'future':
        if data_type == 'cmip6': 
            assert (len(ds.time) == 35405), "projection {} file is missing timesteps, only has {}".format(data_type, len(ds.time))
        else: 
            assert (len(ds.time) == 31390), "projection {} file is missing timesteps, only has {}".format(data_type, len(ds.time))
    elif time_period == 'hist':
        if data_type == 'cmip6':
            assert (len(ds.time) == 27740), "historical {} file is missing timesteps, only has {}".format(data_type, len(ds.time))
        else: 
            assert (len(ds.time) == 23725), "historical {} file is missing timesteps, only has {}".format(data_type, len(ds.time))
    
def test_temp_range(ds, var):
    """
    make sure temp values are in a valid range. valid for tas, tasmin, tasmax 
    """
    assert (ds[var].min() > 150) and (ds[var].max() < 350), "{} values are invalid".format(var) 
    
def test_dtr_range(ds, var):
    """
    make sure DTR values are in a valid range
    """
    assert (ds[var].min() > 0) and (ds[var].max() < 45), "diurnal temperature range values are invalid" 
    
def test_low_temp_range(ds, var): 
    """
    if we have some really low temp values, we want to know. valid for tas, tasmin, tasmax  
    """
    threshold = 180 # K
    return ds[var].where(ds[var] < threshold).count()

def test_high_temp_range(ds, var):
    """
    if we have some really high temp values, we want to know. valid for tas, tasmin, tasmax  
    """
    threshold = 330 # K
    return ds[var].where(ds[var] > threshold).count()

def test_negative_values(ds, var):
    """
    test for presence of negative values. valid for DTR or precip 
    """
    # this is not set to 0 to deal with floating point error 
    assert ds[var].where(ds[var] < -0.001).count() == 0, "there are negative values!"

def test_maximum_precip(ds, var):
    """
    test that max precip is reasonable 
    """
    threshold = 2.0 # max observed is 1.825m --> maximum occurs between 0.5-0.8
    return ds[var].where(ds[var] > threshold).count()

def test_variable_names(ds, var):
    """
    test that the correct variable name exists in the file
    """
    assert var in ds.var(), "{} not in Dataset".format(var)
    
def test_dataset_allvars(ds, var, data_type, time_period="future"):
    """
    test tasmax, tasmin, dtr, precip for # of timesteps, NaNs, variable names
    data_type options: cmip6 or other (cmip6 has concatenation for historical/ssps)
    time_period: historical or future
    var: tasmax, tasmin, dtr, pr 
    """
    
    test_for_nans(ds, var)
    test_timesteps(ds, data_type, time_period="future")
    test_variable_names(ds, var)
    
def plot_diagnostic_climo_periods(ds_hist, ds_future, ssp, years, variable, metric, data_type, units, pdf_location, vmin=240, vmax=320, transform = ccrs.PlateCarree()):    
    """
    plot mean, max, min tasmax, dtr, precip for CMIP6, bias corrected and downscaled data 
    """
    fig, axes = plt.subplots(1, 5, figsize=(20, 6), subplot_kw={'projection': ccrs.PlateCarree()})
    cmap = cm.cividis 
    
    for i, key in enumerate(years): 
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
    
    pdf_title = '{}_{}_{}.pdf'.format(variable, metric, data_type)
    pdf_fname = os.path.join(pdf_location, pdf_title)
    pdf = PdfPages(pdf_fname)
    
    pdf.savefig(fig)
    
    pdf.close()
    
    return pdf_fname
    
def compute_gmst(da, lat_name='lat', lon_name='lon'):
    lat_weights = np.cos(da[lat_name] * np.pi/180.)
    ones = xr.DataArray(np.ones(da.shape), dims=da.dims, coords=da.coords)
    weights = ones * lat_weights
    masked_weights = weights.where(~da.isnull(), 0)
    
    gmst = (
        (da * masked_weights).sum(dim=(lat_name, lon_name))
        / (masked_weights).sum(dim=(lat_name, lon_name)))
    
    return gmst

def plot_gmst_diagnostic(ds_hist_cmip6, ds_fut_cmip6, ds_hist_bc, ds_fut_bc, pdf_location, variable='tasmax', 
                         ssp='370', ds_hist_downscaled=None, ds_fut_downscaled=None):
    """
    plot GMST diagnostic for cmip6, bias corrected and downscaled data. Downscaled is usually not included since there is not much added benefit
    of computing it on the downscaled data.
    Takes in annual mean DataArray of the above, eager. 
    """
    da_cmip6_hist = ds_hist_cmip6[variable].groupby('time.year').mean()
    gmst_hist_cmip6 = compute_gmst(da_cmip6_hist.load())
    
    da_cmip6_fut = ds_fut_cmip6[variable].groupby('time.year').mean()
    gmst_fut_cmip6 = compute_gmst(da_cmip6_fut.load())
    
    da_bc_hist = ds_hist_bc[variable].groupby('time.year').mean()
    gmst_hist_bc = compute_gmst(da_bc_hist.load())
    
    da_bc_fut = ds_fut_bc[variable].groupby('time.year').mean()
    gmst_fut_bc = compute_gmst(da_bc_fut.load())
    
    if ds_hist_downscaled is not None: 
        da_ds_hist = ds_hist_downscaled[variable].groupby('time.year').mean()
        gmst_hist_ds = compute_gmst(da_ds_hist.load())
        
        da_ds_fut = ds_fut_downscaled[variable].groupby('time.year').mean()
        gmst_fut_ds = compute_gmst(da_ds_fut.load())
        
    fig = plt.figure(figsize=(12, 4))
    gmst_hist_cmip6.plot(linestyle=':', color='black')
    gmst_fut_cmip6.plot(linestyle=':', color='black', label='cmip6')

    gmst_hist_bc.plot(color='green')
    gmst_fut_bc.plot(color='green', label='bias corrected')
    
    if ds_hist_downscaled is not None: 
        gmst_hist_ds.plot(color='blue')
        gmst_fut_ds.plot(color='blue', label='downscaled')
    
    plt.legend()
    plt.title('Global Mean {} {}'.format(variable, ssp))
    
    pdf_title = 'global_mean_{}_{}.pdf'.format(variable, ssp)
    pdf_fname = os.path.join(pdf_location, pdf_title)
    pdf = PdfPages(pdf_fname)
    
    pdf.savefig(fig)
    
    pdf.close()
    
    return pdf_fname

def plot_bias_correction_downscale_differences(da_hist_bc, da_hist_ds, da_future_bc, da_future_ds, plot_type, data_type, pdf_location, variable,
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
        pdf_title = '{}_{}_{}.pdf'.format(variable, plot_type, data_type)
    elif plot_type == 'downscaled_minus_biascorrected':
        diff1 = da_hist_ds - da_hist_bc
        diff2 = da_future_ds - da_future_bc
        suptitle = "{} downscaled minus bias corrected".format(ssp)
        cmap = cm.bwr
        pdf_title = '{}_{}.pdf'.format(variable, plot_type)

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
    
    pdf_fname = os.path.join(pdf_location, pdf_title)
    pdf = PdfPages(pdf_fname)
    
    pdf.savefig(fig, dpi=200)
    
    pdf.close()
    
    return pdf_fname

def merge_validation_pdfs(pdf_list, pdf_fname):
    """
    merges list of validation pdfs into one master pdf from a pipeline run 
    """
    # initiate merger object
    merger = PdfFileMerger()

    # loop over all pdfs in pdf_list and merge them
    for pdf in pdf_list:
        merger.append(pdf)

    merger.write(pdf_fname)
    merger.close()
    
