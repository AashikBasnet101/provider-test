import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider_test/core/constants/app_color.dart';

backdropFilter(context) {
  return Center(
    child: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
        child: SafeArea(
          child: Stack(
            children: [
              Center(child: SpinKitSpinningLines(color: Colors.black)),
              Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white.withOpacity(0),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
