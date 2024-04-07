part of 'feed_dog_bloc.dart';

sealed class FeedDogEvent extends Equatable {
  const FeedDogEvent();

  @override
  List<Object> get props => [];
}

class GetRandomDog extends FeedDogEvent {}
