import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task/consts/app_colors.dart';
import 'package:task/consts/app_fonts.dart';
import 'package:task/src/bloc/feed_dog_bloc/feed_dog_bloc.dart';
import 'package:task/utils/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Animation dogPositionAnimation;
  late Animation dogTailAnimation;
  late AnimationController dogAnimationController;
  late AnimationController tailController;
  int portions = 0;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 30),
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
                    child: Column(children: [
                      const SizedBox(height: 84),
                      Center(
                          child: Text(
                        portions.toString(),
                        style: AppFonts.alternateS30,
                      )),
                    ]),
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
                    bottom: -30,
                    left: 30,
                    right: 30,
                    child: BlocBuilder<FeedDogBloc, FeedDogState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () async {
                            if (state is! FeedDogLoaded) return;
                            Future.delayed(const Duration(milliseconds: 1500), () {
                              context.read<FeedDogBloc>().add(GetRandomDog());
                            });
                            if (dogAnimationController.status == AnimationStatus.forward) {
                              dogAnimationController.reverse();
                              tailController.reverse();
                            } else {
                              await DBHelper.incrementPortions();
                              setState(() {
                                portions = portions + 1;
                              });
                              dogAnimationController.reset();
                              tailController.reset();
                              dogAnimationController.forward();
                              tailController.forward();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 80,
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
      ],
    );
  }
}
