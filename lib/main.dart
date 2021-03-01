import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './blocs/blocs.dart';
import './screens/connect_device/connect_device_screen.dart';
import './screens/start_screen/start_screen.dart';
import './service/locator.dart';
import './service/main_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(isDemo: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BluetoothBloc>(
          create: (context) => BluetoothBloc(),
        ),
        BlocProvider<DtcBloc>(
          create: (context) => DtcBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryTextTheme: TextTheme(
            headline6: TextStyle(
              color: Color(0xFFF9F9F9),
              fontFamily: 'Nunito',
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
            ),
            subtitle1: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            button: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
            bodyText2: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          colorScheme: ColorScheme(
              primary: Color(0xFF807CB0),
              primaryVariant: Color(0xFF4C3C8A),
              secondary: Color(0xFFACB07C),
              secondaryVariant: Color(0xFF6B7535),
              surface: Color(0xFFC7C5DE),
              background: Color(0xFFE8E8F1),
              error: Color(0xFF9E220C),
              onPrimary: Color(0xFF191919),
              onSecondary: Color(0xFFB0CA87),
              onSurface: Color(0xFF191919),
              onBackground: Color(0xFF191919),
              onError: Color(0xFFF9F9F9),
              brightness: Brightness.light),
          appBarTheme: AppBarTheme(
            color: Color(0xFF4C3C8A),
          ),
        ),
        routes: {
          ConnectDeviceScreen.route: (context) => ConnectDeviceScreen(),
          StartScreen.route: (context) => StartScreen(),
        },
        home: StartScreen(),
      ),
    );
  }

  @override
  void dispose() {
    MainService().dispose();
    super.dispose();
  }
}

//class BluetoothApp extends StatefulWidget {
//  @override
//  _BluetoothAppState createState() => _BluetoothAppState();
//}
//
//class _BluetoothAppState extends State<BluetoothApp> {
//  // Initializing the Bluetooth connection state to be unknown
//  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
//  // Initializing a global key, as it would help us in showing a SnackBar later
//  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//  // Get the instance of the Bluetooth
//  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
//  // Track the Bluetooth connection with the remote device
//  BluetoothConnection connection;
//  Logger _logger = Logger();
//
//  int _deviceState;
//
//  bool isDisconnecting = false;
//
//  Map<String, Color> colors = {
//    'onBorderColor': Colors.green,
//    'offBorderColor': Colors.red,
//    'neutralBorderColor': Colors.transparent,
//    'onTextColor': Colors.green[700],
//    'offTextColor': Colors.red[700],
//    'neutralTextColor': Colors.blue,
//  };
//
//  // To track whether the device is still connected to Bluetooth
//  bool get isConnected => connection != null && connection.isConnected;
//
//  // Define some variables, which will be required later
//  List<BluetoothDevice> _devicesList = [];
//  BluetoothDevice _device;
//  bool _connected = false;
//  bool _isButtonUnavailable = false;
//
//  BluetoothConnectionService bluetoothConnectionService =
//      BluetoothConnectionService();
//  @override
//  void initState() {
//    super.initState();
//
//    // Get current state
//    FlutterBluetoothSerial.instance.state.then((state) {
//      setState(() {
//        _bluetoothState = state;
//      });
//    });
//
//    _deviceState = 0; // neutral
//
//    // If the bluetooth of the device is not enabled,
//    // then request permission to turn on bluetooth
//    // as the app starts up
//    enableBluetooth();
//
//    // Listen for further state changes
//    FlutterBluetoothSerial.instance
//        .onStateChanged()
//        .listen((BluetoothState state) {
//      setState(() {
//        _bluetoothState = state;
//        if (_bluetoothState == BluetoothState.STATE_OFF) {
//          _isButtonUnavailable = true;
//        }
//        getPairedDevices();
//      });
//    });
//  }

//  @override
//  void dispose() {
//    // Avoid memory leak and disconnect
//    if (isConnected) {
//      isDisconnecting = true;
//      connection.dispose();
//      connection = null;
//    }
//
//    super.dispose();
//  }

// Request Bluetooth permission from the user
//  Future<void> enableBluetooth() async {
//    // Retrieving the current Bluetooth state
//    _bluetoothState = await FlutterBluetoothSerial.instance.state;
//
//    // If the bluetooth is off, then turn it on first
//    // and then retrieve the devices that are paired.
//    if (_bluetoothState == BluetoothState.STATE_OFF) {
//      await FlutterBluetoothSerial.instance.requestEnable();
//      await getPairedDevices();
//      return true;
//    } else {
//      await getPairedDevices();
//    }
//    return false;
//  }

//  // For retrieving and storing the paired devices
//  // in a list.
//  Future<void> getPairedDevices() async {
//    List<BluetoothDevice> devices = [];
//
//    // To get the list of paired devices
//    try {
//      devices = await _bluetooth.getBondedDevices();
//    } on PlatformException {
//      print("Error");
//    }
//
//    // It is an error to call [setState] unless [mounted] is true.
//    if (!mounted) {
//      return;
//    }
//
//    // Store the [devices] list in the [_devicesList] for accessing
//    // the list outside this class
//    setState(() {
//      _devicesList = devices;
//    });
//  }

//  // Now, its time to build the UI
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        key: _scaffoldKey,
//        appBar: AppBar(
//          title: Text("Flutter Bluetooth"),
//          backgroundColor: Colors.deepPurple,
//          actions: <Widget>[
//            FlatButton.icon(
//              icon: Icon(
//                Icons.refresh,
//                color: Colors.white,
//              ),
//              label: Text(
//                "Refresh",
//                style: TextStyle(
//                  color: Colors.white,
//                ),
//              ),
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(30),
//              ),
//              splashColor: Colors.deepPurple,
//              onPressed: () async {
//                // So, that when new devices are paired
//                // while the app is running, user can refresh
//                // the paired devices list.
//                await getPairedDevices().then((_) {
//                  show('Device list refreshed');
//                });
//              },
//            ),
//          ],
//        ),
//        body: LogConsoleOnShake(
//          child: Container(
//            child: Column(
//              mainAxisSize: MainAxisSize.max,
//              children: <Widget>[
//                Visibility(
//                  visible: _isButtonUnavailable &&
//                      _bluetoothState == BluetoothState.STATE_ON,
//                  child: LinearProgressIndicator(
//                    backgroundColor: Colors.yellow,
//                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(10),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      Expanded(
//                        child: Text(
//                          'Enable Bluetooth',
//                          style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 16,
//                          ),
//                        ),
//                      ),
//                      Switch(
//                        value: _bluetoothState.isEnabled,
//                        onChanged: (bool value) {
//                          future() async {
//                            if (value) {
//                              await FlutterBluetoothSerial.instance
//                                  .requestEnable();
//                            } else {
//                              await FlutterBluetoothSerial.instance
//                                  .requestDisable();
//                            }
//
//                            await getPairedDevices();
//                            _isButtonUnavailable = false;
//
//                            if (_connected) {
//                              _disconnect();
//                            }
//                          }
//
//                          future().then((_) {
//                            setState(() {});
//                          });
//                        },
//                      )
//                    ],
//                  ),
//                ),
//                Stack(
//                  children: <Widget>[
//                    Column(
//                      children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.only(top: 10),
//                          child: Text(
//                            "PAIRED DEVICES",
//                            style: TextStyle(fontSize: 24, color: Colors.blue),
//                            textAlign: TextAlign.center,
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              Text(
//                                'Device:',
//                                style: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                              DropdownButton(
//                                items: _getDeviceItems(),
//                                onChanged: (value) =>
//                                    setState(() => _device = value),
//                                value: _devicesList.isNotEmpty ? _device : null,
//                              ),
//                              RaisedButton(
//                                onPressed: _isButtonUnavailable
//                                    ? null
//                                    : _connected
//                                        ? _disconnect
//                                        : _connect,
//                                child:
//                                    Text(_connected ? 'Disconnect' : 'Connect'),
//                              ),
//                            ],
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(16.0),
//                          child: Card(
//                            shape: RoundedRectangleBorder(
//                              side: new BorderSide(
//                                color: _deviceState == 0
//                                    ? colors['neutralBorderColor']
//                                    : _deviceState == 1
//                                        ? colors['onBorderColor']
//                                        : colors['offBorderColor'],
//                                width: 3,
//                              ),
//                              borderRadius: BorderRadius.circular(4.0),
//                            ),
//                            elevation: _deviceState == 0 ? 4 : 0,
//                            child: Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Row(
//                                children: <Widget>[
//                                  Expanded(
//                                    child: Text(
//                                      "DEVICE 1",
//                                      style: TextStyle(
//                                        fontSize: 20,
//                                        color: _deviceState == 0
//                                            ? colors['neutralTextColor']
//                                            : _deviceState == 1
//                                                ? colors['onTextColor']
//                                                : colors['offTextColor'],
//                                      ),
//                                    ),
//                                  ),
//                                  Expanded(
//                                    child: FlatButton(
//                                      onPressed:
//                                          _connected ? resetMessage : null,
//                                      child: Text('cfg'),
//                                    ),
//                                  ),
//                                  Expanded(
//                                    child: FlatButton(
//                                      onPressed: _connected
//                                          ? sendGetAvailablePids
//                                          : null,
//                                      child: Text('pids'),
//                                    ),
//                                  ),
//                                  Expanded(
//                                    child: FlatButton(
//                                      onPressed:
//                                          _connected ? sendGetSpeed : null,
//                                      child: Text('speed'),
//                                    ),
//                                  ),
//                                  Expanded(
//                                    child: FlatButton(
//                                      onPressed: _connected ? sendGetRpm : null,
//                                      child: Text('rpm'),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                    Container(
//                      color: Colors.blue,
//                    ),
//                  ],
//                ),
//                Expanded(
//                  child: Padding(
//                    padding: const EdgeInsets.all(20),
//                    child: Center(
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Text(
//                            "NOTE: If you cannot find the device in the list, please pair the device by going to the bluetooth settings",
//                            style: TextStyle(
//                              fontSize: 15,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.red,
//                            ),
//                          ),
//                          SizedBox(height: 15),
//                          RaisedButton(
//                            elevation: 2,
//                            child: Text("Bluetooth Settings"),
//                            onPressed: () {
//                              FlutterBluetoothSerial.instance.openSettings();
//                            },
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                )
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  // Create the List of devices to be shown in Dropdown Menu
//  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
//    List<DropdownMenuItem<BluetoothDevice>> items = [];
//    if (_devicesList.isEmpty) {
//      items.add(DropdownMenuItem(
//        child: Text('NONE'),
//      ));
//    } else {
//      _devicesList.forEach((device) {
//        items.add(DropdownMenuItem(
//          child: Text(device.name),
//          value: device,
//        ));
//      });
//    }
//    return items;
//  }
//
//  // Method to connect to bluetooth
//  void _connect() async {
//    setState(() {
//      _isButtonUnavailable = true;
//    });
//    if (_device == null) {
//      show('No device selected');
//    } else {
//      if (!isConnected) {
//        await BluetoothConnection.toAddress(_device.address)
//            .then((_connection) {
//          print('Connected to the device');
//          connection = _connection;
//          setState(() {
//            _connected = true;
//          });
//
//          connection.input.listen((Uint8List list) {
//            _logger.d('Response:');
//            _logger.d(utf8.decode(list));
//            _logger.d(list.map((e) => e.toRadixString(16)).toList());
//          }).onDone(() {
//            if (isDisconnecting) {
//              print('Disconnecting locally!');
//            } else {
//              print('Disconnected remotely!');
//            }
//            if (this.mounted) {
//              setState(() {});
//            }
//          });
//        }).catchError((error) {
//          print('Cannot connect, exception occurred');
//          print(error);
//        });
//        show('Device connected');
//
//        setState(() => _isButtonUnavailable = false);
//      }
//    }
//  }
//
//  // void _onDataReceived(Uint8List data) {
//  //   // Allocate buffer for parsed data
//  //   int backspacesCounter = 0;
//  //   data.forEach((byte) {
//  //     if (byte == 8 || byte == 127) {
//  //       backspacesCounter++;
//  //     }
//  //   });
//  //   Uint8List buffer = Uint8List(data.length - backspacesCounter);
//  //   int bufferIndex = buffer.length;
//
//  //   // Apply backspace control character
//  //   backspacesCounter = 0;
//  //   for (int i = data.length - 1; i >= 0; i--) {
//  //     if (data[i] == 8 || data[i] == 127) {
//  //       backspacesCounter++;
//  //     } else {
//  //       if (backspacesCounter > 0) {
//  //         backspacesCounter--;
//  //       } else {
//  //         buffer[--bufferIndex] = data[i];
//  //       }
//  //     }
//  //   }
//  // }
//
//  // Method to disconnect bluetooth
//  void _disconnect() async {
//    setState(() {
//      _isButtonUnavailable = true;
//      _deviceState = 0;
//    });
//
//    await connection.close();
//    show('Device disconnected');
//    if (!connection.isConnected) {
//      setState(() {
//        _connected = false;
//        _isButtonUnavailable = false;
//      });
//    }
//  }
//
//  // Method to show a Snackbar,
//  // taking message as the text
//  Future show(
//    String message, {
//    Duration duration: const Duration(seconds: 3),
//  }) async {
//    await new Future.delayed(new Duration(milliseconds: 100));
//    _scaffoldKey.currentState.showSnackBar(
//      new SnackBar(
//        content: new Text(
//          message,
//        ),
//        duration: duration,
//      ),
//    );
//  }
//
//  void resetMessage() async {
//    await _sendElmCommand('AT Z');
//    await _sendElmCommand('AT E0');
//    await _sendElmCommand('AT L0');
//    await _sendElmCommand('AT S0');
//    await _sendElmCommand('AT SP 0');
//  }
//
//  void sendGetAvailablePids() async {
//    await _sendMessage('01 00');
//  }
//
//  void sendGetSpeed() async {
//    await _sendMessage('03');
//  }
//
//  void sendGetRpm() async {
//    await _sendMessage('01 0C');
//  }
//
//  Future<void> _sendMessage(String command) async {
//    BluetoothRequest bluetoothRequest =
//        BluetoothRequest(ObdCommand(command: command));
//    connection.output.add(bluetoothRequest.getDataToSend);
//    await Future.delayed(Duration(milliseconds: 600));
//  }
//
//  Future<void> _sendElmCommand(String command) async {
//    connection.output.add(Uint8List.fromList([
//      ...utf8.encode(command + '\r'),
//    ]));
//    await Future.delayed(Duration(milliseconds: 400));
//  }
//}
