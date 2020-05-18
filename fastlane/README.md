fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios certificates
```
fastlane ios certificates
```

### ios build
```
fastlane ios build
```

### ios post_deploy
```
fastlane ios post_deploy
```
Generates release notes for slack and create the next tag
### ios inform_sentry
```
fastlane ios inform_sentry
```
Upload DSYM and release on Sentry
### ios release
```
fastlane ios release
```
Release application to AppStore

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
