import xesmf as xe
import pandas as pd
import xarray as xr

def apply_weights(regridder, input_data):
    regridder._grid_in = None
    regridder._grid_out = None
    result = regridder(input_data)
    return result
