import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/src/bloc/tab_index_cubit/tab_index_cubit.dart';
import 'package:task/ui/pages/account_page.dart';
import 'package:task/ui/pages/discover_page.dart';
import 'package:task/ui/pages/feeder_page.dart';
import 'package:task/ui/pages/home_page.dart';
import 'package:task/ui/widgets/global_bottom_nav.dart';
import 'package:task/ui/widgets/global_scaffold.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      bottomNavigationBar: const GlobalBottomNav(),
      body: BlocBuilder<TabIndexCubit, int>(
        builder: (context, state) {
          return IndexedStack(
            index: state,
            children: const [
              HomePage(),
              DiscoverPage(),
              FeederPage(),
              AccountPage(),
            ],
          );
        },
      ),
    );
  }
}
