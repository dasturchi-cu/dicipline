// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_focus_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMonthlyFocusEntityCollection on Isar {
  IsarCollection<MonthlyFocusEntity> get monthlyFocusEntitys =>
      this.collection();
}

const MonthlyFocusEntitySchema = CollectionSchema(
  name: r'MonthlyFocusEntity',
  id: -4354592354124589677,
  properties: {
    r'emoji': PropertySchema(
      id: 0,
      name: r'emoji',
      type: IsarType.string,
    ),
    r'focusDescription': PropertySchema(
      id: 1,
      name: r'focusDescription',
      type: IsarType.string,
    ),
    r'focusTitle': PropertySchema(
      id: 2,
      name: r'focusTitle',
      type: IsarType.string,
    ),
    r'goalId': PropertySchema(
      id: 3,
      name: r'goalId',
      type: IsarType.long,
    ),
    r'monthKey': PropertySchema(
      id: 4,
      name: r'monthKey',
      type: IsarType.string,
    ),
    r'setAt': PropertySchema(
      id: 5,
      name: r'setAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _monthlyFocusEntityEstimateSize,
  serialize: _monthlyFocusEntitySerialize,
  deserialize: _monthlyFocusEntityDeserialize,
  deserializeProp: _monthlyFocusEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'monthKey': IndexSchema(
      id: -6349924167704926890,
      name: r'monthKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'monthKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _monthlyFocusEntityGetId,
  getLinks: _monthlyFocusEntityGetLinks,
  attach: _monthlyFocusEntityAttach,
  version: '3.1.0+1',
);

int _monthlyFocusEntityEstimateSize(
  MonthlyFocusEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.emoji.length * 3;
  {
    final value = object.focusDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.focusTitle.length * 3;
  bytesCount += 3 + object.monthKey.length * 3;
  return bytesCount;
}

void _monthlyFocusEntitySerialize(
  MonthlyFocusEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.emoji);
  writer.writeString(offsets[1], object.focusDescription);
  writer.writeString(offsets[2], object.focusTitle);
  writer.writeLong(offsets[3], object.goalId);
  writer.writeString(offsets[4], object.monthKey);
  writer.writeDateTime(offsets[5], object.setAt);
}

MonthlyFocusEntity _monthlyFocusEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MonthlyFocusEntity();
  object.emoji = reader.readString(offsets[0]);
  object.focusDescription = reader.readStringOrNull(offsets[1]);
  object.focusTitle = reader.readString(offsets[2]);
  object.goalId = reader.readLong(offsets[3]);
  object.id = id;
  object.monthKey = reader.readString(offsets[4]);
  object.setAt = reader.readDateTime(offsets[5]);
  return object;
}

P _monthlyFocusEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _monthlyFocusEntityGetId(MonthlyFocusEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _monthlyFocusEntityGetLinks(
    MonthlyFocusEntity object) {
  return [];
}

void _monthlyFocusEntityAttach(
    IsarCollection<dynamic> col, Id id, MonthlyFocusEntity object) {
  object.id = id;
}

extension MonthlyFocusEntityByIndex on IsarCollection<MonthlyFocusEntity> {
  Future<MonthlyFocusEntity?> getByMonthKey(String monthKey) {
    return getByIndex(r'monthKey', [monthKey]);
  }

  MonthlyFocusEntity? getByMonthKeySync(String monthKey) {
    return getByIndexSync(r'monthKey', [monthKey]);
  }

  Future<bool> deleteByMonthKey(String monthKey) {
    return deleteByIndex(r'monthKey', [monthKey]);
  }

  bool deleteByMonthKeySync(String monthKey) {
    return deleteByIndexSync(r'monthKey', [monthKey]);
  }

  Future<List<MonthlyFocusEntity?>> getAllByMonthKey(
      List<String> monthKeyValues) {
    final values = monthKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'monthKey', values);
  }

  List<MonthlyFocusEntity?> getAllByMonthKeySync(List<String> monthKeyValues) {
    final values = monthKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'monthKey', values);
  }

  Future<int> deleteAllByMonthKey(List<String> monthKeyValues) {
    final values = monthKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'monthKey', values);
  }

  int deleteAllByMonthKeySync(List<String> monthKeyValues) {
    final values = monthKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'monthKey', values);
  }

  Future<Id> putByMonthKey(MonthlyFocusEntity object) {
    return putByIndex(r'monthKey', object);
  }

  Id putByMonthKeySync(MonthlyFocusEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'monthKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMonthKey(List<MonthlyFocusEntity> objects) {
    return putAllByIndex(r'monthKey', objects);
  }

  List<Id> putAllByMonthKeySync(List<MonthlyFocusEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'monthKey', objects, saveLinks: saveLinks);
  }
}

extension MonthlyFocusEntityQueryWhereSort
    on QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QWhere> {
  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MonthlyFocusEntityQueryWhere
    on QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QWhereClause> {
  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterWhereClause>
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterWhereClause>
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterWhereClause>
      monthKeyEqualTo(String monthKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'monthKey',
        value: [monthKey],
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterWhereClause>
      monthKeyNotEqualTo(String monthKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthKey',
              lower: [],
              upper: [monthKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthKey',
              lower: [monthKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthKey',
              lower: [monthKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthKey',
              lower: [],
              upper: [monthKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MonthlyFocusEntityQueryFilter
    on QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QFilterCondition> {
  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      emojiEqualTo(
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      emojiGreaterThan(
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      emojiLessThan(
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      emojiBetween(
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      emojiStartsWith(
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      emojiEndsWith(
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      emojiContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      emojiMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emoji',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      emojiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emoji',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      emojiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emoji',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'focusDescription',
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'focusDescription',
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'focusDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'focusDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'focusDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'focusDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'focusDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'focusDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'focusDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'focusDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'focusDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'focusDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'focusTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'focusTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'focusTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'focusTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'focusTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'focusTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'focusTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'focusTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'focusTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      focusTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'focusTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      goalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      goalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      goalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      goalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
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

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      monthKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      monthKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      monthKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      monthKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      monthKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      monthKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      monthKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      monthKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'monthKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      monthKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      monthKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'monthKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      setAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      setAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      setAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterFilterCondition>
      setAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MonthlyFocusEntityQueryObject
    on QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QFilterCondition> {}

extension MonthlyFocusEntityQueryLinks
    on QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QFilterCondition> {}

extension MonthlyFocusEntityQuerySortBy
    on QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QSortBy> {
  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortByEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortByEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortByFocusDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusDescription', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortByFocusDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusDescription', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortByFocusTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusTitle', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortByFocusTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusTitle', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortBySetAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setAt', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      sortBySetAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setAt', Sort.desc);
    });
  }
}

extension MonthlyFocusEntityQuerySortThenBy
    on QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QSortThenBy> {
  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByFocusDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusDescription', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByFocusDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusDescription', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByFocusTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusTitle', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByFocusTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusTitle', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenBySetAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setAt', Sort.asc);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QAfterSortBy>
      thenBySetAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setAt', Sort.desc);
    });
  }
}

extension MonthlyFocusEntityQueryWhereDistinct
    on QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QDistinct> {
  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QDistinct>
      distinctByEmoji({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emoji', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QDistinct>
      distinctByFocusDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QDistinct>
      distinctByFocusTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QDistinct>
      distinctByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalId');
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QDistinct>
      distinctByMonthKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QDistinct>
      distinctBySetAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setAt');
    });
  }
}

extension MonthlyFocusEntityQueryProperty
    on QueryBuilder<MonthlyFocusEntity, MonthlyFocusEntity, QQueryProperty> {
  QueryBuilder<MonthlyFocusEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MonthlyFocusEntity, String, QQueryOperations> emojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emoji');
    });
  }

  QueryBuilder<MonthlyFocusEntity, String?, QQueryOperations>
      focusDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusDescription');
    });
  }

  QueryBuilder<MonthlyFocusEntity, String, QQueryOperations>
      focusTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusTitle');
    });
  }

  QueryBuilder<MonthlyFocusEntity, int, QQueryOperations> goalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalId');
    });
  }

  QueryBuilder<MonthlyFocusEntity, String, QQueryOperations>
      monthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthKey');
    });
  }

  QueryBuilder<MonthlyFocusEntity, DateTime, QQueryOperations> setAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setAt');
    });
  }
}
