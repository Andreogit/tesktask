import 'package:flutter/material.dart';
import 'package:task/consts/app_colors.dart';
import 'package:task/consts/app_fonts.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: AppColors.background,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.lightBlue,
                    ),
                    Icon(
                      Icons.pets,
                      size: 45,
                      color: AppColors.blue,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("DogLover16", style: AppFonts.boldS20),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
