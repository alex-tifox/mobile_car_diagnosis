// For performing some operations asynchronously
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

// For using PlatformException
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:logger/logger.dart';
import 'package:logger_flutter/logger_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothApp(),
    );
  }
}

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;
  Logger _logger = Logger();

  int _deviceState;

  bool isDisconnecting = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700],
    'offTextColor': Colors.red[700],
    'neutralTextColor': Colors.blue,
  };

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  // Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Flutter Bluetooth"),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: Text(
                "Refresh",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              splashColor: Colors.deepPurple,
              onPressed: () async {
                // So, that when new devices are paired
                // while the app is running, user can refresh
                // the paired devices list.
                await getPairedDevices().then((_) {
                  show('Device list refreshed');
                });
              },
            ),
          ],
        ),
        body: LogConsoleOnShake(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _isButtonUnavailable &&
                      _bluetoothState == BluetoothState.STATE_ON,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.yellow,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Enable Bluetooth',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Switch(
                        value: _bluetoothState.isEnabled,
                        onChanged: (bool value) {
                          future() async {
                            if (value) {
                              await FlutterBluetoothSerial.instance
                                  .requestEnable();
                            } else {
                              await FlutterBluetoothSerial.instance
                                  .requestDisable();
                            }

                            await getPairedDevices();
                            _isButtonUnavailable = false;

                            if (_connected) {
                              _disconnect();
                            }
                          }

                          future().then((_) {
                            setState(() {});
                          });
                        },
                      )
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "PAIRED DEVICES",
                            style: TextStyle(fontSize: 24, color: Colors.blue),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Device:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DropdownButton(
                                items: _getDeviceItems(),
                                onChanged: (value) =>
                                    setState(() => _device = value),
                                value: _devicesList.isNotEmpty ? _device : null,
                              ),
                              RaisedButton(
                                onPressed: _isButtonUnavailable
                                    ? null
                                    : _connected
                                        ? _disconnect
                                        : _connect,
                                child:
                                    Text(_connected ? 'Disconnect' : 'Connect'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: new BorderSide(
                                color: _deviceState == 0
                                    ? colors['neutralBorderColor']
                                    : _deviceState == 1
                                        ? colors['onBorderColor']
                                        : colors['offBorderColor'],
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            elevation: _deviceState == 0 ? 4 : 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "DEVICE 1",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: _deviceState == 0
                                            ? colors['neutralTextColor']
                                            : _deviceState == 1
                                                ? colors['onTextColor']
                                                : colors['offTextColor'],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed:
                                          _connected ? resetMessage : null,
                                      child: Text('Z'),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed:
                                          _connected ? setNoEchoMessage : null,
                                      child: Text('E0'),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: _connected
                                          ? lineFeedOffMessage
                                          : null,
                                      child: Text('L0'),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed:
                                          _connected ? setTimeoutMessage : null,
                                      child: Text('TO'),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: _connected
                                          ? setProtocol0Message
                                          : null,
                                      child: Text('SP0'),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: _connected
                                          ? setProtocol3Message
                                          : null,
                                      child: Text('SP3'),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: _connected
                                          ? setProtocol4Message
                                          : null,
                                      child: Text('SP4'),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: _connected
                                          ? setProtocol5Message
                                          : null,
                                      child: Text('SP5'),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: _connected
                                          ? setProtocol6Message
                                          : null,
                                      child: Text('SP6'),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: _connected
                                          ? sendMessageToBluetooth
                                          : null,
                                      child: Text('0100'),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: _connected
                                          ? sendMessageToBluetoothTwo
                                          : null,
                                      child: Text('0101'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.blue,
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "NOTE: If you cannot find the device in the list, please pair the device by going to the bluetooth settings",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 15),
                          RaisedButton(
                            elevation: 2,
                            child: Text("Bluetooth Settings"),
                            onPressed: () {
                              FlutterBluetoothSerial.instance.openSettings();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen((Uint8List list) {
            _logger.d('Response came:');
            _logger.d(list.map((e) => e.toRadixString(16)).toList());
          }).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // void _onDataReceived(Uint8List data) {
  //   // Allocate buffer for parsed data
  //   int backspacesCounter = 0;
  //   data.forEach((byte) {
  //     if (byte == 8 || byte == 127) {
  //       backspacesCounter++;
  //     }
  //   });
  //   Uint8List buffer = Uint8List(data.length - backspacesCounter);
  //   int bufferIndex = buffer.length;

  //   // Apply backspace control character
  //   backspacesCounter = 0;
  //   for (int i = data.length - 1; i >= 0; i--) {
  //     if (data[i] == 8 || data[i] == 127) {
  //       backspacesCounter++;
  //     } else {
  //       if (backspacesCounter > 0) {
  //         backspacesCounter--;
  //       } else {
  //         buffer[--bufferIndex] = data[i];
  //       }
  //     }
  //   }
  // }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection.close();
    show('Device disconnected');
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // Method to send message,
  // for turning the Bluetooth device on
  void _sendOnMessageToBluetooth() async {
    connection.output.add(utf8.encode("1" + "\r\n"));
    await connection.output.allSent;
    show('Device Turned On');
    setState(() {
      _deviceState = 1; // device on
    });
  }

  // Method to send message,
  // for turning the Bluetooth device off
  void _sendOffMessageToBluetooth() async {
    connection.output.add(utf8.encode("0" + "\r\n"));
    await connection.output.allSent;
    show('Device Turned Off');
    setState(() {
      _deviceState = -1; // device off
    });
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }

  void resetMessage() async {
    connection.output.add(utf8.encode('AT Z'));
    await connection.output.allSent;
    _logger.d('AZ Z');
    await Future.delayed(Duration(milliseconds: 200));
  }

  void lineFeedOffMessage() async {
    connection.output.add(utf8.encode('AT L0'));
    await connection.output.allSent;
    _logger.d('AT L0');
    await Future.delayed(Duration(milliseconds: 200));
  }

  void setProtocol0Message() async {
    connection.output.add(utf8.encode('AT SP 0'));
    await connection.output.allSent;
    _logger.d('AT SP 0');
    await Future.delayed(Duration(milliseconds: 200));
  }

  void setProtocol3Message() async {
    connection.output.add(utf8.encode('AT SP 3'));
    await connection.output.allSent;
    _logger.d('AT SP 3');
    await Future.delayed(Duration(milliseconds: 200));
  }

  void setProtocol4Message() async {
    connection.output.add(utf8.encode('AT SP 4'));
    await connection.output.allSent;
    _logger.d('AT SP 4');
    await Future.delayed(Duration(milliseconds: 200));
  }

  void setProtocol5Message() async {
    connection.output.add(utf8.encode('AT SP 5'));
    await connection.output.allSent;
    _logger.d('AT SP 5');
    await Future.delayed(Duration(milliseconds: 200));
  }

  void setProtocol6Message() async {
    connection.output.add(utf8.encode('AT SP 6'));
    await connection.output.allSent;
    _logger.d('AT SP 6');
    await Future.delayed(Duration(milliseconds: 200));
  }

  void setTimeoutMessage() async {
    await Future.delayed(Duration(milliseconds: 200));
    connection.output
        .add(utf8.encode('AT ST ${(125 & 0xFF).toRadixString(16)}'));
    await connection.output.allSent;
    _logger.d('AT ST 125');
  }

  void setNoEchoMessage() async {
    await Future.delayed(Duration(milliseconds: 200));
    connection.output.add(utf8.encode('AT E0'));
    await connection.output.allSent;
    _logger.d('AT E0');
  }

  void sendMessageToBluetooth() async {
    await Future.delayed(Duration(milliseconds: 200));
    List<int> dataToSent = Uint8List.fromList([0x01, 0x00]);
    connection.output.add(dataToSent);
    await connection.output.allSent;
    _logger.d('01 00');
    _logger
        .d('Data sent: ${dataToSent.map((e) => e.toRadixString(16)).toList()}');
    _logger.d('Raw data sent: $dataToSent');
  }

  void sendMessageToBluetoothTwo() async {
    await Future.delayed(Duration(milliseconds: 200));
    List<int> dataToSent = Uint8List.fromList([0x01, 0x01]);
    connection.output.add(dataToSent);
    _logger.d('01 01');
    _logger
        .d('Data sent: ${dataToSent.map((e) => e.toRadixString(16)).toList()}');
    _logger.d('Raw data sent: $dataToSent');
  }
}
