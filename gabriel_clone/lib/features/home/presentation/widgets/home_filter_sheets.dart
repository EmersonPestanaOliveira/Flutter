import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/entities/camera.dart';
import '../controllers/home_filter_state.dart';
import '../utils/home_date_utils.dart';
import 'alert_filters_sheet.dart';
import 'camera_filters_sheet.dart';

Future<CameraFilterResult?> showHomeCameraFilters({
  required BuildContext context,
  required List<Camera> cameras,
  required HomeFilterState filters,
}) {
  return showModalBottomSheet<CameraFilterResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutral0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return CameraFiltersSheet(
        cameras: cameras,
        selectedBairro: filters.selectedBairro,
        selectedCidade: filters.selectedCidade,
        selectedRegiao: filters.selectedRegiao,
      );
    },
  );
}

Future<AlertFilterResult?> showHomeAlertFilters({
  required BuildContext context,
  required List<Alerta> alertas,
  required HomeFilterState filters,
}) {
  return showModalBottomSheet<AlertFilterResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutral0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return AlertFiltersSheet(
        alertas: alertas,
        selectedBairro: filters.selectedAlertBairro,
        selectedCidade: filters.selectedAlertCidade,
        selectedDateKey: filters.selectedAlertDateKey,
        selectedTipo: filters.selectedAlertTipo,
        dateKeyBuilder: homeDateKey,
        dateLabelBuilder: formatHomeDate,
      );
    },
  );
}
