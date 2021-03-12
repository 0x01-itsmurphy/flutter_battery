import 'dart:async';
import 'package:battery/battery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}


// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   Battery _battery = Battery();
//   BatteryState _batteryState;
//   int _batteryLevel;
//   StreamSubscription<BatteryState> _batteryStateSubscription;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
//       setState(() {
//         _batteryState = state;
//       });
//     });
//   }
//
//   Future<void> _getLevel() async {
//     final int batteryLevel = await _battery.batteryLevel;
//     setState(() {
//       _batteryLevel = batteryLevel;
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     if(_batteryStateSubscription != null) {
//       _batteryStateSubscription.cancel();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Flutter Battery"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Text("State : $_batteryState"),
//           RaisedButton(
//             onPressed: _getLevel,
//             child: Text("Battery Level"),
//           ),
//           Text("Level: $_batteryLevel %"),
//         ],
//       ),
//     );
//   }
// }


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Battery b = Battery();
  int showBatteryLevel = 0;
  BatteryState state;
  bool broadcastBattery;

  Color COLOR_RED = Colors.red;
  Color COLOR_GREEN = Colors.green;
  Color COLOR_GREY = Colors.grey;

  @override
  void initState() {
    // TODO: implement initState, implement Battery
    super.initState();
    _broadcastBatteryLevels();
    b.onBatteryStateChanged.listen((event) {
      setState(() {
        state = event;
      });
    });
  }

  _broadcastBatteryLevels() async {
    broadcastBattery = true;
    while(broadcastBattery) {
      var bLevels = await b.batteryLevel;
      setState(() {
        showBatteryLevel = bLevels;
      });
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Battery Graph"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                width: MediaQuery.of(context).size.width * 0.6,
                //width: 250,
                height: MediaQuery.of(context).size.width * 0.6,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: -6,
                      offset: Offset(4, 4),
                      color: COLOR_GREY,
                    ),
                    // BoxShadow(
                    //   blurRadius: 7,
                    //   spreadRadius: -6,
                    //   offset: Offset(4, 4),
                    //   color: COLOR_GREY,
                    // ),
                  ]
                ),
                child: SfRadialGauge(
                  axes: [
                    RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      startAngle: 270,
                      endAngle: 270,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: AxisLineStyle(
                        thickness: 1,
                        color: showBatteryLevel <=10 ? COLOR_RED : COLOR_GREEN,
                        //color: Colors.blueAccent,
                        thicknessUnit: GaugeSizeUnit.factor
                      ),


                      //Circular bar
                      pointers: <GaugePointer> [
                        RangePointer(
                          value: double.parse(showBatteryLevel.toString()),
                          width: 0.2,
                          color: Colors.white,
                          pointerOffset: 0.1,
                          cornerStyle: showBatteryLevel == 100 ? CornerStyle.bothFlat: CornerStyle.endCurve,
                          sizeUnit: GaugeSizeUnit.factor
                        )
                      ],

                      //inside circular bar
                      annotations: <GaugeAnnotation> [
                        GaugeAnnotation(
                          positionFactor: 0.5,
                          angle: 90,
                          widget: Text(showBatteryLevel == null ? 0 : showBatteryLevel.toString() + " %", style: TextStyle(fontSize: 25, color: Colors.white), )
                        )
                      ]
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 0.4,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      batteryContainer(70, Icons.power, 40,showBatteryLevel <= 10 ? COLOR_RED: COLOR_GREEN, state == BatteryState.charging ? true: false),
                      batteryContainer(70, Icons.power_off, 40,showBatteryLevel <= 10 ? COLOR_RED: COLOR_GREEN, state == BatteryState.discharging ? true: false),
                      batteryContainer(70, Icons.battery_charging_full, 40,showBatteryLevel <= 10 ? COLOR_RED: COLOR_GREEN, state == BatteryState.full ? true: false),
                    ],
                  ),
                ),
              ),


              SizedBox(height: 20,),
              Container(
                child: Text("$state",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  batteryContainer(double size, IconData icon, double iconSize, Color iconColor, bool hasGlow) {
    return Container(
      width: size,
      height: size,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          hasGlow
          ? BoxShadow(
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 0),
            color: iconColor)
          : BoxShadow(
            blurRadius: 7,
            spreadRadius: -5,
            offset: Offset(2, 2),
            color: COLOR_GREY
          )
        ]
      ),
    );
  }
}
