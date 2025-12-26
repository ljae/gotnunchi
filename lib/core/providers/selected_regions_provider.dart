import 'package:flutter_riverpod/flutter_riverpod.dart';

// Global state for selected region IDs
class SelectedRegionsNotifier extends StateNotifier<Set<String>> {
  SelectedRegionsNotifier() : super({'KR-11'}); // Default: Seoul

  void toggleRegion(String regionId) {
    if (state.contains(regionId)) {
      if (state.length > 1) {
        // Don't allow removing the last region
        state = {...state}..remove(regionId);
      }
    } else {
      state = {...state, regionId};
    }
  }

  void setRegions(Set<String> regions) {
    if (regions.isNotEmpty) {
      state = regions;
    }
  }

  void clearAndSet(String regionId) {
    state = {regionId};
  }
}

final selectedRegionsProvider =
    StateNotifierProvider<SelectedRegionsNotifier, Set<String>>((ref) {
  return SelectedRegionsNotifier();
});
