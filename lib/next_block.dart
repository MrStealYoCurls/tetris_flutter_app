import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class NextBlock extends StatefulWidget {
  const NextBlock({super.key});

  @override
  State<StatefulWidget> createState() => _NextBlockState();
}

class _NextBlockState extends State<NextBlock> {
  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
        color: HexColor("#343841"),
        border: Border.all(
          width: 2.0,
          color: Colors.orangeAccent,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        width: double.infinity,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Next',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5,),
            AspectRatio(
              aspectRatio: 1/3,
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor("#17191E"),
                  border: Border.all(
                    width: 2.0,
                    color: Colors.orangeAccent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
                child: Center(
                  child: Provider.of<Data>(context).getNextBlockWidget(),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
