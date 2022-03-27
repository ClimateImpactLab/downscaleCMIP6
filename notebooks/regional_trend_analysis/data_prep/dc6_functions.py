import gcsfs
import xarray as xr


def read_gcs_zarr(
    zarr_url,
    check=False,
):
    """
    takes in a GCSFS zarr url, bucket token, and returns a dataset 
    Note that you will need to have the proper bucket authentication. 
    """
    fs = gcsfs.GCSFileSystem()

    store_path = fs.get_mapper(zarr_url, check=check)
    ds = xr.open_zarr(store_path)

    return ds


def get_cmip6_models():
    models_dict = {
        'BCC-CSM2-MR': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'FGOALS-g3': ['historical', 'ssp245', 'ssp370', 'ssp585'],
        'ACCESS-ESM1-5': ['historical', 'ssp126', 'ssp245', 'ssp370'],
        'ACCESS-CM2': ['historical', 'ssp245', 'ssp370'],
        'INM-CM4-8': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'INM-CM5-0': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'MIROC-ES2L': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'MIROC6': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'NorESM2-LM': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'NorESM2-MM': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'GFDL-ESM4': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'GFDL-CM4': ['historical', 'ssp245', 'ssp585'],
        'NESM3': ['historical', 'ssp126', 'ssp245', 'ssp585'],
        'MPI-ESM1-2-HR': ['historical', 'ssp126', 'ssp585'],
        'HadGEM3-GC31-LL': ['historical', 'ssp126', 'ssp245', 'ssp585'],
        'UKESM1-0-LL': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'MPI-ESM1-2-LR': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'CMCC-CM2-SR5': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'CMCC-ESM2': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'CanESM5': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'EC-Earth3': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'EC-Earth3-AerChem': ['historical', 'ssp370'],
        'EC-Earth3-CC': ['historical', 'ssp245', 'ssp585'],
        'EC-Earth3-Veg': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
        'EC-Earth3-Veg-LR': ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585'],
    }

    return models_dict


def get_cmip6_institutions():
    institutions = {
        'BCC-CSM2-MR': 'BCC',
        'FGOALS-g3': 'CAS',
        'ACCESS-ESM1-5': 'CSIRO',
        'ACCESS-CM2': 'CSIRO-ARCCSS',
        'INM-CM4-8': 'INM',
        'INM-CM5-0': 'INM',
        'MIROC-ES2L': 'MIROC',
        'MIROC6': 'MIROC',
        'NorESM2-LM': 'NCC',
        'NorESM2-MM': 'NCC',
        'GFDL-ESM4': 'NOAA-GFDL',
        'GFDL-CM4': 'NOAA-GFDL',
        'NESM3': 'NUIST',
        'MPI-ESM1-2-HR': 'DKRZ',
        'HadGEM3-GC31-LL': 'MOHC',
        'UKESM1-0-LL': 'MOHC',
        'MPI-ESM1-2-LR': 'MPI-M',
        'CMCC-CM2-SR5': 'CMCC',
        'CMCC-ESM2': 'CMCC',
        'CanESM5': 'CCCma',
        'EC-Earth3': 'EC-Earth-Consortium',
        'EC-Earth3-AerChem': 'EC-Earth-Consortium',
        'EC-Earth3-CC': 'EC-Earth-Consortium',
        'EC-Earth3-Veg': 'EC-Earth-Consortium',
        'EC-Earth3-Veg-LR': 'EC-Earth-Consortium',
    }

    return institutions


def get_cmip6_grids():
    grids = {
        'BCC-CSM2-MR': 'gn',
        'FGOALS-g3': 'gn',
        'ACCESS-ESM1-5': 'gn',
        'ACCESS-CM2': 'gn',
        'INM-CM4-8': 'gr1',
        'INM-CM5-0': 'gr1',
        'MIROC-ES2L': 'gn',
        'MIROC6': 'gn',
        'NorESM2-LM': 'gn',
        'NorESM2-MM': 'gn',
        'GFDL-ESM4': 'gr1',
        'GFDL-CM4': 'gr1',
        'NESM3': 'gn',
        'MPI-ESM1-2-HR': 'gn',
        'HadGEM3-GC31-LL': 'gn',
        'UKESM1-0-LL': 'gn',
        'MPI-ESM1-2-LR': 'gn',
        'CMCC-CM2-SR5': 'gn',
        'CMCC-ESM2': 'gn',
        'CanESM5': 'gn',
        'EC-Earth3': 'gr',
        'EC-Earth3-AerChem': 'gr',
        'EC-Earth3-CC': 'gr',
        'EC-Earth3-Veg': 'gr',
        'EC-Earth3-Veg-LR': 'gr',
    }

    return grids 


def get_cmip6_ensemble_members():
    ensemble_members = {
        'BCC-CSM2-MR': 'r1i1p1f1',
        'FGOALS-g3': 'r1i1p1f1',
        'ACCESS-ESM1-5': 'r1i1p1f1',
        'ACCESS-CM2': 'r1i1p1f1',
        'INM-CM4-8': 'r1i1p1f1',
        'INM-CM5-0': 'r1i1p1f1',
        'MIROC-ES2L': 'r1i1p1f2',
        'MIROC6': 'r1i1p1f1',
        'NorESM2-LM': 'r1i1p1f1',
        'NorESM2-MM': 'r1i1p1f1',
        'GFDL-ESM4': 'r1i1p1f1',
        'GFDL-CM4': 'r1i1p1f1',
        'NESM3': 'r1i1p1f1',
        'MPI-ESM1-2-HR': 'r1i1p1f1',
        'HadGEM3-GC31-LL': 'r1i1p1f3',
        'UKESM1-0-LL': 'r1i1p1f2',
        'MPI-ESM1-2-LR': 'r1i1p1f1',
        'CMCC-CM2-SR5': 'r1i1p1f1',
        'CMCC-ESM2': 'r1i1p1f1',
        'CanESM5': 'r1i1p1f1',
        'EC-Earth3': 'r1i1p1f1',
        'EC-Earth3-AerChem': 'r1i1p1f1',
        'EC-Earth3-CC': 'r1i1p1f1',
        'EC-Earth3-Veg': 'r1i1p1f1',
        'EC-Earth3-Veg-LR': 'r1i1p1f1',
    }

    return ensemble_members


def get_ds_filepath(varname, model, stage, scen, all_paths):
    filepath = all_paths[model + '-' + varname][scen][stage]
    return filepath


def load_zarr(filepath):
    ds = read_gcs_zarr(filepath)
    return ds


def get_diagnostics_filepath(
    diag_type,
    data_type,
    institutions,
    ensemble_members,
    variable,
    model,
    ssp,
):
    """
    variables: {'tasmax', 'tasmin', 'precip'}
    ssps: {'ssp126', 'ssp245', 'ssp370', 'ssp585'}
    period: {'historical', 'future'}
    diag_type: {'city', 'annual'}
    data_type: {'clean', 'bias_corrected', 'downscaled', 'reanalysis'}
    """

    if variable == "precip":
        file_var_name = "pr"
        var_name = 'pr'
    else:
        file_var_name = variable
        var_name = variable

    if diag_type == 'city':
        agg_period = 'daily'
    elif diag_type == 'annual':
        agg_period = 'annual'

    if data_type == "clean":
        diag_folder = 'clean-{agg_period}-{variable}-diagnostics'.format(
            agg_period=agg_period, variable=variable,
        )
    elif data_type == 'bias_corrected':
        diag_folder = 'biascorrected-{agg_period}-{variable}-diagnostics'.format(
            agg_period=agg_period, variable=variable,
        )
    elif data_type == 'downscaled' or data_type == 'reanalysis':
        diag_folder = '{agg_period}-{variable}-diagnostics'.format(
            agg_period=agg_period, variable=variable,
        )

    if ssp == 'historical':
        experiment = 'CMIP'
    else:
        experiment = 'ScenarioMIP'

    if data_type == 'reanalysis':
        filepath = (
            'gs://downscaled-288ec5ac/diagnostics/RELEASE-v1.1/{diag_folder}/'
            'reanalysis/ERA5/F320/{variable}/v1.1.zarr'
        ).format(diag_folder=diag_folder, variable=file_var_name)
    else:
        filepath = (
            'gs://downscaled-288ec5ac/diagnostics/RELEASE-v1.1/{diag_folder}/'
            '{experiment}/{institution}/{model}/{ssp}/{ensemble_member}/'
            'day/{variable}/v1.1.zarr'
        ).format(
            diag_folder=diag_folder,
            experiment=experiment,
            institution=institutions[model],
            model=model,
            ssp=ssp,
            ensemble_member=ensemble_members[model],
            variable=file_var_name,
        )

    return filepath


def convert_longitudes(ds, lon_name):

    # Adjust lon values to make sure they are within (-180, 180)
    ds['_longitude_adjusted'] = (ds[lon_name] + 180) % 360 - 180

    # reassign the new coords to as the main lon coords
    # and sort DataArray using new coordinate values
    ds = (
        ds
        .swap_dims({lon_name: '_longitude_adjusted'})
        .sel(**{'_longitude_adjusted': sorted(ds._longitude_adjusted)})
        .drop(lon_name))

    ds = ds.rename({'_longitude_adjusted': lon_name})

    return ds
