abstract class PokemonBasicEvent {}

class LoadPokemons extends PokemonBasicEvent {
  final int offset;
  LoadPokemons(this.offset);
}
