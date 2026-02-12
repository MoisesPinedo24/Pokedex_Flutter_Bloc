import '../../models/pokemon_basic_data.dart';

abstract class PokemonBasicState {}

class PokemonBasicInitial extends PokemonBasicState {}

class PokemonBasicLoading extends PokemonBasicState {}

class PokemonBasicLoaded extends PokemonBasicState {
  final List<PokemonBasicData> pokemons;
  PokemonBasicLoaded(this.pokemons);
}

class PokemonBasicError extends PokemonBasicState {}
