import matplotlib.pyplot as plt
import numpy as np

def quantile_compare(xds, yds, kind, grouper='time', quantiles=[.01, .05, .25, .5, .75, .95, .99]):
    if kind=="+": return yds.groupby(grouper).quantile(quantiles) - xds.groupby(grouper).quantile(quantiles)
    else: return yds.groupby(grouper).quantile(quantiles) / xds.groupby(grouper).quantile(quantiles)
    
def quantile_compare_plot(raw_tuple, adjust_tuple, kind, grouper='time', quantiles=[.01, .05, .25, .5, .75, .95, .99], simple=False, tworow=False):
    """ `raw_tuple` and `adjust_tuple` ordering should be: (ref, hist, sim) and (hist_qdm, sim_qdm) respectively.
    
        if `grouper` is not "time", please pass only one item in list of `quantiles`
    
        `simple`: if True, only plot the GCM Future - GCM Hist comparison with QDM Future - QDM Hist for given quantiles in top right panel
        
        `tworow`: if True, return a 2x2 Figure with bottom row also showing scatter plot and histogram
    """

    if tworow:
        fig, axs = plt.subplots(2,2,figsize=(20,15))#,sharex=True)#, sharey=True)
        ax=axs[0,0]
    else:
        fig, axs = plt.subplots(1,2,figsize=(20,7))#,sharex=True)#, sharey=True)
        ax=axs[0]
    raw_tuple[0].groupby(grouper).quantile(quantiles).squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='s', alpha=.5, color='orange', label='Obs ref')
    raw_tuple[1].groupby(grouper).quantile(quantiles).squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='o',color='red', label='GCM hist')
    adjust_tuple[0].groupby(grouper).quantile(quantiles).squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='o',mfc='none', color='red', label='QDM hist')
    raw_tuple[2].groupby(grouper).quantile(quantiles).squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='o',alpha=.5, color='blue', label='GCM future')
    adjust_tuple[1].groupby(grouper).quantile(quantiles).squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='o',mfc='none', color='blue', label='QDM future')
    ax.legend(loc='upper left')
    ax.grid(axis='y')

    if 'quantile' in adjust_tuple[0].squeeze().dims:
        quantstr = 'quantiles'
    else:
        quantstr = '{} quantile'.format(quantiles[0])

    ax.set_title('GCM Hist and GCM Future at {} ({})'.format(quantstr,kind))

    if tworow:
        ax=axs[0,1]
    else:
        ax=axs[1]
    if not simple:
        quantile_compare(raw_tuple[1], raw_tuple[0], kind, quantiles=quantiles,
                         grouper=grouper).squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='*', alpha=.5, 
                                                                     color='black', label='Obs ref - GCM hist')
        quantile_compare(raw_tuple[0], adjust_tuple[1], kind, quantiles=quantiles, 
                         grouper=grouper).squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='s', alpha=.5, 
                                                                     color='orange', label='QDM future - Obs ref')
    quantile_compare(raw_tuple[1], raw_tuple[2], kind, quantiles=quantiles, 
                     grouper=grouper).squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='o', alpha=.5, 
                                                                 color='blue', label='GCM future - GCM hist')
    if not simple:
        quantile_compare(raw_tuple[1], adjust_tuple[1], kind, quantiles=quantiles, 
                         grouper=grouper).squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='o', mfc='none', 
                                                                     color='red', label='QDM future - GCM hist')
    quantile_compare(adjust_tuple[0], adjust_tuple[1], kind, quantiles=quantiles, 
                     grouper=grouper).squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='o', mfc='none', 
                                                                 color='blue', label='QDM future - QDM hist')
    if not simple:
        if kind=="+":
            derive = (quantile_compare(raw_tuple[1], raw_tuple[0], kind, quantiles=quantiles, grouper=grouper) 
                      + quantile_compare(raw_tuple[1], raw_tuple[2], kind, quantiles=quantiles, grouper=grouper))
        else:
            derive = (quantile_compare(raw_tuple[1], raw_tuple[0], kind, quantiles=quantiles, grouper=grouper) 
                      * quantile_compare(raw_tuple[1], raw_tuple[2], kind, quantiles=quantiles, grouper=grouper))
        
        derive.squeeze().to_pandas().plot(ax=ax, linestyle='none', marker='s', mfc='none', color='green', label='compare to open red circle')
    
    ax.legend(ncol=2, frameon=True)
    ax.set_title('Change in {} ({})'.format(quantstr, kind))
    ax.grid(axis='y')


    if tworow:
        ax = axs[1,0]
                
        subgroup = grouper.split('.')[-1]
        ret = ax.scatter((adjust_tuple[1].groupby(grouper).quantile(quantiles)-adjust_tuple[0].groupby(grouper).quantile(quantiles)),
          (raw_tuple[2].groupby(grouper).quantile(quantiles)-raw_tuple[1].groupby(grouper).quantile(quantiles)),
          c=raw_tuple[2].groupby(grouper).mean()[subgroup], cmap='Reds')
        # plt.colorbar(ret)
        ax.set_title('Trend differences by day of year ({})'.format(quantstr))
        ax.set_ylabel('GCM Future - GCM Hist')
        ax.set_xlabel('QDM Future - QDM Hist')
        
        ax = axs[1,1]

        ret = ax.hist(((adjust_tuple[1].groupby(grouper).quantile(quantiles)-adjust_tuple[0].groupby(grouper).quantile(quantiles))
                       - (raw_tuple[2].groupby(grouper).quantile(quantiles)-raw_tuple[1].groupby(grouper).quantile(quantiles))).squeeze(),
                     bins=25)
        ax.set_title('QDM-GCM Difference in trend differences ({})'.format(quantstr))
        ax.set_ylabel('Count')
        ax.set_xlabel('Difference')
        
    return fig

def compare_quantile_trends_scatter_hist(raw_tuple, adjust_tuple, grouper, quantiles=[.05,.5,.95]):
    
    subgroup = grouper.split('.')[-1]
    
    ncols = len(quantiles)
    fig,axs=plt.subplots(2,ncols,figsize=(6*ncols,8))
    for aii in np.arange(ncols):
        ax=axs[0,aii]
        quant=quantiles[aii]

        ret = ax.scatter((adjust_tuple[1].groupby(grouper).quantile(quant)-adjust_tuple[0].groupby(grouper).quantile(quant)),
                  (raw_tuple[2].groupby(grouper).quantile(quant)-raw_tuple[1].groupby(grouper).quantile(quant)),
                  c=raw_tuple[2].groupby(grouper).mean()[subgroup], cmap='Reds')

        ax.set_title(quant)
    plt.colorbar(ret)

    for aii in np.arange(ncols):
        ax=axs[1,aii]
        quant=quantiles[aii]

        ret = ax.hist(((adjust_tuple[1].groupby(grouper).quantile(quant)-adjust_tuple[0].groupby(grouper).quantile(quant))
                       - (raw_tuple[2].groupby(grouper).quantile(quant)-raw_tuple[1].groupby(grouper).quantile(quant))).squeeze(),
                     bins=25)
        ax.set_title(quant)

    return fig

def compare_gcm_qdm_quantiles(raw_tuple, adjust_tuple, grouper, quantiles=[.05,.5,.95]):
    
    subgroup = grouper.split('.')[-1]
    
    ncols = len(quantiles)
    fig,axs=plt.subplots(1,ncols,figsize=(6*ncols,5))
    for aii in np.arange(ncols):
        ax=axs[aii]
        quant=quantiles[aii]

        _ = (adjust_tuple[1].groupby(grouper).quantile(quant)
             -adjust_tuple[0].groupby(grouper).quantile(quant)).plot.line(ax=ax, x='dayofyear', color='red', linestyle='none', marker='.', label="QDM")
        _ = (raw_tuple[2].groupby(grouper).quantile(quant)
             -raw_tuple[1].groupby(grouper).quantile(quant)).plot.line(ax=ax, x='dayofyear', color='orange', linestyle='none', marker='o', mfc='none', label="GCM")

        ax.set_title(quant)

    ax.legend()

    _ = fig.suptitle('Compare Future Quantiles by day ')
    return fig
