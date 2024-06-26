import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task/src/bloc/discover_bloc/discover_dogs_bloc.dart';
import 'package:task/src/bloc/feed_dog_bloc/feed_dog_bloc.dart';
import 'package:task/src/bloc/tab_index_cubit/tab_index_cubit.dart';
import 'package:task/src/repository/discover_dogs_repository.dart';
import 'package:task/src/repository/feed_dog_repository.dart';
import 'package:task/ui/pages/home_view.dart';
import 'package:task/utils/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.init();
  await dotenv.load(fileName: ".env");
  runApp(const Aplication());
}

class Aplication extends StatelessWidget {
  const Aplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TabIndexCubit()),
        BlocProvider(create: (context) => DiscoverDogsBloc(DiscoverDogsRepository())),
        BlocProvider(create: (context) => FeedDogBloc(FeedDogRepository())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Test task',
        home: HomeView(),
      ),
    );
  }
}


