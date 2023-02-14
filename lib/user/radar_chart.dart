// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class RadarChartSample extends StatefulWidget {
//   @override
//   _RadarChartSampleState createState() => _RadarChartSampleState();
// }

// class _RadarChartSampleState extends State<RadarChartSample> {
//   List<double> data = [20, 30, 40, 10, 25];
//   int maxValue = 50;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: AspectRatio(
//         aspectRatio: 1,
//         child: RadarChart(
//           RadarChartData(
//             borderData: FlBorderData(show: false),
//             radarBackgroundColor: Colors.white,
//             tickCount: 5,
//             ticksTextStyle: TextStyle(
//               fontSize: 10,
//               color: Colors.grey[400],
//             ),



//             tickFrequency: maxValue / 5,
//             gridBorderData: FlBorderData(
//               show: true,
//               border: Border.all(color: Colors.grey[300], width: 1),
//             ),
//             dataSets: [
//               RadarDataSet(
//                 fillColor: Colors.blue.withOpacity(0.4),
//                 data: data,
//                 borderData: FlBorderData(show: true),
//                 dotData: FlDotData(show: true),
//               ),
//             ],
//             labels: ['心', '技', '体', '生', '運'],
//             labelOffset: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }
