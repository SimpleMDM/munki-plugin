# SimpleMDM Munki Repo Plugin

## Requirements

If you plan on using [AutoPkg](https://github.com/autopkg/autopkg), release 2.2 or greater is required as earlier versions do not have Munki repo plugin support.

## Installation

1. Place `SimpleMDMRepo.py` in the `/usr/local/munki/munkilib/munkirepo/` folder.
1. (Optionally) move `config.plist` to `/usr/local/simplemdm/munki-plugin/config.plist`.

## API Key

### Generating a Key

API keys may be generated within the API section of the SimpleMDM administrator interface. Be sure to grant the key permission for Munki plugin activity. 

### Setting the Key

The plugin attempts to fetch the API key three ways, in order:

1. environment variable
1. configuration file
1. interactively

#### Environment Variable

You may set the key once per terminal session like so:

```
export SIMPLEMDM_API_KEY="Whvop7kWXxsva326ABDF8VDCSGFyEkuEx2xGgj4jab8AE90cn70QdBTq0fplli0a" 
```

You can also set the key for a single command by prepending it like so:

```
SIMPLEMDM_API_KEY="Whvop7kWXxsva326ABDF8VDCSGFyEkuEx2xGgj4jab8AE90cn70QdBTq0fplli0a" autopkg run ...
```

#### Configuration File

You may store the key in a configuration file at `/usr/local/simplemdm/munki-plugin/config.plist`. Please scope the permissions on this file so that it is restricted, however still allowing utilities using the repo plugin to access it. 

The file should be formatted as below. Be sure to provide your own API key:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>key</key>
  <string>Whvop7kWXxsva326ABDF8VDCSGFyEkuEx2xGgj4jab8AE90cn70QdBTq0fplli0a</string>
</dict>
</plist>
```

## Using AutoPkg

Any `.munki` recipe is supported. In this case, we are importing `GoogleChrome.munki`. Be sure to include `extract_icon` if you'd like the icon uploaded to SimpleMDM, if available.

**Please Note:** Running MakeCatalogs.munki is not necessary. See "Using Makecatalogs" below for more information.

```
autopkg run -v GoogleChrome.munki -k MUNKI_REPO_PLUGIN="SimpleMDMRepo" -k extract_icon=True
```

## Using munkiimport and manifestutil

**Please Note:** Running makecatalogs is not necessary. See "Using Makecatalogs" below for more information.

Before using either of these tools, they must be configured by running `munkiimport --configure` or `manifestutil --configure`. Keep all settings default, except:
- Set repo url to `BLANK` or some other dummy value, as it is unused.
- Set the repo plugin to `SimpleMDMRepo`

## Munki Catalog Notes

### Assignment Groups in lieu of Catalogs 

SimpleMDM does not support the concept of Munki catalogs in the traditional sense, however, it does process the catalog information specified in pkginfos that are uploaded by this plugin. When a pkginfo specifies a catalog, SimpleMDM will:
1. Create a new Munki managed assignment group if one does not already exist.
1. Assign the newly uploaded app to the assignment group.

### Using Makecatalogs

SimpleMDM utilizes a proprietary backend for munki asset storage. Such being the case, catalog generation is handled automatically and does not need to be invoked with the `makecatalogs` utility or with `MakeCatalogs.munki`. Munki version 5.1 (yet to be released as of 8/18/20) will automatically detect this and running m`makecatalogs` or `MakeCatalogs.munki` will result in no action being taken. If using an earlier version of Munki, running either of these utilities will result in an error.
