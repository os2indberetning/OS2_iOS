fastlane documentation
================
# Installation
```
sudo gem install -n /usr/local/bin fastlane
```

Since Mac OS X 10.11 El Capitan it is necessary to install in /usr/local/bin
instead of the default location (/usr/bin)

# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Runs all the tests
### ios dev_setup
```
fastlane ios dev_setup
```
Setup Development
### ios dis_setup
```
fastlane ios dis_setup
```
Setup Distribution
### ios beta
```
fastlane ios beta
```
Submit a new Beta Build to Apple TestFlight

This will also make sure the profile is up to date
### ios appstore
```
fastlane ios appstore
```
Deploy a new version to the App Store

----

This README.md is auto-generated and will be re-generated every time to run [fastlane](https://fastlane.tools).  
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).  
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane).
