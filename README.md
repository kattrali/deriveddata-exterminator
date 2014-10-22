
![Exterminator](https://github.com/kattrali/deriveddata-exterminator/raw/master/docs/banner@2x.png)

Sometimes Xcode needs a friendly helping hand with cleaning out the Derived Data for a project. The Exterminator makes this quick and easy.

### Replace This:

**Me:** Build Project

**Xcode:** Nope, we've got errors.

**Me:** Clean Project, then Build

**Xcode:** Nuh uh, still no good.

**Me:** _Open terminal, find DerivedData subdirectories for project, delete directories_

**Xcode:** Oh hey, things are looking swell.


### With This:

![Exterminator Button](https://github.com/kattrali/deriveddata-exterminator/raw/master/docs/exterminator.png)

## Installation

- Install via [Alcatraz](https://github.com/supermarin/Alcatraz)

OR

- Clone and build the project. The plugin will be installed into `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`. (To uninstall the plugin, delete the `DerivedData-Exterminator` directory from there)
- Restart Xcode
- Select `Derived Data Exterminator in Toolbar` in the `View` menu

Note: The default (`master`) branch builds for Xcode 5+. To build the project for Xcode4, check out the `xcode4` branch before building the project.

## Usage

- Push Button
- Moonwalk (optional, but recommended)
- Get back to building cool stuff

### Additional Options

Clearing derived data (for the current project/workspace or all projects) is also available from the `View` menu

![Exterminator Menu Options](https://github.com/kattrali/deriveddata-exterminator/raw/master/docs/menu.png)
