import matplotlib.pyplot as plt
import numpy as np

def quantile_compare(xds, yds, kind, grouper='time', quantiles=[.01, .05, .25, .5, .75, .95, .99]):
    """
        Takes the difference or the ratio of quantiles of the input datasets after grouping. 
        `yds - xds` or `yds/xds`,
        
        Parameters
        ----------
        xds : `xr.Dataset`
            The denominator (if `kind`="*") or subtrahend (if `kind`="+").
        yds : `xr.Dataset`
            The numerator (if `kind`="*") or @@@ (if `kind`="+").
        kind : `str`
            "+" or "*".
        grouper : `str`, optional
            What type of grouping to apply to the input datasets before quantiling.
            Defaults to "time" which usually means no actual grouping is performed.
        quantiles : list-like, optional
            Defines quantiles over which to compute the comparison.
            Defaults to [.01, .05, .25, .5, .75, .95, .99]

        Returns
        -------
        xr.Dataset
            The difference or ratio (depending on `kind`) of quantiles of `xds` and `yds`
            
            
    """
    
    if type(grouper) != str: # assume it's of type Grouper from xclim.sdba
        if kind=="+": 
            return grouper.apply("quantile", yds, q=quantiles) - grouper.apply("quantile", xds, q=quantiles)
        else: 
            return grouper.apply("quantile", yds, q=quantiles) / grouper.apply("quantile", xds, q=quantiles)
    else:
        if kind=="+": 
            return yds.groupby(grouper).quantile(quantiles) - xds.groupby(grouper).quantile(quantiles)
        else: 
            return yds.groupby(grouper).quantile(quantiles) / xds.groupby(grouper).quantile(quantiles)
    
def quantile_compare_plot(rawdt, adjustdt, kind, grouper='time', quantiles=[.01, .05, .25, .5, .75, .95, .99], simple=False, tworow=False):
    """     
        Returns a 1x2 or 2x2 Figure showing comparisons of quantiles computed on raw and bias corrected (adjusted) datasets.
        Top row shows quantiles of raw and adjusted quantiles by group, and differences in raw and adjusted quantiles by group.
        
        Parameters
        ----------
        rawdt : dict of `xr.Dataset`
            A dict of Datasets representing the reference, GCM historical, and GCM future time series with keys "ref", "hist", "sim"
        adjustdt : dict of `xr.Dataset`
            A dict of Datasets representing the bias corrected GCM historical, and GCM future time series with keys "hist", "sim"
        kind : `str`
            "+" or "*".
        grouper : `str`, optional
            What type of grouping to apply to the input datasets before quantiling.
            Defaults to "time" which usually means no actual grouping is performed.
            
            If `grouper` not = "time", make sure to only pass ONE element in the `quantiles` list.
        quantiles : list-like, optional
            Defines quantiles over which to compute the comparison.
            Defaults to [.01, .05, .25, .5, .75, .95, .99]
            
            If `grouper` is not = "time", `quantiles` must be list-like with only one element.
        simple : bool
            if True, only plot the GCM Future - GCM Hist comparison with QDM Future - QDM Hist in top right panel. Otherwise includes 
            a number of additional quantile comparisons.
        tworow : bool
            if True, return a 2x2 Figure with bottom row showing scatter plot of GCM vs QDM quantiles for all elements of `grouper`,
            and histogram of differences between QDM and GCM quantiles for all grouping elements.

        Returns
        -------
        plt.Figure
            
    """

    if tworow:
        fig, axs = plt.subplots(2,2,figsize=(20,15))#,sharex=True)#, sharey=True)
        ax=axs[0,0]
    else:
        fig, axs = plt.subplots(1,2,figsize=(20,7))#,sharex=True)#, sharey=True)
        ax=axs[0]
        
    (grouper.apply("quantile", rawdt['ref'], q=quantiles).squeeze().to_pandas()
     .plot(ax=ax, linestyle='none', marker='s', alpha=.5, color='orange', label='Obs ref')
    )
    (grouper.apply("quantile", rawdt['hist'], q=quantiles).squeeze().to_pandas()
     .plot(ax=ax, linestyle='none', marker='o',color='red', label='GCM hist')
    )
    (grouper.apply("quantile", adjustdt['hist'], q=quantiles).squeeze().to_pandas()
     .plot(ax=ax, linestyle='none', marker='o',mfc='none', color='red', label='QDM hist')
    )
    (grouper.apply("quantile", rawdt['sim'], q=quantiles).squeeze().to_pandas()
     .plot(ax=ax, linestyle='none', marker='o',alpha=.5, color='blue', label='GCM future')
    )
    (grouper.apply("quantile", adjustdt['sim'], q=quantiles).squeeze().to_pandas()
     .plot(ax=ax, linestyle='none', marker='o',mfc='none', color='blue', label='QDM future')
    )
    ax.legend(loc='upper left')
    ax.grid(axis='y')

    if 'quantile' in adjustdt['hist'].squeeze().dims:
        quantstr = 'quantiles'
    else:
        quantstr = '{} quantile'.format(quantiles[0])

    ax.set_title('GCM Hist and GCM Future at {} ({})'.format(quantstr,kind))

    if tworow:
        ax=axs[0,1]
    else:
        ax=axs[1]
    if not simple:
        (quantile_compare(rawdt['hist'], rawdt['ref'], kind, quantiles=quantiles,
                         grouper=grouper).squeeze().to_pandas()
         .plot(ax=ax, linestyle='none', marker='*', alpha=.5, color='black', label='Obs ref - GCM hist')
        )
        (quantile_compare(rawdt['ref'], adjustdt['sim'], kind, quantiles=quantiles, 
                         grouper=grouper).squeeze().to_pandas()
         .plot(ax=ax, linestyle='none', marker='s', alpha=.5, color='orange', label='QDM future - Obs ref')
        )
        
    (quantile_compare(rawdt['hist'], rawdt['sim'], kind, quantiles=quantiles, 
                     grouper=grouper).squeeze().to_pandas()
     .plot(ax=ax, linestyle='none', marker='o', alpha=.5, color='blue', label='GCM future - GCM hist')
    )
    
    if not simple:
        (quantile_compare(rawdt['hist'], adjustdt['sim'], kind, quantiles=quantiles, 
                         grouper=grouper).squeeze().to_pandas()
         .plot(ax=ax, linestyle='none', marker='o', mfc='none', color='red', label='QDM future - GCM hist')
        )
        
    (quantile_compare(adjustdt['hist'], adjustdt['sim'], kind, quantiles=quantiles, 
                     grouper=grouper).squeeze().to_pandas()
     .plot(ax=ax, linestyle='none', marker='o', mfc='none', color='blue', label='QDM future - QDM hist')
    )
    
    if not simple:
        if kind=="+":
            derive = (quantile_compare(rawdt['hist'], rawdt['ref'], kind, quantiles=quantiles, grouper=grouper) 
                      + quantile_compare(rawdt['hist'], rawdt['sim'], kind, quantiles=quantiles, grouper=grouper))
        else:
            derive = (quantile_compare(rawdt['hist'], rawdt['ref'], kind, quantiles=quantiles, grouper=grouper) 
                      * quantile_compare(rawdt['hist'], rawdt['sim'], kind, quantiles=quantiles, grouper=grouper))
        
        derive.squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='s', mfc='none', 
                                          color='green', label='compare to open red circle')
    
    ax.legend(ncol=2, frameon=True)
    ax.set_title('Change in {} ({})'.format(quantstr, kind))
    ax.grid(axis='y')


    if tworow:
        ax = axs[1,0]
                
        subgroup = grouper.name.split('.')[-1]
        # scatter the bias corrected quantile delta (x-axis) against raw quantile delta (y-axis)
        # color denotes dayofyear if grouper='time.dayofyear'
        ret = ax.scatter(quantile_compare(adjustdt['hist'], adjustdt['sim'], kind, quantiles=quantiles,
                         grouper=grouper),
                         quantile_compare(rawdt['hist'], rawdt['sim'], kind, quantiles=quantiles,
                         grouper=grouper),
                         c=grouper.apply("mean", rawdt['sim'])[subgroup], cmap='Reds')# @@ will this cmap work?

        xlims = ax.get_xlim()
        ylims = ax.get_ylim()
        ax.plot(np.arange(xlims[0],xlims[1]),np.arange(xlims[0],xlims[1]),linewidth=.5, color='k' )
        ax.set_xlim(xlims)
        ax.set_ylim(ylims)
        ax.set_title('Quantile deltas colored by {} ({})'.format(subgroup,quantstr))
        ax.set_ylabel('GCM Future - GCM Hist')
        ax.set_xlabel('QDM Future - QDM Hist')
        
        ax = axs[1,1]

        ret = ax.hist(
            (quantile_compare(adjustdt['hist'], adjustdt['sim'], kind, quantiles=quantiles,grouper=grouper) 
             - quantile_compare(rawdt['hist'], rawdt['sim'], kind, quantiles=quantiles,grouper=grouper)).squeeze(),
            bins=25
        )
        ax.set_title('QDM-GCM Difference in quantile deltas for all {} ({})'.format(subgroup,quantstr))
        ax.set_ylabel('Count')
        ax.set_xlabel('(QDM-GCM) Difference')
        
    fig.suptitle('QDM Grouped on {} with window {}'.format(grouper.name, grouper.window))
    return fig

def compare_quantile_deltas_scatter_hist(rawdt, adjustdt, grouper, kind, quantiles=[.05,.5,.95]):
    """     
        Returns a 2xlen(`quantiles`) Figure showing scatter plot of GCM vs QDM quantiles for all elements of `grouper`,
            and histogram of differences between QDM and GCM quantiles for all grouping elements.
        
        Parameters
        ----------
        rawdt : dict of `xr.Dataset`
            A dict of Datasets representing the reference, GCM historical, and GCM future time series with keys "ref", "hist", "sim"
        adjustdt : dict of `xr.Dataset`
            A dict of Datasets representing the bias corrected GCM historical, and GCM future time series with keys "hist", "sim"
        kind : `str`
            "+" or "*".
        grouper : `str`
            What type of grouping to apply to the input datasets before quantiling.
            
            If `grouper` not = "time", make sure to only pass ONE element in the `quantiles` list.
        quantiles : list-like, optional
            Defines quantiles over which to compute the comparison.
            Defaults to [.05, .5, .95]
            
        Returns
        -------
        plt.Figure
            
    """
    subgroup = grouper.name.split('.')[-1]
    
    ncols = len(quantiles)
    fig,axs=plt.subplots(2,ncols,figsize=(6*ncols,8))
    for aii in np.arange(ncols):
        ax=axs[0,aii]
        quant=quantiles[aii]

        ret = ax.scatter(quantile_compare(adjustdt['hist'], adjustdt['sim'], kind, quantiles=quant,
                         grouper=grouper),
                         quantile_compare(rawdt['hist'], rawdt['sim'], kind, quantiles=quant,
                         grouper=grouper),
                         c=grouper.apply("mean", rawdt['sim'])[subgroup], cmap='Reds')
        xlims = ax.get_xlim()
        ylims = ax.get_ylim()
        ax.plot(np.arange(xlims[0],xlims[1]),np.arange(xlims[0],xlims[1]),linewidth=.5, color='k' )
        ax.set_xlim(xlims)
        ax.set_ylim(ylims)
        ax.set_title(quant)
    plt.colorbar(ret)

    for aii in np.arange(ncols):
        ax=axs[1,aii]
        quant=quantiles[aii]

        ret = ax.hist(
            (quantile_compare(adjustdt['hist'], adjustdt['sim'], kind, quantiles=quant,grouper=grouper) 
             - quantile_compare(rawdt['hist'], rawdt['sim'], kind, quantiles=quant,grouper=grouper)).squeeze(),
            bins=25
        )
        ax.set_title(quant)

    return fig

def compare_gcm_qdm_quantile_deltas(rawdt, adjustdt, kind, grouper, quantiles=[.05,.5,.95]):
    """     
        Returns a 2xlen(`quantiles`) Figure showing scatter plot of GCM vs QDM quantiles for all elements of `grouper`,
            and histogram of differences between QDM and GCM quantiles for all grouping elements.
        
        Parameters
        ----------
        rawdt : dict of `xr.Dataset`
            A dict of Datasets representing the reference, GCM historical, and GCM future time series with keys "ref", "hist", "sim"
        adjustdt : dict of `xr.Dataset`
            A dict of Datasets representing the bias corrected GCM historical, and GCM future time series with keys "hist", "sim"
        kind : `str`
            "+" or "*".
        grouper : `str`
            What type of grouping to apply to the input datasets before quantiling.
            
            If `grouper` not = "time", make sure to only pass ONE element in the `quantiles` list.
        quantiles : list-like, optional
            Defines quantiles over which to compute the comparison.
            Defaults to [.05, .5, .95]
            
        Returns
        -------
        plt.Figure
            
    """

    subgroup = grouper.name.split('.')[-1]
    
    ncols = len(quantiles)
    fig,axs=plt.subplots(1,ncols,figsize=(6*ncols,5))
    for aii in np.arange(ncols):
        ax=axs[aii]
        quant=quantiles[aii]

        _ = (quantile_compare(adjustdt['hist'], adjustdt['sim'], kind, quantiles=quant,
                         grouper=grouper)
             .plot.line(ax=ax, x='dayofyear', color='red', linestyle='none', marker='.', label="QDM delta")
            )
        _ = (quantile_compare(rawdt['hist'], rawdt['sim'], kind, quantiles=quant,
                         grouper=grouper)
             .plot.line(ax=ax, x='dayofyear', color='orange', linestyle='none', marker='o', mfc='none', label="GCM delta")
            )
        
        ax.set_title(quant)

    ax.legend()

    _ = fig.suptitle('Compare Future Quantiles Deltas by {} with window {}'.format(grouper.name, grouper.window))
    return fig


def plot_quantile_delta_differences_by_group(rawdt, adjustdt, kind, grouper, quantiles=[.01,.05,.17,.25,.5,.75,.83,.95,.99]):
    

    fig,axs=plt.subplots(1,3,figsize=(24,6))
    ax=axs[0]
    quantile_compare(adjustdt['hist'], adjustdt['sim'], kind, quantiles=quantiles,
                         grouper=grouper).plot(ax=ax, cmap='Reds')
    _ = ax.set_xticks(quantiles)
    ax.set_title('QDM (future - hist)')
    ax=axs[1]
    quantile_compare(rawdt['hist'], rawdt['sim'], kind, quantiles=quantiles,
                         grouper=grouper).plot(ax=ax, cmap='Reds')
    _ = ax.set_xticks(quantiles)
    ax.set_title('Raw (future - hist)')
    ax=axs[2]
    (quantile_compare(adjustdt['hist'], adjustdt['sim'], kind, quantiles=quantiles,
                         grouper=grouper) 
     - quantile_compare(rawdt['hist'], rawdt['sim'], kind, quantiles=quantiles,
                         grouper=grouper)).plot(ax=ax,vmin=-1,vmax=1,cmap='RdBu')
    _ = ax.set_xticks(quantiles)
    ax.set_title('QDM diff - Raw diff')

    return fig