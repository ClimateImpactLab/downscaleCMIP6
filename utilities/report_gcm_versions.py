
import json, yaml, pprint

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
]

DELIVERY_EXPERIMENTS = ['historical', 'ssp245', 'ssp370']

def simple_dict_compare(a, b):
    try:
        if not isinstance(a, dict):
            assert not isinstance(b, dict)
            assert a == b
            return True

        assert sorted(list(a.keys())) == sorted(list(b.keys()))
        for k in a.keys():
            assert simple_dict_compare(a[k], b[k])
        return True
    except AssertionError:
        return False

def simplify(versions, ssp_filter=None):
    simplified = {}

    # deep-copy versions into simplified while filtering SSPs (if ssp_filter provided)
    for m in versions.keys():
        simplified[m] = {}
        for v in versions[m].keys():
            if ssp_filter is not None:
                simplified[m][v] = {s: vals for s, vals in versions[m][v].items() if s in ssp_filter}
            else:
                simplified[m][v] = {s: vals for s, vals in versions[m][v].items()}

    # dedupe by SSP
    for m in simplified.keys():
        for v in simplified[m].keys():
            # drop ssp specification for each variable if versions are the same across SSPs
            if len(set(simplified[m][v].values())) == 1:
                simplified[m][v] = list(simplified[m][v].values())[0]

    # dedupe by variable
    for m in simplified.keys():
        # if each model's spec by variable is the same, drop variable deisgnation
        if all([simple_dict_compare(simplified[m]['tasmax'], simplified[m][var]) for var in simplified[m].keys()]):
            simplified[m] = simplified[m]['tasmax']

    return simplified

def get_workflow_parameter_spec(model, variable):
    spec_fp = f'workflows/parameters/{model}-{variable}.yaml'
    with open(spec_fp, 'r') as f:
        spec = json.loads(yaml.safe_load(f)['jobs'])
    return spec

def main():
    versions = {}
    for m in DELIVERY_MODELS:
        versions[m] = {}
        for v in ['tasmax', 'tasmin', 'pr']:
            spec = get_workflow_parameter_spec(m, v)
            versions[m][v] = {s[s['target']]['experiment_id']: s[s['target']]['version'] for s in spec}

        # also check DTR
        spec = get_workflow_parameter_spec(m, 'dtr')
        dtr_specs = {
            v: {s[v][s[v]['target']]['experiment_id']: s[v][s[v]['target']]['version'] for s in spec}
            for v in ['tasmin', 'tasmax']
        }

        assert simple_dict_compare(dtr_specs['tasmin'], versions[m]['tasmin'])
        assert simple_dict_compare(dtr_specs['tasmax'], versions[m]['tasmax'])

    simplified_versions = simplify(versions, ssp_filter=DELIVERY_EXPERIMENTS)

    pprint.pprint(simplified_versions)

if __name__ == "__main__":
    main()
