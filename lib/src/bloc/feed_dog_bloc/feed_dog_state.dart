part of 'feed_dog_bloc.dart';

sealed class FeedDogState extends Equatable {
  const FeedDogState();

  @override
  List<Object> get props => [];
}

final class FeedDogInitial extends FeedDogState {}

final class FeedDogLoading extends FeedDogState {}

final class FeedDogLoaded extends FeedDogState {
  final Dog dog;

  const FeedDogLoaded({required this.dog});

  @override
  List<Object> get props => [dog];
}

final class FeedDogError extends FeedDogState {
  final String message;

  const FeedDogError({required this.message});
}
