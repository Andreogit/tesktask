import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task/consts/app_colors.dart';

class GlobalScaffold extends StatelessWidget {
  const GlobalScaffold(
      {Key? key, this.appBar, required this.body, this.resizeToAvoidBottomInset, this.bottomNavigationBar, this.backgroundColor})
      : super(key: key);
  final Widget? appBar;
  final Widget body;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: appBar ??
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: SvgPicture.asset(
                "assets/icons/logo.svg",
                fit: BoxFit.cover,
              ),
            ),
      ),
      body: body,
    );
  }
}
