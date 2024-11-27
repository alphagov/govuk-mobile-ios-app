# GOV.UK - iOS mobile application

>[!Note]
>This application is currently in a closed Beta and is not distributed for general use. 


## Getting started:

### Install Xcode
The application will run on several Xcode versions. The working version of the project can be found [here](.xcode-version)

### Resolve packages
Before the app will build, you will need to navigate to `File -> Packages -> Resolve Package Versions` to install required dependencies.

### Run
<kbd>cmd</kbd> + <kbd>R</kbd> <be>

>[!Note]
>You will need to have an Apple developer account to run the project on a physical device, but it can run on a simulator.

## Unit tests
The application has several unit tests and snapshot tests. Although the unit tests do not depend on a specific simulator, the snapshot tests do.
If you wish to run the full suite of tests successfully, the current device requirement can be found [here](/Fastlane/.build.yml) under `[scan][devices]`


## Linting

### SwiftLint

The application uses SwiftLint for linting swift code. Rules can be found [here](.swiftlint.yml)
If you want swiftlint to highlight issues in Xcode, make sure you have it installed. You can do this using [Homebrew](https://brew.sh/)

`brew install swiftlint`

### Rubocop

The application uses Rubocop for lining Ruby code used in CI builds.
To run this before pushing, make sure you have rubocop installed. This can be done with `gem install rubocop` although the prefered method is to install all Gems using [Bundler](https://bundler.io/) by running `bundle install`

Once you have Rubocop installed, you can check the app with `bundle exec rubocop` or `rubocop` if you aren't using Bundler
