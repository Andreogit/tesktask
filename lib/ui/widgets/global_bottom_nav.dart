import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task/consts/app_colors.dart';
import 'package:task/consts/app_fonts.dart';
import 'package:task/src/bloc/tab_index_cubit.dart';

class GlobalBottomNav extends StatelessWidget {
  const GlobalBottomNav({Key? key, required this.activeItemIndex}) : super(key: key);
  final int activeItemIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom + 10,
      color: Colors.transparent,
      child: const Row(
        children: [
          BottomNavItem(
            asset: "assets/icons/home.svg",
            text: "Home",
            index: 0,
          ),
          BottomNavItem(
            asset: "assets/icons/discover.svg",
            text: "Discover",
            index: 1,
          ),
          BottomNavItem(
            asset: "assets/icons/paw.svg",
            text: "Feeder",
            index: 2,
          ),
          BottomNavItem(
            asset: "assets/icons/account.svg",
            text: "Account",
            index: 3,
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({Key? key, required this.asset, required this.text, required this.index, this.notificationCount}) : super(key: key);
  final int index;
  final String asset;
  final String text;
  final int? notificationCount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          context.read<TabIndexCubit>().changeTab(index);
        },
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            BlocBuilder<TabIndexCubit, int>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                  color: state == index ? AppColors.lightBlue : Colors.transparent,
                  child: Column(
                    children: [
                      SvgPicture.asset(asset, color: state == index ? Colors.black : AppColors.blue, height: 36, width: 36),
                      const SizedBox(height: 10),
                      Text(
                        text,
                        style: AppFonts.boldS12.copyWith(color: state == index ? Colors.black : AppColors.blue),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (notificationCount != null && notificationCount! > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  height: 20,
                  width: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.red,
                  ),
                  child: Text(
                    notificationCount?.toString() ?? "0",
                    style: AppFonts.boldS12.copyWith(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
