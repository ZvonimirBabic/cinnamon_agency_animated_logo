import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

// Method to convert degree to radians
double degToRad(num deg) => deg * (pi / 180.0);

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinnamon agency animated logo',
      theme: ThemeData(
        primarySwatch: primaryBlack,
      ),
      home: const MyHomePage(title: 'Cinnamon agency animated logo'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const CinnamonAgencyLogoWidget(),
    );
  }
}

class CinnamonAgencyLogoWidget extends StatefulWidget {
  const CinnamonAgencyLogoWidget({Key? key}) : super(key: key);

  @override
  State<CinnamonAgencyLogoWidget> createState() =>
      _CinnamonAgencyLogoWidgetState();
}

class _CinnamonAgencyLogoWidgetState extends State<CinnamonAgencyLogoWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> length;
  late final Animation<double> opacity;

  bool repeat = false;
  bool forward = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    length = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );

    opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.5,
          1,
          curve: Curves.decelerate,
        ),
      ),
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (repeat) {
          if (forward) {
            controller
              ..reset()
              ..forward();
          }
          if (!forward) {
            dev.log('reverse!');
            controller.reverse();
          }
        }
      }
      if (status == AnimationStatus.dismissed) {
        if (repeat) {
          if (forward) {
            controller.forward();
          }
          if (!forward) {
            dev.log('reverse!');
            controller.forward();
          }
        }
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            CustomPaint(
                painter: CinnamonAgencyLogoPainter(
                    lengthValue: length.value, opacityValue: opacity.value),
                // Pass size as infinite to make use of full screen size
                size: Size.infinite),
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Slider(
                value: controller.value,
                onChanged: (value) {
                  controller.value = value;
                  controller.stop();
                },
              ),
            ),
            Positioned(
              left: 0,
              bottom: 100,
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Checkbox(
                      value: repeat,
                      onChanged: (value) {
                        setState(
                          () {
                            repeat = value ?? false;
                          },
                        );
                      },
                    ),
                  ),
                  const Text('Repeat')
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 50,
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Switch(
                      value: forward,
                      onChanged: (value) {
                        setState(
                          () {
                            forward = value;
                          },
                        );
                      },
                    ),
                  ),
                  Text(forward ? 'Forward' : 'Reverse')
                ],
              ),
            ),
            Positioned(
              right: 15,
              bottom: 50,
              child: MaterialButton(
                shape: const CircleBorder(),
                color: Colors.black,
                onPressed: () {
                  setState(
                    () {
                      if (controller.isAnimating) {
                        controller.stop();
                      } else {
                        if (forward) {
                          controller.forward();
                        } else {
                          controller.reverse();
                        }
                      }
                      if (controller.isCompleted || controller.isDismissed) {
                        if (forward) {
                          controller.forward(from: controller.lowerBound);
                        }
                        if (!forward) {
                          controller.reverse(from: controller.upperBound);
                        }
                      }
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    controller.isAnimating ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// FOR PAINTING THE CIRCLE
class CinnamonAgencyLogoPainter extends CustomPainter {
  CinnamonAgencyLogoPainter(
      {required this.lengthValue, required this.opacityValue});

  final double lengthValue;
  final double opacityValue;

  @override
  void paint(Canvas canvas, Size size) {
    dev.log('length is $lengthValue');
    dev.log('opacity is $opacityValue');

    /// Black arcs
    var paintArc = Paint()
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.round
      ..color = lengthValue == 0 ? Colors.white : Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var leftArc = Path()
      ..arcTo(
          Rect.fromCenter(
              center: Offset((size.width / 2) - 7, (size.height / 2) + 12),
              width: 90,
              height: 90),
          degToRad(280),
          degToRad(-198),
          true)
      ..relativeLineTo(0, -24);

    var rightArc = Path()
      ..arcTo(
          Rect.fromCenter(
              center: Offset((size.width / 2) + 7, (size.height / 2) - 12),
              width: 90,
              height: 90),
          degToRad(100),
          degToRad(-198),
          true)
      ..relativeLineTo(0, 24);

    canvas.drawPath(
        leftArc.computeMetrics().first.extractPath(
            0, lengthValue * leftArc.computeMetrics().first.length),
        paintArc);
    canvas.drawPath(
        rightArc.computeMetrics().first.extractPath(
            0, lengthValue * rightArc.computeMetrics().first.length),
        paintArc);
    TextSpan span = TextSpan(
      text: 'Cinnamon agency',
      style: TextStyle(
        fontSize: 46,
        fontWeight: FontWeight.bold,
        color: Colors.black.withOpacity(opacityValue),
      ),
    );
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center);
    tp.textDirection = TextDirection.ltr;
    tp.layout();
    tp.paint(
      canvas,
      Offset(
        // Do calculations here:
        (size.width - tp.width) * 0.5,
        ((size.height - tp.height) * 0.5) + 100,
      ),
    );
    canvas.clipPath(Path.combine(PathOperation.union, leftArc, rightArc),
        doAntiAlias: true);
    canvas.drawColor(Colors.black.withOpacity(opacityValue), BlendMode.srcATop);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
