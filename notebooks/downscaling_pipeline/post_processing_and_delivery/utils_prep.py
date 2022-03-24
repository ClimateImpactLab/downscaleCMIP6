import datetime

def delivery_models():
    DELIVERY_MODELS = [
    'BCC-CSM2-MR',
    'FGOALS-g3',
    'ACCESS-ESM1-5',
    'ACCESS-CM2',
    'INM-CM4-8',
    'INM-CM5-0',
    'MIROC-ES2L',
    'MIROC6',
    'NorESM2-LM',
    'NorESM2-MM',
    'GFDL-ESM4',
    'GFDL-CM4',
    'NESM3',
    'CMCC-CM2-SR5',
    'CMCC-ESM2',
    'CanESM5',
    'MPI-ESM1-2-HR',
    'EC-Earth3',
    'EC-Earth3-AerChem',
    'EC-Earth3-CC',
    'EC-Earth3-Veg',
    'EC-Earth3-Veg-LR',
    'HadGEM3-GC31-LL',
    'UKESM1-0-LL',
    'MPI-ESM1-2-LR',
    ]
    return DELIVERY_MODELS

def institutions():
    
    INSTITUTIONS = {    
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
        'CMCC-CM2-SR5':'CMCC',
        'CMCC-ESM2':'CMCC',
        'MPI-ESM1-2-HR':'DKRZ',
        'EC-Earth3':'EC-Earth-Consortium',
        'EC-Earth3-AerChem':'EC-Earth-Consortium',
        'EC-Earth3-CC':'EC-Earth-Consortium',
        'EC-Earth3-Veg':'EC-Earth-Consortium',
        'EC-Earth3-Veg-LR':'EC-Earth-Consortium',
        'HadGEM3-GC31-LL':'MOHC',
        'UKESM1-0-LL':'MOHC',
        'MPI-ESM1-2-LR':'MPI-M',
        'CanESM5': 'CCCma',
    }
    
    return INSTITUTIONS

def ensemble_members_pr():
    
    ENSEMBLE_MEMBERS = {
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
        'CMCC-CM2-SR5':'r1i1p1f1',
        'CMCC-ESM2':'r1i1p1f1',
        'MPI-ESM1-2-HR':'r1i1p1f1',
        'EC-Earth3':'r1i1p1f1',
        'EC-Earth3-AerChem':'r1i1p1f1',
        'EC-Earth3-CC':'r1i1p1f1',
        'EC-Earth3-Veg':'r1i1p1f1',
        'EC-Earth3-Veg-LR':'r1i1p1f1',
        'HadGEM3-GC31-LL':'r1i1p1f3',
        'UKESM1-0-LL': 'r1i1p1f2',
        'MPI-ESM1-2-LR':'r1i1p1f1',
        'CanESM5': 'r1i1p1f1',
    }
    
    return ENSEMBLE_MEMBERS


def grid_specs_pr():
    
    GRID_SPECS = {
        "ACCESS-CM2": "gn",
        "ACCESS-ESM1-5": "gn",
        "MIROC6": "gn",
        "EC-Earth3": "gr",
        "EC-Earth3-Veg-LR": "gr",
        "EC-Earth3-Veg": "gr",
        "CMCC-ESM2": "gn",
        "INM-CM5-0": "gr1",
        "INM-CM4-8": "gr1",
        "MIROC-ES2L": "gn",
        "FGOALS-g3": "gn",
        "BCC-CSM2-MR": "gn",
        "NorESM2-LM": "gn",
        "GFDL-ESM4": "gr1",
        "GFDL-CM4": "gr1",
        "NorESM2-MM": "gn",
        "NESM3": "gn",
        'CMCC-CM2-SR5':'gn',
        'CMCC-ESM2':'gn',
        'MPI-ESM1-2-HR':'gn',
        'EC-Earth3-AerChem':'gr',
        'EC-Earth3-CC':'gr',
        'HadGEM3-GC31-LL':'gn',
        'UKESM1-0-LL': 'gn',
        'MPI-ESM1-2-LR':'gn',
        'CanESM5':'gn',
    }
    
    return GRID_SPECS

def ensemble_members_tas():
    
    ENSEMBLE_MEMBERS = {
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
        'CMCC-CM2-SR5':'r1i1p1f1',
        'CMCC-ESM2':'r1i1p1f1',
        'MPI-ESM1-2-HR':'r1i1p1f1',
        'EC-Earth3':'r1i1p1f1',
        'EC-Earth3-AerChem':'r1i1p1f1',
        'EC-Earth3-CC':'r1i1p1f1',
        'EC-Earth3-Veg':'r1i1p1f1',
        'EC-Earth3-Veg-LR':'r1i1p1f1',
        'HadGEM3-GC31-LL':'r1i1p1f3',
        'UKESM1-0-LL': 'r1i1p1f2',
        'MPI-ESM1-2-LR':'r1i1p1f1',
        'CanESM5': 'r1i1p1f1',
    }
    
    return ENSEMBLE_MEMBERS


def grid_specs_tas():
    
    GRID_SPECS = {
        "ACCESS-CM2": "gn",
        "ACCESS-ESM1-5": "gn",
        "MIROC6": "gn",
        "EC-Earth3": "gr",
        "EC-Earth3-Veg-LR": "gr",
        "EC-Earth3-Veg": "gr",
        "CMCC-ESM2": "gn",
        "INM-CM5-0": "gr1",
        "INM-CM4-8": "gr1",
        "MIROC-ES2L": "gn",
        "FGOALS-g3": "gn",
        "BCC-CSM2-MR": "gn",
        "NorESM2-LM": "gn",
        "GFDL-ESM4": "gr1",
        "GFDL-CM4": "gr1",
        "NorESM2-MM": "gn",
        "NESM3": "gn",
        'CMCC-CM2-SR5':'gn',
        'CMCC-ESM2':'gn',
        'MPI-ESM1-2-HR':'gn',
        'EC-Earth3-AerChem':'gr',
        'EC-Earth3-CC':'gr',
        'HadGEM3-GC31-LL':'gn',
        'UKESM1-0-LL': 'gn',
        'MPI-ESM1-2-LR':'gn',
        'CanESM5':'gn',
    }
    
    return GRID_SPECS

def hist_scn():
    
    HIST_EXTENSION_SCENARIO = {
        "ACCESS-CM2": "ssp370",
        "MRI-ESM2-0": "ssp370",
        "CanESM5": "ssp370",
        "ACCESS-ESM1-5": "ssp370",
        "MIROC6": "ssp370",
        "EC-Earth3": "ssp370",
        "EC-Earth3-Veg-LR": "ssp370",
        "EC-Earth3-Veg": "ssp370",
        "MPI-ESM1-2-HR": "ssp370",
        "CMCC-ESM2": "ssp370",
        "INM-CM5-0": "ssp370",
        "INM-CM4-8": "ssp370",
        "MIROC-ES2L": "ssp370",
        "MPI-ESM1-2-LR": "ssp370",
        "FGOALS-g3": "ssp370",
        "BCC-CSM2-MR": "ssp370",
        "AWI-CM-1-1-MR": "ssp370",
        "NorESM2-LM": "ssp370",
        "GFDL-ESM4": "ssp370",
        "GFDL-CM4": "ssp245",
        "CAMS-CSM1-0": "ssp370",
        "NorESM2-MM": "ssp370",
        "NESM3": "ssp245",
        'CMCC-CM2-SR5':"ssp370",
        'CMCC-ESM2':"ssp370",
        'CanESM5':"ssp370",
        'MPI-ESM1-2-HR':"ssp126",
        'EC-Earth3':"ssp370",
        'EC-Earth3-AerChem':"ssp370",
        'EC-Earth3-CC':"ssp245",
        'EC-Earth3-Veg':"ssp370",
        'EC-Earth3-Veg-LR':"ssp370",
        'HadGEM3-GC31-LL':"ssp245",
        'UKESM1-0-LL':"ssp370",
        'MPI-ESM1-2-LR':"ssp370",
    }
    
    return HIST_EXTENSION_SCENARIO


def licenses():
    CC0_LICENSE_MODELS = ['FGOALS-g3', 'INM-CM4-8', 'INM-CM5-0']

    CC_BY_LICENSE_MODELS = [
        'BCC-CSM2-MR',
        'ACCESS-ESM1-5',
        'ACCESS-CM2',
        'MIROC-ES2L',
        'MIROC6',
        'NorESM2-LM',
        'NorESM2-MM',
        'GFDL-CM4',
        'GFDL-ESM4',
        'NESM3',
        'MPI-ESM1-2-HR',
        'HadGEM3-GC31-LL',
        'UKESM1-0-LL',
        'MPI-ESM1-2-LR',
    ]

    CC_BY_SA_LICENSE_MODELS = [
        'CanESM5',
        'CMCC-CM2-SR5',
        'CMCC-ESM2',
        'EC-Earth3',
        'EC-Earth3-AerChem',
        'EC-Earth3-CC',
        'EC-Earth3-Veg',
        'EC-Earth3-Veg-LR',
    ]
    
    return CC0_LICENSE_MODELS, CC_BY_LICENSE_MODELS, CC_BY_SA_LICENSE_MODELS

def check_licenses(delivery_models):
    cc0, cc1, cc2 = licenses()

    for m in delivery_models:
        assert m in (cc0 + cc1 + cc2)
        
def datetime_version():
    now = datetime.datetime.now()
    return f'{now.year}{now.month}{now.day}{now.hour}{now.minute}{now.second}'