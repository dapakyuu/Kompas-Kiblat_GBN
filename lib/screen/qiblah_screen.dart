import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

Animation<double>? animation;
AnimationController? _animationController;
double begin = 0.0;

class _QiblahScreenState extends State<QiblahScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        body: StreamBuilder(
          stream: FlutterQiblah.qiblahStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ));
            }

            final qiblahDirection = snapshot.data;
            double qiblahAngle = (qiblahDirection!.qiblah * (pi / 180) * -1);
            double westAngle = (270 - qiblahDirection.direction) * (pi / 180);

            // Update animation for qiblah angle
            animation = Tween(begin: begin, end: qiblahAngle)
                .animate(_animationController!);
            begin = qiblahAngle;
            _animationController!.forward(from: 0);

            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${qiblahDirection.direction.toInt()}°",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Gambar arah yang mengikuti arah barat
                          Transform.rotate(
                            angle: westAngle, // Rotasi gambar arah ke barat
                            child: Image.asset(
                              'images/arah.png',
                              height: 300,
                              width: 300,
                            ),
                          ),
                          // Gambar kompas yang mengikuti arah kiblat
                          AnimatedBuilder(
                            animation: animation!,
                            builder: (context, child) => Transform.rotate(
                              angle: animation!.value,
                              child: Image.asset(
                                'images/qibla.png',
                                height: 150,
                                width: 150,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            );
          },
        ),
      ),
    );
  }
}
