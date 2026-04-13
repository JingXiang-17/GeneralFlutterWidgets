import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// 1. A generic data model for your X and Y axis
class ChartPoint {
  final double x;
  final double y;
  ChartPoint({required this.x, required this.y});
}

// 2. The Reusable Widget
class DynamicLineChart extends StatelessWidget {
  final List<ChartPoint> data;
  final Color lineColor;
  final String title;

  const DynamicLineChart({
    super.key,
    required this.data,
    this.lineColor = Colors.blueAccent,
    this.title = "Market Data",
  });

  @override
  Widget build(BuildContext context) {
    // Convert our generic ChartPoints into fl_chart's expected format (FlSpot)
    List<FlSpot> spots = data.map((point) => FlSpot(point.x, point.y)).toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                // Hide the grid for a clean, modern FinTech look
                gridData: const FlGridData(show: false),
                // Hide right and top axis titles
                titlesData: const FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false), // Hide the bounding box
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true, // Makes the line smooth like Robinhood/Binance
                    color: lineColor,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false), // Hides the dots on each data point
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColor.withOpacity(0.2), // Adds a nice gradient below the line
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}