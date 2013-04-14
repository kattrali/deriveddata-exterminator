# EXTERMINATE!

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

### Or This, if you use [MiniXcode](https://github.com/omz/MiniXcode):

![Exterminator Button](https://github.com/kattrali/deriveddata-exterminator/raw/master/docs/exterminator+minixcode.png)

## Installation

- Clone and build the project. The plugin will be installed into `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`. (To uninstall the plugin, delete the `DerivedData-Exterminator` directory from there)
- Restart Xcode
- Select `Derived Data Exterminator in Title Bar` in the `View` menu

## Usage

- Push Button
- Moonwalk (optional, but recommended)
- Get back to building cool stuff

## References

- [Creating an Xcode4 Plugin](http://www.blackdogfoundry.com/blog/creating-an-xcode4-plugin/) : Plugin structure and project configuration tutorial
- [MiniXcode](https://github.com/omz/MiniXcode) : Example of how to add UI components to Xcode workspace windows
