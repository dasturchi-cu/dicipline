// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnership_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPartnershipEntityCollection on Isar {
  IsarCollection<PartnershipEntity> get partnershipEntitys => this.collection();
}

const PartnershipEntitySchema = CollectionSchema(
  name: r'PartnershipEntity',
  id: 5217538581282001623,
  properties: {
    r'checkInCount': PropertySchema(
      id: 0,
      name: r'checkInCount',
      type: IsarType.long,
    ),
    r'connectedAt': PropertySchema(
      id: 1,
      name: r'connectedAt',
      type: IsarType.dateTime,
    ),
    r'inviteCode': PropertySchema(
      id: 2,
      name: r'inviteCode',
      type: IsarType.string,
    ),
    r'lastCheckInAt': PropertySchema(
      id: 3,
      name: r'lastCheckInAt',
      type: IsarType.dateTime,
    ),
    r'partnerName': PropertySchema(
      id: 4,
      name: r'partnerName',
      type: IsarType.string,
    ),
    r'shareAchievements': PropertySchema(
      id: 5,
      name: r'shareAchievements',
      type: IsarType.bool,
    ),
    r'shareGoals': PropertySchema(
      id: 6,
      name: r'shareGoals',
      type: IsarType.bool,
    ),
    r'shareStreaks': PropertySchema(
      id: 7,
      name: r'shareStreaks',
      type: IsarType.bool,
    )
  },
  estimateSize: _partnershipEntityEstimateSize,
  serialize: _partnershipEntitySerialize,
  deserialize: _partnershipEntityDeserialize,
  deserializeProp: _partnershipEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'inviteCode': IndexSchema(
      id: 1149539950050509013,
      name: r'inviteCode',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'inviteCode',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _partnershipEntityGetId,
  getLinks: _partnershipEntityGetLinks,
  attach: _partnershipEntityAttach,
  version: '3.1.0+1',
);

int _partnershipEntityEstimateSize(
  PartnershipEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.inviteCode.length * 3;
  bytesCount += 3 + object.partnerName.length * 3;
  return bytesCount;
}

void _partnershipEntitySerialize(
  PartnershipEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.checkInCount);
  writer.writeDateTime(offsets[1], object.connectedAt);
  writer.writeString(offsets[2], object.inviteCode);
  writer.writeDateTime(offsets[3], object.lastCheckInAt);
  writer.writeString(offsets[4], object.partnerName);
  writer.writeBool(offsets[5], object.shareAchievements);
  writer.writeBool(offsets[6], object.shareGoals);
  writer.writeBool(offsets[7], object.shareStreaks);
}

PartnershipEntity _partnershipEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PartnershipEntity();
  object.checkInCount = reader.readLong(offsets[0]);
  object.connectedAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.inviteCode = reader.readString(offsets[2]);
  object.lastCheckInAt = reader.readDateTimeOrNull(offsets[3]);
  object.partnerName = reader.readString(offsets[4]);
  object.shareAchievements = reader.readBool(offsets[5]);
  object.shareGoals = reader.readBool(offsets[6]);
  object.shareStreaks = reader.readBool(offsets[7]);
  return object;
}

P _partnershipEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _partnershipEntityGetId(PartnershipEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _partnershipEntityGetLinks(
    PartnershipEntity object) {
  return [];
}

void _partnershipEntityAttach(
    IsarCollection<dynamic> col, Id id, PartnershipEntity object) {
  object.id = id;
}

extension PartnershipEntityByIndex on IsarCollection<PartnershipEntity> {
  Future<PartnershipEntity?> getByInviteCode(String inviteCode) {
    return getByIndex(r'inviteCode', [inviteCode]);
  }

  PartnershipEntity? getByInviteCodeSync(String inviteCode) {
    return getByIndexSync(r'inviteCode', [inviteCode]);
  }

  Future<bool> deleteByInviteCode(String inviteCode) {
    return deleteByIndex(r'inviteCode', [inviteCode]);
  }

  bool deleteByInviteCodeSync(String inviteCode) {
    return deleteByIndexSync(r'inviteCode', [inviteCode]);
  }

  Future<List<PartnershipEntity?>> getAllByInviteCode(
      List<String> inviteCodeValues) {
    final values = inviteCodeValues.map((e) => [e]).toList();
    return getAllByIndex(r'inviteCode', values);
  }

  List<PartnershipEntity?> getAllByInviteCodeSync(
      List<String> inviteCodeValues) {
    final values = inviteCodeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'inviteCode', values);
  }

  Future<int> deleteAllByInviteCode(List<String> inviteCodeValues) {
    final values = inviteCodeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'inviteCode', values);
  }

  int deleteAllByInviteCodeSync(List<String> inviteCodeValues) {
    final values = inviteCodeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'inviteCode', values);
  }

  Future<Id> putByInviteCode(PartnershipEntity object) {
    return putByIndex(r'inviteCode', object);
  }

  Id putByInviteCodeSync(PartnershipEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'inviteCode', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInviteCode(List<PartnershipEntity> objects) {
    return putAllByIndex(r'inviteCode', objects);
  }

  List<Id> putAllByInviteCodeSync(List<PartnershipEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'inviteCode', objects, saveLinks: saveLinks);
  }
}

extension PartnershipEntityQueryWhereSort
    on QueryBuilder<PartnershipEntity, PartnershipEntity, QWhere> {
  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PartnershipEntityQueryWhere
    on QueryBuilder<PartnershipEntity, PartnershipEntity, QWhereClause> {
  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterWhereClause>
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterWhereClause>
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterWhereClause>
      inviteCodeEqualTo(String inviteCode) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'inviteCode',
        value: [inviteCode],
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterWhereClause>
      inviteCodeNotEqualTo(String inviteCode) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'inviteCode',
              lower: [],
              upper: [inviteCode],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'inviteCode',
              lower: [inviteCode],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'inviteCode',
              lower: [inviteCode],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'inviteCode',
              lower: [],
              upper: [inviteCode],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PartnershipEntityQueryFilter
    on QueryBuilder<PartnershipEntity, PartnershipEntity, QFilterCondition> {
  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      checkInCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkInCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      checkInCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkInCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      checkInCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkInCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      checkInCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkInCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      connectedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'connectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      connectedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'connectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      connectedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'connectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      connectedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'connectedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      inviteCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      inviteCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      inviteCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      inviteCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inviteCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      inviteCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'inviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      inviteCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'inviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      inviteCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'inviteCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      inviteCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'inviteCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      inviteCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inviteCode',
        value: '',
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      inviteCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'inviteCode',
        value: '',
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      lastCheckInAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCheckInAt',
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      lastCheckInAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCheckInAt',
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      lastCheckInAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCheckInAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      lastCheckInAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCheckInAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      lastCheckInAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCheckInAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      lastCheckInAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCheckInAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      partnerNameEqualTo(
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      partnerNameGreaterThan(
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      partnerNameLessThan(
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      partnerNameBetween(
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      partnerNameStartsWith(
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      partnerNameEndsWith(
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

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      partnerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      partnerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partnerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      partnerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      partnerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      shareAchievementsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shareAchievements',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      shareGoalsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shareGoals',
        value: value,
      ));
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterFilterCondition>
      shareStreaksEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shareStreaks',
        value: value,
      ));
    });
  }
}

extension PartnershipEntityQueryObject
    on QueryBuilder<PartnershipEntity, PartnershipEntity, QFilterCondition> {}

extension PartnershipEntityQueryLinks
    on QueryBuilder<PartnershipEntity, PartnershipEntity, QFilterCondition> {}

extension PartnershipEntityQuerySortBy
    on QueryBuilder<PartnershipEntity, PartnershipEntity, QSortBy> {
  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByCheckInCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInCount', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByCheckInCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInCount', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByConnectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectedAt', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByConnectedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectedAt', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByInviteCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inviteCode', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByInviteCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inviteCode', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByLastCheckInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInAt', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByLastCheckInAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInAt', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByShareAchievements() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareAchievements', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByShareAchievementsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareAchievements', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByShareGoals() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareGoals', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByShareGoalsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareGoals', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByShareStreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareStreaks', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      sortByShareStreaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareStreaks', Sort.desc);
    });
  }
}

extension PartnershipEntityQuerySortThenBy
    on QueryBuilder<PartnershipEntity, PartnershipEntity, QSortThenBy> {
  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByCheckInCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInCount', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByCheckInCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInCount', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByConnectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectedAt', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByConnectedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectedAt', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByInviteCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inviteCode', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByInviteCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inviteCode', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByLastCheckInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInAt', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByLastCheckInAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInAt', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByShareAchievements() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareAchievements', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByShareAchievementsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareAchievements', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByShareGoals() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareGoals', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByShareGoalsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareGoals', Sort.desc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByShareStreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareStreaks', Sort.asc);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QAfterSortBy>
      thenByShareStreaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareStreaks', Sort.desc);
    });
  }
}

extension PartnershipEntityQueryWhereDistinct
    on QueryBuilder<PartnershipEntity, PartnershipEntity, QDistinct> {
  QueryBuilder<PartnershipEntity, PartnershipEntity, QDistinct>
      distinctByCheckInCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkInCount');
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QDistinct>
      distinctByConnectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'connectedAt');
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QDistinct>
      distinctByInviteCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inviteCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QDistinct>
      distinctByLastCheckInAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCheckInAt');
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QDistinct>
      distinctByPartnerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QDistinct>
      distinctByShareAchievements() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shareAchievements');
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QDistinct>
      distinctByShareGoals() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shareGoals');
    });
  }

  QueryBuilder<PartnershipEntity, PartnershipEntity, QDistinct>
      distinctByShareStreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shareStreaks');
    });
  }
}

extension PartnershipEntityQueryProperty
    on QueryBuilder<PartnershipEntity, PartnershipEntity, QQueryProperty> {
  QueryBuilder<PartnershipEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PartnershipEntity, int, QQueryOperations>
      checkInCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkInCount');
    });
  }

  QueryBuilder<PartnershipEntity, DateTime, QQueryOperations>
      connectedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'connectedAt');
    });
  }

  QueryBuilder<PartnershipEntity, String, QQueryOperations>
      inviteCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inviteCode');
    });
  }

  QueryBuilder<PartnershipEntity, DateTime?, QQueryOperations>
      lastCheckInAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCheckInAt');
    });
  }

  QueryBuilder<PartnershipEntity, String, QQueryOperations>
      partnerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerName');
    });
  }

  QueryBuilder<PartnershipEntity, bool, QQueryOperations>
      shareAchievementsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shareAchievements');
    });
  }

  QueryBuilder<PartnershipEntity, bool, QQueryOperations> shareGoalsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shareGoals');
    });
  }

  QueryBuilder<PartnershipEntity, bool, QQueryOperations>
      shareStreaksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shareStreaks');
    });
  }
}
