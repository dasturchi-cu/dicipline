// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_settings_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSocialSettingsEntityCollection on Isar {
  IsarCollection<SocialSettingsEntity> get socialSettingsEntitys =>
      this.collection();
}

const SocialSettingsEntitySchema = CollectionSchema(
  name: r'SocialSettingsEntity',
  id: 8925139207742844100,
  properties: {
    r'allowFriendChallenges': PropertySchema(
      id: 0,
      name: r'allowFriendChallenges',
      type: IsarType.bool,
    ),
    r'allowGroupInvites': PropertySchema(
      id: 1,
      name: r'allowGroupInvites',
      type: IsarType.bool,
    ),
    r'displayName': PropertySchema(
      id: 2,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'leaderboardUseAlias': PropertySchema(
      id: 3,
      name: r'leaderboardUseAlias',
      type: IsarType.bool,
    ),
    r'shareAchievements': PropertySchema(
      id: 4,
      name: r'shareAchievements',
      type: IsarType.bool,
    ),
    r'shareStreaks': PropertySchema(
      id: 5,
      name: r'shareStreaks',
      type: IsarType.bool,
    ),
    r'showOnLeaderboard': PropertySchema(
      id: 6,
      name: r'showOnLeaderboard',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _socialSettingsEntityEstimateSize,
  serialize: _socialSettingsEntitySerialize,
  deserialize: _socialSettingsEntityDeserialize,
  deserializeProp: _socialSettingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _socialSettingsEntityGetId,
  getLinks: _socialSettingsEntityGetLinks,
  attach: _socialSettingsEntityAttach,
  version: '3.1.0+1',
);

int _socialSettingsEntityEstimateSize(
  SocialSettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.displayName.length * 3;
  return bytesCount;
}

void _socialSettingsEntitySerialize(
  SocialSettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.allowFriendChallenges);
  writer.writeBool(offsets[1], object.allowGroupInvites);
  writer.writeString(offsets[2], object.displayName);
  writer.writeBool(offsets[3], object.leaderboardUseAlias);
  writer.writeBool(offsets[4], object.shareAchievements);
  writer.writeBool(offsets[5], object.shareStreaks);
  writer.writeBool(offsets[6], object.showOnLeaderboard);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

SocialSettingsEntity _socialSettingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SocialSettingsEntity();
  object.allowFriendChallenges = reader.readBool(offsets[0]);
  object.allowGroupInvites = reader.readBool(offsets[1]);
  object.displayName = reader.readString(offsets[2]);
  object.id = id;
  object.leaderboardUseAlias = reader.readBool(offsets[3]);
  object.shareAchievements = reader.readBool(offsets[4]);
  object.shareStreaks = reader.readBool(offsets[5]);
  object.showOnLeaderboard = reader.readBool(offsets[6]);
  object.updatedAt = reader.readDateTime(offsets[7]);
  return object;
}

P _socialSettingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _socialSettingsEntityGetId(SocialSettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _socialSettingsEntityGetLinks(
    SocialSettingsEntity object) {
  return [];
}

void _socialSettingsEntityAttach(
    IsarCollection<dynamic> col, Id id, SocialSettingsEntity object) {
  object.id = id;
}

extension SocialSettingsEntityQueryWhereSort
    on QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QWhere> {
  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SocialSettingsEntityQueryWhere
    on QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QWhereClause> {
  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterWhereClause>
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

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterWhereClause>
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

extension SocialSettingsEntityQueryFilter on QueryBuilder<SocialSettingsEntity,
    SocialSettingsEntity, QFilterCondition> {
  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> allowFriendChallengesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allowFriendChallenges',
        value: value,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> allowGroupInvitesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allowGroupInvites',
        value: value,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
          QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
          QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
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

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
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

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
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

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> leaderboardUseAliasEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leaderboardUseAlias',
        value: value,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> shareAchievementsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shareAchievements',
        value: value,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> shareStreaksEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shareStreaks',
        value: value,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> showOnLeaderboardEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showOnLeaderboard',
        value: value,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity,
      QAfterFilterCondition> updatedAtBetween(
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

extension SocialSettingsEntityQueryObject on QueryBuilder<SocialSettingsEntity,
    SocialSettingsEntity, QFilterCondition> {}

extension SocialSettingsEntityQueryLinks on QueryBuilder<SocialSettingsEntity,
    SocialSettingsEntity, QFilterCondition> {}

extension SocialSettingsEntityQuerySortBy
    on QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QSortBy> {
  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByAllowFriendChallenges() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowFriendChallenges', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByAllowFriendChallengesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowFriendChallenges', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByAllowGroupInvites() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowGroupInvites', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByAllowGroupInvitesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowGroupInvites', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByLeaderboardUseAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaderboardUseAlias', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByLeaderboardUseAliasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaderboardUseAlias', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByShareAchievements() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareAchievements', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByShareAchievementsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareAchievements', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByShareStreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareStreaks', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByShareStreaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareStreaks', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByShowOnLeaderboard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showOnLeaderboard', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByShowOnLeaderboardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showOnLeaderboard', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SocialSettingsEntityQuerySortThenBy
    on QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QSortThenBy> {
  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByAllowFriendChallenges() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowFriendChallenges', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByAllowFriendChallengesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowFriendChallenges', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByAllowGroupInvites() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowGroupInvites', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByAllowGroupInvitesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowGroupInvites', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByLeaderboardUseAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaderboardUseAlias', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByLeaderboardUseAliasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaderboardUseAlias', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByShareAchievements() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareAchievements', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByShareAchievementsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareAchievements', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByShareStreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareStreaks', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByShareStreaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareStreaks', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByShowOnLeaderboard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showOnLeaderboard', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByShowOnLeaderboardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showOnLeaderboard', Sort.desc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SocialSettingsEntityQueryWhereDistinct
    on QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QDistinct> {
  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QDistinct>
      distinctByAllowFriendChallenges() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allowFriendChallenges');
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QDistinct>
      distinctByAllowGroupInvites() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allowGroupInvites');
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QDistinct>
      distinctByLeaderboardUseAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leaderboardUseAlias');
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QDistinct>
      distinctByShareAchievements() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shareAchievements');
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QDistinct>
      distinctByShareStreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shareStreaks');
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QDistinct>
      distinctByShowOnLeaderboard() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showOnLeaderboard');
    });
  }

  QueryBuilder<SocialSettingsEntity, SocialSettingsEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SocialSettingsEntityQueryProperty on QueryBuilder<
    SocialSettingsEntity, SocialSettingsEntity, QQueryProperty> {
  QueryBuilder<SocialSettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SocialSettingsEntity, bool, QQueryOperations>
      allowFriendChallengesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allowFriendChallenges');
    });
  }

  QueryBuilder<SocialSettingsEntity, bool, QQueryOperations>
      allowGroupInvitesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allowGroupInvites');
    });
  }

  QueryBuilder<SocialSettingsEntity, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<SocialSettingsEntity, bool, QQueryOperations>
      leaderboardUseAliasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leaderboardUseAlias');
    });
  }

  QueryBuilder<SocialSettingsEntity, bool, QQueryOperations>
      shareAchievementsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shareAchievements');
    });
  }

  QueryBuilder<SocialSettingsEntity, bool, QQueryOperations>
      shareStreaksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shareStreaks');
    });
  }

  QueryBuilder<SocialSettingsEntity, bool, QQueryOperations>
      showOnLeaderboardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showOnLeaderboard');
    });
  }

  QueryBuilder<SocialSettingsEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
