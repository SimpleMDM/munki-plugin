# SimpleMDM Munki Repo Plugin

## Requirements

If you plan on using [AutoPkg](https://github.com/autopkg/autopkg), a release greater than 2.1 is required as earlier versions do not have Munki repo plugin support. Currently (8/10/20) the latest build does not include support, so the following files need to be pulled from the AutoPkg repo and replaced on your local installation:

* `autopkglib/MunkiImporter.py`
* `autopkglib/munkirepolibs/AutoPkgLib.py`
* `autopkglib/munkirepolibs/MunkiLibAdapter.py`

## Installation

1. Place `SimpleMDMRepo.py` in the `/usr/local/munki/munkilib/munkirepo/` folder.

## Usage

### API Key

#### Generating a Key

API keys may be generated within the API section of the SimpleMDM administrator interface. Be sure to grant the key permission for Munki plugin activity. 

#### Setting the Key

The plugin will usually prompt for an API key interactively. To avoid this, you may set the key once per terminal session like so:

```
export SIMPLEMDM_API_KEY="Whvop7kWXxsva326ABDF8VDCSGFyEkuEx2xGgj4jab8AE90cn70QdBTq0fplli0a" 
```

### Using AutoPkg

Any `.munki` recipe is supported. In this case, we are importing `GoogleChrome.munki`. Be sure to include `extract_icon` if you'd like the icon uploaded to SimpleMDM, if available.

```
autopkg run -v GoogleChrome.munki -k MUNKI_REPO_PLUGIN="SimpleMDMRepo" -k extract_icon=True
```

### Using munkiimport and Manifestutil

Before using either of these tools, they must be configured by running `munkiimport --configure` or `manifestutil --configure`. Keep all settings default, except:
- Set repo url to `BLANK` or some other dummy value, as it is unused.
- Set the repo plugin to `SimpleMDMRepo`

### Catalog Support

SimpleMDM does not support the concept of Munki catalogs in the traditional sense, however, it does process the catalog information specified in pkginfos that are uploaded by this plugin. When a pkginfo specifies a catalog, SimpleMDM will:
1. Create a new Munki managed assignment group if one does not already exist.
1. Assign the newly uploaded app to the assignment group.

 
