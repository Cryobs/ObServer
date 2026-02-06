import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  late List<GPData> _chartData;
  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SfCircularChart(series: <CircularSeries>[PieSeries<GPData, String>(
          dataSource: _chartData,
          xValueMapper: (GPData data,_) => data.continent,
          yValueMapper: (GPData data,_) => data.gdp,
          ),]), // 4:13 min tutorial
        )
    );
  }
    List<GPData> getChartData(){
      final List<GPData> chartData = [
        GPData('Oceania', 1600)
      ];
      return chartData;
    }

  }

class GPData {
    GPData(this.continent, this.gdp);
    final String continent;
    final int gdp;

  }


