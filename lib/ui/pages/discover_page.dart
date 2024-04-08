import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/consts/app_colors.dart';
import 'package:task/consts/app_fonts.dart';
import 'package:task/src/bloc/discover_bloc/discover_dogs_bloc.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<DiscoverDogsBloc, DiscoverDogsState>(
            builder: (context, state) {
              if (state is DiscoverDogsLoaded) {
                return Column(
                  children: [
                    state.dogs.isEmpty ? const Center(child: Text("No dogs found", style: AppFonts.boldS16)) : const SizedBox.shrink(),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () => context.read<DiscoverDogsBloc>().add(GetRandomDogsEvent()),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text("discover new dogs".toUpperCase(), style: AppFonts.boldS16)),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => context.read<DiscoverDogsBloc>().add(GetRandomDogsEvent()),
                      child: GridView.count(
                        shrinkWrap: true,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        crossAxisCount: 4,
                        children: state.dogs
                            .map(
                              (dog) => Image.network(
                                dog.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            )
                            .toList(),
                      ),
                    )
                  ],
                );
              }
              if (state is DiscoverDogsError) {
                return Text(
                  state.message,
                  style: AppFonts.boldS16,
                );
              }
              if (state is DiscoverDogsLoading) {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ],
                );
              }
              if (state is DiscoverDogsInitial) {
                return InkWell(
                  onTap: () => context.read<DiscoverDogsBloc>().add(GetRandomDogsEvent()),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "discover dogs".toUpperCase(),
                        style: AppFonts.boldS30.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
