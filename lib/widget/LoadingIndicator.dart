import 'package:flutter/cupertino.dart';
import 'package:jojocart_mobile/theme/appTheme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingIndicator extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
        color: AppTheme.primaryColor
        ,
        size: 50.0,
      ),
    );
  }
}