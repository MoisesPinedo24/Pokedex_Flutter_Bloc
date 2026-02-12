import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokemon_flutter/blocs/pokemon_favorite_controller.dart';
import 'package:pokemon_flutter/utils/constants.dart' as constants;
import 'package:pokemon_flutter/models/pokemon_basic_data.dart';
import '../../blocs/theme_controller.dart';
import '../widgets/white_sheet_widgets/white_sheet_widget.dart';

class PokemonDetailScreen extends StatelessWidget {
  static const String routeName = 'PokemonDetailScreen';

  const PokemonDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeController>().themeData;
    final isDark = themeData == ThemeData.dark();

    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final PokemonBasicData pokemon = data['pokemon'];
    final Color cardColor = data['color'];
    final String imageUrl = data['imageUrl'];

    final favoritesController = context.watch<PokemonFavoritesController>();

    // get screen height and width
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: cardColor,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top +
                  constants.screenTopPadding,
            ),

            /// -------- HEADER ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: isDark
                        ? constants.backIconDarkThemeColor
                        : constants.backIconLightThemeColor,
                    size: constants.detailScreenIconSize,
                  ),
                ),

                Text(
                  pokemon.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? constants.pokemonNameDarkThemeColor
                            : constants.pokemonNameTitleLightThemeColor,
                      ),
                ),

                /// -------- FAVORITE BUTTON ----------
                FutureBuilder<bool>(
                  future: favoritesController.isPokemonFavorite(pokemon.name),
                  builder: (context, snapshot) {
                    final isFavorite = snapshot.data ?? false;

                    return IconButton(
                      padding:
                          const EdgeInsets.only(right: constants.mediumPadding),
                      onPressed: () async {
                        await favoritesController
                            .toggleFavoritePokemon(pokemon.name);
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: isFavorite ? Colors.pink : Colors.white,
                        size: constants.detailScreenIconSize,
                      ),
                    );
                  },
                ),
              ],
            ),

            /// -------- BODY ----------
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: WhiteSheetWidget(pokemon: pokemon, isDark: isDark),
                  ),
                  SizedBox(
                    height: screenHeight * 0.35,
                    width: screenWidth,
                    child: Hero(
                      tag: pokemon.name,
                      child: Image.network(imageUrl, fit: BoxFit.contain),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
