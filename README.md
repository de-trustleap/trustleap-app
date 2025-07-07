# Trustleap

## Introduction

### Stack

- Flutter 3.32.5
- Dart 3.5.1
- Visual Studio Code
- Firebase
- BLoC

### Architecture

- BLoC State Management
- Repositories, Models, Widgets
- Modular

## Development

### Environments

Info about our environments:

- We have two environments in our backend: staging and prod.
- For every environment there is a separate firebase project. So every environment has its own database and auth system.
- prod is reachable through <https://app.trust-leap.de>
- staging is reachable through <https://staging.trust-leap.de>

Testing in Prod Environment with Debug Build:

- if you want to test the app against the prod environment from your IDE you need to
change the Firebase Initialization in the main method to an initialization with DefaultFirebaseOptionsProd.
Moreover you need to set the AppCheck Token in the index.html by setting the
self.FIREBASE_APPCHECK_DEBUG_TOKEN to the prod token.

### Flutter Deployment

To deploy the Flutter Web App you have to do the following steps:

- navigate to the scripts directory in the project by 'cd scripts'
- execute the build_web script by using './build_web.sh'

Deploy for Staging:

- test your changes locally by navigating to the root project folder and execute 'GOOGLE_CLOUD_PROJECT=trustleap-staging firebase serve'
- reset the GOOGLE_CLOUD_PROJECT environment variable by executing 'unset GOOGLE_CLOUD_PROJECT'
- finally deploy the app by using 'firebase deploy --project trustleap-staging'

Deploy for Prod:

- test your changes locally by using 'firebase serve'
- finally deploy the staging app by using 'firebase deploy --project finanzwegbegleiter'
