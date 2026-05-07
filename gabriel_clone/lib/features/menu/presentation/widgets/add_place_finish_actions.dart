part of '../menu_pages.dart';

extension _AddPlaceFinishActions on _AddPlacePageState {
  Future<void> _validateFace() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Permita acesso a camera para validar a face.'),
          action: status.isPermanentlyDenied
              ? SnackBarAction(
                  label: 'Abrir ajustes',
                  onPressed: openAppSettings,
                )
              : null,
        ),
      );
      return;
    }

    final selfie = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (selfie == null) {
      return;
    }

    setState(() => _isFaceValidated = true);
  }

  Future<void> _finishLink() async {
    final user = _auth.currentUser;
    final place = _place;
    final profile = _selectedProfile;

    if (user == null || place == null || profile == null) {
      return;
    }

    setState(() => _isBusy = true);
    try {
      final userDocument = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userDocument.exists) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'user-profile-not-found',
          message: 'Usuario nao encontrado no banco.',
        );
      }

      final placeData = place.data() ?? const <String, dynamic>{};
      final camera = Map<String, dynamic>.from(
        placeData['camera'] as Map? ?? _AddPlacePageState._demoCamera,
      );
      final linkData = {
        'userId': user.uid,
        'localidadeId': place.id,
        'localidadeNome': placeData['nome'] ?? 'CEP ${_cepController.text}',
        'perfil': profile,
        'status': 'ativo',
        'faceValidada': true,
        'camera': camera,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('localidades')
          .doc(place.id)
          .set(linkData, SetOptions(merge: true));
      await _firestore
          .collection('vinculos_localidades')
          .doc('${user.uid}_${place.id}')
          .set(linkData, SetOptions(merge: true));
      await _firestore.collection('users').doc(user.uid).set({
        'cameraAtrelada': camera,
        'perfilLocalidade': profile,
        'localidadeAtreladaId': place.id,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localidade e camera atreladas.')),
      );
      context.go(AppRoutes.imagens);
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
}
