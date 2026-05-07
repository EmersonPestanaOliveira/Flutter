part of '../menu_pages.dart';

extension _AddPlaceFindActions on _AddPlacePageState {
  bool get _canFinish =>
      !_isBusy &&
      _place != null &&
      _selectedProfile != null &&
      _isFaceValidated;

  Future<void> _findPlace() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isBusy = true);
    try {
      final cep = _cepController.text.replaceAll(RegExp(r'\D'), '');
      final numero = _numberController.text.trim();
      final query = await _firestore
          .collection('localidades')
          .where('cep', isEqualTo: cep)
          .where('numero', isEqualTo: numero)
          .limit(1)
          .get();

      DocumentSnapshot<Map<String, dynamic>>? place = query.docs.isEmpty
          ? null
          : query.docs.first;
      place ??= await _maybeCreateDemoPlace(cep);

      if (!mounted) {
        return;
      }

      if (place == null) {
        await _firestore.collection('solicitacoes_localidade').add({
          'cep': cep,
          'numero': numero,
          'userId': _auth.currentUser?.uid,
          'status': 'pendente',
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Localidade enviada para cadastro e validacao.'),
          ),
        );
        return;
      }

      setState(() {
        _place = place;
        _selectedProfile = null;
        _isFaceValidated = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_placeFlowErrorMessage(error))));
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _maybeCreateDemoPlace(
    String cep,
  ) async {
    const demoCeps = ['00000000', '01310100', '20040020'];
    if (!demoCeps.contains(cep)) {
      return null;
    }

    final reference = _firestore
        .collection('localidades')
        .doc(_AddPlacePageState._demoPlaceId);
    await reference.set({
      'nome': 'Localidade publica de demonstracao',
      'cep': cep,
      'numero': _numberController.text.trim(),
      'status': 'ativo',
      'camera': _AddPlacePageState._demoCamera,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return reference.get();
  }
}
