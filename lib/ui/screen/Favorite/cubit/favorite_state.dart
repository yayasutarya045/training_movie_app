part of 'favorite_cubit.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteActionLoaded extends FavoriteState {
  final bool isFavorite;
  FavoriteActionLoaded(this.isFavorite);

  @override
  List<Object?> get props => [isFavorite];
}

final class FavoriteLoaded extends FavoriteState {
  final List<FavoriteEntity> favorites;

  FavoriteLoaded({required this.favorites});
}
