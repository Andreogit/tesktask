part of 'discover_dogs_bloc.dart';

sealed class DiscoverDogsState extends Equatable {
  const DiscoverDogsState();

  @override
  List<Object> get props => [];
}

final class DiscoverDogsInitial extends DiscoverDogsState {}

final class DiscoverDogsError extends DiscoverDogsState {
  final String message;

  const DiscoverDogsError({required this.message});
}

final class DiscoverDogsLoaded extends DiscoverDogsState {
  final List<Dog> dogs;

  const DiscoverDogsLoaded({required this.dogs});

  @override
  List<Object> get props => [dogs];
}

final class DiscoverDogsLoading extends DiscoverDogsState {}
