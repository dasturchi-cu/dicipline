// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_profile_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlayerProfileEntityCollection on Isar {
  IsarCollection<PlayerProfileEntity> get playerProfileEntitys =>
      this.collection();
}

const PlayerProfileEntitySchema = CollectionSchema(
  name: r'PlayerProfileEntity',
  id: 2227409078297859035,
  properties: {
    r'avatarEmoji': PropertySchema(
      id: 0,
      name: r'avatarEmoji',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'disciplineXp': PropertySchema(
      id: 2,
      name: r'disciplineXp',
      type: IsarType.long,
    ),
    r'healthXp': PropertySchema(
      id: 3,
      name: r'healthXp',
      type: IsarType.long,
    ),
    r'knowledgeXp': PropertySchema(
      id: 4,
      name: r'knowledgeXp',
      type: IsarType.long,
    ),
    r'lastXpEarnedAt': PropertySchema(
      id: 5,
      name: r'lastXpEarnedAt',
      type: IsarType.dateTime,
    ),
    r'level': PropertySchema(
      id: 6,
      name: r'level',
      type: IsarType.long,
    ),
    r'socialXp': PropertySchema(
      id: 7,
      name: r'socialXp',
      type: IsarType.long,
    ),
    r'spiritualXp': PropertySchema(
      id: 8,
      name: r'spiritualXp',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    ),
    r'totalXp': PropertySchema(
      id: 10,
      name: r'totalXp',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'wealthXp': PropertySchema(
      id: 12,
      name: r'wealthXp',
      type: IsarType.long,
    )
  },
  estimateSize: _playerProfileEntityEstimateSize,
  serialize: _playerProfileEntitySerialize,
  deserialize: _playerProfileEntityDeserialize,
  deserializeProp: _playerProfileEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _playerProfileEntityGetId,
  getLinks: _playerProfileEntityGetLinks,
  attach: _playerProfileEntityAttach,
  version: '3.1.0+1',
);

int _playerProfileEntityEstimateSize(
  PlayerProfileEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.avatarEmoji.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _playerProfileEntitySerialize(
  PlayerProfileEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.avatarEmoji);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.disciplineXp);
  writer.writeLong(offsets[3], object.healthXp);
  writer.writeLong(offsets[4], object.knowledgeXp);
  writer.writeDateTime(offsets[5], object.lastXpEarnedAt);
  writer.writeLong(offsets[6], object.level);
  writer.writeLong(offsets[7], object.socialXp);
  writer.writeLong(offsets[8], object.spiritualXp);
  writer.writeString(offsets[9], object.title);
  writer.writeLong(offsets[10], object.totalXp);
  writer.writeDateTime(offsets[11], object.updatedAt);
  writer.writeLong(offsets[12], object.wealthXp);
}

PlayerProfileEntity _playerProfileEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlayerProfileEntity();
  object.avatarEmoji = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.disciplineXp = reader.readLong(offsets[2]);
  object.healthXp = reader.readLong(offsets[3]);
  object.id = id;
  object.knowledgeXp = reader.readLong(offsets[4]);
  object.lastXpEarnedAt = reader.readDateTimeOrNull(offsets[5]);
  object.level = reader.readLong(offsets[6]);
  object.socialXp = reader.readLong(offsets[7]);
  object.spiritualXp = reader.readLong(offsets[8]);
  object.title = reader.readString(offsets[9]);
  object.totalXp = reader.readLong(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  object.wealthXp = reader.readLong(offsets[12]);
  return object;
}

P _playerProfileEntityDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playerProfileEntityGetId(PlayerProfileEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playerProfileEntityGetLinks(
    PlayerProfileEntity object) {
  return [];
}

void _playerProfileEntityAttach(
    IsarCollection<dynamic> col, Id id, PlayerProfileEntity object) {
  object.id = id;
}

extension PlayerProfileEntityQueryWhereSort
    on QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QWhere> {
  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlayerProfileEntityQueryWhere
    on QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QWhereClause> {
  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterWhereClause>
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterWhereClause>
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
}

extension PlayerProfileEntityQueryFilter on QueryBuilder<PlayerProfileEntity,
    PlayerProfileEntity, QFilterCondition> {
  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      avatarEmojiEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      avatarEmojiGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avatarEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      avatarEmojiLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avatarEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      avatarEmojiBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avatarEmoji',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      avatarEmojiStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'avatarEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      avatarEmojiEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'avatarEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      avatarEmojiContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'avatarEmoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      avatarEmojiMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'avatarEmoji',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      avatarEmojiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarEmoji',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      avatarEmojiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'avatarEmoji',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      disciplineXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'disciplineXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      disciplineXpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'disciplineXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      disciplineXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'disciplineXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      disciplineXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'disciplineXp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      healthXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'healthXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      healthXpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'healthXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      healthXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'healthXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      healthXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'healthXp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      knowledgeXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'knowledgeXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      knowledgeXpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'knowledgeXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      knowledgeXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'knowledgeXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      knowledgeXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'knowledgeXp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      lastXpEarnedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastXpEarnedAt',
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      lastXpEarnedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastXpEarnedAt',
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      lastXpEarnedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastXpEarnedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      lastXpEarnedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastXpEarnedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      lastXpEarnedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastXpEarnedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      lastXpEarnedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastXpEarnedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      levelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      levelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      levelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      socialXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'socialXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      socialXpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'socialXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      socialXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'socialXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      socialXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'socialXp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      spiritualXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spiritualXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      spiritualXpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'spiritualXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      spiritualXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'spiritualXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      spiritualXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'spiritualXp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      titleEqualTo(
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      titleGreaterThan(
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      titleLessThan(
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      titleBetween(
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      titleStartsWith(
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      titleEndsWith(
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      totalXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      totalXpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      totalXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      totalXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalXp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      wealthXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wealthXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      wealthXpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wealthXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      wealthXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wealthXp',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterFilterCondition>
      wealthXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wealthXp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlayerProfileEntityQueryObject on QueryBuilder<PlayerProfileEntity,
    PlayerProfileEntity, QFilterCondition> {}

extension PlayerProfileEntityQueryLinks on QueryBuilder<PlayerProfileEntity,
    PlayerProfileEntity, QFilterCondition> {}

extension PlayerProfileEntityQuerySortBy
    on QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QSortBy> {
  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByAvatarEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarEmoji', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByAvatarEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarEmoji', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByDisciplineXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disciplineXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByDisciplineXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disciplineXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByHealthXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByHealthXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByKnowledgeXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knowledgeXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByKnowledgeXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knowledgeXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByLastXpEarnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastXpEarnedAt', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByLastXpEarnedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastXpEarnedAt', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortBySocialXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortBySocialXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortBySpiritualXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spiritualXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortBySpiritualXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spiritualXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByTotalXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByTotalXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByWealthXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wealthXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      sortByWealthXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wealthXp', Sort.desc);
    });
  }
}

extension PlayerProfileEntityQuerySortThenBy
    on QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QSortThenBy> {
  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByAvatarEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarEmoji', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByAvatarEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarEmoji', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByDisciplineXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disciplineXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByDisciplineXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disciplineXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByHealthXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByHealthXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByKnowledgeXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knowledgeXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByKnowledgeXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knowledgeXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByLastXpEarnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastXpEarnedAt', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByLastXpEarnedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastXpEarnedAt', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenBySocialXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenBySocialXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenBySpiritualXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spiritualXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenBySpiritualXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spiritualXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByTotalXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByTotalXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByWealthXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wealthXp', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QAfterSortBy>
      thenByWealthXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wealthXp', Sort.desc);
    });
  }
}

extension PlayerProfileEntityQueryWhereDistinct
    on QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct> {
  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByAvatarEmoji({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatarEmoji', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByDisciplineXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'disciplineXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByHealthXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'healthXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByKnowledgeXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'knowledgeXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByLastXpEarnedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastXpEarnedAt');
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctBySocialXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'socialXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctBySpiritualXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'spiritualXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByTotalXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QDistinct>
      distinctByWealthXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wealthXp');
    });
  }
}

extension PlayerProfileEntityQueryProperty
    on QueryBuilder<PlayerProfileEntity, PlayerProfileEntity, QQueryProperty> {
  QueryBuilder<PlayerProfileEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlayerProfileEntity, String, QQueryOperations>
      avatarEmojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatarEmoji');
    });
  }

  QueryBuilder<PlayerProfileEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PlayerProfileEntity, int, QQueryOperations>
      disciplineXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'disciplineXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, int, QQueryOperations> healthXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'healthXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, int, QQueryOperations>
      knowledgeXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'knowledgeXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, DateTime?, QQueryOperations>
      lastXpEarnedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastXpEarnedAt');
    });
  }

  QueryBuilder<PlayerProfileEntity, int, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<PlayerProfileEntity, int, QQueryOperations> socialXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'socialXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, int, QQueryOperations>
      spiritualXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'spiritualXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<PlayerProfileEntity, int, QQueryOperations> totalXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalXp');
    });
  }

  QueryBuilder<PlayerProfileEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<PlayerProfileEntity, int, QQueryOperations> wealthXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wealthXp');
    });
  }
}
