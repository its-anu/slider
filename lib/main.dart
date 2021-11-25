import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MySlider(),
    );
  }
}

class MySlider extends StatefulWidget {
  const MySlider({Key? key}) : super(key: key);

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double settlementDays = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 600,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.73,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Edit group details',
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: const Icon(Icons.cancel),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
                                ),
                                // child: Image(image: image),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 60,
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              decoration: const InputDecoration(
                                hintText: 'Flatfriends',
                                hintStyle: TextStyle(fontSize: 14),
                                labelText: 'Name of group',
                              ),
                              style: const TextStyle(fontSize: 20),
                              onSaved: (value) {},
                              validator: (value) {},
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Settles every:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.indigo,
                    inactiveTrackColor: Colors.grey,
                    trackShape: CustomTrackShape(),
                    trackHeight: 2.0,
                    thumbShape: const CustomSliderThumbRect(
                      thumbRadius: 30,
                      max: 30,
                      min: 3,
                      thumbHeight: 50,
                    ),
                    activeTickMarkColor: Colors.indigo,
                    inactiveTickMarkColor: Colors.grey,
                    overlayShape: SliderComponentShape.noOverlay,
                    tickMarkShape: const RoundSliderTickMarkShape(),
                  ),
                  child: Slider(
                    value: settlementDays,
                    min: 3,
                    max: 30,
                    divisions: 27,
                    onChanged: (value) {
                      setState(
                        () {
                          settlementDays = value;
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Next settlement in: ${settlementDays.toInt()}',
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final double thumbHeight;
  final int min;
  final int max;

  const CustomSliderThumbRect({
    required this.thumbRadius,
    required this.thumbHeight,
    required this.min,
    required this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: thumbHeight * 0.9, height: thumbHeight * 0.9),
      Radius.circular(thumbRadius * .4),
    );

    final paint = Paint()
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = Colors.indigo //Thumb Background Color
      ..style = PaintingStyle.stroke;

    TextSpan span = TextSpan(
        style: TextStyle(
            fontSize: thumbHeight * .3,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 1),
        text: getValue(value));
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawRRect(rRect, paint);
    canvas.drawRRect(rRect, paintBorder);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
