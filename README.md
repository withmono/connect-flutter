# Mono Connect

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

The Mono Connect SDK is a quick and secure way to link bank accounts to Mono from within your Flutter app. Mono Connect is a drop-in framework that handles connecting a financial institution to your app (credential validation, multi-factor authentication, error handling, etc).

For accessing customer accounts and interacting with Mono's API (Identity, Transactions, Income, DirectPay) use the server-side [Mono API](https://docs.mono.co/docs).

## Documentation

For complete information about Mono Connect, head to the [docs](https://docs.mono.co/docs).

## Getting Started

1. Register on the [Mono](https://app.mono.com) website and get your public and secret keys.
2. Set up a server to [exchange tokens](https://docs.mono.co/api/bank-data/authorisation/exchange-token) to access user financial data with your Mono secret key.

## Installation 💻

**❗ In order to start using Mono Connect you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Install via `flutter pub add`:

```sh
flutter pub add mono_connect
```

## Additional Setup
### iOS

- Add the key `Privacy - Camera Usage Description` and a usage description to your `Info.plist`.

If editing `Info.plist` as text, add:

```xml
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
```

- Add the following to your `Podfile` file:

```ruby
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      flutter_additional_ios_build_settings(target)

      target.build_configurations.each do |config|
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
          '$(inherited)',

          ## dart: PermissionGroup.camera
          'PERMISSION_CAMERA=1',
        ]
      end
    end
  end
  ```

### Android

State the camera permission in your `android/app/src/main/AndroidManifest.xml` file.

```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

## Usage

#### Import Mono Connect SDK
```dart
import 'package:mono_connect/mono_connect.dart';
```

#### Create a ConnectConfiguration
```dart
final config = ConnectConfiguration(
  publicKey: 'your_public_key',
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: const MonoCustomer(
    newCustomer: MonoNewCustomer(
      name: "Samuel Olamide",
      email: "samuel@neem.com",
      identity: MonoCustomerIdentity(
        type: "bvn",
        number: "2323233239",
      ),
    ),
    existingCustomer: MonoExistingCustomer(
      id: "6759f68cb587236111eac1d4",
    ),
  ),
  selectedInstitution: const ConnectInstitution(
    id: "5f2d08be60b92e2888287702",
    authMethod: ConnectAuthMethod.mobileBanking,
  ),
  reference: 'testref',
  onEvent: (event) {
    log(event.toString());
  },
  onClose: () {
    log('Widget closed.');
  },
);
```

#### Show the Widget
```dart
ElevatedButton(
    onPressed: () {
      MonoConnect.launch(
        context,
        config: config,
        showLogs: true,
      )
    },
    child: Text('Launch Connect Widget'),
)
```

## Configuration Options

- [`publicKey`](#publicKey)
- [`customer`](#customer)
- [`onSuccess`](#onSuccess)
- [`onClose`](#onClose)
- [`onEvent`](#onEvent)
- [`reference`](#reference)
- [`reauthCode`](#reauthCode)
- [`selectedInstitution`](#selectedInstitution)

### <a name="publicKey"></a> `publicKey`
**String: Required**

This is your Mono public API key from the [Mono dashboard](https://app.withmono.com/apps).

```dart
final config = ConnectConfiguration(
  publicKey: 'test_pk_...',
  onSuccess: (code) {
    log('Success with code: $code');
  },
);
```

### <a name="customer"></a> `customer`
**MonoCustomer: Required**

```dart
// Existing customer
final existingCustomer = MonoExistingCustomer(id: "6759f68cb587236111eac1d4");

// new customer
final identity = MonoCustomerIdentity(type: "bvn", number: "2323233239");
final newCustomer = MonoNewCustomer(name: "Samuel Olumide", email: "samuel.olumide@gmail.com", identity: identity);

final config = ConnectConfiguration(
  publicKey: 'test_pk_...',
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: const MonoCustomer(
    newCustomer: newCustomer,
    existingCustomer: existingCustomer,
  ),
);
```

### <a name="onSuccess"></a> `onSuccess`
**void Function(String): Required**

The closure is called when a user has successfully onboarded their account. It should take a single String argument containing the code that can be [exchanged for an account id](https://docs.mono.co/api/bank-data/authorisation/exchange-token).

```dart
final config = ConnectConfiguration(
  publicKey: 'test_pk_...',
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: customer,
);
```

### <a name="onClose"></a> `onClose`
**void Function(): Optional**

The optional closure is called when a user has specifically exited the Mono Connect flow. It does not take any arguments.

```dart
final config = ConnectConfiguration(
  publicKey: 'your_public_key',
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: customer,
  onClose: () {
    log('Widget closed.');
  },
);
```

### <a name="onEvent"></a> `onEvent`
**void Function(ConnectEvent): Optional**

This optional closure is called when certain events in the Mono Connect flow have occurred, for example, when the user selected an institution. This enables your application to gain further insight into what is going on as the user goes through the Mono Connect flow.

See the [ConnectEvent](#ConnectEvent) object below for details.

```dart
final config = ConnectConfiguration(
  publicKey: 'your_public_key',
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: customer,
  onEvent: (event) {
    log(event.toString());
  },
);
```

### <a name="reference"></a> `reference`
**String: Optional**

When passing a reference to the configuration it will be passed back on all onEvent calls.

```dart
final config = ConnectConfiguration(
  publicKey: 'your_public_key',
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: customer,
  reference: 'random_string',
);
```

### <a name="reauthCode"></a> `reauthCode`
**String: Optional**

## Support
If you're having general trouble with Mono Connect Flutter SDK or your Mono integration, please reach out to us at <hi@mono.co> or come chat with us on Slack. We're proud of our level of service, and we're more than happy to help you out with your integration to Mono.

## Contributing
If you would like to contribute to the Mono Connect Flutter SDK, please make sure to read our [contributor guidelines](https://github.com/withmono/connect-flutter/tree/main/CONTRIBUTING.md).


## License

[MIT](https://github.com/withmono/connect-flutter/tree/main/LICENSE) for more information.

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
