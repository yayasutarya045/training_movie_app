import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/ui/screen/Favorite/cubit/favorite_cubit.dart';
import 'package:movie/ui/screen/Favorite/favorite_screen.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FavoriteCubit()..loadFavorite(),
        ),
      ],
      child: FavoriteScreen(),
    );
  }
}
