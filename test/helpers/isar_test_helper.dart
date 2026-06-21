import 'dart:async';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:rejabon_ai/core/database/isar_service.dart';

class TestIsarHandle {
  TestIsarHandle(this.isar, this.directory);

  final Isar isar;
  final Directory directory;
}

Completer<void>? _isarCoreInit;

Future<void> ensureIsarCoreInitialized() async {
  if (_isarCoreInit != null) {
    return _isarCoreInit!.future;
  }
  _isarCoreInit = Completer<void>();
  try {
    await Isar.initializeIsarCore(download: true);
    _isarCoreInit!.complete();
  } catch (error, stackTrace) {
    _isarCoreInit!.completeError(error, stackTrace);
    _isarCoreInit = null;
    rethrow;
  }
}

Future<TestIsarHandle> openTestIsar() async {
  await ensureIsarCoreInitialized();
  final directory = await Directory.systemTemp.createTemp('rejabon_isar_test_');
  final isar = await Isar.open(
    IsarService.schemas,
    directory: directory.path,
    name: 'test_${DateTime.now().microsecondsSinceEpoch}',
  );
  return TestIsarHandle(isar, directory);
}

Future<void> closeTestIsar(TestIsarHandle? handle) async {
  if (handle == null) return;
  if (handle.isar.isOpen) {
    await handle.isar.close(deleteFromDisk: true);
  }
  if (handle.directory.existsSync()) {
    await handle.directory.delete(recursive: true);
  }
}
