// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_challenge_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFriendChallengeEntityCollection on Isar {
  IsarCollection<FriendChallengeEntity> get friendChallengeEntitys =>
      this.collection();
}

const FriendChallengeEntitySchema = CollectionSchema(
  name: r'FriendChallengeEntity',
  id: 804678443392683606,
  properties: {
    r'emoji': PropertySchema(
      id: 0,
      name: r'emoji',
      type: IsarType.string,
    ),
    r'endsAt': PropertySchema(
      id: 1,
      name: r'endsAt',
      type: IsarType.dateTime,
    ),
    r'myProgress': PropertySchema(
      id: 2,
      name: r'myProgress',
      type: IsarType.double,
    ),
    r'myScore': PropertySchema(
      id: 3,
      name: r'myScore',
      type: IsarType.long,
    ),
    r'partnerName': PropertySchema(
      id: 4,
      name: r'partnerName',
      type: IsarType.string,
    ),
    r'partnerProgress': PropertySchema(
      id: 5,
      name: r'partnerProgress',
      type: IsarType.double,
    ),
    r'partnerScore': PropertySchema(
      id: 6,
      name: r'partnerScore',
      type: IsarType.long,
    ),
    r'partnershipId': PropertySchema(
      id: 7,
      name: r'partnershipId',
      type: IsarType.long,
    ),
    r'startedAt': PropertySchema(
      id: 8,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 9,
      name: r'status',
      type: IsarType.string,
    ),
    r'targetScore': PropertySchema(
      id: 10,
      name: r'targetScore',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 11,
      name: r'title',
      type: IsarType.string,
    ),
    r'typeId': PropertySchema(
      id: 12,
      name: r'typeId',
      type: IsarType.string,
    ),
    r'winnerLabel': PropertySchema(
      id: 13,
      name: r'winnerLabel',
      type: IsarType.string,
    )
  },
  estimateSize: _friendChallengeEntityEstimateSize,
  serialize: _friendChallengeEntitySerialize,
  deserialize: _friendChallengeEntityDeserialize,
  deserializeProp: _friendChallengeEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'typeId': IndexSchema(
      id: 5741258893451994948,
      name: r'typeId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'typeId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _friendChallengeEntityGetId,
  getLinks: _friendChallengeEntityGetLinks,
  attach: _friendChallengeEntityAttach,
  version: '3.1.0+1',
);

int _friendChallengeEntityEstimateSize(
  FriendChallengeEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.emoji.length * 3;
  bytesCount += 3 + object.partnerName.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.typeId.length * 3;
  {
    final value = object.winnerLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _friendChallengeEntitySerialize(
  FriendChallengeEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.emoji);
  writer.writeDateTime(offsets[1], object.endsAt);
  writer.writeDouble(offsets[2], object.myProgress);
  writer.writeLong(offsets[3], object.myScore);
  writer.writeString(offsets[4], object.partnerName);
  writer.writeDouble(offsets[5], object.partnerProgress);
  writer.writeLong(offsets[6], object.partnerScore);
  writer.writeLong(offsets[7], object.partnershipId);
  writer.writeDateTime(offsets[8], object.startedAt);
  writer.writeString(offsets[9], object.status);
  writer.writeLong(offsets[10], object.targetScore);
  writer.writeString(offsets[11], object.title);
  writer.writeString(offsets[12], object.typeId);
  writer.writeString(offsets[13], object.winnerLabel);
}

FriendChallengeEntity _friendChallengeEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FriendChallengeEntity();
  object.emoji = reader.readString(offsets[0]);
  object.endsAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.myScore = reader.readLong(offsets[3]);
  object.partnerName = reader.readString(offsets[4]);
  object.partnerScore = reader.readLong(offsets[6]);
  object.partnershipId = reader.readLong(offsets[7]);
  object.startedAt = reader.readDateTime(offsets[8]);
  object.status = reader.readString(offsets[9]);
  object.targetScore = reader.readLong(offsets[10]);
  object.title = reader.readString(offsets[11]);
  object.typeId = reader.readString(offsets[12]);
  object.winnerLabel = reader.readStringOrNull(offsets[13]);
  return object;
}

P _friendChallengeEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _friendChallengeEntityGetId(FriendChallengeEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _friendChallengeEntityGetLinks(
    FriendChallengeEntity object) {
  return [];
}

void _friendChallengeEntityAttach(
    IsarCollection<dynamic> col, Id id, FriendChallengeEntity object) {
  object.id = id;
}

extension FriendChallengeEntityQueryWhereSort
    on QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QWhere> {
  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FriendChallengeEntityQueryWhere on QueryBuilder<FriendChallengeEntity,
    FriendChallengeEntity, QWhereClause> {
  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterWhereClause>
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

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterWhereClause>
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

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterWhereClause>
      typeIdEqualTo(String typeId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'typeId',
        value: [typeId],
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterWhereClause>
      typeIdNotEqualTo(String typeId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'typeId',
              lower: [],
              upper: [typeId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'typeId',
              lower: [typeId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'typeId',
              lower: [typeId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'typeId',
              lower: [],
              upper: [typeId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterWhereClause>
      statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterWhereClause>
      statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FriendChallengeEntityQueryFilter on QueryBuilder<
    FriendChallengeEntity, FriendChallengeEntity, QFilterCondition> {
  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> emojiEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> emojiGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> emojiLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> emojiBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emoji',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> emojiStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> emojiEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      emojiContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      emojiMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emoji',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> emojiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emoji',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> emojiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emoji',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> endsAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endsAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> endsAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endsAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> endsAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endsAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> endsAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endsAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
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

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
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

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
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

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> myProgressEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'myProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> myProgressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'myProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> myProgressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'myProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> myProgressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'myProgress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> myScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'myScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> myScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'myScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> myScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'myScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> myScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'myScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partnerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      partnerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      partnerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partnerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerProgressEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerProgressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partnerProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerProgressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partnerProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerProgressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partnerProgress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partnerScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partnerScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnerScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partnerScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnershipIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnershipId',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnershipIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partnershipId',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnershipIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partnershipId',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> partnershipIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partnershipId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> startedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> startedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> startedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> targetScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> targetScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> targetScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> targetScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> typeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> typeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> typeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> typeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> typeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> typeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      typeIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      typeIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> typeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeId',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> typeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeId',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> winnerLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'winnerLabel',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> winnerLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'winnerLabel',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> winnerLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'winnerLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> winnerLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'winnerLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> winnerLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'winnerLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> winnerLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'winnerLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> winnerLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'winnerLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> winnerLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'winnerLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      winnerLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'winnerLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
          QAfterFilterCondition>
      winnerLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'winnerLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> winnerLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'winnerLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity,
      QAfterFilterCondition> winnerLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'winnerLabel',
        value: '',
      ));
    });
  }
}

extension FriendChallengeEntityQueryObject on QueryBuilder<
    FriendChallengeEntity, FriendChallengeEntity, QFilterCondition> {}

extension FriendChallengeEntityQueryLinks on QueryBuilder<FriendChallengeEntity,
    FriendChallengeEntity, QFilterCondition> {}

extension FriendChallengeEntityQuerySortBy
    on QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QSortBy> {
  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByEndsAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endsAt', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByEndsAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endsAt', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByMyProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myProgress', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByMyProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myProgress', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByMyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myScore', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByMyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myScore', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByPartnerProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerProgress', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByPartnerProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerProgress', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByPartnerScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerScore', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByPartnerScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerScore', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByPartnershipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnershipId', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByPartnershipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnershipId', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByTargetScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetScore', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByTargetScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetScore', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByWinnerLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winnerLabel', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      sortByWinnerLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winnerLabel', Sort.desc);
    });
  }
}

extension FriendChallengeEntityQuerySortThenBy
    on QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QSortThenBy> {
  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByEndsAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endsAt', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByEndsAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endsAt', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByMyProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myProgress', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByMyProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myProgress', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByMyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myScore', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByMyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myScore', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByPartnerProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerProgress', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByPartnerProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerProgress', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByPartnerScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerScore', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByPartnerScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerScore', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByPartnershipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnershipId', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByPartnershipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnershipId', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByTargetScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetScore', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByTargetScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetScore', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.desc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByWinnerLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winnerLabel', Sort.asc);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QAfterSortBy>
      thenByWinnerLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winnerLabel', Sort.desc);
    });
  }
}

extension FriendChallengeEntityQueryWhereDistinct
    on QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct> {
  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByEmoji({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emoji', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByEndsAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endsAt');
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByMyProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'myProgress');
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByMyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'myScore');
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByPartnerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByPartnerProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerProgress');
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByPartnerScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerScore');
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByPartnershipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnershipId');
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByTargetScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetScore');
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByTypeId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FriendChallengeEntity, FriendChallengeEntity, QDistinct>
      distinctByWinnerLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'winnerLabel', caseSensitive: caseSensitive);
    });
  }
}

extension FriendChallengeEntityQueryProperty on QueryBuilder<
    FriendChallengeEntity, FriendChallengeEntity, QQueryProperty> {
  QueryBuilder<FriendChallengeEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FriendChallengeEntity, String, QQueryOperations>
      emojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emoji');
    });
  }

  QueryBuilder<FriendChallengeEntity, DateTime, QQueryOperations>
      endsAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endsAt');
    });
  }

  QueryBuilder<FriendChallengeEntity, double, QQueryOperations>
      myProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'myProgress');
    });
  }

  QueryBuilder<FriendChallengeEntity, int, QQueryOperations> myScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'myScore');
    });
  }

  QueryBuilder<FriendChallengeEntity, String, QQueryOperations>
      partnerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerName');
    });
  }

  QueryBuilder<FriendChallengeEntity, double, QQueryOperations>
      partnerProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerProgress');
    });
  }

  QueryBuilder<FriendChallengeEntity, int, QQueryOperations>
      partnerScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerScore');
    });
  }

  QueryBuilder<FriendChallengeEntity, int, QQueryOperations>
      partnershipIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnershipId');
    });
  }

  QueryBuilder<FriendChallengeEntity, DateTime, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<FriendChallengeEntity, String, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<FriendChallengeEntity, int, QQueryOperations>
      targetScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetScore');
    });
  }

  QueryBuilder<FriendChallengeEntity, String, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<FriendChallengeEntity, String, QQueryOperations>
      typeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeId');
    });
  }

  QueryBuilder<FriendChallengeEntity, String?, QQueryOperations>
      winnerLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'winnerLabel');
    });
  }
}
