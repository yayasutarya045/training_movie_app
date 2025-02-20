import 'package:dio/dio.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';

class MovieRepository {
  final dio = Dio();

  final genreUrl = 'https://api.themoviedb.org/3/genre/movie/list?language=id';
  final nowPlayingUrl =
      'https://api.themoviedb.org/3/movie/now_playing?language=id-ID&page=1&region=ID';
  searchMovieUrl(String query) =>
      'https://api.themoviedb.org/3/search/movie?query=$query&include_adult=true&language=id-ID&page=1';
  final upcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?language=id-ID&page=1&region=ID';
  final accessToken =
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NGI3YTQyOWRlZDQzOTBmMjYwZDAyYjIxNGJhNzg1ZiIsIm5iZiI6MTU3MjYxODg3NS43ODMsInN1YiI6IjVkYmM0MjdiNTRmNmViMDAxODRlYzhkOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YYhrlqbEUiZWdsOhRRv5faIyfCgOb7jCQvSZBy18cyc';
  detailMovieUrl(int id) =>
      'https://api.themoviedb.org/3/movie/$id?language=id-ID';

  Future<List<GenreEntity>> getGenres() async {
    final result = await dio.get(
      genreUrl,
      options: Options(
        headers: {
          'Authorization': accessToken,
          'Content-Type': 'application/json'
        },
      ),
    );

    return (result.data['genres'] as List)
        .map((e) => GenreEntity.fromMap(e))
        .toList();
  }

  Future<List<MovieEntity>> getNowPlaying() async {
    final result = await dio.get(
      nowPlayingUrl,
      options: Options(
        headers: {
          'Authorization': accessToken,
          'Content-Type': 'application/json'
        },
      ),
    );

    return (result.data['results'] as List)
        .map((e) => MovieEntity.fromJson(e))
        .toList();
  }

  Future<List<MovieEntity>> getUpcoming() async {
    final result = await dio.get(
      upcomingUrl,
      options: Options(
        headers: {
          'Authorization': accessToken,
          'Content-Type': 'application/json'
        },
      ),
    );

    return (result.data['results'] as List)
        .map((e) => MovieEntity.fromJson(e))
        .toList();
  }

  Future<DetailMovieEntity> getDetailMovie(int id) async {
    final result = await dio.get(
      detailMovieUrl(id),
      options: Options(
        headers: {
          'Authorization': accessToken,
          'Content-Type': 'application/json'
        },
      ),
    );

    return DetailMovieEntity.fromJson(result.data);
  }

  Future<List<MovieEntity>> searchMovie(String query) async {
    final result = await dio.get(
      searchMovieUrl(query),
      options: Options(
        headers: {
          'Authorization': accessToken,
          'Content-Type': 'application/json'
        },
      ),
    );

    return (result.data['results'] as List)
        .map((e) => MovieEntity.fromJson(e))
        .toList();
  }
}
