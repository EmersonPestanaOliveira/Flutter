import 'package:flutter/widgets.dart';

import '../cubit/home_state.dart';

class HomePinReadiness {
  bool isMapReady = false;
  bool arePinsReady = false;
  bool didForceHomeReady = false;
  String? readyPinsKey;

  bool shouldShowLoading({
    required bool didLoadPreferences,
    required HomeState state,
    required HomeLoaded? loadedState,
    required String? pinsKey,
  }) {
    final areCurrentPinsReady = pinsKey != null &&
        ((readyPinsKey == pinsKey && arePinsReady) || didForceHomeReady);
    if (!didLoadPreferences || state is HomeInitial || state is HomeLoading) {
      return true;
    }
    if (loadedState == null) {
      return true;
    }
    final hasUsefulPins =
        loadedState.cameras.isNotEmpty || loadedState.alertas.isNotEmpty;
    return !hasUsefulPins && (!isMapReady || !areCurrentPinsReady);
  }

  void markMapReady() {
    isMapReady = true;
  }

  void markPinsReady(String pinsKey) {
    readyPinsKey = pinsKey;
    arePinsReady = true;
  }

  void markDirty() {
    arePinsReady = false;
    didForceHomeReady = false;
  }

  void scheduleFallback({
    required State state,
    required HomeLoaded? loadedState,
    required VoidCallback onReady,
  }) {
    if (loadedState == null || didForceHomeReady) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!state.mounted || didForceHomeReady || arePinsReady) {
        return;
      }

      Future<void>.delayed(const Duration(seconds: 4), () {
        if (!state.mounted || didForceHomeReady || arePinsReady) {
          return;
        }
        didForceHomeReady = true;
        onReady();
      });
    });
  }
}
