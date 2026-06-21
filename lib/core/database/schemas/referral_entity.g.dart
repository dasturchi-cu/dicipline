// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReferralEntityCollection on Isar {
  IsarCollection<ReferralEntity> get referralEntitys => this.collection();
}

const ReferralEntitySchema = CollectionSchema(
  name: r'ReferralEntity',
  id: -1620728744880107474,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'referredLabel': PropertySchema(
      id: 1,
      name: r'referredLabel',
      type: IsarType.string,
    ),
    r'rewardClaimed': PropertySchema(
      id: 2,
      name: r'rewardClaimed',
      type: IsarType.bool,
    ),
    r'rewardXp': PropertySchema(
      id: 3,
      name: r'rewardXp',
      type: IsarType.long,
    ),
    r'source': PropertySchema(
      id: 4,
      name: r'source',
      type: IsarType.string,
    ),
    r'usedInviteCode': PropertySchema(
      id: 5,
      name: r'usedInviteCode',
      type: IsarType.string,
    )
  },
  estimateSize: _referralEntityEstimateSize,
  serialize: _referralEntitySerialize,
  deserialize: _referralEntityDeserialize,
  deserializeProp: _referralEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'usedInviteCode': IndexSchema(
      id: 3073627980636999000,
      name: r'usedInviteCode',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'usedInviteCode',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'source': IndexSchema(
      id: -836881197531269605,
      name: r'source',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'source',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _referralEntityGetId,
  getLinks: _referralEntityGetLinks,
  attach: _referralEntityAttach,
  version: '3.1.0+1',
);

int _referralEntityEstimateSize(
  ReferralEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.referredLabel.length * 3;
  bytesCount += 3 + object.source.length * 3;
  bytesCount += 3 + object.usedInviteCode.length * 3;
  return bytesCount;
}

void _referralEntitySerialize(
  ReferralEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.referredLabel);
  writer.writeBool(offsets[2], object.rewardClaimed);
  writer.writeLong(offsets[3], object.rewardXp);
  writer.writeString(offsets[4], object.source);
  writer.writeString(offsets[5], object.usedInviteCode);
}

ReferralEntity _referralEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReferralEntity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.referredLabel = reader.readString(offsets[1]);
  object.rewardClaimed = reader.readBool(offsets[2]);
  object.rewardXp = reader.readLong(offsets[3]);
  object.source = reader.readString(offsets[4]);
  object.usedInviteCode = reader.readString(offsets[5]);
  return object;
}

P _referralEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _referralEntityGetId(ReferralEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _referralEntityGetLinks(ReferralEntity object) {
  return [];
}

void _referralEntityAttach(
    IsarCollection<dynamic> col, Id id, ReferralEntity object) {
  object.id = id;
}

extension ReferralEntityQueryWhereSort
    on QueryBuilder<ReferralEntity, ReferralEntity, QWhere> {
  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension ReferralEntityQueryWhere
    on QueryBuilder<ReferralEntity, ReferralEntity, QWhereClause> {
  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause>
      usedInviteCodeEqualTo(String usedInviteCode) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'usedInviteCode',
        value: [usedInviteCode],
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause>
      usedInviteCodeNotEqualTo(String usedInviteCode) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'usedInviteCode',
              lower: [],
              upper: [usedInviteCode],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'usedInviteCode',
              lower: [usedInviteCode],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'usedInviteCode',
              lower: [usedInviteCode],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'usedInviteCode',
              lower: [],
              upper: [usedInviteCode],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause> sourceEqualTo(
      String source) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'source',
        value: [source],
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause>
      sourceNotEqualTo(String source) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [],
              upper: [source],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [source],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [source],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [],
              upper: [source],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReferralEntityQueryFilter
    on QueryBuilder<ReferralEntity, ReferralEntity, QFilterCondition> {
  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
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

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
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

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
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

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
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

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
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

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      referredLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referredLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      referredLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referredLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      referredLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referredLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      referredLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referredLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      referredLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'referredLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      referredLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'referredLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      referredLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'referredLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      referredLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'referredLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      referredLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referredLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      referredLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'referredLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      rewardClaimedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardClaimed',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      rewardXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardXp',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      rewardXpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rewardXp',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      rewardXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rewardXp',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      rewardXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rewardXp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      usedInviteCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'usedInviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      usedInviteCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'usedInviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      usedInviteCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'usedInviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      usedInviteCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'usedInviteCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      usedInviteCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'usedInviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      usedInviteCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'usedInviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      usedInviteCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'usedInviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      usedInviteCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'usedInviteCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      usedInviteCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'usedInviteCode',
        value: '',
      ));
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterFilterCondition>
      usedInviteCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'usedInviteCode',
        value: '',
      ));
    });
  }
}

extension ReferralEntityQueryObject
    on QueryBuilder<ReferralEntity, ReferralEntity, QFilterCondition> {}

extension ReferralEntityQueryLinks
    on QueryBuilder<ReferralEntity, ReferralEntity, QFilterCondition> {}

extension ReferralEntityQuerySortBy
    on QueryBuilder<ReferralEntity, ReferralEntity, QSortBy> {
  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      sortByReferredLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referredLabel', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      sortByReferredLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referredLabel', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      sortByRewardClaimed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardClaimed', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      sortByRewardClaimedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardClaimed', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy> sortByRewardXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardXp', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      sortByRewardXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardXp', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      sortByUsedInviteCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedInviteCode', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      sortByUsedInviteCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedInviteCode', Sort.desc);
    });
  }
}

extension ReferralEntityQuerySortThenBy
    on QueryBuilder<ReferralEntity, ReferralEntity, QSortThenBy> {
  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      thenByReferredLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referredLabel', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      thenByReferredLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referredLabel', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      thenByRewardClaimed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardClaimed', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      thenByRewardClaimedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardClaimed', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy> thenByRewardXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardXp', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      thenByRewardXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardXp', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      thenByUsedInviteCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedInviteCode', Sort.asc);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QAfterSortBy>
      thenByUsedInviteCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedInviteCode', Sort.desc);
    });
  }
}

extension ReferralEntityQueryWhereDistinct
    on QueryBuilder<ReferralEntity, ReferralEntity, QDistinct> {
  QueryBuilder<ReferralEntity, ReferralEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QDistinct>
      distinctByReferredLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referredLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QDistinct>
      distinctByRewardClaimed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rewardClaimed');
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QDistinct> distinctByRewardXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rewardXp');
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QDistinct> distinctBySource(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReferralEntity, ReferralEntity, QDistinct>
      distinctByUsedInviteCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'usedInviteCode',
          caseSensitive: caseSensitive);
    });
  }
}

extension ReferralEntityQueryProperty
    on QueryBuilder<ReferralEntity, ReferralEntity, QQueryProperty> {
  QueryBuilder<ReferralEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReferralEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ReferralEntity, String, QQueryOperations>
      referredLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referredLabel');
    });
  }

  QueryBuilder<ReferralEntity, bool, QQueryOperations> rewardClaimedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rewardClaimed');
    });
  }

  QueryBuilder<ReferralEntity, int, QQueryOperations> rewardXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rewardXp');
    });
  }

  QueryBuilder<ReferralEntity, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<ReferralEntity, String, QQueryOperations>
      usedInviteCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'usedInviteCode');
    });
  }
}
