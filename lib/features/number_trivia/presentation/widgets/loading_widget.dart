import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: const Center(
        child: SingleChildScrollView(
          child: SpinKitFadingFour(
            color: Colors.purple,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
