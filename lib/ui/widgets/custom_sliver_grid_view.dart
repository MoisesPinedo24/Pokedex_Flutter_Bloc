import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_flutter/models/pokemon_basic_data.dart';
import 'package:pokemon_flutter/ui/widgets/pokemon_card_item.dart';

import '../../blocs/pokemon_basic/pokemon_bloc.dart';
import '../../blocs/pokemon_basic/pokemon_state.dart';
import '../../blocs/pokemon_favorite_controller.dart';

class CustomSliverGridView extends StatelessWidget {
  final bool showFavorites;

  const CustomSliverGridView({Key? key, this.showFavorites = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBasicBloc, PokemonBasicState>(
      builder: (context, state) {
        if (state is PokemonBasicLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is PokemonBasicLoaded) {
          List<PokemonBasicData> pokemons = state.pokemons;

          if (showFavorites) {
            pokemons =
                context.read<PokemonFavoritesController>().favoritePokemons;
          }

          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final pokemon = pokemons[index];

                String pokemonIdPadLeft =
                    (index + 1).toString().padLeft(3, '0');

                String imageUrl =
                    'https://assets.pokemon.com/assets/cms2/img/pokedex/full/$pokemonIdPadLeft.png';

                if (showFavorites) {
                  imageUrl = pokemon.imageUrl;
                  pokemonIdPadLeft = pokemon.id;
                }

                return PokemonCardItem(
                  pokemon: pokemon,
                  isDark: Theme.of(context).brightness == Brightness.dark,
                  id: pokemonIdPadLeft,
                  imageUrl: imageUrl,
                );
              },
              childCount: pokemons.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 200,
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }
}
