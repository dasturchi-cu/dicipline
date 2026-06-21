import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import 'app_error_state.dart';
import 'app_loading_state.dart';

/// Stream/Future provider holatlarini standart loading/error/data ko'rinishida chiqaradi.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => loading ?? const AppLoadingState(),
      error: (error, _) => AppErrorState(
        message: AppStrings.errorGeneric,
        onRetry: onRetry,
      ),
      data: data,
    );
  }
}
