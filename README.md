# Mono Connect

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

The Mono Connect SDK is a quick and secure way to link bank accounts to Mono from within your Flutter app. Mono Connect is a drop-in framework that handles connecting a financial institution to your app (credential validation, multi-factor authentication, error handling, etc).

For accessing customer accounts and interacting with Mono's API (Identity, Transactions, Income, DirectPay) use the server-side [Mono API](https://docs.mono.co/api).

## Documentation

For complete information about Mono Connect, head to the [docs](https://docs.mono.co/docs/financial-data/overview).

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
  publicKey: 'test_pk_...',
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: const MonoCustomer(
    newCustomer: MonoNewCustomer(
      name: 'Samuel Olamide',
      email: 'samuel@neem.com',
      identity: MonoCustomerIdentity(
        type: 'bvn',
        number: '2323233239',
      ),
    ),
    // or
    existingCustomer: MonoExistingCustomer(
      id: '6759f68cb587236111eac1d4',
    ),
  ),
  selectedInstitution: const ConnectInstitution(
    id: '5f2d08be60b92e2888287702',
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
- [`accountId`](#accountId)
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
final existingCustomer = MonoExistingCustomer(id: '6759f68cb587236111eac1d4');

// new customer
final identity = MonoCustomerIdentity(type: 'bvn', number: '2323233239');
final newCustomer = MonoNewCustomer(name: 'Samuel Olamide', email: 'samuel.olumide@gmail.com', identity: identity);

final config = ConnectConfiguration(
  publicKey: 'test_pk_...',
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: const MonoCustomer(
    newCustomer: newCustomer,
    // or
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
  publicKey: 'test_pk_...',
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
  publicKey: 'test_pk_...',
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
  publicKey: 'test_pk_...',
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: customer,
  reference: 'random_string',
);
```

### <a name="accountId"></a> `accountId`
**String: Optional**

### Re-authorizing an Account with Mono: A Step-by-Step Guide
#### Step 1: Fetch Account ID for previously linked account

Fetch the Account ID of the linked account from the [Mono dashboard](https://app.mono.co/customers) or [API](https://docs.mono.co/docs/customers).

Alternatively, make an API call to the [Exchange Token Endpoint](https://api.withmono.com/v2/accounts/auth) with the code from a successful linking and your mono application secret key. If successful, this will return an Account ID.

##### Sample request:
```shell
curl --request POST \
  --url https://api.withmono.com/v2/accounts/auth \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --header 'mono-sec-key: your_secret_key' \
  --data '{"code":"string"}'
```

##### Sample response:
```json
{
  "id": "661d759280dbf646242634cc"
}
```

#### Step 2: Initiate your SDK with re-authorisation config option
With step one out of the way, pass the customer's Account ID to your config option in your installed SDK. Implementation example provided below for the Flutter SDK

```dart
final config = ConnectConfiguration(
  publicKey: 'test_pk_...', // your publicKey
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: customer,
  reference: 'reference',
  accountId: 'customer-account-id',
  onEvent: (event) {
    log(event.toString());
  },
);
```

#### Step 3: Trigger re-authorisation widget
In this final step, ensure the widget is launched with the new config. Once opened the user provides a security information which can be: password, pin, OTP, token, security answer etc.
If the re-authorisation process is successful, the user's account becomes re-authorised after which two things happen.
a. The 'mono.events.account_reauthorized' webhook event is sent to the webhook URL that you specified on your dashboard app.
b. Updated financial data gets returned on the Mono connect data APIs when an API request is been made.

##### Example:

```dart
MonoConnect.launch(
  context,
  config: config,
  shouldReauthorise: true,
  showLogs: true,
);
```


## API Reference

### MonoConnect Object

The MonoConnect Object exposes methods that take a [ConnectConfiguration](#ConnectConfiguration) for easy interaction with the Mono Connect Widget.

### <a name="ConnectConfiguration"></a> ConnectConfiguration

The configuration option is passed to the different launch methods from the MonoConnect Object.

```dart
publicKey: String // required
onSuccesss: void Function(String) // required
customer: MonoCustomer, // required
onClose: VoidCallback // optional
onEvent: void Function(ConnectEvent) // optional
reference: String // optional
accountId: String // optional
selectedInstitution: ConnectInstitution // optional
extras: Map<String, dynamic> // optional
```
#### Usage

```dart
final config = ConnectConfiguration(
  publicKey: 'test_pk_...', // your publicKey
  onSuccess: (code) {
    log('Success with code: $code');
  },
  customer: const MonoCustomer(
    newCustomer: MonoNewCustomer(...),
    // or
    existingCustomer: MonoExistingCustomer(...),
  ),
  selectedInstitution: const ConnectInstitution(
    id: '5f2d08be60b92e2888287702',
    authMethod: ConnectAuthMethod.mobileBanking,
  ),
  reference: 'random_string',
  // accountId: '65faa4ae64b5baaa044cb0c3',
  // scope: 'payments',
  // extras: {
  //   'payment_id': 'txreq_mwvphn2xxw',
  // },
  onEvent: (event) {
    log(event.toString());
  },
  onClose: () {
    log('Widget closed.');
  },
);
```

### <a name="connectEvent"></a> ConnectEvent

#### <a name="type"></a> `type: ConnectEventType`

Event types correspond to the `type` key returned by the event data. Possible options are in the table below.

| Event Name          | Description |
|---------------------| ----------- |
| opened              | Triggered when the user opens the Connect Widget. |
| exit                | Triggered when the user closes the Connect Widget. |
| institutionSelected | Triggered when the user selects an institution. |
| authMethodSwitched  | Triggered when the user changes authentication method from internet to mobile banking, or vice versa. |
| submitCredentials   | Triggered when the user presses Log in. |
| accountLinked       | Triggered when the user successfully links their account. |
| accountSelected     | Triggered when the user selects a new account. |
| error               | Triggered when the widget reports an error.|

#### <a name="dataObject"></a> `data: ConnectEventData`
The data object of type ConnectEventData returned from the onEvent callback.

```dart
eventType: String // type of event mono.connect.xxxx
reference: String? // reference passed through the connect config
pageName: String? // name of page the widget exited on
prevAuthMethod: String? // auth method before it was last changed
authMethod: String? // current auth method
mfaType: String? // type of MFA the current user/bank requires
selectedAccountsCount: Int? // number of accounts selected by the user
errorType: String? // error thrown by widget
errorMessage: String? // error message describing the error
institutionId: String? // id of institution
institutionName: String? // name of institution
timestamp: DateTime // timestamp of the event as a DateTime object
```

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
