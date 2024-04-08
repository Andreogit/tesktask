import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task/consts/app_colors.dart';
import 'package:task/consts/app_fonts.dart';
import 'package:task/src/bloc/feed_dog_bloc/feed_dog_bloc.dart';
import 'package:task/ui/widgets/falling_bones_widget.dart';
import 'package:task/utils/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Animation dogPositionAnimation;
  late Animation dogTailAnimation;
  late Animation boneFallAnimation;
  late AnimationController dogAnimationController;
  late AnimationController tailController;
  Timer? loadImageTimer;
  int portions = 0;
  bool eaten = false;
  bool bonesFalling = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<FeedDogBloc>().add(GetRandomDog());
      portions = await DBHelper.getPortions();
      setState(() {});
    });
    dogAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    tailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    dogTailAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 0),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -0.3),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.3, end: 0.2),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: -0.3),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.3, end: 0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 0),
        weight: 3,
      ),
    ]).animate(tailController)
      ..addListener(() {
        setState(() {});
      });
    dogPositionAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: -60, end: -30), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -30, end: -30), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -30, end: -60), weight: 1),
    ]).animate(dogAnimationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    dogAnimationController.dispose();
    tailController.dispose();
    loadImageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 120),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    width: double.infinity,
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
                    child: Column(
                      children: [
                        const SizedBox(height: 84),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<FeedDogBloc, FeedDogState>(
                            builder: (context, state) {
                              if (state is FeedDogLoaded) {
                                return Text(
                                  state.dog.name ?? "",
                                  style: AppFonts.boldS30,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                );
                              }
                              return const Text(
                                "",
                                style: AppFonts.boldS30,
                              );
                            },
                          ),
                        ),
                        if (portions > 0)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      border: Border.all(
                                        width: 1.5,
                                        color: AppColors.lightBlue,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Transform.flip(flipX: true, child: SvgPicture.asset("assets/icons/decoration.svg")),
                                            const SizedBox(width: 16),
                                            Column(
                                              children: [
                                                const SizedBox(height: 16),
                                                Text(
                                                  portions.toString(),
                                                  style: AppFonts.alternateBoldS40,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 16),
                                            SvgPicture.asset("assets/icons/decoration.svg"),
                                          ],
                                        ),
                                        if (eaten)
                                          Text(
                                            "Portion eaten",
                                            style: AppFonts.alternateS20.copyWith(letterSpacing: 1),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  opacity: eaten ? 1 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      width: 52,
                                      height: 52,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.lightBlue,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/icons/like.svg",
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -64,
                    left: 0,
                    right: 0,
                    child: BlocBuilder<FeedDogBloc, FeedDogState>(
                      builder: (context, state) {
                        if (state is FeedDogLoading) {
                          return const Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor: Colors.white,
                              ),
                              CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ],
                          );
                        }
                        if (state is FeedDogLoaded) {
                          return CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(state.dog.imageUrl),
                          );
                        }
                        return const CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.white,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 30,
                    right: 30,
                    child: BlocBuilder<FeedDogBloc, FeedDogState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () async {
                            if (state is! FeedDogLoaded) return;
                            if (loadImageTimer?.isActive ?? false) loadImageTimer!.cancel();
                            loadImageTimer = Timer(const Duration(seconds: 3), () {
                              context.read<FeedDogBloc>().add(GetRandomDog());
                              setState(() {
                                bonesFalling = false;
                              });
                            });
                            if (dogAnimationController.status == AnimationStatus.forward) {
                              dogAnimationController.reverse();
                              tailController.reverse();
                            } else {
                              await DBHelper.incrementPortions();
                              setState(() {
                                bonesFalling = true;
                                eaten = true;
                                portions += 1;
                              });
                              dogAnimationController.reset();
                              tailController.reset();
                              dogAnimationController.forward();
                              tailController.forward();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 63,
                            width: 50,
                            decoration: BoxDecoration(
                              color: portions > 9 ? AppColors.blue : AppColors.red,
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Text(
                              "give food".toUpperCase(),
                              style: AppFonts.boldS30.copyWith(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AnimatedBuilder(
            animation: dogAnimationController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    bottom: dogPositionAnimation.value + 10,
                    left: -70,
                    right: 0,
                    child: Transform.rotate(
                      angle: dogTailAnimation.value,
                      child: SvgPicture.asset(
                        "assets/icons/tail.svg",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: dogPositionAnimation.value,
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset("assets/icons/small_dog.svg"),
                  ),
                ],
              );
            }),
        AnimatedOpacity(
          opacity: bonesFalling ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          child: BonesWidget(
            totalBones: 7,
            speed: .17,
            isRunning: bonesFalling,
          ),
        ),
      ],
    );
  }
}
