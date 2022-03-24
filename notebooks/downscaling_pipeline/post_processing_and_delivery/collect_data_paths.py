# Script to collect intermediary and final DCMIP6 data paths from parameter files. 

import dearprudence as dp
from yaml import load, dump, Loader
import fsspec
import logging
import datetime

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

# User global variables # 
CRED_FILE = '/Users/emile/Desktop/impactlab-data.json' # path to json with GCS credentials
YAML_INPUT_PATT = '/Users/emile/Documents/rhodium/downscaleCMIP6/workflows/parameters/*.yaml' # pattern to find parameter files. The folder should be clean and contain only these files. 
YAML_OUTPUT_PATH = '/Users/emile/Desktop/data_paths.yaml' # where to store the collected paths in a single yaml file. 
##################



# Constant global variables #
LOCAL_FS = fsspec.filesystem('file')
GCLOUD_FS = fsspec.filesystem('gs', token=CRED_FILE)
CLEAN_PATTERN = 'gs://clean-b1dbca25/cmip6/{common}'
CLEAN_REGRIDDED_PATTERN = 'gs://support-c23ff1a3/regrid-cmip6/{common}'
BIASCORRECTED_PATTERN = 'gs://biascorrected-492e989a/stage/{common}'
DOWNSCALED_PATTERN = 'gs://downscaled-288ec5ac/stage/{common}'
COMMON_PATTERN = "{activity_id}/{institution_id}/{source_id}/{experiment_id}/{member_id}/{table_id}/{variable_id}/{grid_label}"
COMMON_VERSION_PATTERN = "%Y%m%d%H%M%S"
DOWNSCALED_DELIVERED_PATTERN = 'gs://downscaled-288ec5ac/outputs/{common_delivered}'
COMMON_DELIVERED_PATTERN = "{activity_id}/{institution_id}/{source_id}/{experiment_id}/{member_id}/{table_id}/{variable_id}"
COMMON_DELIVERED_VERSION = "1.1"

def get_records(fp):
    print(fp)
    runs = dp.read_params(fp)

    records = {}
    for r in runs:
        if r.target == 'ssp':
            records[r.ssp.experiment_id] = r.ssp
        elif r.target == 'historical':
            records['historical'] = r.historical
            source_id = r.historical.source_id
            variable_id = r.historical.variable_id

    return records, source_id, variable_id

def get_paths(fp, gcs_fs):

    paths = {}
    records, source_id, variable_id = get_records(fp)

    for scen, record in records.items():

        common = COMMON_PATTERN.format(**record.__dict__)
        common_delivered = COMMON_DELIVERED_PATTERN.format(**record.__dict__)
        clean = CLEAN_PATTERN.format(common=common)
        clean_regridded = CLEAN_REGRIDDED_PATTERN.format(common=common)
        biascorrected = BIASCORRECTED_PATTERN.format(common=common)
        downscaled = DOWNSCALED_PATTERN.format(common=common)
        downscaled_delivered = DOWNSCALED_DELIVERED_PATTERN.format(common_delivered=common_delivered)
        multi_versioned = dict(biascorrected=biascorrected, downscaled=downscaled, clean_regridded=clean_regridded)

        # appending biascorrected and downscaled version
        for key in multi_versioned:
            fps = gcs_fs.ls(multi_versioned[key]) # listing all versions full absolute url in GCS storage
            versions = [x[len(x) - 19:len(x) - 5] for x in fps] # pull the digits part representing the datetime
            clean_versions = []
            clean_versions_datetime = []
            for v in versions:
                try:
                    v_datetime = datetime.datetime.strptime(v, COMMON_VERSION_PATTERN)
                    clean_versions.append(v)
                    clean_versions_datetime.append(v_datetime)
                except ValueError:
                    logger.warning(f' ignoring a non-parsable version suffix : {v}')
                    pass
            latest = clean_versions[clean_versions_datetime.index(max(clean_versions_datetime))]
            multi_versioned[key] = f'{multi_versioned[key]}/v{latest}.zarr'

        # appending cleaned version
        clean = f'{clean}/v{record.version}.zarr'
        # appending common downscaled delivered version
        downscaled_delivered = f'{downscaled_delivered}/v{COMMON_DELIVERED_VERSION}.zarr'

        paths[scen] = dict(clean=clean, biascorrected=multi_versioned['biascorrected'], downscaled=multi_versioned['downscaled'], clean_regridded=multi_versioned['clean_regridded'], downscaled_delivered=downscaled_delivered)

    return paths, source_id, variable_id

def write_paths(fd_in, fp_out, fs, gcs_fs):

    param_files = fs.glob(fd_in)
    out = {}
    for f in param_files:
        try:
            if 'dtr' not in f:
                print(f"reading {f}")
                paths, source_id, variable_id = get_paths(f, gcs_fs)
                out[f'{source_id}-{variable_id}'] = paths
        except FileNotFoundError:
            logger.warning(f'unable to find data in GCS for parameter file : \n {f}')
            pass

    with fs.open(fp_out, 'w') as outfile:
        dump(out, outfile)

    return out

out = write_paths(fd_in=YAML_INPUT_PATT,
                  fp_out=YAML_OUTPUT_PATH,
                  fs=LOCAL_FS,
                  gcs_fs=GCLOUD_FS)