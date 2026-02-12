import 'package:flutter/material.dart';
import 'package:pokemon_flutter/controllers/search_controller.dart';
import 'package:pokemon_flutter/ui/screens/search_abilitie_screen.dart';
import 'package:pokemon_flutter/ui/widgets/search_widgets/search_terminal_widget.dart';
import 'package:pokemon_flutter/utils/constants.dart' as constants;
import 'package:provider/provider.dart';
import '../../../controllers/theme_controller.dart';

class SearchResultItemWidget extends StatefulWidget {
  final String resultText;
  final bool nameFilter;
  final String? imageUrl;
  const SearchResultItemWidget(
      {Key? key,
      required this.resultText,
      required this.nameFilter,
      this.imageUrl})
      : super(key: key);

  @override
  State<SearchResultItemWidget> createState() => _SearchResultItemWidgetState();
}

class _SearchResultItemWidgetState extends State<SearchResultItemWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Provider.of<ThemeController>(context).themeData;
    bool isDark = themeData == ThemeData.dark();

    // navigate to pokemon data
    void navigateToPokemonData(String name, bool isDarkTheme) async {
      final Map<String, dynamic> pokemonData =
          await Provider.of<SearchPokemonsController>(context, listen: false)
              .getPokemonDataByName(name, isDarkTheme);
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SearchedPokemonTerminalWidget(
                isDark: isDark,
                pokemon: pokemonData['pokemon'],
                imageUrl: pokemonData['imageUrl'],
                id: pokemonData['id'])));
      }
    }

    // navigate to abilities data
    void navigateToAbilitiesData() async {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) =>
              SearchedAbilityScreen(abilityName: widget.resultText)));
    }

    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: constants.mediumPadding),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.resultText,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (widget.imageUrl != null)
                Image.network(
                  widget.imageUrl!,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
            ],
          ),
          const SizedBox(height: constants.mediumPadding),
          const Divider(height: 10),
        ],
      ),
      onTap: () {
        if (widget.nameFilter) {
          navigateToPokemonData(widget.resultText, isDark);
        } else {
          navigateToAbilitiesData();
        }
      },
    );
  }
}
