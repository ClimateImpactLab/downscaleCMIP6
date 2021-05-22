AZ_RESOURCE_GROUP="dc6-resources"
CLUSTER_NAME="dc6-amaterasu"
ARGO_NAMESPACE="argo"

# Set AKS credentials into kubectl config context
az aks get-credentials --name "${CLUSTER_NAME}" --resource-group "${AZ_RESOURCE_GROUP}" --overwrite-existing


argo server --namespaced --managed-namespace argo

argo submit dc6-dev-workflow.yaml --entrypoint train-qdm \
    -p variable="fakevariable" \
    -p ref-zarr="scratch/qdm-dev-4gtfv/input/refdf.zarr" \
    -p hist-zarr="scratch/qdm-dev-4gtfv/input/histdf.zarr" \
    -p out-zarr="scratch/dev/trained-qdm-model.zarr" \
    -p n-quantiles=100 \
    -n argo --watch


#   File "/argo/staging/script", line 26, in <module>
#     QDMdg = sdba.adjustment.QuantileDeltaMapping.from_dataset(qdm_model_ds)
#   File "/opt/conda/lib/python3.8/site-packages/xclim/sdba/base.py", line 125, in from_dataset
#     obj = cls.from_string(defstr)
#   File "/opt/conda/lib/python3.8/site-packages/xclim/sdba/base.py", line 82, in from_string
#     params[dd["name"]] = cls._parametrizable_classes[
# KeyError: 'Grouper'



argo submit dc6-dev-workflow.yaml --entrypoint rechunk \
    -p variable="fakevariable" \
    -p in-zarr="clean-dev/ACCESS-ESM1-5.historical.zarr" \
    -p out-zarr="scratch/rechunk-dev/output.zarr" \
    -p time-chunk="-1" \
    -p lat-chunk="30" \
    -p lon-chunk="30" \
    -n argo --watch
# dc6-dev-plrg4-580946482: Traceback (most recent call last):
# dc6-dev-plrg4-580946482:   File "/argo/staging/script", line 25, in <module>
# dc6-dev-plrg4-580946482:     plan = rechunk(
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/rechunker/api.py", line 296, in rechunk
# dc6-dev-plrg4-580946482:     copy_spec, intermediate, target = _setup_rechunk(
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/rechunker/api.py", line 377, in _setup_rechunk
# dc6-dev-plrg4-580946482:     copy_spec = _setup_array_rechunk(
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/rechunker/api.py", line 497, in _setup_array_rechunk
# dc6-dev-plrg4-580946482:     target_array = _zarr_empty(
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/rechunker/api.py", line 151, in _zarr_empty
# dc6-dev-plrg4-580946482:     return store_or_group.empty(
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/zarr/hierarchy.py", line 901, in empty
# dc6-dev-plrg4-580946482:     return self._write_op(self._empty_nosync, name, **kwargs)
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/zarr/hierarchy.py", line 661, in _write_op
# dc6-dev-plrg4-580946482:     return f(*args, **kwargs)
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/zarr/hierarchy.py", line 907, in _empty_nosync
# dc6-dev-plrg4-580946482:     return empty(store=self._store, path=path, chunk_store=self._chunk_store,
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/zarr/creation.py", line 227, in empty
# dc6-dev-plrg4-580946482:     return create(shape=shape, fill_value=None, **kwargs)
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/zarr/creation.py", line 121, in create
# dc6-dev-plrg4-580946482:     init_array(store, shape=shape, chunks=chunks, dtype=dtype, compressor=compressor,
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/zarr/storage.py", line 348, in init_array
# dc6-dev-plrg4-580946482:     _init_array_metadata(store, shape=shape, chunks=chunks, dtype=dtype,
# dc6-dev-plrg4-580946482:   File "/opt/conda/lib/python3.8/site-packages/zarr/storage.py", line 377, in _init_array_metadata
# dc6-dev-plrg4-580946482:     raise ContainsArrayError(path)
# dc6-dev-plrg4-580946482: zarr.errors.ContainsArrayError: path 'lat' contains an array

# argo submit dc6-dev-workflow.yaml --entrypoint netcdfs2zarr \
#     -p in-dir="scratch/dc6-dev-m7zfj/qdm-years/" \
#     -p out-dir="scratch/rechunk-dev/output.zarr" \
#     -n argo --watch


# tasks.generate-parameter.outputs.parameters.hello-param



# argo submit workflows/dc6-dev-workflow.yaml \
#     --entrypoint rechunk \
#     -p "in-zarr=scratch/clean-dev/ERA-5/tmax.1995-2014.0p25.zarr" \
#     -p "variable=tmax" \
#     -p "out-zarr=scratch/rechunk-dev/ERA-5/tmax.1995-2014.0p25.zarr" \
#     -p "time-chunk=7300" \
#     -p "lat-chunk=10" \
#     -p "lon-chunk=10" \
#     -p "maxmemory=4294967296" \
#     -n argo --watch

argo submit workflows/dc6-dev-workflow.yaml \
    --entrypoint rechunk \
    -p "in-zarr=scratch/clean-dev/ERA-5/tmax.1995-2014.0p25.zarr" \
    -p "variable=tasmax" \
    -p "out-zarr=scratch/rechunk-dev/ERA-5/tmax.1995-2014.0p25.zarr" \
    -p "time-chunk=7300" \
    -p "lat-chunk=10" \
    -p "lon-chunk=10" \
    -n argo --watch


argo submit workflows/dc6-dev-workflow.yaml \
    --entrypoint rechunk-zarr \
    -p "in-zarr=scratch/clean-dev/ERA-5/tmax.1995-2014.0p25.zarr" \
    -p "variable=tmax" \
    -p "tmp-zarr=scratch/rechunk-dev/rechunk-tmp.zarr" \
    -p "out-zarr=scratch/rechunk-dev/ERA-5/tmax.1995-2014.0p25.zarr" \
    -p "time-chunk=7300" \
    -p "lat-chunk=10" \
    -p "lon-chunk=10" \
    -n argo


argo submit workflows/dc6-dev-workflow.yaml \
    --entrypoint rechunk-xarray \
    -p "in-zarr=scratch/clean-dev/ERA-5/tmax.1995-2014.0p25.zarr" \
    -p "variable=tmax" \
    -p "tmp-zarr=scratch/rechunk-dev/rechunk-xarray-tmp.zarr" \
    -p "out-zarr=scratch/rechunk-dev/ERA-5/tmax-xarray.1995-2014.0p25.zarr" \
    -p "time-chunk=7300" \
    -p "lat-chunk=10" \
    -p "lon-chunk=10" \
    -n argo

argo submit workflows/dc6-workflow.yaml \
    --entrypoint printzarr \
    -p "in-zarr=az://scratch/downscale-dev-zlqw6/adjustmentfactors-original.zarr" \
    --generate-name "print-" -n argo --watch

#    -p "in-zarr=az://clean/ACCESS-ESM1-5/training/r1i1p1f1/tasmax.zarr" \


argo submit workflows/dc6-workflow.yaml \
    --entrypoint rechunker \
    -p "in-zarr=az://clean/ACCESS-ESM1-5/ssp370/r1i1p1f1/tasmax.zarr" \
    -p "out-zarr=az://scratch/{{ workflow.name }}/tasmax-rechunked.zarr" \
    -n argo --watch


argo submit workflows/dc6-dev-workflow.yaml \
    --entrypoint timeslicezarr \
    -p "in-zarr=clean-dev/ACCESS-ESM1-5.historical.zarr" \
    -p "out-zarr=scratch/timeslicezarr-dev/sliced.zarr" \
    -p "fromtime=1995" \
    -p "totime=2015" \
    -n argo --watch


argo submit workflows/dc6-dev-workflow.yaml \
    --entrypoint printzarr \
    -p "in-zarr=scratch/dc6-dev-lftv7/reference-rechunk.zarr" \
    --generate-name printzarr- \
    -n argo --watch

## Confirm rechunk/regrid input to bias correction step looks good.
# (base) rhgmac-bmalevich:dc6_argo_workflow bmalevich$ argo logs printzarr-9jv6v -n argo
# printzarr-9jv6v: opening scratch/dc6-dev-lftv7/gcm-historical-rechunk.zarr
# printzarr-9jv6v: <xarray.Dataset>
# printzarr-9jv6v: Dimensions:  (lat: 180, lon: 360, time: 7300)
# printzarr-9jv6v: Coordinates:
# printzarr-9jv6v:   * lat      (lat) float64 -89.5 -88.5 -87.5 -86.5 -85.5 ... 86.5 87.5 88.5 89.5
# printzarr-9jv6v:   * lon      (lon) float64 -179.5 -178.5 -177.5 -176.5 ... 177.5 178.5 179.5
# printzarr-9jv6v:   * time     (time) object 1995-01-01 12:00:00 ... 2014-12-31 12:00:00
# printzarr-9jv6v: Data variables:
# printzarr-9jv6v:     tasmax   (time, lat, lon) float64 dask.array<chunksize=(7300, 10, 10), meta=np.ndarray>
# printzarr-9jv6v: Attributes:
# printzarr-9jv6v:     regrid_method:  bilinear
# (base) rhgmac-bmalevich:dc6_argo_workflow bmalevich$ argo logs printzarr-5zn5t -n argo
# printzarr-5zn5t: opening scratch/dc6-dev-lftv7/gcm-future-rechunk.zarr
# printzarr-5zn5t: <xarray.Dataset>
# printzarr-5zn5t: Dimensions:  (lat: 180, lon: 360, time: 31390)
# printzarr-5zn5t: Coordinates:
# printzarr-5zn5t:   * lat      (lat) float64 -89.5 -88.5 -87.5 -86.5 -85.5 ... 86.5 87.5 88.5 89.5
# printzarr-5zn5t:   * lon      (lon) float64 -179.5 -178.5 -177.5 -176.5 ... 177.5 178.5 179.5
# printzarr-5zn5t:   * time     (time) object 2015-01-01 12:00:00 ... 2100-12-31 12:00:00
# printzarr-5zn5t: Data variables:
# printzarr-5zn5t:     tasmax   (time, lat, lon) float64 dask.array<chunksize=(31390, 10, 10), meta=np.ndarray>
# printzarr-5zn5t: Attributes:
# printzarr-5zn5t:     regrid_method:  bilinear
# (base) rhgmac-bmalevich:dc6_argo_workflow bmalevich$ argo logs printzarr-qwqr8 -n argo
# printzarr-qwqr8: opening scratch/dc6-dev-lftv7/reference-rechunk.zarr
# printzarr-qwqr8: <xarray.Dataset>
# printzarr-qwqr8: Dimensions:  (lat: 180, lon: 360, time: 7300)
# printzarr-qwqr8: Coordinates:
# printzarr-qwqr8:   * lat      (lat) float64 -89.5 -88.5 -87.5 -86.5 -85.5 ... 86.5 87.5 88.5 89.5
# printzarr-qwqr8:   * lon      (lon) float64 -179.5 -178.5 -177.5 -176.5 ... 177.5 178.5 179.5
# printzarr-qwqr8:   * time     (time) object 1995-01-01 00:00:00 ... 2014-12-31 00:00:00
# printzarr-qwqr8: Data variables:
# printzarr-qwqr8:     tasmax   (time, lat, lon) float64 dask.array<chunksize=(7300, 10, 10), meta=np.ndarray>
# printzarr-qwqr8: Attributes:


argo submit workflows/dc6-dev-workflow.yaml --entrypoint biascorrect-qdm \
    -p variable="tasmax" \
    -p ref-zarr="scratch/dc6-dev-lftv7/reference-rechunk.zarr" \
    -p hist-zarr="scratch/dc6-dev-lftv7/gcm-historical-rechunk.zarr" \
    -p future-zarr="scratch/dc6-dev-lftv7/gcm-future-rechunk.zarr" \
    -p out-zarr="scratch/dev/bias-corrected-20210412.zarr" \
    -p n-quantiles=100 \
    -p halfwindow-length=10 \
    -n argo --watch


argo submit workflows/dc6-dev-workflow.yaml --entrypoint qdm-adjust-year \
    -p variable="tasmax" \
    -p year="2025" \
    -p future-zarr="scratch/dc6-dev-lftv7/gcm-future-rechunk.zarr" \
    -p qdm-model-zarr="scratch/dc6-dev-dqt85/qdm-model.zarr" \
    -p out="scratch/{{ workflow.name }}/bias-corrected.zarr" \
    -p halfwindow-length=10 \
    --generate-name "qdm-dev-" \
    -n argo --watch

# Starting QDM-adjust for single year
# Installed custom xclim branch with pip
# Loaded QDM model data
# Created QDM model
# Setup I/O for data-to-adjust
# Data to adjust loaded in
# sys:1: UserWarning: This adjustment was trained on a simulation with the None calendar but the sim input uses noleap. This is not recommended with dayofyear grouping and could give strange results.
# Traceback (most recent call last):
#   File "/argo/staging/script", line 49, in <module>
#     y = QDMdg.adjust(simdf).sel(time=str(yr))
#   File "/opt/conda/lib/python3.8/site-packages/xclim/sdba/adjustment.py", line 141, in adjust
#     scen = self._adjust(sim, **kwargs)
#   File "/opt/conda/lib/python3.8/site-packages/xclim/sdba/adjustment.py", line 415, in _adjust
#     scen = qdm_adjust(
#   File "/opt/conda/lib/python3.8/site-packages/xclim/sdba/base.py", line 533, in _map_blocks
#     if group is not None and len(chunks[group.dim]) > 1:
# KeyError: 'time'

# printzarr-wtl2l: opening scratch/dc6-dev-lftv7/gcm-historical-rechunk.zarr
# printzarr-wtl2l: <xarray.DataArray 'time' (time: 7300)>
# printzarr-wtl2l: array([cftime.DatetimeNoLeap(1995, 1, 1, 12, 0, 0, 0),
# printzarr-wtl2l:        cftime.DatetimeNoLeap(1995, 1, 2, 12, 0, 0, 0),
# printzarr-wtl2l:        cftime.DatetimeNoLeap(1995, 1, 3, 12, 0, 0, 0), ...,
# printzarr-wtl2l:        cftime.DatetimeNoLeap(2014, 12, 29, 12, 0, 0, 0),
# printzarr-wtl2l:        cftime.DatetimeNoLeap(2014, 12, 30, 12, 0, 0, 0),
# printzarr-wtl2l:        cftime.DatetimeNoLeap(2014, 12, 31, 12, 0, 0, 0)], dtype=object)
# printzarr-wtl2l: Coordinates:
# printzarr-wtl2l:   * time     (time) object 1995-01-01 12:00:00 ... 2014-12-31 12:00:00
# printzarr-wtl2l: Attributes:
# printzarr-wtl2l:     axis:           T
# printzarr-wtl2l:     bounds:         time_bnds
# printzarr-wtl2l:     long_name:      time
# printzarr-wtl2l:     standard_name:  time

# printzarr-brtbp: opening scratch/dc6-dev-lftv7/reference-rechunk.zarr
# printzarr-brtbp: <xarray.DataArray 'time' (time: 7300)>
# printzarr-brtbp: array([cftime.DatetimeNoLeap(1995, 1, 1, 0, 0, 0, 0),
# printzarr-brtbp:        cftime.DatetimeNoLeap(1995, 1, 2, 0, 0, 0, 0),
# printzarr-brtbp:        cftime.DatetimeNoLeap(1995, 1, 3, 0, 0, 0, 0), ...,
# printzarr-brtbp:        cftime.DatetimeNoLeap(2014, 12, 29, 0, 0, 0, 0),
# printzarr-brtbp:        cftime.DatetimeNoLeap(2014, 12, 30, 0, 0, 0, 0),
# printzarr-brtbp:        cftime.DatetimeNoLeap(2014, 12, 31, 0, 0, 0, 0)], dtype=object)
# printzarr-brtbp: Coordinates:
# printzarr-brtbp:   * time     (time) object 1995-01-01 00:00:00 ... 2014-12-31 00:00:00

# sys:1: UserWarning: This adjustment was trained on a simulation with the None calendar but the sim input uses noleap. This is not recommended with dayofyear grouping and could give strange results.

argo submit workflows/dc6-dev-workflow.yaml --entrypoint train-qdm \
    -p variable="tasmax" \
    -p ref-zarr="scratch/dc6-dev-lftv7/reference-rechunk.zarr" \
    -p hist-zarr="scratch/dc6-dev-lftv7/gcm-historical-rechunk.zarr" \
    -p out-zarr="scratch/dev/trained-qdm-model.zarr" \
    -p n-quantiles=100 \
    -n argo --watch

argo submit workflows/dc6-dev-workflow.yaml --entrypoint qdm-adjust-year \
    -p variable="tasmax" \
    -p year="2025" \
    -p future-zarr="scratch/dc6-dev-lftv7/gcm-future-rechunk.zarr" \
    -p qdm-model-zarr="scratch/dev/trained-qdm-model.zarr" \
    -p out="scratch/{{ workflow.name }}/bias-corrected.zarr" \
    -p halfwindow-length=10 \
    --generate-name "qdm-dev-" \
    -n argo --watch

# (base) rhgmac-bmalevich:dc6_argo_workflow bmalevich$ argo logs @latest -n argoqdm-dev-8mjp9-2662407511: Starting QDM-adjust for single yearqdm-dev-8mjp9-2662407511: Installed custom xclim branch with pip
# qdm-dev-8mjp9-2662407511: Loaded QDM model data
# qdm-dev-8mjp9-2662407511: Created QDM model
# qdm-dev-8mjp9-2662407511: Setup I/O for data-to-adjust
# qdm-dev-8mjp9-2662407511: Data to adjust loaded
# qdm-dev-8mjp9-2662407511: <xarray.DataArray 'tasmax' (time: 7665, lat: 180, lon: 360)>
# qdm-dev-8mjp9-2662407511: array([[[247.88690676, 247.93293836, 247.96119606, ..., 247.82571479,
# qdm-dev-8mjp9-2662407511:          247.83269658, 247.85348944],
# qdm-dev-8mjp9-2662407511:         [249.81658849, 249.92910541, 250.00214715, ..., 249.65184398,
# qdm-dev-8mjp9-2662407511:          249.67806317, 249.73290082],
# qdm-dev-8mjp9-2662407511:         [252.86200711, 252.96454593, 253.0469183 , ..., 252.64993311,
# qdm-dev-8mjp9-2662407511:          252.71159432, 252.77767821],
# qdm-dev-8mjp9-2662407511:         ...,
# qdm-dev-8mjp9-2662407511:         [244.01069845, 243.96136587, 243.89920312, ..., 244.10399711,
# qdm-dev-8mjp9-2662407511:          244.08332109, 244.05135515],
# qdm-dev-8mjp9-2662407511:         [241.41015936, 241.4265724 , 241.41082552, ..., 241.39697897,
# qdm-dev-8mjp9-2662407511:          241.37682421, 241.3935769 ],
# qdm-dev-8mjp9-2662407511:         [239.41961214, 239.43277264, 239.43109339, ..., 239.40367159,
# qdm-dev-8mjp9-2662407511:          239.39568983, 239.40724995]],
# qdm-dev-8mjp9-2662407511: 
# qdm-dev-8mjp9-2662407511:        [[251.05113708, 251.08142007, 251.11260122, ..., 250.98022607,
# qdm-dev-8mjp9-2662407511:          251.00332348, 251.02510224],
# qdm-dev-8mjp9-2662407511:         [250.564764  , 250.63491095, 250.70777465, ..., 250.3920249 ,
# qdm-dev-8mjp9-2662407511:          250.44006914, 250.49981139],
# qdm-dev-8mjp9-2662407511:         [253.36805359, 253.41645144, 253.46831221, ..., 253.213036  ,
# qdm-dev-8mjp9-2662407511:          253.22311765, 253.30360255],
# qdm-dev-8mjp9-2662407511: ...
# qdm-dev-8mjp9-2662407511:         [243.85569804, 243.94981712, 244.03423667, ..., 243.50529356,
# qdm-dev-8mjp9-2662407511:          243.61120833, 243.74282598],
# qdm-dev-8mjp9-2662407511:         [240.3553147 , 240.41804394, 240.45855037, ..., 240.26135498,
# qdm-dev-8mjp9-2662407511:          240.27288606, 240.30692291],
# qdm-dev-8mjp9-2662407511:         [238.17478022, 238.19675656, 238.20851267, ..., 238.16285465,
# qdm-dev-8mjp9-2662407511:          238.15805742, 238.1618792 ]],
# qdm-dev-8mjp9-2662407511: 
# qdm-dev-8mjp9-2662407511:        [[248.11362136, 248.10617334, 248.10477437, ..., 248.12344544,
# qdm-dev-8mjp9-2662407511:          248.12004155, 248.11824456],
# qdm-dev-8mjp9-2662407511:         [248.34686401, 248.34795376, 248.36832359, ..., 248.29484562,
# qdm-dev-8mjp9-2662407511:          248.31076648, 248.3344645 ],
# qdm-dev-8mjp9-2662407511:         [250.34944118, 250.42948092, 250.54489039, ..., 249.9913326 ,
# qdm-dev-8mjp9-2662407511:          250.10510231, 250.24130817],
# qdm-dev-8mjp9-2662407511:         ...,
# qdm-dev-8mjp9-2662407511:         [246.17928967, 246.04019368, 245.8831498 , ..., 246.57039995,
# qdm-dev-8mjp9-2662407511:          246.44017183, 246.31263026],
# qdm-dev-8mjp9-2662407511:         [245.2910683 , 245.20280089, 245.09954231, ..., 245.54697683,
# qdm-dev-8mjp9-2662407511:          245.46351521, 245.37798157],
# qdm-dev-8mjp9-2662407511:         [244.30766549, 244.27744326, 244.24151184, ..., 244.39651185,
# qdm-dev-8mjp9-2662407511:          244.36780637, 244.33778958]]])
# qdm-dev-8mjp9-2662407511: Coordinates:
# qdm-dev-8mjp9-2662407511:   * lat      (lat) float64 -89.5 -88.5 -87.5 -86.5 -85.5 ... 86.5 87.5 88.5 89.5
# qdm-dev-8mjp9-2662407511:   * lon      (lon) float64 -179.5 -178.5 -177.5 -176.5 ... 177.5 178.5 179.5
# qdm-dev-8mjp9-2662407511:   * time     (time) object 2015-01-01 12:00:00 ... 2035-12-31 12:00:00
# qdm-dev-8mjp9-2662407511: sys:1: UserWarning: This adjustment was trained on a simulation with the None calendar but the sim input uses noleap. This is not recommended with dayofyear grouping and could give strange results.
# qdm-dev-8mjp9-2662407511: Traceback (most recent call last):
# qdm-dev-8mjp9-2662407511:   File "/argo/staging/script", line 49, in <module>
# qdm-dev-8mjp9-2662407511:     y = QDMdg.adjust(simdf) #.sel(time=str(yr))
# qdm-dev-8mjp9-2662407511:   File "/opt/conda/lib/python3.8/site-packages/xclim/sdba/adjustment.py", line 141, in adjust
# qdm-dev-8mjp9-2662407511:     scen = self._adjust(sim, **kwargs)
# qdm-dev-8mjp9-2662407511:   File "/opt/conda/lib/python3.8/site-packages/xclim/sdba/adjustment.py", line 415, in _adjust
# qdm-dev-8mjp9-2662407511:     scen = qdm_adjust(
# qdm-dev-8mjp9-2662407511:   File "/opt/conda/lib/python3.8/site-packages/xclim/sdba/base.py", line 533, in _map_blocks
# qdm-dev-8mjp9-2662407511:     if group is not None and len(chunks[group.dim]) > 1:
# qdm-dev-8mjp9-2662407511: KeyError: 'time'


argo submit workflows/dc6-dev-workflow.yaml \
    --entrypoint printzarr \
    -p "in-zarr=scratch/dc6-dev-xfqzt/biascorrected.zarr" \
    -n argo --watch

# dc6-dev-snmnc: opening scratch/dc6-dev-xfqzt/biascorrected.zarr
# dc6-dev-snmnc: <xarray.Dataset>
# dc6-dev-snmnc: Dimensions:  (lat: 180, lon: 360, time: 23725)
# dc6-dev-snmnc: Coordinates:
# dc6-dev-snmnc:   * lat      (lat) float64 -89.5 -88.5 -87.5 -86.5 -85.5 ... 86.5 87.5 88.5 89.5
# dc6-dev-snmnc:   * lon      (lon) float64 -179.5 -178.5 -177.5 -176.5 ... 177.5 178.5 179.5
# dc6-dev-snmnc:   * time     (time) object 2025-01-01 12:00:00 ... 2089-12-31 12:00:00
# dc6-dev-snmnc: Data variables:
# dc6-dev-snmnc:     scen     (lat, time, lon) float64 dask.array<chunksize=(180, 365, 360), meta=np.ndarray>

argo submit workflows/dc6-workflow.yaml -n argo --entrypoint netcdfs2zarr -p "out-zarr=scratch/{{workflow.name}}/collected.zarr"
dc6-dev-artifactqdm-ccrvp-1845844236

argo submit workflows/dc6-workflow.yaml \
    --entrypoint regrid \
    -p "in-zarr={{ workflow.parameters.climatology-zarr }}" \
    -p "out-zarr=az://scratch/{{ workflow.name }}/coarse-climatology-regrided.zarr" \
    -p "regrid-method=bilinear" \
    -p "domain-file={{ workflow.parameters.domainfile1x1 }}" \
    -n argo --watch

argo submit workflows/dc6-workflow.yaml \
    --entrypoint regrid \
    -p "in-zarr={{ workflow.parameters.climatology-zarr }}" \
    -p "out-zarr=az://scratch/{{ workflow.name }}/fine-climatology-regrided.zarr" \
    -p "regrid-method=bilinear" \
    -p "domain-file={{ workflow.parameters.domainfile0p25x0p25 }}" \
    -n argo --watch

argo submit workflows/dc6-workflow.yaml \
    --entrypoint printzarr \
    -p "in-zarr={{ workflow.parameters.climatology-zarr }}" \
    -n argo --watch

# dodola downscale "az://scratch/dc6-dev-dx794/biascorrected.zarr" \
#     --trainvariable "tasmax" \
#     --yclimocoarse \ # ???
#     --yclimofine "az://clean-dev/tasmax_1995_2015_climo.zarr" \ # ???
#     --out "az://scratch/{{ workflow.name }}/downscaled.zarr" \
#     --method "BCSD" \
#     --domainfile "az://support/domain.0p25x0p25.zarr" \
#     --adjustmentfactors "az://scratch/{{ workflow.name }}/downscale-adjustfacts.zarr"

#       - name: in-zarr
#       - name: domainfile-zarr
#       - name: yclimocoarse-zarr
#       - name: yclimofine-zarr
#       - name: variable
#       - name: method
#       - name: adjustmentfactors-out-zarr
#       - name: out-zarr


argo submit workflows/dc6-workflow.yaml \
    --entrypoint rechunk2 \
    -p "in-zarr={{ workflow.parameters.climatology-zarr }}" \
    -p "variable=tasmax" \
    -p "out-zarr=az://scratch/{{workflow.name}}/clim-rechunk.zarr" \
    -p "time-chunk=-1" \
    -p "lat-chunk=-1" \
    -p "lon-chunk=-1" \
    --generate-name "clim-rechunk2-test-" \
    -n argo --watch

argo submit workflows/dc6-workflow.yaml \
    --entrypoint regrid \
    -p "in-zarr=az://scratch/clim-rechunk2-test-4vpf2/clim-rechunk.zarr" \
    -p "out-zarr=az://scratch/{{ workflow.name }}/fine-climatology-regrided.zarr" \
    -p "regrid-method=bilinear" \
    -p "domain-file={{ workflow.parameters.domainfile0p25x0p25 }}" \
    --generate-name "clim-fineregrid-test-" \
    -n argo --watch

argo submit workflows/dc6-workflow.yaml \
    --entrypoint regrid \
    -p "in-zarr=az://scratch/clim-rechunk2-test-4vpf2/clim-rechunk.zarr" \
    -p "out-zarr=az://scratch/{{ workflow.name }}/coarse-climatology-regrided.zarr" \
    -p "regrid-method=conservative" \
    -p "domain-file={{ workflow.parameters.domainfile1x1 }}" \
    --generate-name "clim-coarseregrid-test-" \
    -n argo --watch




argo submit workflows/clean-cmip6-workflow.yaml \
    --entrypoint standardize-cmip6 \
    -p "in-zarr=az://raw/ACCESS-ESM1-5/historical/r1i1p1f1/tasmax/gn/20191115.zarr" \
    -p "out-zarr=az://scratch/{{ workflow.name }}/ACCESS-ESM1-5/historical/r1i1p1f1/tasmax/gn/20191115.zarr" \
    --generate-name "standardize-historical-dev-" \
    -n argo --watch

argo submit workflows/clean-cmip6-workflow.yaml \
    --entrypoint drop-extra-dims \
    -p "in-zarr=az://raw/ACCESS-ESM1-5/historical/r1i1p1f1/tasmax/gn/20191115.zarr" \
    -p "out-zarr=az://scratch/{{ workflow.name }}/ACCESS-ESM1-5/historical/r1i1p1f1/tasmax/gn/20191115.zarr" \
    --generate-name "dropextradims-historical-dev-" \
    -n argo --watch




argo submit workflows/clean-cmip6-workflow.yaml \
    --entrypoint parse-catalog-for-url \
    -p "source-id=ACCESS-ESM1-5" \
    -p "experiment-id=ssp370" \
    -p "member-id=r1i1p1f1" \
    -p "grid-label=gn" \
    -p "variable-id=tasmin" \
    -p "item-version=20191115" \
    --generate-name "catalog-dev-" \
    -n argo --watch

argo submit workflows/clean-cmip6-workflow.yaml \
    --entrypoint concatenate-ssp \
    -p "source-id=ACCESS-ESM1-5" \
    -p "ssp=ssp370" \
    -p "member-id=r1i1p1f1" \
    -p "grid-label=gn" \
    -p "variable-id=tasmax" \
    -p "item-version=20191115" \
    -p "scratch=az://scratch/{{workflow.name}}/" \
    -p "historical-zarr=az://clean/ACCESS-ESM1-5/historical/r1i1p1f1/tasmax.zarr" \
    --generate-name "concatenate-ssp-dev-" \
    -n argo --watch


argo submit workflows/dc6-workflow.yaml \
    --entrypoint train-qdm \
    -p "ref-zarr=az://scratch/dc6-dev-2gdtq/reference-rechunk.zarr" \
    -p "hist-zarr=az://scratch/dc6-dev-2gdtq/gcm-training-rechunk.zarr" \
    -p "out-zarr=az://scratch/{{ workflow.name }}/trained-qdm.zarr" \
    -p "kind=additive" \
    -p "variable=tasmax" \
    --generate-name "train-qdm-dev-" \
    -n argo --watch

argo submit workflows/dc6-workflow.yaml \
    --entrypoint train-qdm-dodola \
    -p "ref-zarr=az://scratch/dc6-dev-2gdtq/reference-rechunk.zarr" \
    -p "hist-zarr=az://scratch/dc6-dev-2gdtq/gcm-training-rechunk.zarr" \
    -p "out-zarr=/mnt/out/trained-qdm.zarr" \
    -p "kind=additive" \
    -p "variable=tasmax" \
    --generate-name "train-localzarr-qdm-dev-" \
    -n argo --watch


#gcm-training-rechunk.zarr
#
#        - name: variable
#        - name: ref-zarr  # Needs to be az://... format
#        - name: hist-zarr  # Needs to be az://... format
#        - name: out-zarr  # Needs to be az://... format
#        - name: kind


argo submit workflows/dc6-workflow.yaml --entrypoint rechunk \
    -p variable="tasmax" \
    -p in-zarr="az://scratch/dc6-dev-cghkr/biascorrected.zarr" \
    -p out-zarr="az://scratch/{{workflow.name}}/biascorrected-rechunked.zarr" \
    -p time-chunk="365" \
    -p lat-chunk="-1" \
    -p lon-chunk="-1" \
    -n argo --watch


argo submit workflows/dc6-workflow.yaml --entrypoint downscale-bcsd \
    -p in-zarr="az://scratch/dc6-dev-75bpr/biascorrected-rechunked.zarr" \
    -p out-zarr="az://scratch/{{workflow.name}}/biascorrected-downscaled.zarr" \
    -p train-variable="temperature" \
    -p out-variable="tasmax" \
    -p domain-file="{{ workflow.parameters.domainfile0p25x0p25 }}" \
    -p yclimocoarse-zarr="az://scratch/dc6-dev-75bpr/coarse-climatology-regrid.zarr" \
    -p yclimofine-zarr="az://scratch/dc6-dev-75bpr/fine-climatology-regrid.zarr" \
    -p adjustmentfactors-out-zarr="az://scratch/{{ workflow.name }}/downscale-adjustmentfactors.zarr" \
    --generate-name downscale-dev- \
    -n argo --watch
