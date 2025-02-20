import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/favorite.dart';
import 'package:movie/ui/constant/color_pallete.dart';
import 'package:movie/ui/constant/constants.dart';
import 'package:movie/ui/screen/Favorite/cubit/favorite_cubit.dart';
import 'package:movie/ui/screen/detail/cubit/detail_movie_cubit.dart';
import 'package:movie/ui/screen/reservation/reservation_page.dart';

class DetailMovieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallete.colorPrimary,
      body: BlocBuilder<DetailMovieCubit, DetailMovieState>(
          builder: (context, state) {
        if (state is DetailMoviesLoaded) {
          context.read<FavoriteCubit>().checkFavorite(state.data.id!);
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.network(
                      '${Constants.imageBaseUrl}${'/original'}${state.data.posterPath}',
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            ),
                          ),
                          BlocBuilder<FavoriteCubit, FavoriteState>(
                            builder: (context, favoriteState) {
                              bool isFavorite = false;
                              if (favoriteState is FavoriteActionLoaded) {
                                isFavorite = favoriteState.isFavorite;
                              }
                              return IconButton(
                                onPressed: () {
                                  context
                                      .read<FavoriteCubit>()
                                      .actionFavorite(FavoriteEntity(
                                        data: state.data,
                                      )); // FavoriteEntity

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isFavorite
                                            ? 'Dihapus dari favorit'
                                            : 'Ditambahkan ke favorit',
                                      ), // Text
                                    ), // SnackBar
                                  );
                                },
                                icon: Icon(
                                  Icons.bookmark,
                                  color:
                                      isFavorite ? Colors.yellow : Colors.white,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            '${state.data.voteAverage}/10',
                            style: const TextStyle(color: Colors.yellow),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            '(${state.data.voteCount} voting)',
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          itemCount: state.data.genres?.length ?? 0,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                          itemBuilder: (context, index) {
                            var category = state.data.genres?[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: ColorPallete.colorSecondary),
                              child: Center(
                                child: Text(
                                  category?.name ?? '-',
                                  style:
                                      TextStyle(color: ColorPallete.colorWhite),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text('${state.data.title}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24)),
                      const SizedBox(
                        height: 16,
                      ),
                      Text('${state.data.overview}',
                          style: const TextStyle(color: Colors.white))
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (state is DetailMovieFailed) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.white),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
      bottomNavigationBar: BlocBuilder<DetailMovieCubit, DetailMovieState>(
        builder: (context, state) {
          if (state is DetailMoviesLoaded) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 60,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationPage(
                          idMovie: state.data.id ?? 0,
                          title: state.data.title ?? '',
                          imagePath:
                              '${Constants.imageBaseUrl}/original${state.data.posterPath ?? ''}',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorPallete.colorOrange,
                    ),
                    child: const Center(
                      child: Text(
                        'Get Reservation',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
