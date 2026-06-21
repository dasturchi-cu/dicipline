// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_challenge_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGroupChallengeEntityCollection on Isar {
  IsarCollection<GroupChallengeEntity> get groupChallengeEntitys =>
      this.collection();
}

const GroupChallengeEntitySchema = CollectionSchema(
  name: r'GroupChallengeEntity',
  id: -4577879989977525677,
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
    r'maxMembers': PropertySchema(
      id: 2,
      name: r'maxMembers',
      type: IsarType.long,
    ),
    r'membersJson': PropertySchema(
      id: 3,
      name: r'membersJson',
      type: IsarType.string,
    ),
    r'startedAt': PropertySchema(
      id: 4,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 5,
      name: r'status',
      type: IsarType.string,
    ),
    r'targetScore': PropertySchema(
      id: 6,
      name: r'targetScore',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 7,
      name: r'title',
      type: IsarType.string,
    ),
    r'typeId': PropertySchema(
      id: 8,
      name: r'typeId',
      type: IsarType.string,
    )
  },
  estimateSize: _groupChallengeEntityEstimateSize,
  serialize: _groupChallengeEntitySerialize,
  deserialize: _groupChallengeEntityDeserialize,
  deserializeProp: _groupChallengeEntityDeserializeProp,
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
  getId: _groupChallengeEntityGetId,
  getLinks: _groupChallengeEntityGetLinks,
  attach: _groupChallengeEntityAttach,
  version: '3.1.0+1',
);

int _groupChallengeEntityEstimateSize(
  GroupChallengeEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.emoji.length * 3;
  bytesCount += 3 + object.membersJson.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.typeId.length * 3;
  return bytesCount;
}

void _groupChallengeEntitySerialize(
  GroupChallengeEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.emoji);
  writer.writeDateTime(offsets[1], object.endsAt);
  writer.writeLong(offsets[2], object.maxMembers);
  writer.writeString(offsets[3], object.membersJson);
  writer.writeDateTime(offsets[4], object.startedAt);
  writer.writeString(offsets[5], object.status);
  writer.writeLong(offsets[6], object.targetScore);
  writer.writeString(offsets[7], object.title);
  writer.writeString(offsets[8], object.typeId);
}

GroupChallengeEntity _groupChallengeEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GroupChallengeEntity();
  object.emoji = reader.readString(offsets[0]);
  object.endsAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.maxMembers = reader.readLong(offsets[2]);
  object.membersJson = reader.readString(offsets[3]);
  object.startedAt = reader.readDateTime(offsets[4]);
  object.status = reader.readString(offsets[5]);
  object.targetScore = reader.readLong(offsets[6]);
  object.title = reader.readString(offsets[7]);
  object.typeId = reader.readString(offsets[8]);
  return object;
}

P _groupChallengeEntityDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _groupChallengeEntityGetId(GroupChallengeEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _groupChallengeEntityGetLinks(
    GroupChallengeEntity object) {
  return [];
}

void _groupChallengeEntityAttach(
    IsarCollection<dynamic> col, Id id, GroupChallengeEntity object) {
  object.id = id;
}

extension GroupChallengeEntityQueryWhereSort
    on QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QWhere> {
  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GroupChallengeEntityQueryWhere
    on QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QWhereClause> {
  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterWhereClause>
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterWhereClause>
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterWhereClause>
      typeIdEqualTo(String typeId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'typeId',
        value: [typeId],
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterWhereClause>
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterWhereClause>
      statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterWhereClause>
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

extension GroupChallengeEntityQueryFilter on QueryBuilder<GroupChallengeEntity,
    GroupChallengeEntity, QFilterCondition> {
  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> emojiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emoji',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> emojiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emoji',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> endsAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endsAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> maxMembersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxMembers',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> maxMembersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxMembers',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> maxMembersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxMembers',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> maxMembersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxMembers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> membersJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'membersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> membersJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'membersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> membersJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'membersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> membersJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'membersJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> membersJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'membersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> membersJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'membersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
          QAfterFilterCondition>
      membersJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'membersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
          QAfterFilterCondition>
      membersJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'membersJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> membersJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'membersJson',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> membersJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'membersJson',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> targetScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetScore',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
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

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> typeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity,
      QAfterFilterCondition> typeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeId',
        value: '',
      ));
    });
  }
}

extension GroupChallengeEntityQueryObject on QueryBuilder<GroupChallengeEntity,
    GroupChallengeEntity, QFilterCondition> {}

extension GroupChallengeEntityQueryLinks on QueryBuilder<GroupChallengeEntity,
    GroupChallengeEntity, QFilterCondition> {}

extension GroupChallengeEntityQuerySortBy
    on QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QSortBy> {
  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByEndsAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endsAt', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByEndsAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endsAt', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByMaxMembers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxMembers', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByMaxMembersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxMembers', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByMembersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membersJson', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByMembersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membersJson', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByTargetScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetScore', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByTargetScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetScore', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      sortByTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.desc);
    });
  }
}

extension GroupChallengeEntityQuerySortThenBy
    on QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QSortThenBy> {
  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByEndsAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endsAt', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByEndsAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endsAt', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByMaxMembers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxMembers', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByMaxMembersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxMembers', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByMembersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membersJson', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByMembersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membersJson', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByTargetScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetScore', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByTargetScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetScore', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.asc);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QAfterSortBy>
      thenByTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.desc);
    });
  }
}

extension GroupChallengeEntityQueryWhereDistinct
    on QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QDistinct> {
  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QDistinct>
      distinctByEmoji({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emoji', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QDistinct>
      distinctByEndsAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endsAt');
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QDistinct>
      distinctByMaxMembers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxMembers');
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QDistinct>
      distinctByMembersJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'membersJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QDistinct>
      distinctByTargetScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetScore');
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupChallengeEntity, GroupChallengeEntity, QDistinct>
      distinctByTypeId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeId', caseSensitive: caseSensitive);
    });
  }
}

extension GroupChallengeEntityQueryProperty on QueryBuilder<
    GroupChallengeEntity, GroupChallengeEntity, QQueryProperty> {
  QueryBuilder<GroupChallengeEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GroupChallengeEntity, String, QQueryOperations> emojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emoji');
    });
  }

  QueryBuilder<GroupChallengeEntity, DateTime, QQueryOperations>
      endsAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endsAt');
    });
  }

  QueryBuilder<GroupChallengeEntity, int, QQueryOperations>
      maxMembersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxMembers');
    });
  }

  QueryBuilder<GroupChallengeEntity, String, QQueryOperations>
      membersJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'membersJson');
    });
  }

  QueryBuilder<GroupChallengeEntity, DateTime, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<GroupChallengeEntity, String, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<GroupChallengeEntity, int, QQueryOperations>
      targetScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetScore');
    });
  }

  QueryBuilder<GroupChallengeEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<GroupChallengeEntity, String, QQueryOperations>
      typeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeId');
    });
  }
}
