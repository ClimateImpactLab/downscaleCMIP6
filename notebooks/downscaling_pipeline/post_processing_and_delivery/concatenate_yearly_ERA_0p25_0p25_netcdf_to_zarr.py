import xarray as xr
import numpy as np
import fsspec
import logging
import datetime
import os 

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

FS = fsspec.filesystem("gs", token=os.getenv('GOOGLE_APPLICATION_CREDENTIALS')) # this should give access to impactlab GCS
LOCAL_FS = fsspec.filesystem("file")
FPS_IN_PATTERN = (
    "gs://impactlab-data/climate/source_data/ERA-5/{VARIABLE_ID}/daily/netcdf/v1.1/*.nc"
)
OUT_FP_PATTERN = "gs://impactlab-data/climate/source_data/ERA-5/{VARIABLE_ID}/daily/netcdf/v1.1/all_years_concatenated.zarr"
VAR_PARSER = {
    "pr": "precip_total",
    "tasmin": "tmin",
    "tasmax": "tmax",
}


def get_time(fps, fs=FS):
    """
    get number of days in concat dataset
    """

    time_info = {}
    for fp in fps:
        logger.info(
            f"{str(datetime.datetime.now())} : Retrieving time info for file {fp}"
        )
        try:
            with xr.open_dataset(fs.open(fp)) as ds:
                time_info[fp] = ds["time"].values
        except ValueError as ve:
            logger.error(f"encountered an error reading file {fp} and getting time info, skipping. Error message : {ve}")
    logger.info(
        f"{str(datetime.datetime.now())} : Retrieved dictionary of time info"
    )
    return time_info


def get_lat_lon(fp, fs=FS):
    """
    get lat lon values for concat dataset
    """
    logger.info(f"{str(datetime.datetime.now())} : Retrieving lat lon")
    with xr.open_dataset(fs.open(fp)) as ds:
        lat, lon = ds["latitude"].values, ds["longitude"].values
    logger.info(f"{str(datetime.datetime.now())} : Retrieved lat lon")
    return lat, lon


def prime_zarr(
    fp_out,
    time_info,
    lat=[-1, 1],
    lon=[-1, 1],
    variable="fake_variable",
    fs=FS,
):
    """
    filling a time, lat, lon zarr storage with zeros
    """
    logger.info(f"{str(datetime.datetime.now())} : Priming zarr : {fp_out}")

    time = np.concatenate(list(time_info.values()))
#     time = xr.cftime_range(
#         start=start_time, freq="D", periods=len_time, calendar="standard"
#     ) that was before
    x = np.zeros((len(time), len(lat), len(lon)))
    da = xr.DataArray(
        data=x,
        dims=["time", "lat", "lon"],
        coords={"time": time, "lon": lon, "lat": lat},
    )
    out = xr.Dataset({variable: da})

    out.to_zarr(fs.get_mapper(fp_out), mode="w", compute=False, consolidated=True, safe_chunks=False)

    logger.info(f"{str(datetime.datetime.now())} : Done priming zarr : {fp_out}")
    # with fs.open(fp_out) as outfile:
    #     out.to_zarr(outfile, mode="w", compute=True)


def write_period(fp_in, fp_out, region, variable, fs=FS):

    """
    write some data to a zarr's given time period
    """

    logger.info(
        f"{str(datetime.datetime.now())} : Writing data from {fp_in} to {fp_out}"
    )

    with xr.open_dataset(fs.open(fp_in)) as ds_in:
        # We need to drop all variables not sliced by the selected zarr_region.
        ds_in = ds_in.rename(
            {
                "longitude": "lon",
                "latitude": "lat",
                VAR_PARSER[variable]: variable,
            }
        )
        variables_to_drop = []
        region_variables = list(region.keys())
        for variable_name, variable in ds_in.variables.items():
            if any(
                region_variable not in variable.dims
                for region_variable in region_variables
            ):
                variables_to_drop.append(variable_name)

        to_write = ds_in.drop_vars(variables_to_drop)
    logger.info(
        f"{str(datetime.datetime.now())} : Done converting var names and dropping irrelevant variables"
    )
    logger.info(
        f"{str(datetime.datetime.now())} :Writing to zarr {fp_out} in regions {region}"
    )
    to_write.to_zarr(fs.get_mapper(fp_out), mode="a", region=region)
    logger.info(
        f"{str(datetime.datetime.now())} : Done writing data from {fp_in} to {fp_out}"
    )


def prime_and_write_periods(fp_out, variable, light, fs=FS):

    # priming
    fps_in = fs.glob(FPS_IN_PATTERN.format(VARIABLE_ID=variable))
    if light:
        fps_in = fps_in[1:6]
    time_arrays = get_time(fps_in)
    lat, lon = get_lat_lon(fps_in[0])
    prime_zarr(fp_out, time_arrays, lat, lon, variable)

    logger.info(
        f"{str(datetime.datetime.now())} : Starting to loop over files, length of loop is {len(fps_in)}"
    )
    
    # writing periods
    i = 0
    for fp_in in sorted(list(time_arrays.keys())):
        time_slice_to_write = slice(i, i+len(time_arrays[fp_in]))
        logger.info(
            f"{str(datetime.datetime.now())} : Processing file : {fp_in} with slice : {str(time_slice_to_write)}"
        )
        try:
            write_period(
                fp_in,
                fp_out,
                region={"time": time_slice_to_write},
                variable=variable,
                fs=FS,
            )
            i = i+len(time_arrays[fp_in])
        except Exception:
            logger.error(f"{str(datetime.datetime.now())} : encountered an error writing period of file {fp_in} to {fp_out}")
            raise

    logger.info(
        f"{str(datetime.datetime.now())} : End of files iteration"
    )

def controller(variable, out_fs=FS, overwrite=True, light=False):
    fp_out = OUT_FP_PATTERN.format(VARIABLE_ID=variable)
    if out_fs.exists(fp_out) and overwrite: # should always overwrite, the code is iterating over indices. 
        logger.info(f"Removing already existing {fp_out}")
        out_fs.rm(fp_out, recursive=True)
    prime_and_write_periods(fp_out, variable, light)


# import this module and run it the following way : 
# controller('pr')
# controller('tasmin')
# controller('tasmax')