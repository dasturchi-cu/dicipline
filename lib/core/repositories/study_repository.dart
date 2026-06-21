import 'dart:math' as math;

import 'package:isar/isar.dart';

import '../database/schemas/study_session_entity.dart';
import '../database/schemas/study_subject_entity.dart';

class StudyProgress {
  const StudyProgress({
    required this.subjectId,
    required this.subjectName,
    required this.totalMinutes,
    required this.targetMinutes,
    required this.progressPercent,
  });

  final int subjectId;
  final String subjectName;
  final int totalMinutes;
  final int targetMinutes;
  final double progressPercent;
}

class StudyRepository {
  StudyRepository(this._isar);

  final Isar _isar;

  Stream<List<StudySubjectEntity>> watchAllSubjects() {
    return _isar.studySubjectEntitys
        .where()
        .watch(fireImmediately: true);
  }

  Stream<List<StudySessionEntity>> watchAllSessions() {
    return _isar.studySessionEntitys
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<StudySessionEntity>> watchSessionsBySubject(int subjectId) {
    return _isar.studySessionEntitys
        .filter()
        .subjectIdEqualTo(subjectId)
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  Future<StudySubjectEntity?> getSubjectById(int id) {
    return _isar.studySubjectEntitys.get(id);
  }

  Future<StudySessionEntity?> getSessionById(int id) {
    return _isar.studySessionEntitys.get(id);
  }

  Future<List<StudySubjectEntity>> getAllSubjects() {
    return _isar.studySubjectEntitys.where().findAll();
  }

  Future<List<StudySessionEntity>> getAllSessions() {
    return _isar.studySessionEntitys.where().sortByDateDesc().findAll();
  }

  Future<StudyProgress?> getProgress(int subjectId) async {
    final subject = await getSubjectById(subjectId);
    if (subject == null) return null;

    final sessions = await _isar.studySessionEntitys
        .filter()
        .subjectIdEqualTo(subjectId)
        .findAll();
    final sessionMinutes =
        sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);
    final totalMinutes = subject.totalMinutes + sessionMinutes;
    final target = subject.targetMinutes;
    final progressPercent =
        target <= 0 ? 0.0 : (totalMinutes / target * 100).clamp(0, 100);

    return StudyProgress(
      subjectId: subject.id,
      subjectName: subject.name,
      totalMinutes: totalMinutes,
      targetMinutes: target,
      progressPercent: progressPercent.toDouble(),
    );
  }

  Future<List<StudyProgress>> getAllProgress() async {
    final subjects = await getAllSubjects();
    final results = <StudyProgress>[];
    for (final subject in subjects) {
      final progress = await getProgress(subject.id);
      if (progress != null) {
        results.add(progress);
      }
    }
    return results;
  }

  Future<StudySubjectEntity> saveSubject(StudySubjectEntity subject) async {
    await _isar.writeTxn(() async {
      await _isar.studySubjectEntitys.put(subject);
    });
    return subject;
  }

  Future<StudySessionEntity> addSession(StudySessionEntity session) async {
    await _isar.writeTxn(() async {
      await _isar.studySessionEntitys.put(session);
      final subject = await _isar.studySubjectEntitys.get(session.subjectId);
      if (subject != null) {
        subject.totalMinutes += session.durationMinutes;
        await _isar.studySubjectEntitys.put(subject);
      }
    });
    return session;
  }

  Future<StudySubjectEntity> createSubject({
    required String name,
    int color = 0xFF6366F1,
    int targetMinutes = 0,
  }) async {
    final subject = StudySubjectEntity.create(
      name: name,
      color: color,
      targetMinutes: targetMinutes,
    );
    await _isar.writeTxn(() async {
      await _isar.studySubjectEntitys.put(subject);
    });
    return subject;
  }

  Future<StudySubjectEntity> updateSubject(StudySubjectEntity subject) async {
    await _isar.writeTxn(() async {
      await _isar.studySubjectEntitys.put(subject);
    });
    return subject;
  }

  Future<bool> deleteSubject(int id) async {
    return _isar.writeTxn(() async {
      await _isar.studySessionEntitys
          .filter()
          .subjectIdEqualTo(id)
          .deleteAll();
      return _isar.studySubjectEntitys.delete(id);
    });
  }

  Future<StudySessionEntity> createSession({
    required int subjectId,
    required int durationMinutes,
    DateTime? date,
    String? notes,
  }) async {
    final session = StudySessionEntity.create(
      subjectId: subjectId,
      durationMinutes: durationMinutes,
      date: date,
      notes: notes,
    );
    await _isar.writeTxn(() async {
      await _isar.studySessionEntitys.put(session);
      final subject = await _isar.studySubjectEntitys.get(subjectId);
      if (subject != null) {
        subject.totalMinutes += durationMinutes;
        await _isar.studySubjectEntitys.put(subject);
      }
    });
    return session;
  }

  Future<StudySessionEntity> updateSession(StudySessionEntity session) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.studySessionEntitys.get(session.id);
      if (existing != null && existing.durationMinutes != session.durationMinutes) {
        final subject = await _isar.studySubjectEntitys.get(session.subjectId);
        if (subject != null) {
          subject.totalMinutes +=
              session.durationMinutes - existing.durationMinutes;
          await _isar.studySubjectEntitys.put(subject);
        }
      }
      await _isar.studySessionEntitys.put(session);
    });
    return session;
  }

  Future<bool> deleteSession(int id) async {
    return _isar.writeTxn(() async {
      final session = await _isar.studySessionEntitys.get(id);
      if (session != null) {
        final subject = await _isar.studySubjectEntitys.get(session.subjectId);
        if (subject != null) {
          subject.totalMinutes = math.max(
            0,
            subject.totalMinutes - session.durationMinutes,
          );
          await _isar.studySubjectEntitys.put(subject);
        }
      }
      return _isar.studySessionEntitys.delete(id);
    });
  }
}
