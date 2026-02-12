import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_flutter/blocs/pokemon_basic/pokemon_event.dart';
import 'package:pokemon_flutter/blocs/pokemon_basic/pokemon_state.dart';
import '../../services/pokemon_basic_service.dart';
import '../../models/pokemon_basic_data.dart';

class PokemonBasicBloc extends Bloc<PokemonBasicEvent, PokemonBasicState> {
  final PokemonBasicDataService basicDataService;

  List<PokemonBasicData> _pokemons = [];

  PokemonBasicBloc(this.basicDataService) : super(PokemonBasicInitial()) {
    on<LoadPokemons>(_onLoadPokemons);
  }

  Future<void> _onLoadPokemons(
    LoadPokemons event,
    Emitter<PokemonBasicState> emit,
  ) async {
    try {
      emit(PokemonBasicLoading());

      final fetchedPokemons =
          await basicDataService.getAllPokemons(event.offset);

      _pokemons.addAll(fetchedPokemons);

      emit(PokemonBasicLoaded(List.from(_pokemons)));
    } catch (_) {
      emit(PokemonBasicError());
    }
  }
}
