import 'package:flutter/material.dart';
import 'package:pokemon_flutter/blocs/pokemon_about_controller.dart';
import 'package:pokemon_flutter/blocs/pokemon_basic/pokemon_event.dart';
import 'package:pokemon_flutter/blocs/pokemon_favorite_controller.dart';
import 'package:pokemon_flutter/blocs/pokemon_more_info_controller.dart';
import 'package:pokemon_flutter/blocs/pokemon_stat_controller.dart';
import 'package:pokemon_flutter/blocs/search_controller.dart';
import 'package:pokemon_flutter/ui/screens/favorite_screen.dart';
import 'package:pokemon_flutter/ui/screens/home_screen.dart';
import 'package:pokemon_flutter/ui/screens/pokemon_detail_screen.dart';
import 'package:pokemon_flutter/ui/screens/search_screen.dart';
import 'package:pokemon_flutter/ui/screens/settings_screen.dart';
import 'package:pokemon_flutter/blocs/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_flutter/blocs/pokemon_basic/pokemon_bloc.dart';
import 'package:pokemon_flutter/services/pokemon_basic_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isDarkTheme = prefs.getBool("isDark") ?? true;

  runApp(
    MultiProvider(
      providers: [
        /// -------- THEME ----------
        ChangeNotifierProvider(
          create: (_) => ThemeController(isDarkTheme),
        ),

        /// -------- BLOCS ----------
        BlocProvider(
          create: (_) =>
              PokemonBasicBloc(PokemonBasicDataService())..add(LoadPokemons(0)),
        ),

        /// -------- CONTROLLERS ----------
        ChangeNotifierProvider(create: (_) => PokemonAboutDataController()),
        ChangeNotifierProvider(create: (_) => PokemonMoreInfoController()),
        ChangeNotifierProvider(create: (_) => PokemonStatsController()),
        ChangeNotifierProvider(create: (_) => PokemonFavoritesController()),
        ChangeNotifierProvider(create: (_) => SearchPokemonsController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, provider, ch) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: provider.themeData,
          title: 'Flutter Demo',
          initialRoute: HomeScreen.routeName,
          routes: {
            HomeScreen.routeName: (context) => const HomeScreen(),
            PokemonDetailScreen.routeName: (context) =>
                const PokemonDetailScreen(),
            SettingsScreen.routeName: (context) => const SettingsScreen(),
            FavoriteScreen.routeName: (context) => const FavoriteScreen(),
            SearchScreen.routeName: (context) => const SearchScreen(),
          },
        );
      },
    );
  }
}
