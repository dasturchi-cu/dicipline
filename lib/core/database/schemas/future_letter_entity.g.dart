// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'future_letter_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFutureLetterEntityCollection on Isar {
  IsarCollection<FutureLetterEntity> get futureLetterEntitys =>
      this.collection();
}

const FutureLetterEntitySchema = CollectionSchema(
  name: r'FutureLetterEntity',
  id: -1667730695766462331,
  properties: {
    r'content': PropertySchema(
      id: 0,
      name: r'content',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deliverAt': PropertySchema(
      id: 2,
      name: r'deliverAt',
      type: IsarType.dateTime,
    ),
    r'delivered': PropertySchema(
      id: 3,
      name: r'delivered',
      type: IsarType.bool,
    ),
    r'deliveredAt': PropertySchema(
      id: 4,
      name: r'deliveredAt',
      type: IsarType.dateTime,
    ),
    r'deliveryHorizon': PropertySchema(
      id: 5,
      name: r'deliveryHorizon',
      type: IsarType.string,
    ),
    r'moodAtWriting': PropertySchema(
      id: 6,
      name: r'moodAtWriting',
      type: IsarType.long,
    ),
    r'read': PropertySchema(
      id: 7,
      name: r'read',
      type: IsarType.bool,
    ),
    r'snapshotJson': PropertySchema(
      id: 8,
      name: r'snapshotJson',
      type: IsarType.string,
    )
  },
  estimateSize: _futureLetterEntityEstimateSize,
  serialize: _futureLetterEntitySerialize,
  deserialize: _futureLetterEntityDeserialize,
  deserializeProp: _futureLetterEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'deliveryHorizon': IndexSchema(
      id: 2532409467854731793,
      name: r'deliveryHorizon',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deliveryHorizon',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'deliverAt': IndexSchema(
      id: 9137352138184127768,
      name: r'deliverAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deliverAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _futureLetterEntityGetId,
  getLinks: _futureLetterEntityGetLinks,
  attach: _futureLetterEntityAttach,
  version: '3.1.0+1',
);

int _futureLetterEntityEstimateSize(
  FutureLetterEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.deliveryHorizon.length * 3;
  {
    final value = object.snapshotJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _futureLetterEntitySerialize(
  FutureLetterEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.content);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.deliverAt);
  writer.writeBool(offsets[3], object.delivered);
  writer.writeDateTime(offsets[4], object.deliveredAt);
  writer.writeString(offsets[5], object.deliveryHorizon);
  writer.writeLong(offsets[6], object.moodAtWriting);
  writer.writeBool(offsets[7], object.read);
  writer.writeString(offsets[8], object.snapshotJson);
}

FutureLetterEntity _futureLetterEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FutureLetterEntity();
  object.content = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.deliverAt = reader.readDateTime(offsets[2]);
  object.delivered = reader.readBool(offsets[3]);
  object.deliveredAt = reader.readDateTimeOrNull(offsets[4]);
  object.deliveryHorizon = reader.readString(offsets[5]);
  object.id = id;
  object.moodAtWriting = reader.readLong(offsets[6]);
  object.read = reader.readBool(offsets[7]);
  object.snapshotJson = reader.readStringOrNull(offsets[8]);
  return object;
}

P _futureLetterEntityDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _futureLetterEntityGetId(FutureLetterEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _futureLetterEntityGetLinks(
    FutureLetterEntity object) {
  return [];
}

void _futureLetterEntityAttach(
    IsarCollection<dynamic> col, Id id, FutureLetterEntity object) {
  object.id = id;
}

extension FutureLetterEntityQueryWhereSort
    on QueryBuilder<FutureLetterEntity, FutureLetterEntity, QWhere> {
  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhere>
      anyDeliverAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'deliverAt'),
      );
    });
  }
}

extension FutureLetterEntityQueryWhere
    on QueryBuilder<FutureLetterEntity, FutureLetterEntity, QWhereClause> {
  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
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

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
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

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
      deliveryHorizonEqualTo(String deliveryHorizon) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deliveryHorizon',
        value: [deliveryHorizon],
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
      deliveryHorizonNotEqualTo(String deliveryHorizon) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliveryHorizon',
              lower: [],
              upper: [deliveryHorizon],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliveryHorizon',
              lower: [deliveryHorizon],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliveryHorizon',
              lower: [deliveryHorizon],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliveryHorizon',
              lower: [],
              upper: [deliveryHorizon],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
      deliverAtEqualTo(DateTime deliverAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deliverAt',
        value: [deliverAt],
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
      deliverAtNotEqualTo(DateTime deliverAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliverAt',
              lower: [],
              upper: [deliverAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliverAt',
              lower: [deliverAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliverAt',
              lower: [deliverAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliverAt',
              lower: [],
              upper: [deliverAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
      deliverAtGreaterThan(
    DateTime deliverAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deliverAt',
        lower: [deliverAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
      deliverAtLessThan(
    DateTime deliverAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deliverAt',
        lower: [],
        upper: [deliverAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterWhereClause>
      deliverAtBetween(
    DateTime lowerDeliverAt,
    DateTime upperDeliverAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deliverAt',
        lower: [lowerDeliverAt],
        includeLower: includeLower,
        upper: [upperDeliverAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FutureLetterEntityQueryFilter
    on QueryBuilder<FutureLetterEntity, FutureLetterEntity, QFilterCondition> {
  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
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

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
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

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
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

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliverAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliverAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliverAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deliverAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliverAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deliverAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliverAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deliverAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'delivered',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveredAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deliveredAt',
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveredAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deliveredAt',
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveredAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveredAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deliveredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveredAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deliveredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveredAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deliveredAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveryHorizonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryHorizon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveryHorizonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deliveryHorizon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveryHorizonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deliveryHorizon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveryHorizonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deliveryHorizon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveryHorizonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deliveryHorizon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveryHorizonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deliveryHorizon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveryHorizonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deliveryHorizon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveryHorizonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deliveryHorizon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveryHorizonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryHorizon',
        value: '',
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      deliveryHorizonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deliveryHorizon',
        value: '',
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
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

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
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

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
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

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      moodAtWritingEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodAtWriting',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      moodAtWritingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodAtWriting',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      moodAtWritingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodAtWriting',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      moodAtWritingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodAtWriting',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      readEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'read',
        value: value,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'snapshotJson',
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'snapshotJson',
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snapshotJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'snapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'snapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'snapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'snapshotJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotJson',
        value: '',
      ));
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterFilterCondition>
      snapshotJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'snapshotJson',
        value: '',
      ));
    });
  }
}

extension FutureLetterEntityQueryObject
    on QueryBuilder<FutureLetterEntity, FutureLetterEntity, QFilterCondition> {}

extension FutureLetterEntityQueryLinks
    on QueryBuilder<FutureLetterEntity, FutureLetterEntity, QFilterCondition> {}

extension FutureLetterEntityQuerySortBy
    on QueryBuilder<FutureLetterEntity, FutureLetterEntity, QSortBy> {
  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByDeliverAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliverAt', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByDeliverAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliverAt', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByDelivered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delivered', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByDeliveredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delivered', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByDeliveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveredAt', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByDeliveredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveredAt', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByDeliveryHorizon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryHorizon', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByDeliveryHorizonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryHorizon', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByMoodAtWriting() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodAtWriting', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByMoodAtWritingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodAtWriting', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortBySnapshotJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotJson', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      sortBySnapshotJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotJson', Sort.desc);
    });
  }
}

extension FutureLetterEntityQuerySortThenBy
    on QueryBuilder<FutureLetterEntity, FutureLetterEntity, QSortThenBy> {
  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByDeliverAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliverAt', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByDeliverAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliverAt', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByDelivered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delivered', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByDeliveredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delivered', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByDeliveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveredAt', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByDeliveredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveredAt', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByDeliveryHorizon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryHorizon', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByDeliveryHorizonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryHorizon', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByMoodAtWriting() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodAtWriting', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByMoodAtWritingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodAtWriting', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.desc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenBySnapshotJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotJson', Sort.asc);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QAfterSortBy>
      thenBySnapshotJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotJson', Sort.desc);
    });
  }
}

extension FutureLetterEntityQueryWhereDistinct
    on QueryBuilder<FutureLetterEntity, FutureLetterEntity, QDistinct> {
  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QDistinct>
      distinctByContent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QDistinct>
      distinctByDeliverAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliverAt');
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QDistinct>
      distinctByDelivered() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'delivered');
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QDistinct>
      distinctByDeliveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveredAt');
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QDistinct>
      distinctByDeliveryHorizon({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveryHorizon',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QDistinct>
      distinctByMoodAtWriting() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodAtWriting');
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QDistinct>
      distinctByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'read');
    });
  }

  QueryBuilder<FutureLetterEntity, FutureLetterEntity, QDistinct>
      distinctBySnapshotJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotJson', caseSensitive: caseSensitive);
    });
  }
}

extension FutureLetterEntityQueryProperty
    on QueryBuilder<FutureLetterEntity, FutureLetterEntity, QQueryProperty> {
  QueryBuilder<FutureLetterEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FutureLetterEntity, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<FutureLetterEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FutureLetterEntity, DateTime, QQueryOperations>
      deliverAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliverAt');
    });
  }

  QueryBuilder<FutureLetterEntity, bool, QQueryOperations> deliveredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'delivered');
    });
  }

  QueryBuilder<FutureLetterEntity, DateTime?, QQueryOperations>
      deliveredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveredAt');
    });
  }

  QueryBuilder<FutureLetterEntity, String, QQueryOperations>
      deliveryHorizonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveryHorizon');
    });
  }

  QueryBuilder<FutureLetterEntity, int, QQueryOperations>
      moodAtWritingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodAtWriting');
    });
  }

  QueryBuilder<FutureLetterEntity, bool, QQueryOperations> readProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'read');
    });
  }

  QueryBuilder<FutureLetterEntity, String?, QQueryOperations>
      snapshotJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotJson');
    });
  }
}
