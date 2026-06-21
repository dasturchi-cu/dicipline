// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twin_profile_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTwinProfileEntityCollection on Isar {
  IsarCollection<TwinProfileEntity> get twinProfileEntitys => this.collection();
}

const TwinProfileEntitySchema = CollectionSchema(
  name: r'TwinProfileEntity',
  id: -4398638543725474725,
  properties: {
    r'chronotype': PropertySchema(
      id: 0,
      name: r'chronotype',
      type: IsarType.string,
    ),
    r'goalOrientation': PropertySchema(
      id: 1,
      name: r'goalOrientation',
      type: IsarType.string,
    ),
    r'habitConsistency': PropertySchema(
      id: 2,
      name: r'habitConsistency',
      type: IsarType.string,
    ),
    r'lifeScoreSnapshot': PropertySchema(
      id: 3,
      name: r'lifeScoreSnapshot',
      type: IsarType.long,
    ),
    r'moodTrend': PropertySchema(
      id: 4,
      name: r'moodTrend',
      type: IsarType.string,
    ),
    r'productivityStyle': PropertySchema(
      id: 5,
      name: r'productivityStyle',
      type: IsarType.string,
    ),
    r'traitsJson': PropertySchema(
      id: 6,
      name: r'traitsJson',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _twinProfileEntityEstimateSize,
  serialize: _twinProfileEntitySerialize,
  deserialize: _twinProfileEntityDeserialize,
  deserializeProp: _twinProfileEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _twinProfileEntityGetId,
  getLinks: _twinProfileEntityGetLinks,
  attach: _twinProfileEntityAttach,
  version: '3.1.0+1',
);

int _twinProfileEntityEstimateSize(
  TwinProfileEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chronotype.length * 3;
  bytesCount += 3 + object.goalOrientation.length * 3;
  bytesCount += 3 + object.habitConsistency.length * 3;
  bytesCount += 3 + object.moodTrend.length * 3;
  bytesCount += 3 + object.productivityStyle.length * 3;
  bytesCount += 3 + object.traitsJson.length * 3;
  return bytesCount;
}

void _twinProfileEntitySerialize(
  TwinProfileEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chronotype);
  writer.writeString(offsets[1], object.goalOrientation);
  writer.writeString(offsets[2], object.habitConsistency);
  writer.writeLong(offsets[3], object.lifeScoreSnapshot);
  writer.writeString(offsets[4], object.moodTrend);
  writer.writeString(offsets[5], object.productivityStyle);
  writer.writeString(offsets[6], object.traitsJson);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

TwinProfileEntity _twinProfileEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TwinProfileEntity();
  object.chronotype = reader.readString(offsets[0]);
  object.goalOrientation = reader.readString(offsets[1]);
  object.habitConsistency = reader.readString(offsets[2]);
  object.id = id;
  object.lifeScoreSnapshot = reader.readLong(offsets[3]);
  object.moodTrend = reader.readString(offsets[4]);
  object.productivityStyle = reader.readString(offsets[5]);
  object.traitsJson = reader.readString(offsets[6]);
  object.updatedAt = reader.readDateTime(offsets[7]);
  return object;
}

P _twinProfileEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _twinProfileEntityGetId(TwinProfileEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _twinProfileEntityGetLinks(
    TwinProfileEntity object) {
  return [];
}

void _twinProfileEntityAttach(
    IsarCollection<dynamic> col, Id id, TwinProfileEntity object) {
  object.id = id;
}

extension TwinProfileEntityQueryWhereSort
    on QueryBuilder<TwinProfileEntity, TwinProfileEntity, QWhere> {
  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhere>
      anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension TwinProfileEntityQueryWhere
    on QueryBuilder<TwinProfileEntity, TwinProfileEntity, QWhereClause> {
  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhereClause>
      updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterWhereClause>
      updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TwinProfileEntityQueryFilter
    on QueryBuilder<TwinProfileEntity, TwinProfileEntity, QFilterCondition> {
  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      chronotypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      chronotypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      chronotypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      chronotypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chronotype',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      chronotypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      chronotypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      chronotypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      chronotypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chronotype',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      chronotypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chronotype',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      chronotypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chronotype',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      goalOrientationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalOrientation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      goalOrientationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalOrientation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      goalOrientationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalOrientation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      goalOrientationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalOrientation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      goalOrientationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'goalOrientation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      goalOrientationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'goalOrientation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      goalOrientationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'goalOrientation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      goalOrientationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'goalOrientation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      goalOrientationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalOrientation',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      goalOrientationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'goalOrientation',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      habitConsistencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitConsistency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      habitConsistencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'habitConsistency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      habitConsistencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'habitConsistency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      habitConsistencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'habitConsistency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      habitConsistencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'habitConsistency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      habitConsistencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'habitConsistency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      habitConsistencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'habitConsistency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      habitConsistencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'habitConsistency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      habitConsistencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitConsistency',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      habitConsistencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'habitConsistency',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      lifeScoreSnapshotEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lifeScoreSnapshot',
        value: value,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      lifeScoreSnapshotGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lifeScoreSnapshot',
        value: value,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      lifeScoreSnapshotLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lifeScoreSnapshot',
        value: value,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      lifeScoreSnapshotBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lifeScoreSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      moodTrendEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      moodTrendGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      moodTrendLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      moodTrendBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodTrend',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      moodTrendStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      moodTrendEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      moodTrendContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      moodTrendMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moodTrend',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      moodTrendIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodTrend',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      moodTrendIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moodTrend',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      productivityStyleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productivityStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      productivityStyleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productivityStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      productivityStyleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productivityStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      productivityStyleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productivityStyle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      productivityStyleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productivityStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      productivityStyleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productivityStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      productivityStyleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productivityStyle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      productivityStyleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productivityStyle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      productivityStyleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productivityStyle',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      productivityStyleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productivityStyle',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      traitsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'traitsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      traitsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'traitsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      traitsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'traitsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      traitsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'traitsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      traitsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'traitsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      traitsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'traitsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      traitsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'traitsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      traitsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'traitsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      traitsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'traitsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      traitsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'traitsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TwinProfileEntityQueryObject
    on QueryBuilder<TwinProfileEntity, TwinProfileEntity, QFilterCondition> {}

extension TwinProfileEntityQueryLinks
    on QueryBuilder<TwinProfileEntity, TwinProfileEntity, QFilterCondition> {}

extension TwinProfileEntityQuerySortBy
    on QueryBuilder<TwinProfileEntity, TwinProfileEntity, QSortBy> {
  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByChronotype() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chronotype', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByChronotypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chronotype', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByGoalOrientation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalOrientation', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByGoalOrientationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalOrientation', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByHabitConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitConsistency', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByHabitConsistencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitConsistency', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByLifeScoreSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lifeScoreSnapshot', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByLifeScoreSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lifeScoreSnapshot', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByMoodTrend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTrend', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByMoodTrendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTrend', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByProductivityStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityStyle', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByProductivityStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityStyle', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByTraitsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'traitsJson', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByTraitsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'traitsJson', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TwinProfileEntityQuerySortThenBy
    on QueryBuilder<TwinProfileEntity, TwinProfileEntity, QSortThenBy> {
  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByChronotype() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chronotype', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByChronotypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chronotype', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByGoalOrientation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalOrientation', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByGoalOrientationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalOrientation', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByHabitConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitConsistency', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByHabitConsistencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitConsistency', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByLifeScoreSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lifeScoreSnapshot', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByLifeScoreSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lifeScoreSnapshot', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByMoodTrend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTrend', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByMoodTrendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTrend', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByProductivityStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityStyle', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByProductivityStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityStyle', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByTraitsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'traitsJson', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByTraitsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'traitsJson', Sort.desc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TwinProfileEntityQueryWhereDistinct
    on QueryBuilder<TwinProfileEntity, TwinProfileEntity, QDistinct> {
  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QDistinct>
      distinctByChronotype({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chronotype', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QDistinct>
      distinctByGoalOrientation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalOrientation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QDistinct>
      distinctByHabitConsistency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitConsistency',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QDistinct>
      distinctByLifeScoreSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lifeScoreSnapshot');
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QDistinct>
      distinctByMoodTrend({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodTrend', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QDistinct>
      distinctByProductivityStyle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productivityStyle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QDistinct>
      distinctByTraitsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'traitsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwinProfileEntity, TwinProfileEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension TwinProfileEntityQueryProperty
    on QueryBuilder<TwinProfileEntity, TwinProfileEntity, QQueryProperty> {
  QueryBuilder<TwinProfileEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TwinProfileEntity, String, QQueryOperations>
      chronotypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chronotype');
    });
  }

  QueryBuilder<TwinProfileEntity, String, QQueryOperations>
      goalOrientationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalOrientation');
    });
  }

  QueryBuilder<TwinProfileEntity, String, QQueryOperations>
      habitConsistencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitConsistency');
    });
  }

  QueryBuilder<TwinProfileEntity, int, QQueryOperations>
      lifeScoreSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lifeScoreSnapshot');
    });
  }

  QueryBuilder<TwinProfileEntity, String, QQueryOperations>
      moodTrendProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodTrend');
    });
  }

  QueryBuilder<TwinProfileEntity, String, QQueryOperations>
      productivityStyleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productivityStyle');
    });
  }

  QueryBuilder<TwinProfileEntity, String, QQueryOperations>
      traitsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'traitsJson');
    });
  }

  QueryBuilder<TwinProfileEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
