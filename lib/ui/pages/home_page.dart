import 'package:flutter/material.dart';
import 'package:task/consts/app_colors.dart';
import 'package:task/consts/app_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(40),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 380,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(233, 228, 209, 0.3),
                      blurRadius: 15,
                      spreadRadius: 15,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              Positioned(
                bottom: -30,
                left: 30,
                right: 30,
                child: Container(
                  alignment: Alignment.center,
                  height: 80,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    "give food".toUpperCase(),
                    style: AppFonts.boldS30.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
