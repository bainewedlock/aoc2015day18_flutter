import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'dart:io';
import 'package:path/path.dart' as path;

var W = 100;
var H = 100;
var F = 3.0;

var lines = """
##.#.#
...##.
#....#
..#...
#.#..#
####.#
""".trim().split("\n");


void main() {
  H = lines.length;
  W = lines[0].length;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Size canvasSize = Size(W*F, H*F);

  _MyAppState(){
    for (var y=0; y<H; y++)
    {
      for (var x=0; x<W; x++)
      {
        if (lines[y][x] == '#')
        {
          items.add(Point(x,y));
        }
      }
    }
  }

  Set<Point> items = {};

  void updateStarPositions() {
    setState(() {
      items = items.map((offset) {
        return offset;
      }).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff000435),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomPaint(
                size: canvasSize,
                painter: DynamicStarCustomPainter(
                  items: items,
                ),
              ),
              SizedBox(height: 70),
              ElevatedButton(
                onPressed: updateStarPositions,
                child: Text('Update Star Positions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DynamicStarCustomPainter extends CustomPainter {
  final Set<Point> items;

  DynamicStarCustomPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {

    var paths = items.map((s) {
      return Path()
        ..addRect(Rect.fromPoints(Offset(s.x*F,s.y*F), Offset(s.x*F+F,s.y*F+F)));
    }).toList();

    var paints = items.map((s) {
      return Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white.withOpacity(1.0);
    }).toList();

    for (int i = 0; i < paths.length; i++) {
      canvas.drawPath(paths[i], paints[i]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}