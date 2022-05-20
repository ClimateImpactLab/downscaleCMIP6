"""
This script exports the license and citation information in the following files:

* citations_cc0.rst
* citations_cc_by.rst
* citations_cc_by_sa.rst

Citation information is pulled from the JSON metadata API here:
https://cera-www.dkrz.de/WDCC/ui/cerasearch/cerarest/exportcmip6

Any errors in the citations generated from these entries are unintentional.
Feel free to suggest an edit on the [downscaleCMIP6 repository issues](https://github.com/ClimateImpactLab/downscaleCMIP6/issues)
or by emailing climatesci@rhg.com.

These files are not included in the repository, but contain the contents of the
"GCM-specific licenses & citations" section of the README. This script can be run
to create these files and then manually update the readme with their contents.

Run the script from the project root:

    python -m utilities/report_gcm_versions.py

"""


import json, yaml
import requests

MODELS_BY_LICENSE = {
    "cc0": [
        "FGOALS-g3",
        "INM-CM4-8",
        "INM-CM5-0",
    ],
    "cc_by": [
        "ACCESS-CM2",
        "ACCESS-ESM1-5",
        "BCC-CSM2-MR",
        "CMCC-CM2-SR5",
        "CMCC-ESM2",
        "EC-Earth3-AerChem",
        "EC-Earth3-CC",
        "EC-Earth3-Veg-LR",
        "EC-Earth3-Veg",
        "EC-Earth3",
        "GFDL-CM4",
        "GFDL-ESM4",
        "HadGEM3-GC31-LL",
        "MIROC-ES2L",
        "MIROC6",
        "MPI-ESM1-2-HR",
        "MPI-ESM1-2-LR",
        "NESM3",
        "NorESM2-LM",
        "NorESM2-MM",
        "UKESM1-0-LL",
    ],
    "cc_by_sa": [
        "CanESM5",
    ]
}

ALL_MODELS = sum(MODELS_BY_LICENSE.values(), [])

INSTITUTIONS = {
    'BCC-CSM2-MR': {'CMIP': 'BCC', 'ScenarioMIP': 'BCC'},
    'FGOALS-g3': {'CMIP': 'CAS', 'ScenarioMIP': 'CAS'},
    'ACCESS-ESM1-5': {'CMIP': 'CSIRO', 'ScenarioMIP': 'CSIRO'},
    'ACCESS-CM2': {'CMIP': 'CSIRO-ARCCSS', 'ScenarioMIP': 'CSIRO-ARCCSS'},
    'INM-CM4-8': {'CMIP': 'INM', 'ScenarioMIP': 'INM'},
    'INM-CM5-0': {'CMIP': 'INM', 'ScenarioMIP': 'INM'},
    'MIROC-ES2L': {'CMIP': 'MIROC', 'ScenarioMIP': 'MIROC'},
    'MIROC6': {'CMIP': 'MIROC', 'ScenarioMIP': 'MIROC'},
    'NorESM2-LM': {'CMIP': 'NCC', 'ScenarioMIP': 'NCC'},
    'NorESM2-MM': {'CMIP': 'NCC', 'ScenarioMIP': 'NCC'},
    'GFDL-ESM4': {'CMIP': 'NOAA-GFDL', 'ScenarioMIP': 'NOAA-GFDL'},
    'GFDL-CM4': {'CMIP': 'NOAA-GFDL', 'ScenarioMIP': 'NOAA-GFDL'},
    'NESM3': {'CMIP': 'NUIST', 'ScenarioMIP': 'NUIST'},
    'MPI-ESM1-2-HR': {'CMIP': 'MPI-M', 'ScenarioMIP': 'DKRZ'},
    'HadGEM3-GC31-LL': {'CMIP': 'MOHC', 'ScenarioMIP': 'MOHC'},
    'UKESM1-0-LL': {'CMIP': 'MOHC', 'ScenarioMIP': 'MOHC'},
    'MPI-ESM1-2-LR': {'CMIP': 'MPI-M', 'ScenarioMIP': 'MPI-M'},
    'CMCC-CM2-SR5': {'CMIP': 'CMCC', 'ScenarioMIP': 'CMCC'},
    'CMCC-ESM2': {'CMIP': 'CMCC', 'ScenarioMIP': 'CMCC'},
    'CanESM5': {'CMIP': 'CCCma', 'ScenarioMIP': 'CCCma'},
    'EC-Earth3': {'CMIP': 'EC-Earth-Consortium', 'ScenarioMIP': 'EC-Earth-Consortium'},
    'EC-Earth3-AerChem': {'CMIP': 'EC-Earth-Consortium', 'ScenarioMIP': 'EC-Earth-Consortium'},
    'EC-Earth3-CC': {'CMIP': 'EC-Earth-Consortium', 'ScenarioMIP': 'EC-Earth-Consortium'},
    'EC-Earth3-Veg': {'CMIP': 'EC-Earth-Consortium', 'ScenarioMIP': 'EC-Earth-Consortium'},
    'EC-Earth3-Veg-LR': {'CMIP': 'EC-Earth-Consortium', 'ScenarioMIP': 'EC-Earth-Consortium'},
}

ALL_EXPERIMENTS = ['historical', 'ssp126', 'ssp245', 'ssp370', 'ssp585']
EXPERIMENT_STRING_NAMES = {
    'historical': 'Historical',
    'ssp126': 'SSP1-2.6',
    'ssp245': 'SSP2-4.5',
    'ssp370': 'SSP3-7.0',
    'ssp585': 'SSP5-8.5',
}

LICENSE_HEADERS = {
    "cc0": "The following bias corrected and downscaled model simulations are available in the public domain using a `CC0 1.0 Universal Public Domain Declaration <https://creativecommons.org/publicdomain/zero/1.0/>`_.",
    "cc_by": "The following bias corrected and downscaled model simulations are licensed under a `Creative Commons Attribution 4.0 International License <https://creativecommons.org/licenses/by/4.0/>`_. Note that this license requires citation of the source model output (included here). Please see https://creativecommons.org/licenses/by/4.0/ for more information.",
    "cc_by_sa": "The following bias corrected and downscaled model simulations are licensed under a `Creative Commons Attribution-ShareAlike 4.0 International License <https://creativecommons.org/licenses/by-sa/4.0/>`_. Note that this license requires citation of the source model output (included here) and requires that derived works be shared under the same license. Please see https://creativecommons.org/licenses/by-sa/4.0/ for more information.",
}

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
    for m in ALL_MODELS:
        versions[m] = {}
        for v in ['tasmax', 'tasmin', 'pr']:
            spec = get_workflow_parameter_spec(m, v)
            versions[m][v] = {s[s['target']]['experiment_id']: s[s['target']]['version'] for s in spec}

    simplified_versions = simplify(versions, ssp_filter=ALL_EXPERIMENTS)

    summary = {}
    for m in simplified_versions.keys():
        if isinstance(simplified_versions[m], dict):
            if 'pr' in simplified_versions[m].keys():
                cmip_versions = {v: simplified_versions[m][v]['historical'] for v in simplified_versions[m].keys()}
                if len(set(cmip_versions.values())) == 1:
                    cmip_versions = set(cmip_versions.values()).pop()
                    cmip_versions = 'Version {}'.format(cmip_versions)
                else:
                    cmip_versions = '; '.join([
                        '{} version {}'.format(varname, v) for varname, v in cmip_versions.items()
                    ])

                scenariomip_versions = {
                    s: {v: simplified_versions[m][v][s] for v in simplified_versions[m].keys() if s in simplified_versions[m][v].keys()}
                    for s in ALL_EXPERIMENTS[1:]
                }

                for s in scenariomip_versions.keys():
                    if len(set(scenariomip_versions[s].values())) == 1:
                        scenariomip_versions[s] = '{} version {}'.format(EXPERIMENT_STRING_NAMES.get(s, s), set(scenariomip_versions[s].values()).pop())
                    else:
                        scenariomip_versions[s] = '; '.join([
                            '{} {} version {}'.format(
                                EXPERIMENT_STRING_NAMES.get(s, s),
                                v,
                                scenariomip_versions[s][v]
                            )
                            for v in scenariomip_versions[s].keys()
                        ])

                scenariomip_versions = '; '.join([
                    scenariomip_versions[s] for s in sorted(scenariomip_versions.keys())
                ])


                summary[m] = {
                    'CMIP': cmip_versions,
                    'ScenarioMIP': scenariomip_versions,
                }
            else:
                scenariomip_versions = {s: vers for s, vers in simplified_versions[m].items() if s != 'historical'}
                if len(set(scenariomip_versions.values())) > 1:
                    scenariomip_versions = '; '.join(sorted([
                        '{} version {}'.format(EXPERIMENT_STRING_NAMES.get(k, k), v)
                        for k, v in scenariomip_versions.items()
                    ]))
                else:
                    scenariomip_versions = 'Version {}'.format(set(scenariomip_versions.values()).pop())

                summary[m] = {
                    'CMIP': 'Version {}'.format(simplified_versions[m]['historical']),
                    'ScenarioMIP': scenariomip_versions,
                }
        else:
            summary[m] = {
                'CMIP': 'Version {}'.format(simplified_versions[m]),
                'ScenarioMIP': 'Version {}'.format(simplified_versions[m]),
            }

    rst_model_listings = {}

    for source_id in ALL_MODELS:

        citations = {}

        for activity_id in ['CMIP', 'ScenarioMIP']:
            institution_id = INSTITUTIONS[source_id][activity_id]
            ref_url = (
                "https://cera-www.dkrz.de/WDCC/ui/cerasearch/cerarest/exportcmip6?"
                "input=CMIP6.{activity_id}.{institution_id}.{source_id}"
            ).format(
                activity_id=activity_id,
                institution_id=institution_id,
                source_id=source_id,
            )

            ref_listing = requests.get(ref_url).json()

            citation =  "{creators} **({publicationYear})**. *{title}*. {versions}. {publisher}. {url}".format(
                creators="; ".join([c["creatorName"] for c in ref_listing["creators"]]),
                title=ref_listing["titles"][0],
                publisher=ref_listing["publisher"],
                publicationYear=ref_listing["publicationYear"],
                versions=summary[source_id][activity_id],
                url=(
                    "https://doi.org/{}".format(ref_listing["identifier"]["id"])
                    if ref_listing["identifier"]["identifierType"] == "DOI"
                    else ref_listing["identifier"]["id"]
                ),
            )

            citations[activity_id] = citation
        
        listing = (
            "* **{source_id}**\n\n"
            "  License description: `data_licenses/{source_id}.txt <https://raw.githubusercontent.com/ClimateImpactLab/downscaleCMIP6/master/data_licenses/{source_id}.txt>`_\n\n"
            "  CMIP Citation:\n\n    {cmip_citation}\n\n"
            "  ScenarioMIP Citation:\n\n    {scenariomip_citation}\n"
        ).format(
            source_id=source_id,
            cmip_citation=citations['CMIP'],
            scenariomip_citation=citations['ScenarioMIP'],
        )

        rst_model_listings[source_id] = listing

    for license_type in MODELS_BY_LICENSE.keys():
        with open(f'citations_{license_type}.rst', 'w+') as f:
            f.write(LICENSE_HEADERS[license_type])
            f.write('\n\n')
            for source_id in MODELS_BY_LICENSE[license_type]:
                f.write(rst_model_listings[source_id])
                f.write('\n\n')

if __name__ == "__main__":
    main()
