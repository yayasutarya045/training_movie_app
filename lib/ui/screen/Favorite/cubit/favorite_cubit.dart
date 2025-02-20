import 'dart:convert';
import 'dart:core';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:movie/domain/entities/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorite_state.dart';

// class FavoriteCubit extends Cubit<FavoriteState> {
//   FavoriteCubit() : super(FavoriteInitial());

//   Future<void> loadFavorite() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? dataFavorite = prefs.getStringList('favorite') ?? [];

//     List<FavoriteEntity> favorites = dataFavorite
//         .map((fav) => FavoriteEntity.fromJson(json.decode(fav)))
//         .toList();

//     emit(FavoriteLoaded(favorites: favorites));
//   }

//   Future<void> checkFavorite(int movieId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> dataFavorite = prefs.getStringList('favorite') ?? [];

//     List<FavoriteEntity> favorites = dataFavorite
//         .map((fav) => FavoriteEntity.fromJson(json.decode(fav)))
//         .toList();

//     bool isFavorite = favorites.any((element) => element.data.id == movieId);
//     emit(FavoriteActionLoaded(isFavorite));
//   }

//   Future<void> actionFavorite(FavoriteEntity favorite) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> dataFavorite = prefs.getStringList('favorite') ?? [];

//     List<FavoriteEntity> favorites = dataFavorite
//         .map((fav) => FavoriteEntity.fromJson(json.decode(fav)))
//         .toList();

//     bool isFavorite =
//         favorites.any((element) => element.data.id == favorite.data.id);

//     if (isFavorite) {
//       favorites.removeWhere((element) => element.data.id == favorite.data.id);
//     } else {
//       favorites.add(favorite);
//     }

//     List<String> updateFavorite =
//         favorites.map((fav) => json.encode(fav.toJson())).toList();
//     await prefs.setStringList('favorite', updateFavorite);

//     await checkFavorite(favorite.data.id!);
//   }
// }
class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  /// **Memuat semua daftar film favorit dari SharedPreferences**
  Future<void> loadFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataFavorite = prefs.getStringList('favorite') ?? [];

    List<FavoriteEntity> favorites = dataFavorite
        .map((fav) => FavoriteEntity.fromJson(json.decode(fav)))
        .toList();

    emit(FavoriteLoaded(favorites: favorites));
  }

  /// **Memeriksa apakah film tertentu ada dalam daftar favorit**
  Future<void> checkFavorite(int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataFavorite = prefs.getStringList('favorite') ?? [];

    List<FavoriteEntity> favorites = dataFavorite
        .map((fav) => FavoriteEntity.fromJson(json.decode(fav)))
        .toList();

    bool isFavorite = favorites.any((element) => element.data.id == movieId);

    emit(FavoriteActionLoaded(isFavorite));
  }

  /// **Menambahkan atau menghapus film dari daftar favorit**
  Future<void> actionFavorite(FavoriteEntity favorite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataFavorite = prefs.getStringList('favorite') ?? [];

    List<FavoriteEntity> favorites = dataFavorite
        .map((fav) => FavoriteEntity.fromJson(json.decode(fav)))
        .toList();

    bool isFavorite =
        favorites.any((element) => element.data.id == favorite.data.id);

    if (isFavorite) {
      favorites.removeWhere((element) => element.data.id == favorite.data.id);
    } else {
      favorites.add(favorite);
    }

    List<String> updateFavorite =
        favorites.map((fav) => json.encode(fav.toJson())).toList();
    await prefs.setStringList('favorite', updateFavorite);

    /// **Periksa kembali status favorit setelah perubahan**
    await checkFavorite(favorite.data.id!);
  }

  /// **Mengambil semua daftar film favorit**
  Future<List<FavoriteEntity>> getFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataFavorite = prefs.getStringList('favorite') ?? [];

    List<FavoriteEntity> favorites = dataFavorite
        .map((fav) => FavoriteEntity.fromJson(json.decode(fav)))
        .toList();

    return favorites;
  }
}
