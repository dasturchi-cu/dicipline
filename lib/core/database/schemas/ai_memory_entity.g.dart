// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_memory_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAiMemoryEntityCollection on Isar {
  IsarCollection<AiMemoryEntity> get aiMemoryEntitys => this.collection();
}

const AiMemoryEntitySchema = CollectionSchema(
  name: r'AiMemoryEntity',
  id: 8118517714043671449,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'confidence': PropertySchema(
      id: 1,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'insight': PropertySchema(
      id: 3,
      name: r'insight',
      type: IsarType.string,
    ),
    r'lastReferencedAt': PropertySchema(
      id: 4,
      name: r'lastReferencedAt',
      type: IsarType.dateTime,
    ),
    r'referenceCount': PropertySchema(
      id: 5,
      name: r'referenceCount',
      type: IsarType.long,
    )
  },
  estimateSize: _aiMemoryEntityEstimateSize,
  serialize: _aiMemoryEntitySerialize,
  deserialize: _aiMemoryEntityDeserialize,
  deserializeProp: _aiMemoryEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'category': IndexSchema(
      id: -7560358558326323820,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
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
  getId: _aiMemoryEntityGetId,
  getLinks: _aiMemoryEntityGetLinks,
  attach: _aiMemoryEntityAttach,
  version: '3.1.0+1',
);

int _aiMemoryEntityEstimateSize(
  AiMemoryEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.insight.length * 3;
  return bytesCount;
}

void _aiMemoryEntitySerialize(
  AiMemoryEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeDouble(offsets[1], object.confidence);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.insight);
  writer.writeDateTime(offsets[4], object.lastReferencedAt);
  writer.writeLong(offsets[5], object.referenceCount);
}

AiMemoryEntity _aiMemoryEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AiMemoryEntity();
  object.category = reader.readString(offsets[0]);
  object.confidence = reader.readDouble(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.insight = reader.readString(offsets[3]);
  object.lastReferencedAt = reader.readDateTime(offsets[4]);
  object.referenceCount = reader.readLong(offsets[5]);
  return object;
}

P _aiMemoryEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _aiMemoryEntityGetId(AiMemoryEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _aiMemoryEntityGetLinks(AiMemoryEntity object) {
  return [];
}

void _aiMemoryEntityAttach(
    IsarCollection<dynamic> col, Id id, AiMemoryEntity object) {
  object.id = id;
}

extension AiMemoryEntityQueryWhereSort
    on QueryBuilder<AiMemoryEntity, AiMemoryEntity, QWhere> {
  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension AiMemoryEntityQueryWhere
    on QueryBuilder<AiMemoryEntity, AiMemoryEntity, QWhereClause> {
  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause>
      categoryEqualTo(String category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'category',
        value: [category],
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause>
      categoryNotEqualTo(String category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause>
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause>
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause>
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterWhereClause>
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

extension AiMemoryEntityQueryFilter
    on QueryBuilder<AiMemoryEntity, AiMemoryEntity, QFilterCondition> {
  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      confidenceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      confidenceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      confidenceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      confidenceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      insightEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      insightGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      insightLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      insightBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'insight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      insightStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      insightEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      insightContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'insight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      insightMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'insight',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      insightIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insight',
        value: '',
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      insightIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'insight',
        value: '',
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      lastReferencedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReferencedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      lastReferencedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReferencedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      lastReferencedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReferencedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      lastReferencedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReferencedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      referenceCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      referenceCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      referenceCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterFilterCondition>
      referenceCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referenceCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AiMemoryEntityQueryObject
    on QueryBuilder<AiMemoryEntity, AiMemoryEntity, QFilterCondition> {}

extension AiMemoryEntityQueryLinks
    on QueryBuilder<AiMemoryEntity, AiMemoryEntity, QFilterCondition> {}

extension AiMemoryEntityQuerySortBy
    on QueryBuilder<AiMemoryEntity, AiMemoryEntity, QSortBy> {
  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy> sortByInsight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insight', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      sortByInsightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insight', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      sortByLastReferencedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReferencedAt', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      sortByLastReferencedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReferencedAt', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      sortByReferenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceCount', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      sortByReferenceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceCount', Sort.desc);
    });
  }
}

extension AiMemoryEntityQuerySortThenBy
    on QueryBuilder<AiMemoryEntity, AiMemoryEntity, QSortThenBy> {
  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy> thenByInsight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insight', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      thenByInsightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insight', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      thenByLastReferencedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReferencedAt', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      thenByLastReferencedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReferencedAt', Sort.desc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      thenByReferenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceCount', Sort.asc);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QAfterSortBy>
      thenByReferenceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceCount', Sort.desc);
    });
  }
}

extension AiMemoryEntityQueryWhereDistinct
    on QueryBuilder<AiMemoryEntity, AiMemoryEntity, QDistinct> {
  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QDistinct>
      distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QDistinct> distinctByInsight(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'insight', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QDistinct>
      distinctByLastReferencedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReferencedAt');
    });
  }

  QueryBuilder<AiMemoryEntity, AiMemoryEntity, QDistinct>
      distinctByReferenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referenceCount');
    });
  }
}

extension AiMemoryEntityQueryProperty
    on QueryBuilder<AiMemoryEntity, AiMemoryEntity, QQueryProperty> {
  QueryBuilder<AiMemoryEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AiMemoryEntity, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<AiMemoryEntity, double, QQueryOperations> confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<AiMemoryEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AiMemoryEntity, String, QQueryOperations> insightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'insight');
    });
  }

  QueryBuilder<AiMemoryEntity, DateTime, QQueryOperations>
      lastReferencedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReferencedAt');
    });
  }

  QueryBuilder<AiMemoryEntity, int, QQueryOperations> referenceCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceCount');
    });
  }
}
