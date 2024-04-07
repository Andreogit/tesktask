import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task/model/dog.dart';
import 'package:task/src/repository/feed_dog_repository.dart';

part 'feed_dog_event.dart';
part 'feed_dog_state.dart';

class FeedDogBloc extends Bloc<FeedDogEvent, FeedDogState> {
  FeedDogBloc(FeedDogRepository repository) : super(FeedDogInitial()) {
    on<FeedDogEvent>((event, emit) {});
    on<GetRandomDog>((event, emit) async {
      emit(FeedDogLoading());
      final dog = await repository.getRandomDog();
      emit(FeedDogLoaded(dog: dog));
    });
  }
}
