import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task/model/dog.dart';
import 'package:task/src/repository/discover_dogs_repository.dart';

part 'discover_dogs_event.dart';
part 'discover_dogs_state.dart';

class DiscoverDogsBloc extends Bloc<DiscoverDogsEvent, DiscoverDogsState> {
  DiscoverDogsBloc(DiscoverDogsRepository repository) : super(DiscoverDogsInitial()) {
    getDogs(GetRandomDogsEvent event, Emitter<DiscoverDogsState> emit) async {
      emit(DiscoverDogsLoading());
      try {
        final dogs = await repository.getRandomDogs();
        emit(DiscoverDogsLoaded(dogs: dogs));
      } catch (e) {
        emit(DiscoverDogsError(message: e.toString()));
      }
    }

    on<GetRandomDogsEvent>(getDogs);
  }
}
