import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class CustomAnnimation extends StatelessWidget {
  const CustomAnnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return  Lottie.asset('assets/lotties/loading_lottie.json');
    ;
  }
}
