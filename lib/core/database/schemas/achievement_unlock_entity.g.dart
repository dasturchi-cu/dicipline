// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_unlock_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAchievementUnlockEntityCollection on Isar {
  IsarCollection<AchievementUnlockEntity> get achievementUnlockEntitys =>
      this.collection();
}

const AchievementUnlockEntitySchema = CollectionSchema(
  name: r'AchievementUnlockEntity',
  id: 1492716085813283170,
  properties: {
    r'achievementId': PropertySchema(
      id: 0,
      name: r'achievementId',
      type: IsarType.string,
    ),
    r'celebrated': PropertySchema(
      id: 1,
      name: r'celebrated',
      type: IsarType.bool,
    ),
    r'unlockedAt': PropertySchema(
      id: 2,
      name: r'unlockedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _achievementUnlockEntityEstimateSize,
  serialize: _achievementUnlockEntitySerialize,
  deserialize: _achievementUnlockEntityDeserialize,
  deserializeProp: _achievementUnlockEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'achievementId': IndexSchema(
      id: 547487615361511857,
      name: r'achievementId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'achievementId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _achievementUnlockEntityGetId,
  getLinks: _achievementUnlockEntityGetLinks,
  attach: _achievementUnlockEntityAttach,
  version: '3.1.0+1',
);

int _achievementUnlockEntityEstimateSize(
  AchievementUnlockEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.achievementId.length * 3;
  return bytesCount;
}

void _achievementUnlockEntitySerialize(
  AchievementUnlockEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.achievementId);
  writer.writeBool(offsets[1], object.celebrated);
  writer.writeDateTime(offsets[2], object.unlockedAt);
}

AchievementUnlockEntity _achievementUnlockEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AchievementUnlockEntity();
  object.achievementId = reader.readString(offsets[0]);
  object.celebrated = reader.readBool(offsets[1]);
  object.id = id;
  object.unlockedAt = reader.readDateTime(offsets[2]);
  return object;
}

P _achievementUnlockEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _achievementUnlockEntityGetId(AchievementUnlockEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _achievementUnlockEntityGetLinks(
    AchievementUnlockEntity object) {
  return [];
}

void _achievementUnlockEntityAttach(
    IsarCollection<dynamic> col, Id id, AchievementUnlockEntity object) {
  object.id = id;
}

extension AchievementUnlockEntityByIndex
    on IsarCollection<AchievementUnlockEntity> {
  Future<AchievementUnlockEntity?> getByAchievementId(String achievementId) {
    return getByIndex(r'achievementId', [achievementId]);
  }

  AchievementUnlockEntity? getByAchievementIdSync(String achievementId) {
    return getByIndexSync(r'achievementId', [achievementId]);
  }

  Future<bool> deleteByAchievementId(String achievementId) {
    return deleteByIndex(r'achievementId', [achievementId]);
  }

  bool deleteByAchievementIdSync(String achievementId) {
    return deleteByIndexSync(r'achievementId', [achievementId]);
  }

  Future<List<AchievementUnlockEntity?>> getAllByAchievementId(
      List<String> achievementIdValues) {
    final values = achievementIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'achievementId', values);
  }

  List<AchievementUnlockEntity?> getAllByAchievementIdSync(
      List<String> achievementIdValues) {
    final values = achievementIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'achievementId', values);
  }

  Future<int> deleteAllByAchievementId(List<String> achievementIdValues) {
    final values = achievementIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'achievementId', values);
  }

  int deleteAllByAchievementIdSync(List<String> achievementIdValues) {
    final values = achievementIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'achievementId', values);
  }

  Future<Id> putByAchievementId(AchievementUnlockEntity object) {
    return putByIndex(r'achievementId', object);
  }

  Id putByAchievementIdSync(AchievementUnlockEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'achievementId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAchievementId(
      List<AchievementUnlockEntity> objects) {
    return putAllByIndex(r'achievementId', objects);
  }

  List<Id> putAllByAchievementIdSync(List<AchievementUnlockEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'achievementId', objects, saveLinks: saveLinks);
  }
}

extension AchievementUnlockEntityQueryWhereSort
    on QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QWhere> {
  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AchievementUnlockEntityQueryWhere on QueryBuilder<
    AchievementUnlockEntity, AchievementUnlockEntity, QWhereClause> {
  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterWhereClause> achievementIdEqualTo(String achievementId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'achievementId',
        value: [achievementId],
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterWhereClause> achievementIdNotEqualTo(String achievementId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'achievementId',
              lower: [],
              upper: [achievementId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'achievementId',
              lower: [achievementId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'achievementId',
              lower: [achievementId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'achievementId',
              lower: [],
              upper: [achievementId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AchievementUnlockEntityQueryFilter on QueryBuilder<
    AchievementUnlockEntity, AchievementUnlockEntity, QFilterCondition> {
  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> achievementIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'achievementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> achievementIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'achievementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> achievementIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'achievementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> achievementIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'achievementId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> achievementIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'achievementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> achievementIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'achievementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
          QAfterFilterCondition>
      achievementIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'achievementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
          QAfterFilterCondition>
      achievementIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'achievementId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> achievementIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'achievementId',
        value: '',
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> achievementIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'achievementId',
        value: '',
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> celebratedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'celebrated',
        value: value,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> unlockedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unlockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> unlockedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unlockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> unlockedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unlockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity,
      QAfterFilterCondition> unlockedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unlockedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AchievementUnlockEntityQueryObject on QueryBuilder<
    AchievementUnlockEntity, AchievementUnlockEntity, QFilterCondition> {}

extension AchievementUnlockEntityQueryLinks on QueryBuilder<
    AchievementUnlockEntity, AchievementUnlockEntity, QFilterCondition> {}

extension AchievementUnlockEntityQuerySortBy
    on QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QSortBy> {
  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      sortByAchievementId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementId', Sort.asc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      sortByAchievementIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementId', Sort.desc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      sortByCelebrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'celebrated', Sort.asc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      sortByCelebratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'celebrated', Sort.desc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      sortByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      sortByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension AchievementUnlockEntityQuerySortThenBy on QueryBuilder<
    AchievementUnlockEntity, AchievementUnlockEntity, QSortThenBy> {
  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      thenByAchievementId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementId', Sort.asc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      thenByAchievementIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementId', Sort.desc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      thenByCelebrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'celebrated', Sort.asc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      thenByCelebratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'celebrated', Sort.desc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      thenByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QAfterSortBy>
      thenByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension AchievementUnlockEntityQueryWhereDistinct on QueryBuilder<
    AchievementUnlockEntity, AchievementUnlockEntity, QDistinct> {
  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QDistinct>
      distinctByAchievementId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'achievementId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QDistinct>
      distinctByCelebrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'celebrated');
    });
  }

  QueryBuilder<AchievementUnlockEntity, AchievementUnlockEntity, QDistinct>
      distinctByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockedAt');
    });
  }
}

extension AchievementUnlockEntityQueryProperty on QueryBuilder<
    AchievementUnlockEntity, AchievementUnlockEntity, QQueryProperty> {
  QueryBuilder<AchievementUnlockEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AchievementUnlockEntity, String, QQueryOperations>
      achievementIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'achievementId');
    });
  }

  QueryBuilder<AchievementUnlockEntity, bool, QQueryOperations>
      celebratedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'celebrated');
    });
  }

  QueryBuilder<AchievementUnlockEntity, DateTime, QQueryOperations>
      unlockedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedAt');
    });
  }
}
