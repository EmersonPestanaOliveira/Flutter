import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/backend_error_mapper.dart';
import '../../domain/entities/resultado.dart';
import 'resultados_state.dart';

class ResultadosCubit extends Cubit<ResultadosState> {
  ResultadosCubit() : super(const ResultadosInitial());

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> loadResultados() async {
    emit(const ResultadosLoading());
    try {
      // Busca as duas coleções em paralelo
      final results = await Future.wait([
        _firestore.collection('casos_solucionados').get(),
        _firestore.collection('novidades').get(),
      ]);

      final casosDocs = results[0].docs;
      final novidadesDocs = results[1].docs;

      final casos = await Future.wait(
        casosDocs.map((doc) async {
          final d = doc.data();
          return Resultado(
            id: doc.id,
            titulo: _readText(d, const ['titulo', 'title']),
            categoria: 'casos_solucionados',
            cidade: _readText(d, const ['cidade', 'local', 'bairro']),
            data: _readDate(d['data']),
            imagemUrl: await _readImageUrl(d),
            conteudo: _readOptionalText(d, const ['descricao', 'conteudo']),
          );
        }),
      );

      final novidades = await Future.wait(
        novidadesDocs.map((doc) async {
          final d = doc.data();
          return Resultado(
            id: doc.id,
            titulo: _readText(d, const ['titulo', 'title']),
            categoria: 'novidades',
            cidade: _readText(d, const ['cidade', 'local', 'bairro']),
            data: _readDate(d['data']),
            imagemUrl: await _readImageUrl(d),
            conteudo: _readOptionalText(d, const ['descricao', 'conteudo']),
          );
        }),
      );

      final todos = [...casos, ...novidades]
        ..sort((a, b) => b.data.compareTo(a.data));

      emit(
        ResultadosLoaded(todos: todos, filtro: 'casos_solucionados', query: ''),
      );
    } catch (error) {
      emit(ResultadosError(message: BackendErrorMapper.message(error)));
    }
  }

  void filtrar(String filtro) {
    final s = state;
    if (s is ResultadosLoaded) emit(s.copyWith(filtro: filtro));
  }

  void buscar(String query) {
    final s = state;
    if (s is ResultadosLoaded) emit(s.copyWith(query: query));
  }

  Future<String?> _readImageUrl(Map<String, dynamic> data) async {
    final raw = _firstImageValue(data);
    final image = _cleanImageValue(_extractImageString(raw));
    if (image == null || image.isEmpty) {
      return null;
    }

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }

    try {
      if (image.startsWith('gs://')) {
        return _storage.refFromURL(image).getDownloadURL();
      }

      return _storage.ref(image).getDownloadURL();
    } catch (_) {
      return image;
    }
  }

  String _readText(Map<String, dynamic> data, List<String> keys) {
    return _readOptionalText(data, keys) ?? '';
  }

  String? _readOptionalText(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value == null) {
        continue;
      }
      final text = value.toString().trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return null;
  }

  DateTime _readDate(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Object? _firstImageValue(Map<String, dynamic> data) {
    const keys = [
      'imagem',
      'imagemUrl',
      'imageUrl',
      'image',
      'foto',
      'fotoUrl',
      'urlImagem',
      'capa',
      'banner',
      'thumbnail',
      'thumb',
      'imagens',
      'images',
      'fotos',
    ];

    for (final key in keys) {
      final value = data[key];
      if (value != null) {
        return value;
      }
    }
    return null;
  }

  String? _extractImageString(Object? value) {
    if (value is String) {
      return value;
    }

    if (value is List && value.isNotEmpty) {
      return _extractImageString(value.first);
    }

    if (value is Map) {
      for (final key in const [
        'url',
        'downloadUrl',
        'imagem',
        'imagemUrl',
        'imageUrl',
        'path',
      ]) {
        final nested = value[key];
        final image = _extractImageString(nested);
        if (image != null && image.trim().isNotEmpty) {
          return image;
        }
      }
    }

    return null;
  }

  String? _cleanImageValue(String? value) {
    var image = value?.trim();
    if (image == null || image.isEmpty) {
      return null;
    }

    while (image != null &&
        image.length >= 2 &&
        ((image.startsWith('"') && image.endsWith('"')) ||
            (image.startsWith("'") && image.endsWith("'")))) {
      image = image.substring(1, image.length - 1).trim();
    }

    image = image
        ?.replaceAll(r'\"', '"')
        .replaceAll(r"\'", "'")
        .replaceAll('&amp;', '&')
        .trim();

    return image?.isEmpty == true ? null : image;
  }
}
