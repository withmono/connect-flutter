import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mono_connect/mono_connect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mono Connect Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    reference: DateTime.now().millisecondsSinceEpoch.toString(),
    onEvent: (event) {
      log(event.toString());
    },
    onClose: () {
      log('Widget closed.');
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            MonoConnect.launch(
              context,
              config: config,
              showLogs: true,
            );
          },
          child: Text('Launch Connect Widget'),
        ),
      ),
    );
  }
}
