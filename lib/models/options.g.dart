// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOptionsCollection on Isar {
  IsarCollection<Options> get options => this.collection();
}

const OptionsSchema = CollectionSchema(
  name: r'Options',
  id: 8610493837141536158,
  properties: {
    r'beep': PropertySchema(
      id: 0,
      name: r'beep',
      type: IsarType.bool,
    ),
    r'copyToClipboard': PropertySchema(
      id: 1,
      name: r'copyToClipboard',
      type: IsarType.bool,
    ),
    r'detectionSpeed': PropertySchema(
      id: 2,
      name: r'detectionSpeed',
      type: IsarType.byte,
      enumMap: _OptionsdetectionSpeedEnumValueMap,
    ),
    r'facing': PropertySchema(
      id: 3,
      name: r'facing',
      type: IsarType.byte,
      enumMap: _OptionsfacingEnumValueMap,
    ),
    r'flash': PropertySchema(
      id: 4,
      name: r'flash',
      type: IsarType.bool,
    ),
    r'qrSize': PropertySchema(
      id: 5,
      name: r'qrSize',
      type: IsarType.long,
    ),
    r'qrTransparent': PropertySchema(
      id: 6,
      name: r'qrTransparent',
      type: IsarType.bool,
    ),
    r'theme': PropertySchema(
      id: 7,
      name: r'theme',
      type: IsarType.long,
    ),
    r'vibrate': PropertySchema(
      id: 8,
      name: r'vibrate',
      type: IsarType.bool,
    )
  },
  estimateSize: _optionsEstimateSize,
  serialize: _optionsSerialize,
  deserialize: _optionsDeserialize,
  deserializeProp: _optionsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _optionsGetId,
  getLinks: _optionsGetLinks,
  attach: _optionsAttach,
  version: '3.1.0+1',
);

int _optionsEstimateSize(
  Options object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _optionsSerialize(
  Options object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.beep);
  writer.writeBool(offsets[1], object.copyToClipboard);
  writer.writeByte(offsets[2], object.detectionSpeed.index);
  writer.writeByte(offsets[3], object.facing.index);
  writer.writeBool(offsets[4], object.flash);
  writer.writeLong(offsets[5], object.qrSize);
  writer.writeBool(offsets[6], object.qrTransparent);
  writer.writeLong(offsets[7], object.theme);
  writer.writeBool(offsets[8], object.vibrate);
}

Options _optionsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Options();
  object.beep = reader.readBoolOrNull(offsets[0]);
  object.copyToClipboard = reader.readBoolOrNull(offsets[1]);
  object.detectionSpeed =
      _OptionsdetectionSpeedValueEnumMap[reader.readByteOrNull(offsets[2])] ??
          DetectionSpeed.noDuplicates;
  object.facing =
      _OptionsfacingValueEnumMap[reader.readByteOrNull(offsets[3])] ??
          CameraFacing.front;
  object.flash = reader.readBoolOrNull(offsets[4]);
  object.id = id;
  object.qrSize = reader.readLongOrNull(offsets[5]);
  object.qrTransparent = reader.readBoolOrNull(offsets[6]);
  object.theme = reader.readLongOrNull(offsets[7]);
  object.vibrate = reader.readBoolOrNull(offsets[8]);
  return object;
}

P _optionsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (_OptionsdetectionSpeedValueEnumMap[
              reader.readByteOrNull(offset)] ??
          DetectionSpeed.noDuplicates) as P;
    case 3:
      return (_OptionsfacingValueEnumMap[reader.readByteOrNull(offset)] ??
          CameraFacing.front) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readBoolOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _OptionsdetectionSpeedEnumValueMap = {
  'noDuplicates': 0,
  'normal': 1,
  'unrestricted': 2,
};
const _OptionsdetectionSpeedValueEnumMap = {
  0: DetectionSpeed.noDuplicates,
  1: DetectionSpeed.normal,
  2: DetectionSpeed.unrestricted,
};
const _OptionsfacingEnumValueMap = {
  'front': 0,
  'back': 1,
};
const _OptionsfacingValueEnumMap = {
  0: CameraFacing.front,
  1: CameraFacing.back,
};

Id _optionsGetId(Options object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _optionsGetLinks(Options object) {
  return [];
}

void _optionsAttach(IsarCollection<dynamic> col, Id id, Options object) {
  object.id = id;
}

extension OptionsQueryWhereSort on QueryBuilder<Options, Options, QWhere> {
  QueryBuilder<Options, Options, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OptionsQueryWhere on QueryBuilder<Options, Options, QWhereClause> {
  QueryBuilder<Options, Options, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Options, Options, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Options, Options, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Options, Options, QAfterWhereClause> idBetween(
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

extension OptionsQueryFilter
    on QueryBuilder<Options, Options, QFilterCondition> {
  QueryBuilder<Options, Options, QAfterFilterCondition> beepIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'beep',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> beepIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'beep',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> beepEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beep',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition>
      copyToClipboardIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'copyToClipboard',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition>
      copyToClipboardIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'copyToClipboard',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> copyToClipboardEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'copyToClipboard',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> detectionSpeedEqualTo(
      DetectionSpeed value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detectionSpeed',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition>
      detectionSpeedGreaterThan(
    DetectionSpeed value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'detectionSpeed',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> detectionSpeedLessThan(
    DetectionSpeed value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'detectionSpeed',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> detectionSpeedBetween(
    DetectionSpeed lower,
    DetectionSpeed upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'detectionSpeed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> facingEqualTo(
      CameraFacing value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facing',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> facingGreaterThan(
    CameraFacing value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'facing',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> facingLessThan(
    CameraFacing value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'facing',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> facingBetween(
    CameraFacing lower,
    CameraFacing upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'facing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> flashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'flash',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> flashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'flash',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> flashEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flash',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Options, Options, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Options, Options, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Options, Options, QAfterFilterCondition> qrSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'qrSize',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> qrSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'qrSize',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> qrSizeEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qrSize',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> qrSizeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qrSize',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> qrSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qrSize',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> qrSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qrSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> qrTransparentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'qrTransparent',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition>
      qrTransparentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'qrTransparent',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> qrTransparentEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qrTransparent',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> themeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'theme',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> themeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'theme',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> themeEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> themeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'theme',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> themeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'theme',
        value: value,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> themeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'theme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> vibrateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vibrate',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> vibrateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vibrate',
      ));
    });
  }

  QueryBuilder<Options, Options, QAfterFilterCondition> vibrateEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vibrate',
        value: value,
      ));
    });
  }
}

extension OptionsQueryObject
    on QueryBuilder<Options, Options, QFilterCondition> {}

extension OptionsQueryLinks
    on QueryBuilder<Options, Options, QFilterCondition> {}

extension OptionsQuerySortBy on QueryBuilder<Options, Options, QSortBy> {
  QueryBuilder<Options, Options, QAfterSortBy> sortByBeep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beep', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByBeepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beep', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByCopyToClipboard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copyToClipboard', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByCopyToClipboardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copyToClipboard', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByDetectionSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectionSpeed', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByDetectionSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectionSpeed', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByFacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facing', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByFacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facing', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByFlash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flash', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByFlashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flash', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByQrSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrSize', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByQrSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrSize', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByQrTransparent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrTransparent', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByQrTransparentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrTransparent', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByVibrate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrate', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> sortByVibrateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrate', Sort.desc);
    });
  }
}

extension OptionsQuerySortThenBy
    on QueryBuilder<Options, Options, QSortThenBy> {
  QueryBuilder<Options, Options, QAfterSortBy> thenByBeep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beep', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByBeepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beep', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByCopyToClipboard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copyToClipboard', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByCopyToClipboardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copyToClipboard', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByDetectionSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectionSpeed', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByDetectionSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectionSpeed', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByFacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facing', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByFacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facing', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByFlash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flash', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByFlashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flash', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByQrSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrSize', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByQrSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrSize', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByQrTransparent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrTransparent', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByQrTransparentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrTransparent', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByVibrate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrate', Sort.asc);
    });
  }

  QueryBuilder<Options, Options, QAfterSortBy> thenByVibrateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrate', Sort.desc);
    });
  }
}

extension OptionsQueryWhereDistinct
    on QueryBuilder<Options, Options, QDistinct> {
  QueryBuilder<Options, Options, QDistinct> distinctByBeep() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beep');
    });
  }

  QueryBuilder<Options, Options, QDistinct> distinctByCopyToClipboard() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'copyToClipboard');
    });
  }

  QueryBuilder<Options, Options, QDistinct> distinctByDetectionSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'detectionSpeed');
    });
  }

  QueryBuilder<Options, Options, QDistinct> distinctByFacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'facing');
    });
  }

  QueryBuilder<Options, Options, QDistinct> distinctByFlash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flash');
    });
  }

  QueryBuilder<Options, Options, QDistinct> distinctByQrSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qrSize');
    });
  }

  QueryBuilder<Options, Options, QDistinct> distinctByQrTransparent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qrTransparent');
    });
  }

  QueryBuilder<Options, Options, QDistinct> distinctByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'theme');
    });
  }

  QueryBuilder<Options, Options, QDistinct> distinctByVibrate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vibrate');
    });
  }
}

extension OptionsQueryProperty
    on QueryBuilder<Options, Options, QQueryProperty> {
  QueryBuilder<Options, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Options, bool?, QQueryOperations> beepProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beep');
    });
  }

  QueryBuilder<Options, bool?, QQueryOperations> copyToClipboardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'copyToClipboard');
    });
  }

  QueryBuilder<Options, DetectionSpeed, QQueryOperations>
      detectionSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'detectionSpeed');
    });
  }

  QueryBuilder<Options, CameraFacing, QQueryOperations> facingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'facing');
    });
  }

  QueryBuilder<Options, bool?, QQueryOperations> flashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flash');
    });
  }

  QueryBuilder<Options, int?, QQueryOperations> qrSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qrSize');
    });
  }

  QueryBuilder<Options, bool?, QQueryOperations> qrTransparentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qrTransparent');
    });
  }

  QueryBuilder<Options, int?, QQueryOperations> themeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'theme');
    });
  }

  QueryBuilder<Options, bool?, QQueryOperations> vibrateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vibrate');
    });
  }
}
