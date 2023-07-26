# Changelog

## [1.3.1] - 2023-07-26

### Added

- Fixed "Munki Import throws python warnings with autopkg" https://github.com/SimpleMDM/munki-plugin/issues/9

## [1.3.0] - 2023-07-26

### Added

- Support for file-based base url configuration

## [1.2.4] - 2020-12-07

### Fixed

- Specify content type of XML for pkginfo transmission to avoid ambiguity when XML payload includes unstructured data, like shell script.

## [1.2.3] - 2020-11-13

### Removed

- Notice during plugin execution that the MUNKI_REPO setting is ignored.

## [1.2.2] - 2020-09-10

### Fixed

- config.plist permissions are now retained during installation
- config.plist file is no longer overwritten during subsequent installs

## [1.2.1] - 2020-09-10

### Changed

- Sets the default config.plist to world readable/writable for easier usage with third party tools like AutoPkgr

## [1.2.0] - 2020-08-24

### Added

- Support for file-based API key storage

## [1.1.3] - 2020-08-18

### Added

- Support for plugin-driven makecatalogs

### Fixed

- Switched to Python 2-compatible super() instantiation for URLGetter class

## [1.1.2] - 2020-08-13

### Fixed

- Removed f-strings as they were causing compatibility issues with Python 2

## [1.1.1] - 2020-08-10

### Fixed

- Removed redundant URLGetter object instantiation

## [1.1.0] - 2020-08-10

### Added

- Better reporting when authentication and authorization errors occur
- Ability to change repo base url

### Changed

- Eliminated dependency on AutoPkg libraries.

## [1.0.0] - 2020-08-06

Initial release