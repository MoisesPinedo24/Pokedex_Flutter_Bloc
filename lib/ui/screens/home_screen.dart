import 'package:flutter/material.dart';
import 'package:pokemon_flutter/blocs/pokemon_basic/pokemon_state.dart';
import 'package:provider/provider.dart';
import '../../blocs/theme_controller.dart';
import '../widgets/bottom_loading_bar_widget.dart';
import '../widgets/home_screen_sliver_app_bar.dart';
import '../widgets/custom_sliver_grid_view.dart';
import 'package:pokemon_flutter/utils/constants.dart' as constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/pokemon_basic/pokemon_bloc.dart';
import '../../blocs/pokemon_basic/pokemon_event.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  int offset = 0;
  bool atBottom = false;
  bool loadData = false;

  @override
  void initState() {
    context.read<PokemonBasicBloc>().add(LoadPokemons(offset));
    pokemonLazyLoading();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Provider.of<ThemeController>(context).themeData;
    bool isDark = themeData == ThemeData.dark();
    return Scaffold(
        backgroundColor: isDark
            ? constants.scaffoldDarkThemeColor
            : constants.scaffoldLightThemeColor,
        body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: constants.mediumPadding),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                const CustomSliverAppBar(),

                const SliverToBoxAdapter(
                  child: SizedBox(height: constants.mediumPadding),
                ),

                // 👇 CONTADOR DE POKEMONES
                SliverToBoxAdapter(
                  child: BlocBuilder<PokemonBasicBloc, PokemonBasicState>(
                    builder: (context, state) {
                      if (state is PokemonBasicLoaded) {
                        final total = state.pokemons.length;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Pokémons: $total",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),

                const CustomSliverGridView(),

                if (atBottom && loadData) const BottomLoadingBarWidget(),

                if (atBottom && !loadData)
                  const SliverToBoxAdapter(
                    child: SizedBox(height: constants.mediumPadding),
                  ),
              ],
            )));
  }

  Future<void> pokemonLazyLoading() async {
    // fire at the bottom of the screen
    setState(() {
      atBottom = true;
      loadData = true;
    });
    // set the scroll Controller
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        // if reached the bottom of the grid change offset and fetch new data
        if (!isTop) {
          offset += 20;
        }
      } else if (offset >= 980) {
        setState(() {
          loadData = false;
          atBottom = false;
        });
      }
    });
  }
}
