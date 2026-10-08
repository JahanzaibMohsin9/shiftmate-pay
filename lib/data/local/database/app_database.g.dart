// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $JobsTableTable extends JobsTable
    with TableInfo<$JobsTableTable, JobsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JobsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 7,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hourlyRateMinorUnitsMeta =
      const VerificationMeta('hourlyRateMinorUnits');
  @override
  late final GeneratedColumn<int> hourlyRateMinorUnits = GeneratedColumn<int>(
    'hourly_rate_minor_units',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payRuleSetIdMeta = const VerificationMeta(
    'payRuleSetId',
  );
  @override
  late final GeneratedColumn<String> payRuleSetId = GeneratedColumn<String>(
    'pay_rule_set_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _holidayRuleSetIdMeta = const VerificationMeta(
    'holidayRuleSetId',
  );
  @override
  late final GeneratedColumn<String> holidayRuleSetId = GeneratedColumn<String>(
    'holiday_rule_set_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultSleepLeadMinutesMeta =
      const VerificationMeta('defaultSleepLeadMinutes');
  @override
  late final GeneratedColumn<int> defaultSleepLeadMinutes =
      GeneratedColumn<int>(
        'default_sleep_lead_minutes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorHex,
    currencyCode,
    hourlyRateMinorUnits,
    payRuleSetId,
    holidayRuleSetId,
    defaultSleepLeadMinutes,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jobs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<JobsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('hourly_rate_minor_units')) {
      context.handle(
        _hourlyRateMinorUnitsMeta,
        hourlyRateMinorUnits.isAcceptableOrUnknown(
          data['hourly_rate_minor_units']!,
          _hourlyRateMinorUnitsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hourlyRateMinorUnitsMeta);
    }
    if (data.containsKey('pay_rule_set_id')) {
      context.handle(
        _payRuleSetIdMeta,
        payRuleSetId.isAcceptableOrUnknown(
          data['pay_rule_set_id']!,
          _payRuleSetIdMeta,
        ),
      );
    }
    if (data.containsKey('holiday_rule_set_id')) {
      context.handle(
        _holidayRuleSetIdMeta,
        holidayRuleSetId.isAcceptableOrUnknown(
          data['holiday_rule_set_id']!,
          _holidayRuleSetIdMeta,
        ),
      );
    }
    if (data.containsKey('default_sleep_lead_minutes')) {
      context.handle(
        _defaultSleepLeadMinutesMeta,
        defaultSleepLeadMinutes.isAcceptableOrUnknown(
          data['default_sleep_lead_minutes']!,
          _defaultSleepLeadMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JobsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JobsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      hourlyRateMinorUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hourly_rate_minor_units'],
      )!,
      payRuleSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pay_rule_set_id'],
      ),
      holidayRuleSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}holiday_rule_set_id'],
      ),
      defaultSleepLeadMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_sleep_lead_minutes'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $JobsTableTable createAlias(String alias) {
    return $JobsTableTable(attachedDatabase, alias);
  }
}

class JobsTableData extends DataClass implements Insertable<JobsTableData> {
  final String id;
  final String name;
  final String colorHex;
  final String currencyCode;
  final int hourlyRateMinorUnits;
  final String? payRuleSetId;
  final String? holidayRuleSetId;
  final int? defaultSleepLeadMinutes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const JobsTableData({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.currencyCode,
    required this.hourlyRateMinorUnits,
    this.payRuleSetId,
    this.holidayRuleSetId,
    this.defaultSleepLeadMinutes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_hex'] = Variable<String>(colorHex);
    map['currency_code'] = Variable<String>(currencyCode);
    map['hourly_rate_minor_units'] = Variable<int>(hourlyRateMinorUnits);
    if (!nullToAbsent || payRuleSetId != null) {
      map['pay_rule_set_id'] = Variable<String>(payRuleSetId);
    }
    if (!nullToAbsent || holidayRuleSetId != null) {
      map['holiday_rule_set_id'] = Variable<String>(holidayRuleSetId);
    }
    if (!nullToAbsent || defaultSleepLeadMinutes != null) {
      map['default_sleep_lead_minutes'] = Variable<int>(
        defaultSleepLeadMinutes,
      );
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JobsTableCompanion toCompanion(bool nullToAbsent) {
    return JobsTableCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: Value(colorHex),
      currencyCode: Value(currencyCode),
      hourlyRateMinorUnits: Value(hourlyRateMinorUnits),
      payRuleSetId: payRuleSetId == null && nullToAbsent
          ? const Value.absent()
          : Value(payRuleSetId),
      holidayRuleSetId: holidayRuleSetId == null && nullToAbsent
          ? const Value.absent()
          : Value(holidayRuleSetId),
      defaultSleepLeadMinutes: defaultSleepLeadMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultSleepLeadMinutes),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory JobsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JobsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      hourlyRateMinorUnits: serializer.fromJson<int>(
        json['hourlyRateMinorUnits'],
      ),
      payRuleSetId: serializer.fromJson<String?>(json['payRuleSetId']),
      holidayRuleSetId: serializer.fromJson<String?>(json['holidayRuleSetId']),
      defaultSleepLeadMinutes: serializer.fromJson<int?>(
        json['defaultSleepLeadMinutes'],
      ),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String>(colorHex),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'hourlyRateMinorUnits': serializer.toJson<int>(hourlyRateMinorUnits),
      'payRuleSetId': serializer.toJson<String?>(payRuleSetId),
      'holidayRuleSetId': serializer.toJson<String?>(holidayRuleSetId),
      'defaultSleepLeadMinutes': serializer.toJson<int?>(
        defaultSleepLeadMinutes,
      ),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JobsTableData copyWith({
    String? id,
    String? name,
    String? colorHex,
    String? currencyCode,
    int? hourlyRateMinorUnits,
    Value<String?> payRuleSetId = const Value.absent(),
    Value<String?> holidayRuleSetId = const Value.absent(),
    Value<int?> defaultSleepLeadMinutes = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => JobsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    colorHex: colorHex ?? this.colorHex,
    currencyCode: currencyCode ?? this.currencyCode,
    hourlyRateMinorUnits: hourlyRateMinorUnits ?? this.hourlyRateMinorUnits,
    payRuleSetId: payRuleSetId.present ? payRuleSetId.value : this.payRuleSetId,
    holidayRuleSetId: holidayRuleSetId.present
        ? holidayRuleSetId.value
        : this.holidayRuleSetId,
    defaultSleepLeadMinutes: defaultSleepLeadMinutes.present
        ? defaultSleepLeadMinutes.value
        : this.defaultSleepLeadMinutes,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  JobsTableData copyWithCompanion(JobsTableCompanion data) {
    return JobsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      hourlyRateMinorUnits: data.hourlyRateMinorUnits.present
          ? data.hourlyRateMinorUnits.value
          : this.hourlyRateMinorUnits,
      payRuleSetId: data.payRuleSetId.present
          ? data.payRuleSetId.value
          : this.payRuleSetId,
      holidayRuleSetId: data.holidayRuleSetId.present
          ? data.holidayRuleSetId.value
          : this.holidayRuleSetId,
      defaultSleepLeadMinutes: data.defaultSleepLeadMinutes.present
          ? data.defaultSleepLeadMinutes.value
          : this.defaultSleepLeadMinutes,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JobsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('hourlyRateMinorUnits: $hourlyRateMinorUnits, ')
          ..write('payRuleSetId: $payRuleSetId, ')
          ..write('holidayRuleSetId: $holidayRuleSetId, ')
          ..write('defaultSleepLeadMinutes: $defaultSleepLeadMinutes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    colorHex,
    currencyCode,
    hourlyRateMinorUnits,
    payRuleSetId,
    holidayRuleSetId,
    defaultSleepLeadMinutes,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JobsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.currencyCode == this.currencyCode &&
          other.hourlyRateMinorUnits == this.hourlyRateMinorUnits &&
          other.payRuleSetId == this.payRuleSetId &&
          other.holidayRuleSetId == this.holidayRuleSetId &&
          other.defaultSleepLeadMinutes == this.defaultSleepLeadMinutes &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JobsTableCompanion extends UpdateCompanion<JobsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> colorHex;
  final Value<String> currencyCode;
  final Value<int> hourlyRateMinorUnits;
  final Value<String?> payRuleSetId;
  final Value<String?> holidayRuleSetId;
  final Value<int?> defaultSleepLeadMinutes;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const JobsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.hourlyRateMinorUnits = const Value.absent(),
    this.payRuleSetId = const Value.absent(),
    this.holidayRuleSetId = const Value.absent(),
    this.defaultSleepLeadMinutes = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JobsTableCompanion.insert({
    required String id,
    required String name,
    required String colorHex,
    required String currencyCode,
    required int hourlyRateMinorUnits,
    this.payRuleSetId = const Value.absent(),
    this.holidayRuleSetId = const Value.absent(),
    this.defaultSleepLeadMinutes = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorHex = Value(colorHex),
       currencyCode = Value(currencyCode),
       hourlyRateMinorUnits = Value(hourlyRateMinorUnits),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<JobsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<String>? currencyCode,
    Expression<int>? hourlyRateMinorUnits,
    Expression<String>? payRuleSetId,
    Expression<String>? holidayRuleSetId,
    Expression<int>? defaultSleepLeadMinutes,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (hourlyRateMinorUnits != null)
        'hourly_rate_minor_units': hourlyRateMinorUnits,
      if (payRuleSetId != null) 'pay_rule_set_id': payRuleSetId,
      if (holidayRuleSetId != null) 'holiday_rule_set_id': holidayRuleSetId,
      if (defaultSleepLeadMinutes != null)
        'default_sleep_lead_minutes': defaultSleepLeadMinutes,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JobsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? colorHex,
    Value<String>? currencyCode,
    Value<int>? hourlyRateMinorUnits,
    Value<String?>? payRuleSetId,
    Value<String?>? holidayRuleSetId,
    Value<int?>? defaultSleepLeadMinutes,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return JobsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      currencyCode: currencyCode ?? this.currencyCode,
      hourlyRateMinorUnits: hourlyRateMinorUnits ?? this.hourlyRateMinorUnits,
      payRuleSetId: payRuleSetId ?? this.payRuleSetId,
      holidayRuleSetId: holidayRuleSetId ?? this.holidayRuleSetId,
      defaultSleepLeadMinutes:
          defaultSleepLeadMinutes ?? this.defaultSleepLeadMinutes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (hourlyRateMinorUnits.present) {
      map['hourly_rate_minor_units'] = Variable<int>(
        hourlyRateMinorUnits.value,
      );
    }
    if (payRuleSetId.present) {
      map['pay_rule_set_id'] = Variable<String>(payRuleSetId.value);
    }
    if (holidayRuleSetId.present) {
      map['holiday_rule_set_id'] = Variable<String>(holidayRuleSetId.value);
    }
    if (defaultSleepLeadMinutes.present) {
      map['default_sleep_lead_minutes'] = Variable<int>(
        defaultSleepLeadMinutes.value,
      );
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JobsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('hourlyRateMinorUnits: $hourlyRateMinorUnits, ')
          ..write('payRuleSetId: $payRuleSetId, ')
          ..write('holidayRuleSetId: $holidayRuleSetId, ')
          ..write('defaultSleepLeadMinutes: $defaultSleepLeadMinutes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayRuleSetsTableTable extends PayRuleSetsTable
    with TableInfo<$PayRuleSetsTableTable, PayRuleSetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayRuleSetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jobs_table (id)',
    ),
  );
  static const VerificationMeta _overtimeThresholdDailyMinutesMeta =
      const VerificationMeta('overtimeThresholdDailyMinutes');
  @override
  late final GeneratedColumn<int> overtimeThresholdDailyMinutes =
      GeneratedColumn<int>(
        'overtime_threshold_daily_minutes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _overtimeThresholdWeeklyMinutesMeta =
      const VerificationMeta('overtimeThresholdWeeklyMinutes');
  @override
  late final GeneratedColumn<int> overtimeThresholdWeeklyMinutes =
      GeneratedColumn<int>(
        'overtime_threshold_weekly_minutes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _overtimeMultiplierBpsMeta =
      const VerificationMeta('overtimeMultiplierBps');
  @override
  late final GeneratedColumn<int> overtimeMultiplierBps = GeneratedColumn<int>(
    'overtime_multiplier_bps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doubleTimeThresholdMinutesMeta =
      const VerificationMeta('doubleTimeThresholdMinutes');
  @override
  late final GeneratedColumn<int> doubleTimeThresholdMinutes =
      GeneratedColumn<int>(
        'double_time_threshold_minutes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _doubleTimeMultiplierBpsMeta =
      const VerificationMeta('doubleTimeMultiplierBps');
  @override
  late final GeneratedColumn<int> doubleTimeMultiplierBps =
      GeneratedColumn<int>(
        'double_time_multiplier_bps',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _roundRuleMeta = const VerificationMeta(
    'roundRule',
  );
  @override
  late final GeneratedColumn<String> roundRule = GeneratedColumn<String>(
    'round_rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobId,
    overtimeThresholdDailyMinutes,
    overtimeThresholdWeeklyMinutes,
    overtimeMultiplierBps,
    doubleTimeThresholdMinutes,
    doubleTimeMultiplierBps,
    roundRule,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pay_rule_sets_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PayRuleSetsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('overtime_threshold_daily_minutes')) {
      context.handle(
        _overtimeThresholdDailyMinutesMeta,
        overtimeThresholdDailyMinutes.isAcceptableOrUnknown(
          data['overtime_threshold_daily_minutes']!,
          _overtimeThresholdDailyMinutesMeta,
        ),
      );
    }
    if (data.containsKey('overtime_threshold_weekly_minutes')) {
      context.handle(
        _overtimeThresholdWeeklyMinutesMeta,
        overtimeThresholdWeeklyMinutes.isAcceptableOrUnknown(
          data['overtime_threshold_weekly_minutes']!,
          _overtimeThresholdWeeklyMinutesMeta,
        ),
      );
    }
    if (data.containsKey('overtime_multiplier_bps')) {
      context.handle(
        _overtimeMultiplierBpsMeta,
        overtimeMultiplierBps.isAcceptableOrUnknown(
          data['overtime_multiplier_bps']!,
          _overtimeMultiplierBpsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_overtimeMultiplierBpsMeta);
    }
    if (data.containsKey('double_time_threshold_minutes')) {
      context.handle(
        _doubleTimeThresholdMinutesMeta,
        doubleTimeThresholdMinutes.isAcceptableOrUnknown(
          data['double_time_threshold_minutes']!,
          _doubleTimeThresholdMinutesMeta,
        ),
      );
    }
    if (data.containsKey('double_time_multiplier_bps')) {
      context.handle(
        _doubleTimeMultiplierBpsMeta,
        doubleTimeMultiplierBps.isAcceptableOrUnknown(
          data['double_time_multiplier_bps']!,
          _doubleTimeMultiplierBpsMeta,
        ),
      );
    }
    if (data.containsKey('round_rule')) {
      context.handle(
        _roundRuleMeta,
        roundRule.isAcceptableOrUnknown(data['round_rule']!, _roundRuleMeta),
      );
    } else if (isInserting) {
      context.missing(_roundRuleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayRuleSetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayRuleSetsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      overtimeThresholdDailyMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overtime_threshold_daily_minutes'],
      ),
      overtimeThresholdWeeklyMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overtime_threshold_weekly_minutes'],
      ),
      overtimeMultiplierBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overtime_multiplier_bps'],
      )!,
      doubleTimeThresholdMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}double_time_threshold_minutes'],
      ),
      doubleTimeMultiplierBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}double_time_multiplier_bps'],
      ),
      roundRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}round_rule'],
      )!,
    );
  }

  @override
  $PayRuleSetsTableTable createAlias(String alias) {
    return $PayRuleSetsTableTable(attachedDatabase, alias);
  }
}

class PayRuleSetsTableData extends DataClass
    implements Insertable<PayRuleSetsTableData> {
  final String id;
  final String jobId;
  final int? overtimeThresholdDailyMinutes;
  final int? overtimeThresholdWeeklyMinutes;
  final int overtimeMultiplierBps;
  final int? doubleTimeThresholdMinutes;
  final int? doubleTimeMultiplierBps;
  final String roundRule;
  const PayRuleSetsTableData({
    required this.id,
    required this.jobId,
    this.overtimeThresholdDailyMinutes,
    this.overtimeThresholdWeeklyMinutes,
    required this.overtimeMultiplierBps,
    this.doubleTimeThresholdMinutes,
    this.doubleTimeMultiplierBps,
    required this.roundRule,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    if (!nullToAbsent || overtimeThresholdDailyMinutes != null) {
      map['overtime_threshold_daily_minutes'] = Variable<int>(
        overtimeThresholdDailyMinutes,
      );
    }
    if (!nullToAbsent || overtimeThresholdWeeklyMinutes != null) {
      map['overtime_threshold_weekly_minutes'] = Variable<int>(
        overtimeThresholdWeeklyMinutes,
      );
    }
    map['overtime_multiplier_bps'] = Variable<int>(overtimeMultiplierBps);
    if (!nullToAbsent || doubleTimeThresholdMinutes != null) {
      map['double_time_threshold_minutes'] = Variable<int>(
        doubleTimeThresholdMinutes,
      );
    }
    if (!nullToAbsent || doubleTimeMultiplierBps != null) {
      map['double_time_multiplier_bps'] = Variable<int>(
        doubleTimeMultiplierBps,
      );
    }
    map['round_rule'] = Variable<String>(roundRule);
    return map;
  }

  PayRuleSetsTableCompanion toCompanion(bool nullToAbsent) {
    return PayRuleSetsTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      overtimeThresholdDailyMinutes:
          overtimeThresholdDailyMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(overtimeThresholdDailyMinutes),
      overtimeThresholdWeeklyMinutes:
          overtimeThresholdWeeklyMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(overtimeThresholdWeeklyMinutes),
      overtimeMultiplierBps: Value(overtimeMultiplierBps),
      doubleTimeThresholdMinutes:
          doubleTimeThresholdMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(doubleTimeThresholdMinutes),
      doubleTimeMultiplierBps: doubleTimeMultiplierBps == null && nullToAbsent
          ? const Value.absent()
          : Value(doubleTimeMultiplierBps),
      roundRule: Value(roundRule),
    );
  }

  factory PayRuleSetsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayRuleSetsTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      overtimeThresholdDailyMinutes: serializer.fromJson<int?>(
        json['overtimeThresholdDailyMinutes'],
      ),
      overtimeThresholdWeeklyMinutes: serializer.fromJson<int?>(
        json['overtimeThresholdWeeklyMinutes'],
      ),
      overtimeMultiplierBps: serializer.fromJson<int>(
        json['overtimeMultiplierBps'],
      ),
      doubleTimeThresholdMinutes: serializer.fromJson<int?>(
        json['doubleTimeThresholdMinutes'],
      ),
      doubleTimeMultiplierBps: serializer.fromJson<int?>(
        json['doubleTimeMultiplierBps'],
      ),
      roundRule: serializer.fromJson<String>(json['roundRule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'overtimeThresholdDailyMinutes': serializer.toJson<int?>(
        overtimeThresholdDailyMinutes,
      ),
      'overtimeThresholdWeeklyMinutes': serializer.toJson<int?>(
        overtimeThresholdWeeklyMinutes,
      ),
      'overtimeMultiplierBps': serializer.toJson<int>(overtimeMultiplierBps),
      'doubleTimeThresholdMinutes': serializer.toJson<int?>(
        doubleTimeThresholdMinutes,
      ),
      'doubleTimeMultiplierBps': serializer.toJson<int?>(
        doubleTimeMultiplierBps,
      ),
      'roundRule': serializer.toJson<String>(roundRule),
    };
  }

  PayRuleSetsTableData copyWith({
    String? id,
    String? jobId,
    Value<int?> overtimeThresholdDailyMinutes = const Value.absent(),
    Value<int?> overtimeThresholdWeeklyMinutes = const Value.absent(),
    int? overtimeMultiplierBps,
    Value<int?> doubleTimeThresholdMinutes = const Value.absent(),
    Value<int?> doubleTimeMultiplierBps = const Value.absent(),
    String? roundRule,
  }) => PayRuleSetsTableData(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    overtimeThresholdDailyMinutes: overtimeThresholdDailyMinutes.present
        ? overtimeThresholdDailyMinutes.value
        : this.overtimeThresholdDailyMinutes,
    overtimeThresholdWeeklyMinutes: overtimeThresholdWeeklyMinutes.present
        ? overtimeThresholdWeeklyMinutes.value
        : this.overtimeThresholdWeeklyMinutes,
    overtimeMultiplierBps: overtimeMultiplierBps ?? this.overtimeMultiplierBps,
    doubleTimeThresholdMinutes: doubleTimeThresholdMinutes.present
        ? doubleTimeThresholdMinutes.value
        : this.doubleTimeThresholdMinutes,
    doubleTimeMultiplierBps: doubleTimeMultiplierBps.present
        ? doubleTimeMultiplierBps.value
        : this.doubleTimeMultiplierBps,
    roundRule: roundRule ?? this.roundRule,
  );
  PayRuleSetsTableData copyWithCompanion(PayRuleSetsTableCompanion data) {
    return PayRuleSetsTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      overtimeThresholdDailyMinutes: data.overtimeThresholdDailyMinutes.present
          ? data.overtimeThresholdDailyMinutes.value
          : this.overtimeThresholdDailyMinutes,
      overtimeThresholdWeeklyMinutes:
          data.overtimeThresholdWeeklyMinutes.present
          ? data.overtimeThresholdWeeklyMinutes.value
          : this.overtimeThresholdWeeklyMinutes,
      overtimeMultiplierBps: data.overtimeMultiplierBps.present
          ? data.overtimeMultiplierBps.value
          : this.overtimeMultiplierBps,
      doubleTimeThresholdMinutes: data.doubleTimeThresholdMinutes.present
          ? data.doubleTimeThresholdMinutes.value
          : this.doubleTimeThresholdMinutes,
      doubleTimeMultiplierBps: data.doubleTimeMultiplierBps.present
          ? data.doubleTimeMultiplierBps.value
          : this.doubleTimeMultiplierBps,
      roundRule: data.roundRule.present ? data.roundRule.value : this.roundRule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayRuleSetsTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write(
            'overtimeThresholdDailyMinutes: $overtimeThresholdDailyMinutes, ',
          )
          ..write(
            'overtimeThresholdWeeklyMinutes: $overtimeThresholdWeeklyMinutes, ',
          )
          ..write('overtimeMultiplierBps: $overtimeMultiplierBps, ')
          ..write('doubleTimeThresholdMinutes: $doubleTimeThresholdMinutes, ')
          ..write('doubleTimeMultiplierBps: $doubleTimeMultiplierBps, ')
          ..write('roundRule: $roundRule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jobId,
    overtimeThresholdDailyMinutes,
    overtimeThresholdWeeklyMinutes,
    overtimeMultiplierBps,
    doubleTimeThresholdMinutes,
    doubleTimeMultiplierBps,
    roundRule,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayRuleSetsTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.overtimeThresholdDailyMinutes ==
              this.overtimeThresholdDailyMinutes &&
          other.overtimeThresholdWeeklyMinutes ==
              this.overtimeThresholdWeeklyMinutes &&
          other.overtimeMultiplierBps == this.overtimeMultiplierBps &&
          other.doubleTimeThresholdMinutes == this.doubleTimeThresholdMinutes &&
          other.doubleTimeMultiplierBps == this.doubleTimeMultiplierBps &&
          other.roundRule == this.roundRule);
}

class PayRuleSetsTableCompanion extends UpdateCompanion<PayRuleSetsTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<int?> overtimeThresholdDailyMinutes;
  final Value<int?> overtimeThresholdWeeklyMinutes;
  final Value<int> overtimeMultiplierBps;
  final Value<int?> doubleTimeThresholdMinutes;
  final Value<int?> doubleTimeMultiplierBps;
  final Value<String> roundRule;
  final Value<int> rowid;
  const PayRuleSetsTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.overtimeThresholdDailyMinutes = const Value.absent(),
    this.overtimeThresholdWeeklyMinutes = const Value.absent(),
    this.overtimeMultiplierBps = const Value.absent(),
    this.doubleTimeThresholdMinutes = const Value.absent(),
    this.doubleTimeMultiplierBps = const Value.absent(),
    this.roundRule = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayRuleSetsTableCompanion.insert({
    required String id,
    required String jobId,
    this.overtimeThresholdDailyMinutes = const Value.absent(),
    this.overtimeThresholdWeeklyMinutes = const Value.absent(),
    required int overtimeMultiplierBps,
    this.doubleTimeThresholdMinutes = const Value.absent(),
    this.doubleTimeMultiplierBps = const Value.absent(),
    required String roundRule,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       overtimeMultiplierBps = Value(overtimeMultiplierBps),
       roundRule = Value(roundRule);
  static Insertable<PayRuleSetsTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<int>? overtimeThresholdDailyMinutes,
    Expression<int>? overtimeThresholdWeeklyMinutes,
    Expression<int>? overtimeMultiplierBps,
    Expression<int>? doubleTimeThresholdMinutes,
    Expression<int>? doubleTimeMultiplierBps,
    Expression<String>? roundRule,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (overtimeThresholdDailyMinutes != null)
        'overtime_threshold_daily_minutes': overtimeThresholdDailyMinutes,
      if (overtimeThresholdWeeklyMinutes != null)
        'overtime_threshold_weekly_minutes': overtimeThresholdWeeklyMinutes,
      if (overtimeMultiplierBps != null)
        'overtime_multiplier_bps': overtimeMultiplierBps,
      if (doubleTimeThresholdMinutes != null)
        'double_time_threshold_minutes': doubleTimeThresholdMinutes,
      if (doubleTimeMultiplierBps != null)
        'double_time_multiplier_bps': doubleTimeMultiplierBps,
      if (roundRule != null) 'round_rule': roundRule,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayRuleSetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<int?>? overtimeThresholdDailyMinutes,
    Value<int?>? overtimeThresholdWeeklyMinutes,
    Value<int>? overtimeMultiplierBps,
    Value<int?>? doubleTimeThresholdMinutes,
    Value<int?>? doubleTimeMultiplierBps,
    Value<String>? roundRule,
    Value<int>? rowid,
  }) {
    return PayRuleSetsTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      overtimeThresholdDailyMinutes:
          overtimeThresholdDailyMinutes ?? this.overtimeThresholdDailyMinutes,
      overtimeThresholdWeeklyMinutes:
          overtimeThresholdWeeklyMinutes ?? this.overtimeThresholdWeeklyMinutes,
      overtimeMultiplierBps:
          overtimeMultiplierBps ?? this.overtimeMultiplierBps,
      doubleTimeThresholdMinutes:
          doubleTimeThresholdMinutes ?? this.doubleTimeThresholdMinutes,
      doubleTimeMultiplierBps:
          doubleTimeMultiplierBps ?? this.doubleTimeMultiplierBps,
      roundRule: roundRule ?? this.roundRule,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (overtimeThresholdDailyMinutes.present) {
      map['overtime_threshold_daily_minutes'] = Variable<int>(
        overtimeThresholdDailyMinutes.value,
      );
    }
    if (overtimeThresholdWeeklyMinutes.present) {
      map['overtime_threshold_weekly_minutes'] = Variable<int>(
        overtimeThresholdWeeklyMinutes.value,
      );
    }
    if (overtimeMultiplierBps.present) {
      map['overtime_multiplier_bps'] = Variable<int>(
        overtimeMultiplierBps.value,
      );
    }
    if (doubleTimeThresholdMinutes.present) {
      map['double_time_threshold_minutes'] = Variable<int>(
        doubleTimeThresholdMinutes.value,
      );
    }
    if (doubleTimeMultiplierBps.present) {
      map['double_time_multiplier_bps'] = Variable<int>(
        doubleTimeMultiplierBps.value,
      );
    }
    if (roundRule.present) {
      map['round_rule'] = Variable<String>(roundRule.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayRuleSetsTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write(
            'overtimeThresholdDailyMinutes: $overtimeThresholdDailyMinutes, ',
          )
          ..write(
            'overtimeThresholdWeeklyMinutes: $overtimeThresholdWeeklyMinutes, ',
          )
          ..write('overtimeMultiplierBps: $overtimeMultiplierBps, ')
          ..write('doubleTimeThresholdMinutes: $doubleTimeThresholdMinutes, ')
          ..write('doubleTimeMultiplierBps: $doubleTimeMultiplierBps, ')
          ..write('roundRule: $roundRule, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AdvancedPayRuleSetsTableTable extends AdvancedPayRuleSetsTable
    with
        TableInfo<
          $AdvancedPayRuleSetsTableTable,
          AdvancedPayRuleSetsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdvancedPayRuleSetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jobs_table (id)',
    ),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobId,
    enabled,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'advanced_pay_rule_sets_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdvancedPayRuleSetsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdvancedPayRuleSetsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdvancedPayRuleSetsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AdvancedPayRuleSetsTableTable createAlias(String alias) {
    return $AdvancedPayRuleSetsTableTable(attachedDatabase, alias);
  }
}

class AdvancedPayRuleSetsTableData extends DataClass
    implements Insertable<AdvancedPayRuleSetsTableData> {
  final String id;
  final String jobId;
  final bool enabled;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AdvancedPayRuleSetsTableData({
    required this.id,
    required this.jobId,
    required this.enabled,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['enabled'] = Variable<bool>(enabled);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AdvancedPayRuleSetsTableCompanion toCompanion(bool nullToAbsent) {
    return AdvancedPayRuleSetsTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      enabled: Value(enabled),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AdvancedPayRuleSetsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdvancedPayRuleSetsTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'enabled': serializer.toJson<bool>(enabled),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AdvancedPayRuleSetsTableData copyWith({
    String? id,
    String? jobId,
    bool? enabled,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AdvancedPayRuleSetsTableData(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    enabled: enabled ?? this.enabled,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AdvancedPayRuleSetsTableData copyWithCompanion(
    AdvancedPayRuleSetsTableCompanion data,
  ) {
    return AdvancedPayRuleSetsTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdvancedPayRuleSetsTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('enabled: $enabled, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, jobId, enabled, version, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdvancedPayRuleSetsTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.enabled == this.enabled &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AdvancedPayRuleSetsTableCompanion
    extends UpdateCompanion<AdvancedPayRuleSetsTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<bool> enabled;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AdvancedPayRuleSetsTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AdvancedPayRuleSetsTableCompanion.insert({
    required String id,
    required String jobId,
    this.enabled = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AdvancedPayRuleSetsTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<bool>? enabled,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (enabled != null) 'enabled': enabled,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AdvancedPayRuleSetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<bool>? enabled,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AdvancedPayRuleSetsTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      enabled: enabled ?? this.enabled,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdvancedPayRuleSetsTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('enabled: $enabled, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OvertimeTierRulesTableTable extends OvertimeTierRulesTable
    with TableInfo<$OvertimeTierRulesTableTable, OvertimeTierRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OvertimeTierRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _advancedPayRuleSetIdMeta =
      const VerificationMeta('advancedPayRuleSetId');
  @override
  late final GeneratedColumn<String> advancedPayRuleSetId =
      GeneratedColumn<String>(
        'advanced_pay_rule_set_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES advanced_pay_rule_sets_table (id)',
        ),
      );
  static const VerificationMeta _periodTypeMeta = const VerificationMeta(
    'periodType',
  );
  @override
  late final GeneratedColumn<String> periodType = GeneratedColumn<String>(
    'period_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thresholdMinutesMeta = const VerificationMeta(
    'thresholdMinutes',
  );
  @override
  late final GeneratedColumn<int> thresholdMinutes = GeneratedColumn<int>(
    'threshold_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _multiplierBpsMeta = const VerificationMeta(
    'multiplierBps',
  );
  @override
  late final GeneratedColumn<int> multiplierBps = GeneratedColumn<int>(
    'multiplier_bps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    advancedPayRuleSetId,
    periodType,
    thresholdMinutes,
    multiplierBps,
    priority,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'overtime_tier_rules_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OvertimeTierRulesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('advanced_pay_rule_set_id')) {
      context.handle(
        _advancedPayRuleSetIdMeta,
        advancedPayRuleSetId.isAcceptableOrUnknown(
          data['advanced_pay_rule_set_id']!,
          _advancedPayRuleSetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_advancedPayRuleSetIdMeta);
    }
    if (data.containsKey('period_type')) {
      context.handle(
        _periodTypeMeta,
        periodType.isAcceptableOrUnknown(data['period_type']!, _periodTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_periodTypeMeta);
    }
    if (data.containsKey('threshold_minutes')) {
      context.handle(
        _thresholdMinutesMeta,
        thresholdMinutes.isAcceptableOrUnknown(
          data['threshold_minutes']!,
          _thresholdMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_thresholdMinutesMeta);
    }
    if (data.containsKey('multiplier_bps')) {
      context.handle(
        _multiplierBpsMeta,
        multiplierBps.isAcceptableOrUnknown(
          data['multiplier_bps']!,
          _multiplierBpsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_multiplierBpsMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OvertimeTierRulesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OvertimeTierRulesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      advancedPayRuleSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}advanced_pay_rule_set_id'],
      )!,
      periodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_type'],
      )!,
      thresholdMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}threshold_minutes'],
      )!,
      multiplierBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}multiplier_bps'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $OvertimeTierRulesTableTable createAlias(String alias) {
    return $OvertimeTierRulesTableTable(attachedDatabase, alias);
  }
}

class OvertimeTierRulesTableData extends DataClass
    implements Insertable<OvertimeTierRulesTableData> {
  final String id;
  final String advancedPayRuleSetId;
  final String periodType;
  final int thresholdMinutes;
  final int multiplierBps;
  final int priority;
  final bool enabled;
  const OvertimeTierRulesTableData({
    required this.id,
    required this.advancedPayRuleSetId,
    required this.periodType,
    required this.thresholdMinutes,
    required this.multiplierBps,
    required this.priority,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['advanced_pay_rule_set_id'] = Variable<String>(advancedPayRuleSetId);
    map['period_type'] = Variable<String>(periodType);
    map['threshold_minutes'] = Variable<int>(thresholdMinutes);
    map['multiplier_bps'] = Variable<int>(multiplierBps);
    map['priority'] = Variable<int>(priority);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  OvertimeTierRulesTableCompanion toCompanion(bool nullToAbsent) {
    return OvertimeTierRulesTableCompanion(
      id: Value(id),
      advancedPayRuleSetId: Value(advancedPayRuleSetId),
      periodType: Value(periodType),
      thresholdMinutes: Value(thresholdMinutes),
      multiplierBps: Value(multiplierBps),
      priority: Value(priority),
      enabled: Value(enabled),
    );
  }

  factory OvertimeTierRulesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OvertimeTierRulesTableData(
      id: serializer.fromJson<String>(json['id']),
      advancedPayRuleSetId: serializer.fromJson<String>(
        json['advancedPayRuleSetId'],
      ),
      periodType: serializer.fromJson<String>(json['periodType']),
      thresholdMinutes: serializer.fromJson<int>(json['thresholdMinutes']),
      multiplierBps: serializer.fromJson<int>(json['multiplierBps']),
      priority: serializer.fromJson<int>(json['priority']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'advancedPayRuleSetId': serializer.toJson<String>(advancedPayRuleSetId),
      'periodType': serializer.toJson<String>(periodType),
      'thresholdMinutes': serializer.toJson<int>(thresholdMinutes),
      'multiplierBps': serializer.toJson<int>(multiplierBps),
      'priority': serializer.toJson<int>(priority),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  OvertimeTierRulesTableData copyWith({
    String? id,
    String? advancedPayRuleSetId,
    String? periodType,
    int? thresholdMinutes,
    int? multiplierBps,
    int? priority,
    bool? enabled,
  }) => OvertimeTierRulesTableData(
    id: id ?? this.id,
    advancedPayRuleSetId: advancedPayRuleSetId ?? this.advancedPayRuleSetId,
    periodType: periodType ?? this.periodType,
    thresholdMinutes: thresholdMinutes ?? this.thresholdMinutes,
    multiplierBps: multiplierBps ?? this.multiplierBps,
    priority: priority ?? this.priority,
    enabled: enabled ?? this.enabled,
  );
  OvertimeTierRulesTableData copyWithCompanion(
    OvertimeTierRulesTableCompanion data,
  ) {
    return OvertimeTierRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      advancedPayRuleSetId: data.advancedPayRuleSetId.present
          ? data.advancedPayRuleSetId.value
          : this.advancedPayRuleSetId,
      periodType: data.periodType.present
          ? data.periodType.value
          : this.periodType,
      thresholdMinutes: data.thresholdMinutes.present
          ? data.thresholdMinutes.value
          : this.thresholdMinutes,
      multiplierBps: data.multiplierBps.present
          ? data.multiplierBps.value
          : this.multiplierBps,
      priority: data.priority.present ? data.priority.value : this.priority,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OvertimeTierRulesTableData(')
          ..write('id: $id, ')
          ..write('advancedPayRuleSetId: $advancedPayRuleSetId, ')
          ..write('periodType: $periodType, ')
          ..write('thresholdMinutes: $thresholdMinutes, ')
          ..write('multiplierBps: $multiplierBps, ')
          ..write('priority: $priority, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    advancedPayRuleSetId,
    periodType,
    thresholdMinutes,
    multiplierBps,
    priority,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OvertimeTierRulesTableData &&
          other.id == this.id &&
          other.advancedPayRuleSetId == this.advancedPayRuleSetId &&
          other.periodType == this.periodType &&
          other.thresholdMinutes == this.thresholdMinutes &&
          other.multiplierBps == this.multiplierBps &&
          other.priority == this.priority &&
          other.enabled == this.enabled);
}

class OvertimeTierRulesTableCompanion
    extends UpdateCompanion<OvertimeTierRulesTableData> {
  final Value<String> id;
  final Value<String> advancedPayRuleSetId;
  final Value<String> periodType;
  final Value<int> thresholdMinutes;
  final Value<int> multiplierBps;
  final Value<int> priority;
  final Value<bool> enabled;
  final Value<int> rowid;
  const OvertimeTierRulesTableCompanion({
    this.id = const Value.absent(),
    this.advancedPayRuleSetId = const Value.absent(),
    this.periodType = const Value.absent(),
    this.thresholdMinutes = const Value.absent(),
    this.multiplierBps = const Value.absent(),
    this.priority = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OvertimeTierRulesTableCompanion.insert({
    required String id,
    required String advancedPayRuleSetId,
    required String periodType,
    required int thresholdMinutes,
    required int multiplierBps,
    required int priority,
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       advancedPayRuleSetId = Value(advancedPayRuleSetId),
       periodType = Value(periodType),
       thresholdMinutes = Value(thresholdMinutes),
       multiplierBps = Value(multiplierBps),
       priority = Value(priority);
  static Insertable<OvertimeTierRulesTableData> custom({
    Expression<String>? id,
    Expression<String>? advancedPayRuleSetId,
    Expression<String>? periodType,
    Expression<int>? thresholdMinutes,
    Expression<int>? multiplierBps,
    Expression<int>? priority,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (advancedPayRuleSetId != null)
        'advanced_pay_rule_set_id': advancedPayRuleSetId,
      if (periodType != null) 'period_type': periodType,
      if (thresholdMinutes != null) 'threshold_minutes': thresholdMinutes,
      if (multiplierBps != null) 'multiplier_bps': multiplierBps,
      if (priority != null) 'priority': priority,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OvertimeTierRulesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? advancedPayRuleSetId,
    Value<String>? periodType,
    Value<int>? thresholdMinutes,
    Value<int>? multiplierBps,
    Value<int>? priority,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return OvertimeTierRulesTableCompanion(
      id: id ?? this.id,
      advancedPayRuleSetId: advancedPayRuleSetId ?? this.advancedPayRuleSetId,
      periodType: periodType ?? this.periodType,
      thresholdMinutes: thresholdMinutes ?? this.thresholdMinutes,
      multiplierBps: multiplierBps ?? this.multiplierBps,
      priority: priority ?? this.priority,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (advancedPayRuleSetId.present) {
      map['advanced_pay_rule_set_id'] = Variable<String>(
        advancedPayRuleSetId.value,
      );
    }
    if (periodType.present) {
      map['period_type'] = Variable<String>(periodType.value);
    }
    if (thresholdMinutes.present) {
      map['threshold_minutes'] = Variable<int>(thresholdMinutes.value);
    }
    if (multiplierBps.present) {
      map['multiplier_bps'] = Variable<int>(multiplierBps.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OvertimeTierRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('advancedPayRuleSetId: $advancedPayRuleSetId, ')
          ..write('periodType: $periodType, ')
          ..write('thresholdMinutes: $thresholdMinutes, ')
          ..write('multiplierBps: $multiplierBps, ')
          ..write('priority: $priority, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftTemplatesTableTable extends ShiftTemplatesTable
    with TableInfo<$ShiftTemplatesTableTable, ShiftTemplatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftTemplatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jobs_table (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesLocalMeta = const VerificationMeta(
    'startMinutesLocal',
  );
  @override
  late final GeneratedColumn<int> startMinutesLocal = GeneratedColumn<int>(
    'start_minutes_local',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinutesLocalMeta = const VerificationMeta(
    'endMinutesLocal',
  );
  @override
  late final GeneratedColumn<int> endMinutesLocal = GeneratedColumn<int>(
    'end_minutes_local',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unpaidBreakMinutesMeta =
      const VerificationMeta('unpaidBreakMinutes');
  @override
  late final GeneratedColumn<int> unpaidBreakMinutes = GeneratedColumn<int>(
    'unpaid_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultNoteMeta = const VerificationMeta(
    'defaultNote',
  );
  @override
  late final GeneratedColumn<String> defaultNote = GeneratedColumn<String>(
    'default_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobId,
    name,
    startMinutesLocal,
    endMinutesLocal,
    unpaidBreakMinutes,
    category,
    defaultNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_templates_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftTemplatesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_minutes_local')) {
      context.handle(
        _startMinutesLocalMeta,
        startMinutesLocal.isAcceptableOrUnknown(
          data['start_minutes_local']!,
          _startMinutesLocalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinutesLocalMeta);
    }
    if (data.containsKey('end_minutes_local')) {
      context.handle(
        _endMinutesLocalMeta,
        endMinutesLocal.isAcceptableOrUnknown(
          data['end_minutes_local']!,
          _endMinutesLocalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_endMinutesLocalMeta);
    }
    if (data.containsKey('unpaid_break_minutes')) {
      context.handle(
        _unpaidBreakMinutesMeta,
        unpaidBreakMinutes.isAcceptableOrUnknown(
          data['unpaid_break_minutes']!,
          _unpaidBreakMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unpaidBreakMinutesMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('default_note')) {
      context.handle(
        _defaultNoteMeta,
        defaultNote.isAcceptableOrUnknown(
          data['default_note']!,
          _defaultNoteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftTemplatesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftTemplatesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startMinutesLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes_local'],
      )!,
      endMinutesLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes_local'],
      )!,
      unpaidBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unpaid_break_minutes'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      defaultNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_note'],
      ),
    );
  }

  @override
  $ShiftTemplatesTableTable createAlias(String alias) {
    return $ShiftTemplatesTableTable(attachedDatabase, alias);
  }
}

class ShiftTemplatesTableData extends DataClass
    implements Insertable<ShiftTemplatesTableData> {
  final String id;
  final String jobId;
  final String name;
  final int startMinutesLocal;
  final int endMinutesLocal;
  final int unpaidBreakMinutes;
  final String category;
  final String? defaultNote;
  const ShiftTemplatesTableData({
    required this.id,
    required this.jobId,
    required this.name,
    required this.startMinutesLocal,
    required this.endMinutesLocal,
    required this.unpaidBreakMinutes,
    required this.category,
    this.defaultNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['name'] = Variable<String>(name);
    map['start_minutes_local'] = Variable<int>(startMinutesLocal);
    map['end_minutes_local'] = Variable<int>(endMinutesLocal);
    map['unpaid_break_minutes'] = Variable<int>(unpaidBreakMinutes);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || defaultNote != null) {
      map['default_note'] = Variable<String>(defaultNote);
    }
    return map;
  }

  ShiftTemplatesTableCompanion toCompanion(bool nullToAbsent) {
    return ShiftTemplatesTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      name: Value(name),
      startMinutesLocal: Value(startMinutesLocal),
      endMinutesLocal: Value(endMinutesLocal),
      unpaidBreakMinutes: Value(unpaidBreakMinutes),
      category: Value(category),
      defaultNote: defaultNote == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultNote),
    );
  }

  factory ShiftTemplatesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftTemplatesTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      name: serializer.fromJson<String>(json['name']),
      startMinutesLocal: serializer.fromJson<int>(json['startMinutesLocal']),
      endMinutesLocal: serializer.fromJson<int>(json['endMinutesLocal']),
      unpaidBreakMinutes: serializer.fromJson<int>(json['unpaidBreakMinutes']),
      category: serializer.fromJson<String>(json['category']),
      defaultNote: serializer.fromJson<String?>(json['defaultNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'name': serializer.toJson<String>(name),
      'startMinutesLocal': serializer.toJson<int>(startMinutesLocal),
      'endMinutesLocal': serializer.toJson<int>(endMinutesLocal),
      'unpaidBreakMinutes': serializer.toJson<int>(unpaidBreakMinutes),
      'category': serializer.toJson<String>(category),
      'defaultNote': serializer.toJson<String?>(defaultNote),
    };
  }

  ShiftTemplatesTableData copyWith({
    String? id,
    String? jobId,
    String? name,
    int? startMinutesLocal,
    int? endMinutesLocal,
    int? unpaidBreakMinutes,
    String? category,
    Value<String?> defaultNote = const Value.absent(),
  }) => ShiftTemplatesTableData(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    name: name ?? this.name,
    startMinutesLocal: startMinutesLocal ?? this.startMinutesLocal,
    endMinutesLocal: endMinutesLocal ?? this.endMinutesLocal,
    unpaidBreakMinutes: unpaidBreakMinutes ?? this.unpaidBreakMinutes,
    category: category ?? this.category,
    defaultNote: defaultNote.present ? defaultNote.value : this.defaultNote,
  );
  ShiftTemplatesTableData copyWithCompanion(ShiftTemplatesTableCompanion data) {
    return ShiftTemplatesTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      name: data.name.present ? data.name.value : this.name,
      startMinutesLocal: data.startMinutesLocal.present
          ? data.startMinutesLocal.value
          : this.startMinutesLocal,
      endMinutesLocal: data.endMinutesLocal.present
          ? data.endMinutesLocal.value
          : this.endMinutesLocal,
      unpaidBreakMinutes: data.unpaidBreakMinutes.present
          ? data.unpaidBreakMinutes.value
          : this.unpaidBreakMinutes,
      category: data.category.present ? data.category.value : this.category,
      defaultNote: data.defaultNote.present
          ? data.defaultNote.value
          : this.defaultNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftTemplatesTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('name: $name, ')
          ..write('startMinutesLocal: $startMinutesLocal, ')
          ..write('endMinutesLocal: $endMinutesLocal, ')
          ..write('unpaidBreakMinutes: $unpaidBreakMinutes, ')
          ..write('category: $category, ')
          ..write('defaultNote: $defaultNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jobId,
    name,
    startMinutesLocal,
    endMinutesLocal,
    unpaidBreakMinutes,
    category,
    defaultNote,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftTemplatesTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.name == this.name &&
          other.startMinutesLocal == this.startMinutesLocal &&
          other.endMinutesLocal == this.endMinutesLocal &&
          other.unpaidBreakMinutes == this.unpaidBreakMinutes &&
          other.category == this.category &&
          other.defaultNote == this.defaultNote);
}

class ShiftTemplatesTableCompanion
    extends UpdateCompanion<ShiftTemplatesTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<String> name;
  final Value<int> startMinutesLocal;
  final Value<int> endMinutesLocal;
  final Value<int> unpaidBreakMinutes;
  final Value<String> category;
  final Value<String?> defaultNote;
  final Value<int> rowid;
  const ShiftTemplatesTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.name = const Value.absent(),
    this.startMinutesLocal = const Value.absent(),
    this.endMinutesLocal = const Value.absent(),
    this.unpaidBreakMinutes = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftTemplatesTableCompanion.insert({
    required String id,
    required String jobId,
    required String name,
    required int startMinutesLocal,
    required int endMinutesLocal,
    required int unpaidBreakMinutes,
    required String category,
    this.defaultNote = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       name = Value(name),
       startMinutesLocal = Value(startMinutesLocal),
       endMinutesLocal = Value(endMinutesLocal),
       unpaidBreakMinutes = Value(unpaidBreakMinutes),
       category = Value(category);
  static Insertable<ShiftTemplatesTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<String>? name,
    Expression<int>? startMinutesLocal,
    Expression<int>? endMinutesLocal,
    Expression<int>? unpaidBreakMinutes,
    Expression<String>? category,
    Expression<String>? defaultNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (name != null) 'name': name,
      if (startMinutesLocal != null) 'start_minutes_local': startMinutesLocal,
      if (endMinutesLocal != null) 'end_minutes_local': endMinutesLocal,
      if (unpaidBreakMinutes != null)
        'unpaid_break_minutes': unpaidBreakMinutes,
      if (category != null) 'category': category,
      if (defaultNote != null) 'default_note': defaultNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftTemplatesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<String>? name,
    Value<int>? startMinutesLocal,
    Value<int>? endMinutesLocal,
    Value<int>? unpaidBreakMinutes,
    Value<String>? category,
    Value<String?>? defaultNote,
    Value<int>? rowid,
  }) {
    return ShiftTemplatesTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      name: name ?? this.name,
      startMinutesLocal: startMinutesLocal ?? this.startMinutesLocal,
      endMinutesLocal: endMinutesLocal ?? this.endMinutesLocal,
      unpaidBreakMinutes: unpaidBreakMinutes ?? this.unpaidBreakMinutes,
      category: category ?? this.category,
      defaultNote: defaultNote ?? this.defaultNote,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startMinutesLocal.present) {
      map['start_minutes_local'] = Variable<int>(startMinutesLocal.value);
    }
    if (endMinutesLocal.present) {
      map['end_minutes_local'] = Variable<int>(endMinutesLocal.value);
    }
    if (unpaidBreakMinutes.present) {
      map['unpaid_break_minutes'] = Variable<int>(unpaidBreakMinutes.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (defaultNote.present) {
      map['default_note'] = Variable<String>(defaultNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftTemplatesTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('name: $name, ')
          ..write('startMinutesLocal: $startMinutesLocal, ')
          ..write('endMinutesLocal: $endMinutesLocal, ')
          ..write('unpaidBreakMinutes: $unpaidBreakMinutes, ')
          ..write('category: $category, ')
          ..write('defaultNote: $defaultNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DifferentialRulesTableTable extends DifferentialRulesTable
    with TableInfo<$DifferentialRulesTableTable, DifferentialRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DifferentialRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _advancedPayRuleSetIdMeta =
      const VerificationMeta('advancedPayRuleSetId');
  @override
  late final GeneratedColumn<String> advancedPayRuleSetId =
      GeneratedColumn<String>(
        'advanced_pay_rule_set_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES advanced_pay_rule_sets_table (id)',
        ),
      );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _combinationModeMeta = const VerificationMeta(
    'combinationMode',
  );
  @override
  late final GeneratedColumn<String> combinationMode = GeneratedColumn<String>(
    'combination_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _multiplierBpsMeta = const VerificationMeta(
    'multiplierBps',
  );
  @override
  late final GeneratedColumn<int> multiplierBps = GeneratedColumn<int>(
    'multiplier_bps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flatAmountMinorMeta = const VerificationMeta(
    'flatAmountMinor',
  );
  @override
  late final GeneratedColumn<int> flatAmountMinor = GeneratedColumn<int>(
    'flat_amount_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startMinutesLocalMeta = const VerificationMeta(
    'startMinutesLocal',
  );
  @override
  late final GeneratedColumn<int> startMinutesLocal = GeneratedColumn<int>(
    'start_minutes_local',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMinutesLocalMeta = const VerificationMeta(
    'endMinutesLocal',
  );
  @override
  late final GeneratedColumn<int> endMinutesLocal = GeneratedColumn<int>(
    'end_minutes_local',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appliesOnSaturdayMeta = const VerificationMeta(
    'appliesOnSaturday',
  );
  @override
  late final GeneratedColumn<bool> appliesOnSaturday = GeneratedColumn<bool>(
    'applies_on_saturday',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("applies_on_saturday" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _appliesOnSundayMeta = const VerificationMeta(
    'appliesOnSunday',
  );
  @override
  late final GeneratedColumn<bool> appliesOnSunday = GeneratedColumn<bool>(
    'applies_on_sunday',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("applies_on_sunday" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _shiftTemplateIdMeta = const VerificationMeta(
    'shiftTemplateId',
  );
  @override
  late final GeneratedColumn<String> shiftTemplateId = GeneratedColumn<String>(
    'shift_template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_templates_table (id)',
    ),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    advancedPayRuleSetId,
    type,
    combinationMode,
    multiplierBps,
    flatAmountMinor,
    startMinutesLocal,
    endMinutesLocal,
    appliesOnSaturday,
    appliesOnSunday,
    shiftTemplateId,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'differential_rules_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DifferentialRulesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('advanced_pay_rule_set_id')) {
      context.handle(
        _advancedPayRuleSetIdMeta,
        advancedPayRuleSetId.isAcceptableOrUnknown(
          data['advanced_pay_rule_set_id']!,
          _advancedPayRuleSetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_advancedPayRuleSetIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('combination_mode')) {
      context.handle(
        _combinationModeMeta,
        combinationMode.isAcceptableOrUnknown(
          data['combination_mode']!,
          _combinationModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_combinationModeMeta);
    }
    if (data.containsKey('multiplier_bps')) {
      context.handle(
        _multiplierBpsMeta,
        multiplierBps.isAcceptableOrUnknown(
          data['multiplier_bps']!,
          _multiplierBpsMeta,
        ),
      );
    }
    if (data.containsKey('flat_amount_minor')) {
      context.handle(
        _flatAmountMinorMeta,
        flatAmountMinor.isAcceptableOrUnknown(
          data['flat_amount_minor']!,
          _flatAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('start_minutes_local')) {
      context.handle(
        _startMinutesLocalMeta,
        startMinutesLocal.isAcceptableOrUnknown(
          data['start_minutes_local']!,
          _startMinutesLocalMeta,
        ),
      );
    }
    if (data.containsKey('end_minutes_local')) {
      context.handle(
        _endMinutesLocalMeta,
        endMinutesLocal.isAcceptableOrUnknown(
          data['end_minutes_local']!,
          _endMinutesLocalMeta,
        ),
      );
    }
    if (data.containsKey('applies_on_saturday')) {
      context.handle(
        _appliesOnSaturdayMeta,
        appliesOnSaturday.isAcceptableOrUnknown(
          data['applies_on_saturday']!,
          _appliesOnSaturdayMeta,
        ),
      );
    }
    if (data.containsKey('applies_on_sunday')) {
      context.handle(
        _appliesOnSundayMeta,
        appliesOnSunday.isAcceptableOrUnknown(
          data['applies_on_sunday']!,
          _appliesOnSundayMeta,
        ),
      );
    }
    if (data.containsKey('shift_template_id')) {
      context.handle(
        _shiftTemplateIdMeta,
        shiftTemplateId.isAcceptableOrUnknown(
          data['shift_template_id']!,
          _shiftTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DifferentialRulesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DifferentialRulesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      advancedPayRuleSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}advanced_pay_rule_set_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      combinationMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}combination_mode'],
      )!,
      multiplierBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}multiplier_bps'],
      ),
      flatAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flat_amount_minor'],
      ),
      startMinutesLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes_local'],
      ),
      endMinutesLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes_local'],
      ),
      appliesOnSaturday: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}applies_on_saturday'],
      )!,
      appliesOnSunday: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}applies_on_sunday'],
      )!,
      shiftTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_template_id'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $DifferentialRulesTableTable createAlias(String alias) {
    return $DifferentialRulesTableTable(attachedDatabase, alias);
  }
}

class DifferentialRulesTableData extends DataClass
    implements Insertable<DifferentialRulesTableData> {
  final String id;
  final String advancedPayRuleSetId;
  final String type;
  final String combinationMode;
  final int? multiplierBps;
  final int? flatAmountMinor;
  final int? startMinutesLocal;
  final int? endMinutesLocal;
  final bool appliesOnSaturday;
  final bool appliesOnSunday;
  final String? shiftTemplateId;
  final bool enabled;
  const DifferentialRulesTableData({
    required this.id,
    required this.advancedPayRuleSetId,
    required this.type,
    required this.combinationMode,
    this.multiplierBps,
    this.flatAmountMinor,
    this.startMinutesLocal,
    this.endMinutesLocal,
    required this.appliesOnSaturday,
    required this.appliesOnSunday,
    this.shiftTemplateId,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['advanced_pay_rule_set_id'] = Variable<String>(advancedPayRuleSetId);
    map['type'] = Variable<String>(type);
    map['combination_mode'] = Variable<String>(combinationMode);
    if (!nullToAbsent || multiplierBps != null) {
      map['multiplier_bps'] = Variable<int>(multiplierBps);
    }
    if (!nullToAbsent || flatAmountMinor != null) {
      map['flat_amount_minor'] = Variable<int>(flatAmountMinor);
    }
    if (!nullToAbsent || startMinutesLocal != null) {
      map['start_minutes_local'] = Variable<int>(startMinutesLocal);
    }
    if (!nullToAbsent || endMinutesLocal != null) {
      map['end_minutes_local'] = Variable<int>(endMinutesLocal);
    }
    map['applies_on_saturday'] = Variable<bool>(appliesOnSaturday);
    map['applies_on_sunday'] = Variable<bool>(appliesOnSunday);
    if (!nullToAbsent || shiftTemplateId != null) {
      map['shift_template_id'] = Variable<String>(shiftTemplateId);
    }
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  DifferentialRulesTableCompanion toCompanion(bool nullToAbsent) {
    return DifferentialRulesTableCompanion(
      id: Value(id),
      advancedPayRuleSetId: Value(advancedPayRuleSetId),
      type: Value(type),
      combinationMode: Value(combinationMode),
      multiplierBps: multiplierBps == null && nullToAbsent
          ? const Value.absent()
          : Value(multiplierBps),
      flatAmountMinor: flatAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(flatAmountMinor),
      startMinutesLocal: startMinutesLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinutesLocal),
      endMinutesLocal: endMinutesLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(endMinutesLocal),
      appliesOnSaturday: Value(appliesOnSaturday),
      appliesOnSunday: Value(appliesOnSunday),
      shiftTemplateId: shiftTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftTemplateId),
      enabled: Value(enabled),
    );
  }

  factory DifferentialRulesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DifferentialRulesTableData(
      id: serializer.fromJson<String>(json['id']),
      advancedPayRuleSetId: serializer.fromJson<String>(
        json['advancedPayRuleSetId'],
      ),
      type: serializer.fromJson<String>(json['type']),
      combinationMode: serializer.fromJson<String>(json['combinationMode']),
      multiplierBps: serializer.fromJson<int?>(json['multiplierBps']),
      flatAmountMinor: serializer.fromJson<int?>(json['flatAmountMinor']),
      startMinutesLocal: serializer.fromJson<int?>(json['startMinutesLocal']),
      endMinutesLocal: serializer.fromJson<int?>(json['endMinutesLocal']),
      appliesOnSaturday: serializer.fromJson<bool>(json['appliesOnSaturday']),
      appliesOnSunday: serializer.fromJson<bool>(json['appliesOnSunday']),
      shiftTemplateId: serializer.fromJson<String?>(json['shiftTemplateId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'advancedPayRuleSetId': serializer.toJson<String>(advancedPayRuleSetId),
      'type': serializer.toJson<String>(type),
      'combinationMode': serializer.toJson<String>(combinationMode),
      'multiplierBps': serializer.toJson<int?>(multiplierBps),
      'flatAmountMinor': serializer.toJson<int?>(flatAmountMinor),
      'startMinutesLocal': serializer.toJson<int?>(startMinutesLocal),
      'endMinutesLocal': serializer.toJson<int?>(endMinutesLocal),
      'appliesOnSaturday': serializer.toJson<bool>(appliesOnSaturday),
      'appliesOnSunday': serializer.toJson<bool>(appliesOnSunday),
      'shiftTemplateId': serializer.toJson<String?>(shiftTemplateId),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  DifferentialRulesTableData copyWith({
    String? id,
    String? advancedPayRuleSetId,
    String? type,
    String? combinationMode,
    Value<int?> multiplierBps = const Value.absent(),
    Value<int?> flatAmountMinor = const Value.absent(),
    Value<int?> startMinutesLocal = const Value.absent(),
    Value<int?> endMinutesLocal = const Value.absent(),
    bool? appliesOnSaturday,
    bool? appliesOnSunday,
    Value<String?> shiftTemplateId = const Value.absent(),
    bool? enabled,
  }) => DifferentialRulesTableData(
    id: id ?? this.id,
    advancedPayRuleSetId: advancedPayRuleSetId ?? this.advancedPayRuleSetId,
    type: type ?? this.type,
    combinationMode: combinationMode ?? this.combinationMode,
    multiplierBps: multiplierBps.present
        ? multiplierBps.value
        : this.multiplierBps,
    flatAmountMinor: flatAmountMinor.present
        ? flatAmountMinor.value
        : this.flatAmountMinor,
    startMinutesLocal: startMinutesLocal.present
        ? startMinutesLocal.value
        : this.startMinutesLocal,
    endMinutesLocal: endMinutesLocal.present
        ? endMinutesLocal.value
        : this.endMinutesLocal,
    appliesOnSaturday: appliesOnSaturday ?? this.appliesOnSaturday,
    appliesOnSunday: appliesOnSunday ?? this.appliesOnSunday,
    shiftTemplateId: shiftTemplateId.present
        ? shiftTemplateId.value
        : this.shiftTemplateId,
    enabled: enabled ?? this.enabled,
  );
  DifferentialRulesTableData copyWithCompanion(
    DifferentialRulesTableCompanion data,
  ) {
    return DifferentialRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      advancedPayRuleSetId: data.advancedPayRuleSetId.present
          ? data.advancedPayRuleSetId.value
          : this.advancedPayRuleSetId,
      type: data.type.present ? data.type.value : this.type,
      combinationMode: data.combinationMode.present
          ? data.combinationMode.value
          : this.combinationMode,
      multiplierBps: data.multiplierBps.present
          ? data.multiplierBps.value
          : this.multiplierBps,
      flatAmountMinor: data.flatAmountMinor.present
          ? data.flatAmountMinor.value
          : this.flatAmountMinor,
      startMinutesLocal: data.startMinutesLocal.present
          ? data.startMinutesLocal.value
          : this.startMinutesLocal,
      endMinutesLocal: data.endMinutesLocal.present
          ? data.endMinutesLocal.value
          : this.endMinutesLocal,
      appliesOnSaturday: data.appliesOnSaturday.present
          ? data.appliesOnSaturday.value
          : this.appliesOnSaturday,
      appliesOnSunday: data.appliesOnSunday.present
          ? data.appliesOnSunday.value
          : this.appliesOnSunday,
      shiftTemplateId: data.shiftTemplateId.present
          ? data.shiftTemplateId.value
          : this.shiftTemplateId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DifferentialRulesTableData(')
          ..write('id: $id, ')
          ..write('advancedPayRuleSetId: $advancedPayRuleSetId, ')
          ..write('type: $type, ')
          ..write('combinationMode: $combinationMode, ')
          ..write('multiplierBps: $multiplierBps, ')
          ..write('flatAmountMinor: $flatAmountMinor, ')
          ..write('startMinutesLocal: $startMinutesLocal, ')
          ..write('endMinutesLocal: $endMinutesLocal, ')
          ..write('appliesOnSaturday: $appliesOnSaturday, ')
          ..write('appliesOnSunday: $appliesOnSunday, ')
          ..write('shiftTemplateId: $shiftTemplateId, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    advancedPayRuleSetId,
    type,
    combinationMode,
    multiplierBps,
    flatAmountMinor,
    startMinutesLocal,
    endMinutesLocal,
    appliesOnSaturday,
    appliesOnSunday,
    shiftTemplateId,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DifferentialRulesTableData &&
          other.id == this.id &&
          other.advancedPayRuleSetId == this.advancedPayRuleSetId &&
          other.type == this.type &&
          other.combinationMode == this.combinationMode &&
          other.multiplierBps == this.multiplierBps &&
          other.flatAmountMinor == this.flatAmountMinor &&
          other.startMinutesLocal == this.startMinutesLocal &&
          other.endMinutesLocal == this.endMinutesLocal &&
          other.appliesOnSaturday == this.appliesOnSaturday &&
          other.appliesOnSunday == this.appliesOnSunday &&
          other.shiftTemplateId == this.shiftTemplateId &&
          other.enabled == this.enabled);
}

class DifferentialRulesTableCompanion
    extends UpdateCompanion<DifferentialRulesTableData> {
  final Value<String> id;
  final Value<String> advancedPayRuleSetId;
  final Value<String> type;
  final Value<String> combinationMode;
  final Value<int?> multiplierBps;
  final Value<int?> flatAmountMinor;
  final Value<int?> startMinutesLocal;
  final Value<int?> endMinutesLocal;
  final Value<bool> appliesOnSaturday;
  final Value<bool> appliesOnSunday;
  final Value<String?> shiftTemplateId;
  final Value<bool> enabled;
  final Value<int> rowid;
  const DifferentialRulesTableCompanion({
    this.id = const Value.absent(),
    this.advancedPayRuleSetId = const Value.absent(),
    this.type = const Value.absent(),
    this.combinationMode = const Value.absent(),
    this.multiplierBps = const Value.absent(),
    this.flatAmountMinor = const Value.absent(),
    this.startMinutesLocal = const Value.absent(),
    this.endMinutesLocal = const Value.absent(),
    this.appliesOnSaturday = const Value.absent(),
    this.appliesOnSunday = const Value.absent(),
    this.shiftTemplateId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DifferentialRulesTableCompanion.insert({
    required String id,
    required String advancedPayRuleSetId,
    required String type,
    required String combinationMode,
    this.multiplierBps = const Value.absent(),
    this.flatAmountMinor = const Value.absent(),
    this.startMinutesLocal = const Value.absent(),
    this.endMinutesLocal = const Value.absent(),
    this.appliesOnSaturday = const Value.absent(),
    this.appliesOnSunday = const Value.absent(),
    this.shiftTemplateId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       advancedPayRuleSetId = Value(advancedPayRuleSetId),
       type = Value(type),
       combinationMode = Value(combinationMode);
  static Insertable<DifferentialRulesTableData> custom({
    Expression<String>? id,
    Expression<String>? advancedPayRuleSetId,
    Expression<String>? type,
    Expression<String>? combinationMode,
    Expression<int>? multiplierBps,
    Expression<int>? flatAmountMinor,
    Expression<int>? startMinutesLocal,
    Expression<int>? endMinutesLocal,
    Expression<bool>? appliesOnSaturday,
    Expression<bool>? appliesOnSunday,
    Expression<String>? shiftTemplateId,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (advancedPayRuleSetId != null)
        'advanced_pay_rule_set_id': advancedPayRuleSetId,
      if (type != null) 'type': type,
      if (combinationMode != null) 'combination_mode': combinationMode,
      if (multiplierBps != null) 'multiplier_bps': multiplierBps,
      if (flatAmountMinor != null) 'flat_amount_minor': flatAmountMinor,
      if (startMinutesLocal != null) 'start_minutes_local': startMinutesLocal,
      if (endMinutesLocal != null) 'end_minutes_local': endMinutesLocal,
      if (appliesOnSaturday != null) 'applies_on_saturday': appliesOnSaturday,
      if (appliesOnSunday != null) 'applies_on_sunday': appliesOnSunday,
      if (shiftTemplateId != null) 'shift_template_id': shiftTemplateId,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DifferentialRulesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? advancedPayRuleSetId,
    Value<String>? type,
    Value<String>? combinationMode,
    Value<int?>? multiplierBps,
    Value<int?>? flatAmountMinor,
    Value<int?>? startMinutesLocal,
    Value<int?>? endMinutesLocal,
    Value<bool>? appliesOnSaturday,
    Value<bool>? appliesOnSunday,
    Value<String?>? shiftTemplateId,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return DifferentialRulesTableCompanion(
      id: id ?? this.id,
      advancedPayRuleSetId: advancedPayRuleSetId ?? this.advancedPayRuleSetId,
      type: type ?? this.type,
      combinationMode: combinationMode ?? this.combinationMode,
      multiplierBps: multiplierBps ?? this.multiplierBps,
      flatAmountMinor: flatAmountMinor ?? this.flatAmountMinor,
      startMinutesLocal: startMinutesLocal ?? this.startMinutesLocal,
      endMinutesLocal: endMinutesLocal ?? this.endMinutesLocal,
      appliesOnSaturday: appliesOnSaturday ?? this.appliesOnSaturday,
      appliesOnSunday: appliesOnSunday ?? this.appliesOnSunday,
      shiftTemplateId: shiftTemplateId ?? this.shiftTemplateId,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (advancedPayRuleSetId.present) {
      map['advanced_pay_rule_set_id'] = Variable<String>(
        advancedPayRuleSetId.value,
      );
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (combinationMode.present) {
      map['combination_mode'] = Variable<String>(combinationMode.value);
    }
    if (multiplierBps.present) {
      map['multiplier_bps'] = Variable<int>(multiplierBps.value);
    }
    if (flatAmountMinor.present) {
      map['flat_amount_minor'] = Variable<int>(flatAmountMinor.value);
    }
    if (startMinutesLocal.present) {
      map['start_minutes_local'] = Variable<int>(startMinutesLocal.value);
    }
    if (endMinutesLocal.present) {
      map['end_minutes_local'] = Variable<int>(endMinutesLocal.value);
    }
    if (appliesOnSaturday.present) {
      map['applies_on_saturday'] = Variable<bool>(appliesOnSaturday.value);
    }
    if (appliesOnSunday.present) {
      map['applies_on_sunday'] = Variable<bool>(appliesOnSunday.value);
    }
    if (shiftTemplateId.present) {
      map['shift_template_id'] = Variable<String>(shiftTemplateId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DifferentialRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('advancedPayRuleSetId: $advancedPayRuleSetId, ')
          ..write('type: $type, ')
          ..write('combinationMode: $combinationMode, ')
          ..write('multiplierBps: $multiplierBps, ')
          ..write('flatAmountMinor: $flatAmountMinor, ')
          ..write('startMinutesLocal: $startMinutesLocal, ')
          ..write('endMinutesLocal: $endMinutesLocal, ')
          ..write('appliesOnSaturday: $appliesOnSaturday, ')
          ..write('appliesOnSunday: $appliesOnSunday, ')
          ..write('shiftTemplateId: $shiftTemplateId, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AllowanceRulesTableTable extends AllowanceRulesTable
    with TableInfo<$AllowanceRulesTableTable, AllowanceRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllowanceRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _advancedPayRuleSetIdMeta =
      const VerificationMeta('advancedPayRuleSetId');
  @override
  late final GeneratedColumn<String> advancedPayRuleSetId =
      GeneratedColumn<String>(
        'advanced_pay_rule_set_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES advanced_pay_rule_sets_table (id)',
        ),
      );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appliesOnHolidayMeta = const VerificationMeta(
    'appliesOnHoliday',
  );
  @override
  late final GeneratedColumn<bool> appliesOnHoliday = GeneratedColumn<bool>(
    'applies_on_holiday',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("applies_on_holiday" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _shiftTemplateIdMeta = const VerificationMeta(
    'shiftTemplateId',
  );
  @override
  late final GeneratedColumn<String> shiftTemplateId = GeneratedColumn<String>(
    'shift_template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_templates_table (id)',
    ),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    advancedPayRuleSetId,
    type,
    amountMinor,
    appliesOnHoliday,
    shiftTemplateId,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allowance_rules_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AllowanceRulesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('advanced_pay_rule_set_id')) {
      context.handle(
        _advancedPayRuleSetIdMeta,
        advancedPayRuleSetId.isAcceptableOrUnknown(
          data['advanced_pay_rule_set_id']!,
          _advancedPayRuleSetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_advancedPayRuleSetIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('applies_on_holiday')) {
      context.handle(
        _appliesOnHolidayMeta,
        appliesOnHoliday.isAcceptableOrUnknown(
          data['applies_on_holiday']!,
          _appliesOnHolidayMeta,
        ),
      );
    }
    if (data.containsKey('shift_template_id')) {
      context.handle(
        _shiftTemplateIdMeta,
        shiftTemplateId.isAcceptableOrUnknown(
          data['shift_template_id']!,
          _shiftTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllowanceRulesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllowanceRulesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      advancedPayRuleSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}advanced_pay_rule_set_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      appliesOnHoliday: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}applies_on_holiday'],
      )!,
      shiftTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_template_id'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $AllowanceRulesTableTable createAlias(String alias) {
    return $AllowanceRulesTableTable(attachedDatabase, alias);
  }
}

class AllowanceRulesTableData extends DataClass
    implements Insertable<AllowanceRulesTableData> {
  final String id;
  final String advancedPayRuleSetId;
  final String type;
  final int amountMinor;
  final bool appliesOnHoliday;
  final String? shiftTemplateId;
  final bool enabled;
  const AllowanceRulesTableData({
    required this.id,
    required this.advancedPayRuleSetId,
    required this.type,
    required this.amountMinor,
    required this.appliesOnHoliday,
    this.shiftTemplateId,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['advanced_pay_rule_set_id'] = Variable<String>(advancedPayRuleSetId);
    map['type'] = Variable<String>(type);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['applies_on_holiday'] = Variable<bool>(appliesOnHoliday);
    if (!nullToAbsent || shiftTemplateId != null) {
      map['shift_template_id'] = Variable<String>(shiftTemplateId);
    }
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  AllowanceRulesTableCompanion toCompanion(bool nullToAbsent) {
    return AllowanceRulesTableCompanion(
      id: Value(id),
      advancedPayRuleSetId: Value(advancedPayRuleSetId),
      type: Value(type),
      amountMinor: Value(amountMinor),
      appliesOnHoliday: Value(appliesOnHoliday),
      shiftTemplateId: shiftTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftTemplateId),
      enabled: Value(enabled),
    );
  }

  factory AllowanceRulesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllowanceRulesTableData(
      id: serializer.fromJson<String>(json['id']),
      advancedPayRuleSetId: serializer.fromJson<String>(
        json['advancedPayRuleSetId'],
      ),
      type: serializer.fromJson<String>(json['type']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      appliesOnHoliday: serializer.fromJson<bool>(json['appliesOnHoliday']),
      shiftTemplateId: serializer.fromJson<String?>(json['shiftTemplateId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'advancedPayRuleSetId': serializer.toJson<String>(advancedPayRuleSetId),
      'type': serializer.toJson<String>(type),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'appliesOnHoliday': serializer.toJson<bool>(appliesOnHoliday),
      'shiftTemplateId': serializer.toJson<String?>(shiftTemplateId),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  AllowanceRulesTableData copyWith({
    String? id,
    String? advancedPayRuleSetId,
    String? type,
    int? amountMinor,
    bool? appliesOnHoliday,
    Value<String?> shiftTemplateId = const Value.absent(),
    bool? enabled,
  }) => AllowanceRulesTableData(
    id: id ?? this.id,
    advancedPayRuleSetId: advancedPayRuleSetId ?? this.advancedPayRuleSetId,
    type: type ?? this.type,
    amountMinor: amountMinor ?? this.amountMinor,
    appliesOnHoliday: appliesOnHoliday ?? this.appliesOnHoliday,
    shiftTemplateId: shiftTemplateId.present
        ? shiftTemplateId.value
        : this.shiftTemplateId,
    enabled: enabled ?? this.enabled,
  );
  AllowanceRulesTableData copyWithCompanion(AllowanceRulesTableCompanion data) {
    return AllowanceRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      advancedPayRuleSetId: data.advancedPayRuleSetId.present
          ? data.advancedPayRuleSetId.value
          : this.advancedPayRuleSetId,
      type: data.type.present ? data.type.value : this.type,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      appliesOnHoliday: data.appliesOnHoliday.present
          ? data.appliesOnHoliday.value
          : this.appliesOnHoliday,
      shiftTemplateId: data.shiftTemplateId.present
          ? data.shiftTemplateId.value
          : this.shiftTemplateId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllowanceRulesTableData(')
          ..write('id: $id, ')
          ..write('advancedPayRuleSetId: $advancedPayRuleSetId, ')
          ..write('type: $type, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('appliesOnHoliday: $appliesOnHoliday, ')
          ..write('shiftTemplateId: $shiftTemplateId, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    advancedPayRuleSetId,
    type,
    amountMinor,
    appliesOnHoliday,
    shiftTemplateId,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllowanceRulesTableData &&
          other.id == this.id &&
          other.advancedPayRuleSetId == this.advancedPayRuleSetId &&
          other.type == this.type &&
          other.amountMinor == this.amountMinor &&
          other.appliesOnHoliday == this.appliesOnHoliday &&
          other.shiftTemplateId == this.shiftTemplateId &&
          other.enabled == this.enabled);
}

class AllowanceRulesTableCompanion
    extends UpdateCompanion<AllowanceRulesTableData> {
  final Value<String> id;
  final Value<String> advancedPayRuleSetId;
  final Value<String> type;
  final Value<int> amountMinor;
  final Value<bool> appliesOnHoliday;
  final Value<String?> shiftTemplateId;
  final Value<bool> enabled;
  final Value<int> rowid;
  const AllowanceRulesTableCompanion({
    this.id = const Value.absent(),
    this.advancedPayRuleSetId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.appliesOnHoliday = const Value.absent(),
    this.shiftTemplateId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AllowanceRulesTableCompanion.insert({
    required String id,
    required String advancedPayRuleSetId,
    required String type,
    required int amountMinor,
    this.appliesOnHoliday = const Value.absent(),
    this.shiftTemplateId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       advancedPayRuleSetId = Value(advancedPayRuleSetId),
       type = Value(type),
       amountMinor = Value(amountMinor);
  static Insertable<AllowanceRulesTableData> custom({
    Expression<String>? id,
    Expression<String>? advancedPayRuleSetId,
    Expression<String>? type,
    Expression<int>? amountMinor,
    Expression<bool>? appliesOnHoliday,
    Expression<String>? shiftTemplateId,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (advancedPayRuleSetId != null)
        'advanced_pay_rule_set_id': advancedPayRuleSetId,
      if (type != null) 'type': type,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (appliesOnHoliday != null) 'applies_on_holiday': appliesOnHoliday,
      if (shiftTemplateId != null) 'shift_template_id': shiftTemplateId,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AllowanceRulesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? advancedPayRuleSetId,
    Value<String>? type,
    Value<int>? amountMinor,
    Value<bool>? appliesOnHoliday,
    Value<String?>? shiftTemplateId,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return AllowanceRulesTableCompanion(
      id: id ?? this.id,
      advancedPayRuleSetId: advancedPayRuleSetId ?? this.advancedPayRuleSetId,
      type: type ?? this.type,
      amountMinor: amountMinor ?? this.amountMinor,
      appliesOnHoliday: appliesOnHoliday ?? this.appliesOnHoliday,
      shiftTemplateId: shiftTemplateId ?? this.shiftTemplateId,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (advancedPayRuleSetId.present) {
      map['advanced_pay_rule_set_id'] = Variable<String>(
        advancedPayRuleSetId.value,
      );
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (appliesOnHoliday.present) {
      map['applies_on_holiday'] = Variable<bool>(appliesOnHoliday.value);
    }
    if (shiftTemplateId.present) {
      map['shift_template_id'] = Variable<String>(shiftTemplateId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllowanceRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('advancedPayRuleSetId: $advancedPayRuleSetId, ')
          ..write('type: $type, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('appliesOnHoliday: $appliesOnHoliday, ')
          ..write('shiftTemplateId: $shiftTemplateId, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AdvancedBreakRulesTableTable extends AdvancedBreakRulesTable
    with TableInfo<$AdvancedBreakRulesTableTable, AdvancedBreakRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdvancedBreakRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _advancedPayRuleSetIdMeta =
      const VerificationMeta('advancedPayRuleSetId');
  @override
  late final GeneratedColumn<String> advancedPayRuleSetId =
      GeneratedColumn<String>(
        'advanced_pay_rule_set_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES advanced_pay_rule_sets_table (id)',
        ),
      );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftTemplateIdMeta = const VerificationMeta(
    'shiftTemplateId',
  );
  @override
  late final GeneratedColumn<String> shiftTemplateId = GeneratedColumn<String>(
    'shift_template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_templates_table (id)',
    ),
  );
  static const VerificationMeta _shiftCategoryMeta = const VerificationMeta(
    'shiftCategory',
  );
  @override
  late final GeneratedColumn<String> shiftCategory = GeneratedColumn<String>(
    'shift_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    advancedPayRuleSetId,
    minutes,
    shiftTemplateId,
    shiftCategory,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'advanced_break_rules_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdvancedBreakRulesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('advanced_pay_rule_set_id')) {
      context.handle(
        _advancedPayRuleSetIdMeta,
        advancedPayRuleSetId.isAcceptableOrUnknown(
          data['advanced_pay_rule_set_id']!,
          _advancedPayRuleSetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_advancedPayRuleSetIdMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    } else if (isInserting) {
      context.missing(_minutesMeta);
    }
    if (data.containsKey('shift_template_id')) {
      context.handle(
        _shiftTemplateIdMeta,
        shiftTemplateId.isAcceptableOrUnknown(
          data['shift_template_id']!,
          _shiftTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('shift_category')) {
      context.handle(
        _shiftCategoryMeta,
        shiftCategory.isAcceptableOrUnknown(
          data['shift_category']!,
          _shiftCategoryMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdvancedBreakRulesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdvancedBreakRulesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      advancedPayRuleSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}advanced_pay_rule_set_id'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      shiftTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_template_id'],
      ),
      shiftCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_category'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $AdvancedBreakRulesTableTable createAlias(String alias) {
    return $AdvancedBreakRulesTableTable(attachedDatabase, alias);
  }
}

class AdvancedBreakRulesTableData extends DataClass
    implements Insertable<AdvancedBreakRulesTableData> {
  final String id;
  final String advancedPayRuleSetId;
  final int minutes;
  final String? shiftTemplateId;
  final String? shiftCategory;
  final bool enabled;
  const AdvancedBreakRulesTableData({
    required this.id,
    required this.advancedPayRuleSetId,
    required this.minutes,
    this.shiftTemplateId,
    this.shiftCategory,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['advanced_pay_rule_set_id'] = Variable<String>(advancedPayRuleSetId);
    map['minutes'] = Variable<int>(minutes);
    if (!nullToAbsent || shiftTemplateId != null) {
      map['shift_template_id'] = Variable<String>(shiftTemplateId);
    }
    if (!nullToAbsent || shiftCategory != null) {
      map['shift_category'] = Variable<String>(shiftCategory);
    }
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  AdvancedBreakRulesTableCompanion toCompanion(bool nullToAbsent) {
    return AdvancedBreakRulesTableCompanion(
      id: Value(id),
      advancedPayRuleSetId: Value(advancedPayRuleSetId),
      minutes: Value(minutes),
      shiftTemplateId: shiftTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftTemplateId),
      shiftCategory: shiftCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftCategory),
      enabled: Value(enabled),
    );
  }

  factory AdvancedBreakRulesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdvancedBreakRulesTableData(
      id: serializer.fromJson<String>(json['id']),
      advancedPayRuleSetId: serializer.fromJson<String>(
        json['advancedPayRuleSetId'],
      ),
      minutes: serializer.fromJson<int>(json['minutes']),
      shiftTemplateId: serializer.fromJson<String?>(json['shiftTemplateId']),
      shiftCategory: serializer.fromJson<String?>(json['shiftCategory']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'advancedPayRuleSetId': serializer.toJson<String>(advancedPayRuleSetId),
      'minutes': serializer.toJson<int>(minutes),
      'shiftTemplateId': serializer.toJson<String?>(shiftTemplateId),
      'shiftCategory': serializer.toJson<String?>(shiftCategory),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  AdvancedBreakRulesTableData copyWith({
    String? id,
    String? advancedPayRuleSetId,
    int? minutes,
    Value<String?> shiftTemplateId = const Value.absent(),
    Value<String?> shiftCategory = const Value.absent(),
    bool? enabled,
  }) => AdvancedBreakRulesTableData(
    id: id ?? this.id,
    advancedPayRuleSetId: advancedPayRuleSetId ?? this.advancedPayRuleSetId,
    minutes: minutes ?? this.minutes,
    shiftTemplateId: shiftTemplateId.present
        ? shiftTemplateId.value
        : this.shiftTemplateId,
    shiftCategory: shiftCategory.present
        ? shiftCategory.value
        : this.shiftCategory,
    enabled: enabled ?? this.enabled,
  );
  AdvancedBreakRulesTableData copyWithCompanion(
    AdvancedBreakRulesTableCompanion data,
  ) {
    return AdvancedBreakRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      advancedPayRuleSetId: data.advancedPayRuleSetId.present
          ? data.advancedPayRuleSetId.value
          : this.advancedPayRuleSetId,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      shiftTemplateId: data.shiftTemplateId.present
          ? data.shiftTemplateId.value
          : this.shiftTemplateId,
      shiftCategory: data.shiftCategory.present
          ? data.shiftCategory.value
          : this.shiftCategory,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdvancedBreakRulesTableData(')
          ..write('id: $id, ')
          ..write('advancedPayRuleSetId: $advancedPayRuleSetId, ')
          ..write('minutes: $minutes, ')
          ..write('shiftTemplateId: $shiftTemplateId, ')
          ..write('shiftCategory: $shiftCategory, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    advancedPayRuleSetId,
    minutes,
    shiftTemplateId,
    shiftCategory,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdvancedBreakRulesTableData &&
          other.id == this.id &&
          other.advancedPayRuleSetId == this.advancedPayRuleSetId &&
          other.minutes == this.minutes &&
          other.shiftTemplateId == this.shiftTemplateId &&
          other.shiftCategory == this.shiftCategory &&
          other.enabled == this.enabled);
}

class AdvancedBreakRulesTableCompanion
    extends UpdateCompanion<AdvancedBreakRulesTableData> {
  final Value<String> id;
  final Value<String> advancedPayRuleSetId;
  final Value<int> minutes;
  final Value<String?> shiftTemplateId;
  final Value<String?> shiftCategory;
  final Value<bool> enabled;
  final Value<int> rowid;
  const AdvancedBreakRulesTableCompanion({
    this.id = const Value.absent(),
    this.advancedPayRuleSetId = const Value.absent(),
    this.minutes = const Value.absent(),
    this.shiftTemplateId = const Value.absent(),
    this.shiftCategory = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AdvancedBreakRulesTableCompanion.insert({
    required String id,
    required String advancedPayRuleSetId,
    required int minutes,
    this.shiftTemplateId = const Value.absent(),
    this.shiftCategory = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       advancedPayRuleSetId = Value(advancedPayRuleSetId),
       minutes = Value(minutes);
  static Insertable<AdvancedBreakRulesTableData> custom({
    Expression<String>? id,
    Expression<String>? advancedPayRuleSetId,
    Expression<int>? minutes,
    Expression<String>? shiftTemplateId,
    Expression<String>? shiftCategory,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (advancedPayRuleSetId != null)
        'advanced_pay_rule_set_id': advancedPayRuleSetId,
      if (minutes != null) 'minutes': minutes,
      if (shiftTemplateId != null) 'shift_template_id': shiftTemplateId,
      if (shiftCategory != null) 'shift_category': shiftCategory,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AdvancedBreakRulesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? advancedPayRuleSetId,
    Value<int>? minutes,
    Value<String?>? shiftTemplateId,
    Value<String?>? shiftCategory,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return AdvancedBreakRulesTableCompanion(
      id: id ?? this.id,
      advancedPayRuleSetId: advancedPayRuleSetId ?? this.advancedPayRuleSetId,
      minutes: minutes ?? this.minutes,
      shiftTemplateId: shiftTemplateId ?? this.shiftTemplateId,
      shiftCategory: shiftCategory ?? this.shiftCategory,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (advancedPayRuleSetId.present) {
      map['advanced_pay_rule_set_id'] = Variable<String>(
        advancedPayRuleSetId.value,
      );
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (shiftTemplateId.present) {
      map['shift_template_id'] = Variable<String>(shiftTemplateId.value);
    }
    if (shiftCategory.present) {
      map['shift_category'] = Variable<String>(shiftCategory.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdvancedBreakRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('advancedPayRuleSetId: $advancedPayRuleSetId, ')
          ..write('minutes: $minutes, ')
          ..write('shiftTemplateId: $shiftTemplateId, ')
          ..write('shiftCategory: $shiftCategory, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HolidayRuleSetsTableTable extends HolidayRuleSetsTable
    with TableInfo<$HolidayRuleSetsTableTable, HolidayRuleSetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HolidayRuleSetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jobs_table (id)',
    ),
  );
  static const VerificationMeta _holidayMultiplierBpsMeta =
      const VerificationMeta('holidayMultiplierBps');
  @override
  late final GeneratedColumn<int> holidayMultiplierBps = GeneratedColumn<int>(
    'holiday_multiplier_bps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _holidaySourceMeta = const VerificationMeta(
    'holidaySource',
  );
  @override
  late final GeneratedColumn<String> holidaySource = GeneratedColumn<String>(
    'holiday_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobId,
    holidayMultiplierBps,
    holidaySource,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holiday_rule_sets_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HolidayRuleSetsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('holiday_multiplier_bps')) {
      context.handle(
        _holidayMultiplierBpsMeta,
        holidayMultiplierBps.isAcceptableOrUnknown(
          data['holiday_multiplier_bps']!,
          _holidayMultiplierBpsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_holidayMultiplierBpsMeta);
    }
    if (data.containsKey('holiday_source')) {
      context.handle(
        _holidaySourceMeta,
        holidaySource.isAcceptableOrUnknown(
          data['holiday_source']!,
          _holidaySourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_holidaySourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HolidayRuleSetsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HolidayRuleSetsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      holidayMultiplierBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}holiday_multiplier_bps'],
      )!,
      holidaySource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}holiday_source'],
      )!,
    );
  }

  @override
  $HolidayRuleSetsTableTable createAlias(String alias) {
    return $HolidayRuleSetsTableTable(attachedDatabase, alias);
  }
}

class HolidayRuleSetsTableData extends DataClass
    implements Insertable<HolidayRuleSetsTableData> {
  final String id;
  final String jobId;
  final int holidayMultiplierBps;
  final String holidaySource;
  const HolidayRuleSetsTableData({
    required this.id,
    required this.jobId,
    required this.holidayMultiplierBps,
    required this.holidaySource,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['holiday_multiplier_bps'] = Variable<int>(holidayMultiplierBps);
    map['holiday_source'] = Variable<String>(holidaySource);
    return map;
  }

  HolidayRuleSetsTableCompanion toCompanion(bool nullToAbsent) {
    return HolidayRuleSetsTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      holidayMultiplierBps: Value(holidayMultiplierBps),
      holidaySource: Value(holidaySource),
    );
  }

  factory HolidayRuleSetsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HolidayRuleSetsTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      holidayMultiplierBps: serializer.fromJson<int>(
        json['holidayMultiplierBps'],
      ),
      holidaySource: serializer.fromJson<String>(json['holidaySource']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'holidayMultiplierBps': serializer.toJson<int>(holidayMultiplierBps),
      'holidaySource': serializer.toJson<String>(holidaySource),
    };
  }

  HolidayRuleSetsTableData copyWith({
    String? id,
    String? jobId,
    int? holidayMultiplierBps,
    String? holidaySource,
  }) => HolidayRuleSetsTableData(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    holidayMultiplierBps: holidayMultiplierBps ?? this.holidayMultiplierBps,
    holidaySource: holidaySource ?? this.holidaySource,
  );
  HolidayRuleSetsTableData copyWithCompanion(
    HolidayRuleSetsTableCompanion data,
  ) {
    return HolidayRuleSetsTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      holidayMultiplierBps: data.holidayMultiplierBps.present
          ? data.holidayMultiplierBps.value
          : this.holidayMultiplierBps,
      holidaySource: data.holidaySource.present
          ? data.holidaySource.value
          : this.holidaySource,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HolidayRuleSetsTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('holidayMultiplierBps: $holidayMultiplierBps, ')
          ..write('holidaySource: $holidaySource')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, jobId, holidayMultiplierBps, holidaySource);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HolidayRuleSetsTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.holidayMultiplierBps == this.holidayMultiplierBps &&
          other.holidaySource == this.holidaySource);
}

class HolidayRuleSetsTableCompanion
    extends UpdateCompanion<HolidayRuleSetsTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<int> holidayMultiplierBps;
  final Value<String> holidaySource;
  final Value<int> rowid;
  const HolidayRuleSetsTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.holidayMultiplierBps = const Value.absent(),
    this.holidaySource = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HolidayRuleSetsTableCompanion.insert({
    required String id,
    required String jobId,
    required int holidayMultiplierBps,
    required String holidaySource,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       holidayMultiplierBps = Value(holidayMultiplierBps),
       holidaySource = Value(holidaySource);
  static Insertable<HolidayRuleSetsTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<int>? holidayMultiplierBps,
    Expression<String>? holidaySource,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (holidayMultiplierBps != null)
        'holiday_multiplier_bps': holidayMultiplierBps,
      if (holidaySource != null) 'holiday_source': holidaySource,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HolidayRuleSetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<int>? holidayMultiplierBps,
    Value<String>? holidaySource,
    Value<int>? rowid,
  }) {
    return HolidayRuleSetsTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      holidayMultiplierBps: holidayMultiplierBps ?? this.holidayMultiplierBps,
      holidaySource: holidaySource ?? this.holidaySource,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (holidayMultiplierBps.present) {
      map['holiday_multiplier_bps'] = Variable<int>(holidayMultiplierBps.value);
    }
    if (holidaySource.present) {
      map['holiday_source'] = Variable<String>(holidaySource.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HolidayRuleSetsTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('holidayMultiplierBps: $holidayMultiplierBps, ')
          ..write('holidaySource: $holidaySource, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftPatternsTableTable extends ShiftPatternsTable
    with TableInfo<$ShiftPatternsTableTable, ShiftPatternsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftPatternsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jobs_table (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleLengthDaysMeta = const VerificationMeta(
    'cycleLengthDays',
  );
  @override
  late final GeneratedColumn<int> cycleLengthDays = GeneratedColumn<int>(
    'cycle_length_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobId,
    name,
    cycleLengthDays,
    startDate,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_patterns_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftPatternsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cycle_length_days')) {
      context.handle(
        _cycleLengthDaysMeta,
        cycleLengthDays.isAcceptableOrUnknown(
          data['cycle_length_days']!,
          _cycleLengthDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cycleLengthDaysMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftPatternsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftPatternsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      cycleLengthDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_length_days'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ShiftPatternsTableTable createAlias(String alias) {
    return $ShiftPatternsTableTable(attachedDatabase, alias);
  }
}

class ShiftPatternsTableData extends DataClass
    implements Insertable<ShiftPatternsTableData> {
  final String id;
  final String jobId;
  final String name;
  final int cycleLengthDays;
  final DateTime startDate;
  final bool isActive;
  const ShiftPatternsTableData({
    required this.id,
    required this.jobId,
    required this.name,
    required this.cycleLengthDays,
    required this.startDate,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['name'] = Variable<String>(name);
    map['cycle_length_days'] = Variable<int>(cycleLengthDays);
    map['start_date'] = Variable<DateTime>(startDate);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ShiftPatternsTableCompanion toCompanion(bool nullToAbsent) {
    return ShiftPatternsTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      name: Value(name),
      cycleLengthDays: Value(cycleLengthDays),
      startDate: Value(startDate),
      isActive: Value(isActive),
    );
  }

  factory ShiftPatternsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftPatternsTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      name: serializer.fromJson<String>(json['name']),
      cycleLengthDays: serializer.fromJson<int>(json['cycleLengthDays']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'name': serializer.toJson<String>(name),
      'cycleLengthDays': serializer.toJson<int>(cycleLengthDays),
      'startDate': serializer.toJson<DateTime>(startDate),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ShiftPatternsTableData copyWith({
    String? id,
    String? jobId,
    String? name,
    int? cycleLengthDays,
    DateTime? startDate,
    bool? isActive,
  }) => ShiftPatternsTableData(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    name: name ?? this.name,
    cycleLengthDays: cycleLengthDays ?? this.cycleLengthDays,
    startDate: startDate ?? this.startDate,
    isActive: isActive ?? this.isActive,
  );
  ShiftPatternsTableData copyWithCompanion(ShiftPatternsTableCompanion data) {
    return ShiftPatternsTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      name: data.name.present ? data.name.value : this.name,
      cycleLengthDays: data.cycleLengthDays.present
          ? data.cycleLengthDays.value
          : this.cycleLengthDays,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftPatternsTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('name: $name, ')
          ..write('cycleLengthDays: $cycleLengthDays, ')
          ..write('startDate: $startDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, jobId, name, cycleLengthDays, startDate, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftPatternsTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.name == this.name &&
          other.cycleLengthDays == this.cycleLengthDays &&
          other.startDate == this.startDate &&
          other.isActive == this.isActive);
}

class ShiftPatternsTableCompanion
    extends UpdateCompanion<ShiftPatternsTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<String> name;
  final Value<int> cycleLengthDays;
  final Value<DateTime> startDate;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ShiftPatternsTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.name = const Value.absent(),
    this.cycleLengthDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftPatternsTableCompanion.insert({
    required String id,
    required String jobId,
    required String name,
    required int cycleLengthDays,
    required DateTime startDate,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       name = Value(name),
       cycleLengthDays = Value(cycleLengthDays),
       startDate = Value(startDate);
  static Insertable<ShiftPatternsTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<String>? name,
    Expression<int>? cycleLengthDays,
    Expression<DateTime>? startDate,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (name != null) 'name': name,
      if (cycleLengthDays != null) 'cycle_length_days': cycleLengthDays,
      if (startDate != null) 'start_date': startDate,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftPatternsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<String>? name,
    Value<int>? cycleLengthDays,
    Value<DateTime>? startDate,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return ShiftPatternsTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      name: name ?? this.name,
      cycleLengthDays: cycleLengthDays ?? this.cycleLengthDays,
      startDate: startDate ?? this.startDate,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cycleLengthDays.present) {
      map['cycle_length_days'] = Variable<int>(cycleLengthDays.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftPatternsTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('name: $name, ')
          ..write('cycleLengthDays: $cycleLengthDays, ')
          ..write('startDate: $startDate, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftPatternEntriesTableTable extends ShiftPatternEntriesTable
    with
        TableInfo<
          $ShiftPatternEntriesTableTable,
          ShiftPatternEntriesTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftPatternEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patternIdMeta = const VerificationMeta(
    'patternId',
  );
  @override
  late final GeneratedColumn<String> patternId = GeneratedColumn<String>(
    'pattern_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_patterns_table (id)',
    ),
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftTemplateIdMeta = const VerificationMeta(
    'shiftTemplateId',
  );
  @override
  late final GeneratedColumn<String> shiftTemplateId = GeneratedColumn<String>(
    'shift_template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_templates_table (id)',
    ),
  );
  static const VerificationMeta _isOffDayMeta = const VerificationMeta(
    'isOffDay',
  );
  @override
  late final GeneratedColumn<bool> isOffDay = GeneratedColumn<bool>(
    'is_off_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_off_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patternId,
    dayIndex,
    shiftTemplateId,
    isOffDay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_pattern_entries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftPatternEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pattern_id')) {
      context.handle(
        _patternIdMeta,
        patternId.isAcceptableOrUnknown(data['pattern_id']!, _patternIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patternIdMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('shift_template_id')) {
      context.handle(
        _shiftTemplateIdMeta,
        shiftTemplateId.isAcceptableOrUnknown(
          data['shift_template_id']!,
          _shiftTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('is_off_day')) {
      context.handle(
        _isOffDayMeta,
        isOffDay.isAcceptableOrUnknown(data['is_off_day']!, _isOffDayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftPatternEntriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftPatternEntriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patternId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern_id'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      shiftTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_template_id'],
      ),
      isOffDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_off_day'],
      )!,
    );
  }

  @override
  $ShiftPatternEntriesTableTable createAlias(String alias) {
    return $ShiftPatternEntriesTableTable(attachedDatabase, alias);
  }
}

class ShiftPatternEntriesTableData extends DataClass
    implements Insertable<ShiftPatternEntriesTableData> {
  final String id;
  final String patternId;
  final int dayIndex;
  final String? shiftTemplateId;
  final bool isOffDay;
  const ShiftPatternEntriesTableData({
    required this.id,
    required this.patternId,
    required this.dayIndex,
    this.shiftTemplateId,
    required this.isOffDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pattern_id'] = Variable<String>(patternId);
    map['day_index'] = Variable<int>(dayIndex);
    if (!nullToAbsent || shiftTemplateId != null) {
      map['shift_template_id'] = Variable<String>(shiftTemplateId);
    }
    map['is_off_day'] = Variable<bool>(isOffDay);
    return map;
  }

  ShiftPatternEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return ShiftPatternEntriesTableCompanion(
      id: Value(id),
      patternId: Value(patternId),
      dayIndex: Value(dayIndex),
      shiftTemplateId: shiftTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftTemplateId),
      isOffDay: Value(isOffDay),
    );
  }

  factory ShiftPatternEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftPatternEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      patternId: serializer.fromJson<String>(json['patternId']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      shiftTemplateId: serializer.fromJson<String?>(json['shiftTemplateId']),
      isOffDay: serializer.fromJson<bool>(json['isOffDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patternId': serializer.toJson<String>(patternId),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'shiftTemplateId': serializer.toJson<String?>(shiftTemplateId),
      'isOffDay': serializer.toJson<bool>(isOffDay),
    };
  }

  ShiftPatternEntriesTableData copyWith({
    String? id,
    String? patternId,
    int? dayIndex,
    Value<String?> shiftTemplateId = const Value.absent(),
    bool? isOffDay,
  }) => ShiftPatternEntriesTableData(
    id: id ?? this.id,
    patternId: patternId ?? this.patternId,
    dayIndex: dayIndex ?? this.dayIndex,
    shiftTemplateId: shiftTemplateId.present
        ? shiftTemplateId.value
        : this.shiftTemplateId,
    isOffDay: isOffDay ?? this.isOffDay,
  );
  ShiftPatternEntriesTableData copyWithCompanion(
    ShiftPatternEntriesTableCompanion data,
  ) {
    return ShiftPatternEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      patternId: data.patternId.present ? data.patternId.value : this.patternId,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      shiftTemplateId: data.shiftTemplateId.present
          ? data.shiftTemplateId.value
          : this.shiftTemplateId,
      isOffDay: data.isOffDay.present ? data.isOffDay.value : this.isOffDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftPatternEntriesTableData(')
          ..write('id: $id, ')
          ..write('patternId: $patternId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('shiftTemplateId: $shiftTemplateId, ')
          ..write('isOffDay: $isOffDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, patternId, dayIndex, shiftTemplateId, isOffDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftPatternEntriesTableData &&
          other.id == this.id &&
          other.patternId == this.patternId &&
          other.dayIndex == this.dayIndex &&
          other.shiftTemplateId == this.shiftTemplateId &&
          other.isOffDay == this.isOffDay);
}

class ShiftPatternEntriesTableCompanion
    extends UpdateCompanion<ShiftPatternEntriesTableData> {
  final Value<String> id;
  final Value<String> patternId;
  final Value<int> dayIndex;
  final Value<String?> shiftTemplateId;
  final Value<bool> isOffDay;
  final Value<int> rowid;
  const ShiftPatternEntriesTableCompanion({
    this.id = const Value.absent(),
    this.patternId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.shiftTemplateId = const Value.absent(),
    this.isOffDay = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftPatternEntriesTableCompanion.insert({
    required String id,
    required String patternId,
    required int dayIndex,
    this.shiftTemplateId = const Value.absent(),
    this.isOffDay = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patternId = Value(patternId),
       dayIndex = Value(dayIndex);
  static Insertable<ShiftPatternEntriesTableData> custom({
    Expression<String>? id,
    Expression<String>? patternId,
    Expression<int>? dayIndex,
    Expression<String>? shiftTemplateId,
    Expression<bool>? isOffDay,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patternId != null) 'pattern_id': patternId,
      if (dayIndex != null) 'day_index': dayIndex,
      if (shiftTemplateId != null) 'shift_template_id': shiftTemplateId,
      if (isOffDay != null) 'is_off_day': isOffDay,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftPatternEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? patternId,
    Value<int>? dayIndex,
    Value<String?>? shiftTemplateId,
    Value<bool>? isOffDay,
    Value<int>? rowid,
  }) {
    return ShiftPatternEntriesTableCompanion(
      id: id ?? this.id,
      patternId: patternId ?? this.patternId,
      dayIndex: dayIndex ?? this.dayIndex,
      shiftTemplateId: shiftTemplateId ?? this.shiftTemplateId,
      isOffDay: isOffDay ?? this.isOffDay,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patternId.present) {
      map['pattern_id'] = Variable<String>(patternId.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (shiftTemplateId.present) {
      map['shift_template_id'] = Variable<String>(shiftTemplateId.value);
    }
    if (isOffDay.present) {
      map['is_off_day'] = Variable<bool>(isOffDay.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftPatternEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('patternId: $patternId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('shiftTemplateId: $shiftTemplateId, ')
          ..write('isOffDay: $isOffDay, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftInstancesTableTable extends ShiftInstancesTable
    with TableInfo<$ShiftInstancesTableTable, ShiftInstancesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftInstancesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jobs_table (id)',
    ),
  );
  static const VerificationMeta _shiftTemplateIdMeta = const VerificationMeta(
    'shiftTemplateId',
  );
  @override
  late final GeneratedColumn<String> shiftTemplateId = GeneratedColumn<String>(
    'shift_template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_templates_table (id)',
    ),
  );
  static const VerificationMeta _startDateTimeMeta = const VerificationMeta(
    'startDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> startDateTime =
      GeneratedColumn<DateTime>(
        'start_date_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _endDateTimeMeta = const VerificationMeta(
    'endDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> endDateTime = GeneratedColumn<DateTime>(
    'end_date_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unpaidBreakMinutesMeta =
      const VerificationMeta('unpaidBreakMinutes');
  @override
  late final GeneratedColumn<int> unpaidBreakMinutes = GeneratedColumn<int>(
    'unpaid_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overrideTypeMeta = const VerificationMeta(
    'overrideType',
  );
  @override
  late final GeneratedColumn<String> overrideType = GeneratedColumn<String>(
    'override_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOffDayMeta = const VerificationMeta(
    'isOffDay',
  );
  @override
  late final GeneratedColumn<bool> isOffDay = GeneratedColumn<bool>(
    'is_off_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_off_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isHolidayMeta = const VerificationMeta(
    'isHoliday',
  );
  @override
  late final GeneratedColumn<bool> isHoliday = GeneratedColumn<bool>(
    'is_holiday',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_holiday" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobId,
    shiftTemplateId,
    startDateTime,
    endDateTime,
    unpaidBreakMinutes,
    source,
    overrideType,
    note,
    isOffDay,
    isHoliday,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_instances_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftInstancesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('shift_template_id')) {
      context.handle(
        _shiftTemplateIdMeta,
        shiftTemplateId.isAcceptableOrUnknown(
          data['shift_template_id']!,
          _shiftTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('start_date_time')) {
      context.handle(
        _startDateTimeMeta,
        startDateTime.isAcceptableOrUnknown(
          data['start_date_time']!,
          _startDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startDateTimeMeta);
    }
    if (data.containsKey('end_date_time')) {
      context.handle(
        _endDateTimeMeta,
        endDateTime.isAcceptableOrUnknown(
          data['end_date_time']!,
          _endDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_endDateTimeMeta);
    }
    if (data.containsKey('unpaid_break_minutes')) {
      context.handle(
        _unpaidBreakMinutesMeta,
        unpaidBreakMinutes.isAcceptableOrUnknown(
          data['unpaid_break_minutes']!,
          _unpaidBreakMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unpaidBreakMinutesMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('override_type')) {
      context.handle(
        _overrideTypeMeta,
        overrideType.isAcceptableOrUnknown(
          data['override_type']!,
          _overrideTypeMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_off_day')) {
      context.handle(
        _isOffDayMeta,
        isOffDay.isAcceptableOrUnknown(data['is_off_day']!, _isOffDayMeta),
      );
    }
    if (data.containsKey('is_holiday')) {
      context.handle(
        _isHolidayMeta,
        isHoliday.isAcceptableOrUnknown(data['is_holiday']!, _isHolidayMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftInstancesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftInstancesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      shiftTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_template_id'],
      ),
      startDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date_time'],
      )!,
      endDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date_time'],
      )!,
      unpaidBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unpaid_break_minutes'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      overrideType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}override_type'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      isOffDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_off_day'],
      )!,
      isHoliday: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_holiday'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ShiftInstancesTableTable createAlias(String alias) {
    return $ShiftInstancesTableTable(attachedDatabase, alias);
  }
}

class ShiftInstancesTableData extends DataClass
    implements Insertable<ShiftInstancesTableData> {
  final String id;
  final String jobId;
  final String? shiftTemplateId;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int unpaidBreakMinutes;
  final String source;
  final String? overrideType;
  final String? note;
  final bool isOffDay;
  final bool isHoliday;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ShiftInstancesTableData({
    required this.id,
    required this.jobId,
    this.shiftTemplateId,
    required this.startDateTime,
    required this.endDateTime,
    required this.unpaidBreakMinutes,
    required this.source,
    this.overrideType,
    this.note,
    required this.isOffDay,
    required this.isHoliday,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    if (!nullToAbsent || shiftTemplateId != null) {
      map['shift_template_id'] = Variable<String>(shiftTemplateId);
    }
    map['start_date_time'] = Variable<DateTime>(startDateTime);
    map['end_date_time'] = Variable<DateTime>(endDateTime);
    map['unpaid_break_minutes'] = Variable<int>(unpaidBreakMinutes);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || overrideType != null) {
      map['override_type'] = Variable<String>(overrideType);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_off_day'] = Variable<bool>(isOffDay);
    map['is_holiday'] = Variable<bool>(isHoliday);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ShiftInstancesTableCompanion toCompanion(bool nullToAbsent) {
    return ShiftInstancesTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      shiftTemplateId: shiftTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftTemplateId),
      startDateTime: Value(startDateTime),
      endDateTime: Value(endDateTime),
      unpaidBreakMinutes: Value(unpaidBreakMinutes),
      source: Value(source),
      overrideType: overrideType == null && nullToAbsent
          ? const Value.absent()
          : Value(overrideType),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isOffDay: Value(isOffDay),
      isHoliday: Value(isHoliday),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ShiftInstancesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftInstancesTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      shiftTemplateId: serializer.fromJson<String?>(json['shiftTemplateId']),
      startDateTime: serializer.fromJson<DateTime>(json['startDateTime']),
      endDateTime: serializer.fromJson<DateTime>(json['endDateTime']),
      unpaidBreakMinutes: serializer.fromJson<int>(json['unpaidBreakMinutes']),
      source: serializer.fromJson<String>(json['source']),
      overrideType: serializer.fromJson<String?>(json['overrideType']),
      note: serializer.fromJson<String?>(json['note']),
      isOffDay: serializer.fromJson<bool>(json['isOffDay']),
      isHoliday: serializer.fromJson<bool>(json['isHoliday']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'shiftTemplateId': serializer.toJson<String?>(shiftTemplateId),
      'startDateTime': serializer.toJson<DateTime>(startDateTime),
      'endDateTime': serializer.toJson<DateTime>(endDateTime),
      'unpaidBreakMinutes': serializer.toJson<int>(unpaidBreakMinutes),
      'source': serializer.toJson<String>(source),
      'overrideType': serializer.toJson<String?>(overrideType),
      'note': serializer.toJson<String?>(note),
      'isOffDay': serializer.toJson<bool>(isOffDay),
      'isHoliday': serializer.toJson<bool>(isHoliday),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ShiftInstancesTableData copyWith({
    String? id,
    String? jobId,
    Value<String?> shiftTemplateId = const Value.absent(),
    DateTime? startDateTime,
    DateTime? endDateTime,
    int? unpaidBreakMinutes,
    String? source,
    Value<String?> overrideType = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? isOffDay,
    bool? isHoliday,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ShiftInstancesTableData(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    shiftTemplateId: shiftTemplateId.present
        ? shiftTemplateId.value
        : this.shiftTemplateId,
    startDateTime: startDateTime ?? this.startDateTime,
    endDateTime: endDateTime ?? this.endDateTime,
    unpaidBreakMinutes: unpaidBreakMinutes ?? this.unpaidBreakMinutes,
    source: source ?? this.source,
    overrideType: overrideType.present ? overrideType.value : this.overrideType,
    note: note.present ? note.value : this.note,
    isOffDay: isOffDay ?? this.isOffDay,
    isHoliday: isHoliday ?? this.isHoliday,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ShiftInstancesTableData copyWithCompanion(ShiftInstancesTableCompanion data) {
    return ShiftInstancesTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      shiftTemplateId: data.shiftTemplateId.present
          ? data.shiftTemplateId.value
          : this.shiftTemplateId,
      startDateTime: data.startDateTime.present
          ? data.startDateTime.value
          : this.startDateTime,
      endDateTime: data.endDateTime.present
          ? data.endDateTime.value
          : this.endDateTime,
      unpaidBreakMinutes: data.unpaidBreakMinutes.present
          ? data.unpaidBreakMinutes.value
          : this.unpaidBreakMinutes,
      source: data.source.present ? data.source.value : this.source,
      overrideType: data.overrideType.present
          ? data.overrideType.value
          : this.overrideType,
      note: data.note.present ? data.note.value : this.note,
      isOffDay: data.isOffDay.present ? data.isOffDay.value : this.isOffDay,
      isHoliday: data.isHoliday.present ? data.isHoliday.value : this.isHoliday,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftInstancesTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('shiftTemplateId: $shiftTemplateId, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('unpaidBreakMinutes: $unpaidBreakMinutes, ')
          ..write('source: $source, ')
          ..write('overrideType: $overrideType, ')
          ..write('note: $note, ')
          ..write('isOffDay: $isOffDay, ')
          ..write('isHoliday: $isHoliday, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jobId,
    shiftTemplateId,
    startDateTime,
    endDateTime,
    unpaidBreakMinutes,
    source,
    overrideType,
    note,
    isOffDay,
    isHoliday,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftInstancesTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.shiftTemplateId == this.shiftTemplateId &&
          other.startDateTime == this.startDateTime &&
          other.endDateTime == this.endDateTime &&
          other.unpaidBreakMinutes == this.unpaidBreakMinutes &&
          other.source == this.source &&
          other.overrideType == this.overrideType &&
          other.note == this.note &&
          other.isOffDay == this.isOffDay &&
          other.isHoliday == this.isHoliday &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ShiftInstancesTableCompanion
    extends UpdateCompanion<ShiftInstancesTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<String?> shiftTemplateId;
  final Value<DateTime> startDateTime;
  final Value<DateTime> endDateTime;
  final Value<int> unpaidBreakMinutes;
  final Value<String> source;
  final Value<String?> overrideType;
  final Value<String?> note;
  final Value<bool> isOffDay;
  final Value<bool> isHoliday;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ShiftInstancesTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.shiftTemplateId = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
    this.unpaidBreakMinutes = const Value.absent(),
    this.source = const Value.absent(),
    this.overrideType = const Value.absent(),
    this.note = const Value.absent(),
    this.isOffDay = const Value.absent(),
    this.isHoliday = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftInstancesTableCompanion.insert({
    required String id,
    required String jobId,
    this.shiftTemplateId = const Value.absent(),
    required DateTime startDateTime,
    required DateTime endDateTime,
    required int unpaidBreakMinutes,
    required String source,
    this.overrideType = const Value.absent(),
    this.note = const Value.absent(),
    this.isOffDay = const Value.absent(),
    this.isHoliday = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       startDateTime = Value(startDateTime),
       endDateTime = Value(endDateTime),
       unpaidBreakMinutes = Value(unpaidBreakMinutes),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ShiftInstancesTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<String>? shiftTemplateId,
    Expression<DateTime>? startDateTime,
    Expression<DateTime>? endDateTime,
    Expression<int>? unpaidBreakMinutes,
    Expression<String>? source,
    Expression<String>? overrideType,
    Expression<String>? note,
    Expression<bool>? isOffDay,
    Expression<bool>? isHoliday,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (shiftTemplateId != null) 'shift_template_id': shiftTemplateId,
      if (startDateTime != null) 'start_date_time': startDateTime,
      if (endDateTime != null) 'end_date_time': endDateTime,
      if (unpaidBreakMinutes != null)
        'unpaid_break_minutes': unpaidBreakMinutes,
      if (source != null) 'source': source,
      if (overrideType != null) 'override_type': overrideType,
      if (note != null) 'note': note,
      if (isOffDay != null) 'is_off_day': isOffDay,
      if (isHoliday != null) 'is_holiday': isHoliday,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftInstancesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<String?>? shiftTemplateId,
    Value<DateTime>? startDateTime,
    Value<DateTime>? endDateTime,
    Value<int>? unpaidBreakMinutes,
    Value<String>? source,
    Value<String?>? overrideType,
    Value<String?>? note,
    Value<bool>? isOffDay,
    Value<bool>? isHoliday,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ShiftInstancesTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      shiftTemplateId: shiftTemplateId ?? this.shiftTemplateId,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      unpaidBreakMinutes: unpaidBreakMinutes ?? this.unpaidBreakMinutes,
      source: source ?? this.source,
      overrideType: overrideType ?? this.overrideType,
      note: note ?? this.note,
      isOffDay: isOffDay ?? this.isOffDay,
      isHoliday: isHoliday ?? this.isHoliday,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (shiftTemplateId.present) {
      map['shift_template_id'] = Variable<String>(shiftTemplateId.value);
    }
    if (startDateTime.present) {
      map['start_date_time'] = Variable<DateTime>(startDateTime.value);
    }
    if (endDateTime.present) {
      map['end_date_time'] = Variable<DateTime>(endDateTime.value);
    }
    if (unpaidBreakMinutes.present) {
      map['unpaid_break_minutes'] = Variable<int>(unpaidBreakMinutes.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (overrideType.present) {
      map['override_type'] = Variable<String>(overrideType.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isOffDay.present) {
      map['is_off_day'] = Variable<bool>(isOffDay.value);
    }
    if (isHoliday.present) {
      map['is_holiday'] = Variable<bool>(isHoliday.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftInstancesTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('shiftTemplateId: $shiftTemplateId, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('unpaidBreakMinutes: $unpaidBreakMinutes, ')
          ..write('source: $source, ')
          ..write('overrideType: $overrideType, ')
          ..write('note: $note, ')
          ..write('isOffDay: $isOffDay, ')
          ..write('isHoliday: $isHoliday, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderRulesTableTable extends ReminderRulesTable
    with TableInfo<$ReminderRulesTableTable, ReminderRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jobs_table (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leadMinutesMeta = const VerificationMeta(
    'leadMinutes',
  );
  @override
  late final GeneratedColumn<int> leadMinutes = GeneratedColumn<int>(
    'lead_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, jobId, type, leadMinutes, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_rules_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRulesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('lead_minutes')) {
      context.handle(
        _leadMinutesMeta,
        leadMinutes.isAcceptableOrUnknown(
          data['lead_minutes']!,
          _leadMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_leadMinutesMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderRulesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRulesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      leadMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lead_minutes'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $ReminderRulesTableTable createAlias(String alias) {
    return $ReminderRulesTableTable(attachedDatabase, alias);
  }
}

class ReminderRulesTableData extends DataClass
    implements Insertable<ReminderRulesTableData> {
  final String id;
  final String jobId;
  final String type;
  final int leadMinutes;
  final bool enabled;
  const ReminderRulesTableData({
    required this.id,
    required this.jobId,
    required this.type,
    required this.leadMinutes,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['type'] = Variable<String>(type);
    map['lead_minutes'] = Variable<int>(leadMinutes);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  ReminderRulesTableCompanion toCompanion(bool nullToAbsent) {
    return ReminderRulesTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      type: Value(type),
      leadMinutes: Value(leadMinutes),
      enabled: Value(enabled),
    );
  }

  factory ReminderRulesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRulesTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      type: serializer.fromJson<String>(json['type']),
      leadMinutes: serializer.fromJson<int>(json['leadMinutes']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'type': serializer.toJson<String>(type),
      'leadMinutes': serializer.toJson<int>(leadMinutes),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  ReminderRulesTableData copyWith({
    String? id,
    String? jobId,
    String? type,
    int? leadMinutes,
    bool? enabled,
  }) => ReminderRulesTableData(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    type: type ?? this.type,
    leadMinutes: leadMinutes ?? this.leadMinutes,
    enabled: enabled ?? this.enabled,
  );
  ReminderRulesTableData copyWithCompanion(ReminderRulesTableCompanion data) {
    return ReminderRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      type: data.type.present ? data.type.value : this.type,
      leadMinutes: data.leadMinutes.present
          ? data.leadMinutes.value
          : this.leadMinutes,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRulesTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('type: $type, ')
          ..write('leadMinutes: $leadMinutes, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, jobId, type, leadMinutes, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRulesTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.type == this.type &&
          other.leadMinutes == this.leadMinutes &&
          other.enabled == this.enabled);
}

class ReminderRulesTableCompanion
    extends UpdateCompanion<ReminderRulesTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<String> type;
  final Value<int> leadMinutes;
  final Value<bool> enabled;
  final Value<int> rowid;
  const ReminderRulesTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.type = const Value.absent(),
    this.leadMinutes = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderRulesTableCompanion.insert({
    required String id,
    required String jobId,
    required String type,
    required int leadMinutes,
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       type = Value(type),
       leadMinutes = Value(leadMinutes);
  static Insertable<ReminderRulesTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<String>? type,
    Expression<int>? leadMinutes,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (type != null) 'type': type,
      if (leadMinutes != null) 'lead_minutes': leadMinutes,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderRulesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<String>? type,
    Value<int>? leadMinutes,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return ReminderRulesTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      type: type ?? this.type,
      leadMinutes: leadMinutes ?? this.leadMinutes,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (leadMinutes.present) {
      map['lead_minutes'] = Variable<int>(leadMinutes.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('type: $type, ')
          ..write('leadMinutes: $leadMinutes, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanningSettingsTableTable extends PlanningSettingsTable
    with TableInfo<$PlanningSettingsTableTable, PlanningSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanningSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES jobs_table (id)',
    ),
  );
  static const VerificationMeta _planningAlertsEnabledMeta =
      const VerificationMeta('planningAlertsEnabled');
  @override
  late final GeneratedColumn<bool> planningAlertsEnabled =
      GeneratedColumn<bool>(
        'planning_alerts_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("planning_alerts_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _minimumRestMinutesMeta =
      const VerificationMeta('minimumRestMinutes');
  @override
  late final GeneratedColumn<int> minimumRestMinutes = GeneratedColumn<int>(
    'minimum_rest_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxConsecutiveWorkDaysMeta =
      const VerificationMeta('maxConsecutiveWorkDays');
  @override
  late final GeneratedColumn<int> maxConsecutiveWorkDays = GeneratedColumn<int>(
    'max_consecutive_work_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyOvertimeCapMinutesMeta =
      const VerificationMeta('weeklyOvertimeCapMinutes');
  @override
  late final GeneratedColumn<int> weeklyOvertimeCapMinutes =
      GeneratedColumn<int>(
        'weekly_overtime_cap_minutes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _monthlyOvertimeCapMinutesMeta =
      const VerificationMeta('monthlyOvertimeCapMinutes');
  @override
  late final GeneratedColumn<int> monthlyOvertimeCapMinutes =
      GeneratedColumn<int>(
        'monthly_overtime_cap_minutes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobId,
    planningAlertsEnabled,
    minimumRestMinutes,
    maxConsecutiveWorkDays,
    weeklyOvertimeCapMinutes,
    monthlyOvertimeCapMinutes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planning_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanningSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('planning_alerts_enabled')) {
      context.handle(
        _planningAlertsEnabledMeta,
        planningAlertsEnabled.isAcceptableOrUnknown(
          data['planning_alerts_enabled']!,
          _planningAlertsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('minimum_rest_minutes')) {
      context.handle(
        _minimumRestMinutesMeta,
        minimumRestMinutes.isAcceptableOrUnknown(
          data['minimum_rest_minutes']!,
          _minimumRestMinutesMeta,
        ),
      );
    }
    if (data.containsKey('max_consecutive_work_days')) {
      context.handle(
        _maxConsecutiveWorkDaysMeta,
        maxConsecutiveWorkDays.isAcceptableOrUnknown(
          data['max_consecutive_work_days']!,
          _maxConsecutiveWorkDaysMeta,
        ),
      );
    }
    if (data.containsKey('weekly_overtime_cap_minutes')) {
      context.handle(
        _weeklyOvertimeCapMinutesMeta,
        weeklyOvertimeCapMinutes.isAcceptableOrUnknown(
          data['weekly_overtime_cap_minutes']!,
          _weeklyOvertimeCapMinutesMeta,
        ),
      );
    }
    if (data.containsKey('monthly_overtime_cap_minutes')) {
      context.handle(
        _monthlyOvertimeCapMinutesMeta,
        monthlyOvertimeCapMinutes.isAcceptableOrUnknown(
          data['monthly_overtime_cap_minutes']!,
          _monthlyOvertimeCapMinutesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanningSettingsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanningSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      planningAlertsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}planning_alerts_enabled'],
      )!,
      minimumRestMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_rest_minutes'],
      ),
      maxConsecutiveWorkDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_consecutive_work_days'],
      ),
      weeklyOvertimeCapMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_overtime_cap_minutes'],
      ),
      monthlyOvertimeCapMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_overtime_cap_minutes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlanningSettingsTableTable createAlias(String alias) {
    return $PlanningSettingsTableTable(attachedDatabase, alias);
  }
}

class PlanningSettingsTableData extends DataClass
    implements Insertable<PlanningSettingsTableData> {
  final String id;
  final String jobId;
  final bool planningAlertsEnabled;
  final int? minimumRestMinutes;
  final int? maxConsecutiveWorkDays;
  final int? weeklyOvertimeCapMinutes;
  final int? monthlyOvertimeCapMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PlanningSettingsTableData({
    required this.id,
    required this.jobId,
    required this.planningAlertsEnabled,
    this.minimumRestMinutes,
    this.maxConsecutiveWorkDays,
    this.weeklyOvertimeCapMinutes,
    this.monthlyOvertimeCapMinutes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['planning_alerts_enabled'] = Variable<bool>(planningAlertsEnabled);
    if (!nullToAbsent || minimumRestMinutes != null) {
      map['minimum_rest_minutes'] = Variable<int>(minimumRestMinutes);
    }
    if (!nullToAbsent || maxConsecutiveWorkDays != null) {
      map['max_consecutive_work_days'] = Variable<int>(maxConsecutiveWorkDays);
    }
    if (!nullToAbsent || weeklyOvertimeCapMinutes != null) {
      map['weekly_overtime_cap_minutes'] = Variable<int>(
        weeklyOvertimeCapMinutes,
      );
    }
    if (!nullToAbsent || monthlyOvertimeCapMinutes != null) {
      map['monthly_overtime_cap_minutes'] = Variable<int>(
        monthlyOvertimeCapMinutes,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlanningSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return PlanningSettingsTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      planningAlertsEnabled: Value(planningAlertsEnabled),
      minimumRestMinutes: minimumRestMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(minimumRestMinutes),
      maxConsecutiveWorkDays: maxConsecutiveWorkDays == null && nullToAbsent
          ? const Value.absent()
          : Value(maxConsecutiveWorkDays),
      weeklyOvertimeCapMinutes: weeklyOvertimeCapMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyOvertimeCapMinutes),
      monthlyOvertimeCapMinutes:
          monthlyOvertimeCapMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyOvertimeCapMinutes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlanningSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanningSettingsTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      planningAlertsEnabled: serializer.fromJson<bool>(
        json['planningAlertsEnabled'],
      ),
      minimumRestMinutes: serializer.fromJson<int?>(json['minimumRestMinutes']),
      maxConsecutiveWorkDays: serializer.fromJson<int?>(
        json['maxConsecutiveWorkDays'],
      ),
      weeklyOvertimeCapMinutes: serializer.fromJson<int?>(
        json['weeklyOvertimeCapMinutes'],
      ),
      monthlyOvertimeCapMinutes: serializer.fromJson<int?>(
        json['monthlyOvertimeCapMinutes'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'planningAlertsEnabled': serializer.toJson<bool>(planningAlertsEnabled),
      'minimumRestMinutes': serializer.toJson<int?>(minimumRestMinutes),
      'maxConsecutiveWorkDays': serializer.toJson<int?>(maxConsecutiveWorkDays),
      'weeklyOvertimeCapMinutes': serializer.toJson<int?>(
        weeklyOvertimeCapMinutes,
      ),
      'monthlyOvertimeCapMinutes': serializer.toJson<int?>(
        monthlyOvertimeCapMinutes,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlanningSettingsTableData copyWith({
    String? id,
    String? jobId,
    bool? planningAlertsEnabled,
    Value<int?> minimumRestMinutes = const Value.absent(),
    Value<int?> maxConsecutiveWorkDays = const Value.absent(),
    Value<int?> weeklyOvertimeCapMinutes = const Value.absent(),
    Value<int?> monthlyOvertimeCapMinutes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PlanningSettingsTableData(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    planningAlertsEnabled: planningAlertsEnabled ?? this.planningAlertsEnabled,
    minimumRestMinutes: minimumRestMinutes.present
        ? minimumRestMinutes.value
        : this.minimumRestMinutes,
    maxConsecutiveWorkDays: maxConsecutiveWorkDays.present
        ? maxConsecutiveWorkDays.value
        : this.maxConsecutiveWorkDays,
    weeklyOvertimeCapMinutes: weeklyOvertimeCapMinutes.present
        ? weeklyOvertimeCapMinutes.value
        : this.weeklyOvertimeCapMinutes,
    monthlyOvertimeCapMinutes: monthlyOvertimeCapMinutes.present
        ? monthlyOvertimeCapMinutes.value
        : this.monthlyOvertimeCapMinutes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlanningSettingsTableData copyWithCompanion(
    PlanningSettingsTableCompanion data,
  ) {
    return PlanningSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      planningAlertsEnabled: data.planningAlertsEnabled.present
          ? data.planningAlertsEnabled.value
          : this.planningAlertsEnabled,
      minimumRestMinutes: data.minimumRestMinutes.present
          ? data.minimumRestMinutes.value
          : this.minimumRestMinutes,
      maxConsecutiveWorkDays: data.maxConsecutiveWorkDays.present
          ? data.maxConsecutiveWorkDays.value
          : this.maxConsecutiveWorkDays,
      weeklyOvertimeCapMinutes: data.weeklyOvertimeCapMinutes.present
          ? data.weeklyOvertimeCapMinutes.value
          : this.weeklyOvertimeCapMinutes,
      monthlyOvertimeCapMinutes: data.monthlyOvertimeCapMinutes.present
          ? data.monthlyOvertimeCapMinutes.value
          : this.monthlyOvertimeCapMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanningSettingsTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('planningAlertsEnabled: $planningAlertsEnabled, ')
          ..write('minimumRestMinutes: $minimumRestMinutes, ')
          ..write('maxConsecutiveWorkDays: $maxConsecutiveWorkDays, ')
          ..write('weeklyOvertimeCapMinutes: $weeklyOvertimeCapMinutes, ')
          ..write('monthlyOvertimeCapMinutes: $monthlyOvertimeCapMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jobId,
    planningAlertsEnabled,
    minimumRestMinutes,
    maxConsecutiveWorkDays,
    weeklyOvertimeCapMinutes,
    monthlyOvertimeCapMinutes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanningSettingsTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.planningAlertsEnabled == this.planningAlertsEnabled &&
          other.minimumRestMinutes == this.minimumRestMinutes &&
          other.maxConsecutiveWorkDays == this.maxConsecutiveWorkDays &&
          other.weeklyOvertimeCapMinutes == this.weeklyOvertimeCapMinutes &&
          other.monthlyOvertimeCapMinutes == this.monthlyOvertimeCapMinutes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlanningSettingsTableCompanion
    extends UpdateCompanion<PlanningSettingsTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<bool> planningAlertsEnabled;
  final Value<int?> minimumRestMinutes;
  final Value<int?> maxConsecutiveWorkDays;
  final Value<int?> weeklyOvertimeCapMinutes;
  final Value<int?> monthlyOvertimeCapMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlanningSettingsTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.planningAlertsEnabled = const Value.absent(),
    this.minimumRestMinutes = const Value.absent(),
    this.maxConsecutiveWorkDays = const Value.absent(),
    this.weeklyOvertimeCapMinutes = const Value.absent(),
    this.monthlyOvertimeCapMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanningSettingsTableCompanion.insert({
    required String id,
    required String jobId,
    this.planningAlertsEnabled = const Value.absent(),
    this.minimumRestMinutes = const Value.absent(),
    this.maxConsecutiveWorkDays = const Value.absent(),
    this.weeklyOvertimeCapMinutes = const Value.absent(),
    this.monthlyOvertimeCapMinutes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PlanningSettingsTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<bool>? planningAlertsEnabled,
    Expression<int>? minimumRestMinutes,
    Expression<int>? maxConsecutiveWorkDays,
    Expression<int>? weeklyOvertimeCapMinutes,
    Expression<int>? monthlyOvertimeCapMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (planningAlertsEnabled != null)
        'planning_alerts_enabled': planningAlertsEnabled,
      if (minimumRestMinutes != null)
        'minimum_rest_minutes': minimumRestMinutes,
      if (maxConsecutiveWorkDays != null)
        'max_consecutive_work_days': maxConsecutiveWorkDays,
      if (weeklyOvertimeCapMinutes != null)
        'weekly_overtime_cap_minutes': weeklyOvertimeCapMinutes,
      if (monthlyOvertimeCapMinutes != null)
        'monthly_overtime_cap_minutes': monthlyOvertimeCapMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanningSettingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<bool>? planningAlertsEnabled,
    Value<int?>? minimumRestMinutes,
    Value<int?>? maxConsecutiveWorkDays,
    Value<int?>? weeklyOvertimeCapMinutes,
    Value<int?>? monthlyOvertimeCapMinutes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlanningSettingsTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      planningAlertsEnabled:
          planningAlertsEnabled ?? this.planningAlertsEnabled,
      minimumRestMinutes: minimumRestMinutes ?? this.minimumRestMinutes,
      maxConsecutiveWorkDays:
          maxConsecutiveWorkDays ?? this.maxConsecutiveWorkDays,
      weeklyOvertimeCapMinutes:
          weeklyOvertimeCapMinutes ?? this.weeklyOvertimeCapMinutes,
      monthlyOvertimeCapMinutes:
          monthlyOvertimeCapMinutes ?? this.monthlyOvertimeCapMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (planningAlertsEnabled.present) {
      map['planning_alerts_enabled'] = Variable<bool>(
        planningAlertsEnabled.value,
      );
    }
    if (minimumRestMinutes.present) {
      map['minimum_rest_minutes'] = Variable<int>(minimumRestMinutes.value);
    }
    if (maxConsecutiveWorkDays.present) {
      map['max_consecutive_work_days'] = Variable<int>(
        maxConsecutiveWorkDays.value,
      );
    }
    if (weeklyOvertimeCapMinutes.present) {
      map['weekly_overtime_cap_minutes'] = Variable<int>(
        weeklyOvertimeCapMinutes.value,
      );
    }
    if (monthlyOvertimeCapMinutes.present) {
      map['monthly_overtime_cap_minutes'] = Variable<int>(
        monthlyOvertimeCapMinutes.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanningSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('planningAlertsEnabled: $planningAlertsEnabled, ')
          ..write('minimumRestMinutes: $minimumRestMinutes, ')
          ..write('maxConsecutiveWorkDays: $maxConsecutiveWorkDays, ')
          ..write('weeklyOvertimeCapMinutes: $weeklyOvertimeCapMinutes, ')
          ..write('monthlyOvertimeCapMinutes: $monthlyOvertimeCapMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AvailabilityRulesTableTable extends AvailabilityRulesTable
    with TableInfo<$AvailabilityRulesTableTable, AvailabilityRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AvailabilityRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jobs_table (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateTimeMeta = const VerificationMeta(
    'startDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> startDateTime =
      GeneratedColumn<DateTime>(
        'start_date_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _endDateTimeMeta = const VerificationMeta(
    'endDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> endDateTime = GeneratedColumn<DateTime>(
    'end_date_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startMinuteOfDayMeta = const VerificationMeta(
    'startMinuteOfDay',
  );
  @override
  late final GeneratedColumn<int> startMinuteOfDay = GeneratedColumn<int>(
    'start_minute_of_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMinuteOfDayMeta = const VerificationMeta(
    'endMinuteOfDay',
  );
  @override
  late final GeneratedColumn<int> endMinuteOfDay = GeneratedColumn<int>(
    'end_minute_of_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobId,
    type,
    state,
    startDateTime,
    endDateTime,
    weekday,
    startMinuteOfDay,
    endMinuteOfDay,
    note,
    isEnabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'availability_rules_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AvailabilityRulesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('start_date_time')) {
      context.handle(
        _startDateTimeMeta,
        startDateTime.isAcceptableOrUnknown(
          data['start_date_time']!,
          _startDateTimeMeta,
        ),
      );
    }
    if (data.containsKey('end_date_time')) {
      context.handle(
        _endDateTimeMeta,
        endDateTime.isAcceptableOrUnknown(
          data['end_date_time']!,
          _endDateTimeMeta,
        ),
      );
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    }
    if (data.containsKey('start_minute_of_day')) {
      context.handle(
        _startMinuteOfDayMeta,
        startMinuteOfDay.isAcceptableOrUnknown(
          data['start_minute_of_day']!,
          _startMinuteOfDayMeta,
        ),
      );
    }
    if (data.containsKey('end_minute_of_day')) {
      context.handle(
        _endMinuteOfDayMeta,
        endMinuteOfDay.isAcceptableOrUnknown(
          data['end_minute_of_day']!,
          _endMinuteOfDayMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AvailabilityRulesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AvailabilityRulesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      startDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date_time'],
      ),
      endDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date_time'],
      ),
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      ),
      startMinuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute_of_day'],
      ),
      endMinuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute_of_day'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AvailabilityRulesTableTable createAlias(String alias) {
    return $AvailabilityRulesTableTable(attachedDatabase, alias);
  }
}

class AvailabilityRulesTableData extends DataClass
    implements Insertable<AvailabilityRulesTableData> {
  final String id;
  final String jobId;
  final String type;
  final String state;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final int? weekday;
  final int? startMinuteOfDay;
  final int? endMinuteOfDay;
  final String? note;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AvailabilityRulesTableData({
    required this.id,
    required this.jobId,
    required this.type,
    required this.state,
    this.startDateTime,
    this.endDateTime,
    this.weekday,
    this.startMinuteOfDay,
    this.endMinuteOfDay,
    this.note,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['type'] = Variable<String>(type);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || startDateTime != null) {
      map['start_date_time'] = Variable<DateTime>(startDateTime);
    }
    if (!nullToAbsent || endDateTime != null) {
      map['end_date_time'] = Variable<DateTime>(endDateTime);
    }
    if (!nullToAbsent || weekday != null) {
      map['weekday'] = Variable<int>(weekday);
    }
    if (!nullToAbsent || startMinuteOfDay != null) {
      map['start_minute_of_day'] = Variable<int>(startMinuteOfDay);
    }
    if (!nullToAbsent || endMinuteOfDay != null) {
      map['end_minute_of_day'] = Variable<int>(endMinuteOfDay);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AvailabilityRulesTableCompanion toCompanion(bool nullToAbsent) {
    return AvailabilityRulesTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      type: Value(type),
      state: Value(state),
      startDateTime: startDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startDateTime),
      endDateTime: endDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endDateTime),
      weekday: weekday == null && nullToAbsent
          ? const Value.absent()
          : Value(weekday),
      startMinuteOfDay: startMinuteOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinuteOfDay),
      endMinuteOfDay: endMinuteOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(endMinuteOfDay),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isEnabled: Value(isEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AvailabilityRulesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AvailabilityRulesTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      type: serializer.fromJson<String>(json['type']),
      state: serializer.fromJson<String>(json['state']),
      startDateTime: serializer.fromJson<DateTime?>(json['startDateTime']),
      endDateTime: serializer.fromJson<DateTime?>(json['endDateTime']),
      weekday: serializer.fromJson<int?>(json['weekday']),
      startMinuteOfDay: serializer.fromJson<int?>(json['startMinuteOfDay']),
      endMinuteOfDay: serializer.fromJson<int?>(json['endMinuteOfDay']),
      note: serializer.fromJson<String?>(json['note']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'type': serializer.toJson<String>(type),
      'state': serializer.toJson<String>(state),
      'startDateTime': serializer.toJson<DateTime?>(startDateTime),
      'endDateTime': serializer.toJson<DateTime?>(endDateTime),
      'weekday': serializer.toJson<int?>(weekday),
      'startMinuteOfDay': serializer.toJson<int?>(startMinuteOfDay),
      'endMinuteOfDay': serializer.toJson<int?>(endMinuteOfDay),
      'note': serializer.toJson<String?>(note),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AvailabilityRulesTableData copyWith({
    String? id,
    String? jobId,
    String? type,
    String? state,
    Value<DateTime?> startDateTime = const Value.absent(),
    Value<DateTime?> endDateTime = const Value.absent(),
    Value<int?> weekday = const Value.absent(),
    Value<int?> startMinuteOfDay = const Value.absent(),
    Value<int?> endMinuteOfDay = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AvailabilityRulesTableData(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    type: type ?? this.type,
    state: state ?? this.state,
    startDateTime: startDateTime.present
        ? startDateTime.value
        : this.startDateTime,
    endDateTime: endDateTime.present ? endDateTime.value : this.endDateTime,
    weekday: weekday.present ? weekday.value : this.weekday,
    startMinuteOfDay: startMinuteOfDay.present
        ? startMinuteOfDay.value
        : this.startMinuteOfDay,
    endMinuteOfDay: endMinuteOfDay.present
        ? endMinuteOfDay.value
        : this.endMinuteOfDay,
    note: note.present ? note.value : this.note,
    isEnabled: isEnabled ?? this.isEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AvailabilityRulesTableData copyWithCompanion(
    AvailabilityRulesTableCompanion data,
  ) {
    return AvailabilityRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      type: data.type.present ? data.type.value : this.type,
      state: data.state.present ? data.state.value : this.state,
      startDateTime: data.startDateTime.present
          ? data.startDateTime.value
          : this.startDateTime,
      endDateTime: data.endDateTime.present
          ? data.endDateTime.value
          : this.endDateTime,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      startMinuteOfDay: data.startMinuteOfDay.present
          ? data.startMinuteOfDay.value
          : this.startMinuteOfDay,
      endMinuteOfDay: data.endMinuteOfDay.present
          ? data.endMinuteOfDay.value
          : this.endMinuteOfDay,
      note: data.note.present ? data.note.value : this.note,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilityRulesTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('type: $type, ')
          ..write('state: $state, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('weekday: $weekday, ')
          ..write('startMinuteOfDay: $startMinuteOfDay, ')
          ..write('endMinuteOfDay: $endMinuteOfDay, ')
          ..write('note: $note, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jobId,
    type,
    state,
    startDateTime,
    endDateTime,
    weekday,
    startMinuteOfDay,
    endMinuteOfDay,
    note,
    isEnabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AvailabilityRulesTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.type == this.type &&
          other.state == this.state &&
          other.startDateTime == this.startDateTime &&
          other.endDateTime == this.endDateTime &&
          other.weekday == this.weekday &&
          other.startMinuteOfDay == this.startMinuteOfDay &&
          other.endMinuteOfDay == this.endMinuteOfDay &&
          other.note == this.note &&
          other.isEnabled == this.isEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AvailabilityRulesTableCompanion
    extends UpdateCompanion<AvailabilityRulesTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<String> type;
  final Value<String> state;
  final Value<DateTime?> startDateTime;
  final Value<DateTime?> endDateTime;
  final Value<int?> weekday;
  final Value<int?> startMinuteOfDay;
  final Value<int?> endMinuteOfDay;
  final Value<String?> note;
  final Value<bool> isEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AvailabilityRulesTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.type = const Value.absent(),
    this.state = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startMinuteOfDay = const Value.absent(),
    this.endMinuteOfDay = const Value.absent(),
    this.note = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AvailabilityRulesTableCompanion.insert({
    required String id,
    required String jobId,
    required String type,
    required String state,
    this.startDateTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startMinuteOfDay = const Value.absent(),
    this.endMinuteOfDay = const Value.absent(),
    this.note = const Value.absent(),
    this.isEnabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       type = Value(type),
       state = Value(state),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AvailabilityRulesTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<String>? type,
    Expression<String>? state,
    Expression<DateTime>? startDateTime,
    Expression<DateTime>? endDateTime,
    Expression<int>? weekday,
    Expression<int>? startMinuteOfDay,
    Expression<int>? endMinuteOfDay,
    Expression<String>? note,
    Expression<bool>? isEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (type != null) 'type': type,
      if (state != null) 'state': state,
      if (startDateTime != null) 'start_date_time': startDateTime,
      if (endDateTime != null) 'end_date_time': endDateTime,
      if (weekday != null) 'weekday': weekday,
      if (startMinuteOfDay != null) 'start_minute_of_day': startMinuteOfDay,
      if (endMinuteOfDay != null) 'end_minute_of_day': endMinuteOfDay,
      if (note != null) 'note': note,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AvailabilityRulesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<String>? type,
    Value<String>? state,
    Value<DateTime?>? startDateTime,
    Value<DateTime?>? endDateTime,
    Value<int?>? weekday,
    Value<int?>? startMinuteOfDay,
    Value<int?>? endMinuteOfDay,
    Value<String?>? note,
    Value<bool>? isEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AvailabilityRulesTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      type: type ?? this.type,
      state: state ?? this.state,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      weekday: weekday ?? this.weekday,
      startMinuteOfDay: startMinuteOfDay ?? this.startMinuteOfDay,
      endMinuteOfDay: endMinuteOfDay ?? this.endMinuteOfDay,
      note: note ?? this.note,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (startDateTime.present) {
      map['start_date_time'] = Variable<DateTime>(startDateTime.value);
    }
    if (endDateTime.present) {
      map['end_date_time'] = Variable<DateTime>(endDateTime.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (startMinuteOfDay.present) {
      map['start_minute_of_day'] = Variable<int>(startMinuteOfDay.value);
    }
    if (endMinuteOfDay.present) {
      map['end_minute_of_day'] = Variable<int>(endMinuteOfDay.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilityRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('type: $type, ')
          ..write('state: $state, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('weekday: $weekday, ')
          ..write('startMinuteOfDay: $startMinuteOfDay, ')
          ..write('endMinuteOfDay: $endMinuteOfDay, ')
          ..write('note: $note, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActualPayslipsTableTable extends ActualPayslipsTable
    with TableInfo<$ActualPayslipsTableTable, ActualPayslipsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActualPayslipsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobIdMeta = const VerificationMeta('jobId');
  @override
  late final GeneratedColumn<String> jobId = GeneratedColumn<String>(
    'job_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jobs_table (id)',
    ),
  );
  static const VerificationMeta _periodStartMeta = const VerificationMeta(
    'periodStart',
  );
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
    'period_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodEndMeta = const VerificationMeta(
    'periodEnd',
  );
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
    'period_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grossPayMinorMeta = const VerificationMeta(
    'grossPayMinor',
  );
  @override
  late final GeneratedColumn<int> grossPayMinor = GeneratedColumn<int>(
    'gross_pay_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workedMinutesReportedMeta =
      const VerificationMeta('workedMinutesReported');
  @override
  late final GeneratedColumn<int> workedMinutesReported = GeneratedColumn<int>(
    'worked_minutes_reported',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overtimePayMinorMeta = const VerificationMeta(
    'overtimePayMinor',
  );
  @override
  late final GeneratedColumn<int> overtimePayMinor = GeneratedColumn<int>(
    'overtime_pay_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _holidayPayMinorMeta = const VerificationMeta(
    'holidayPayMinor',
  );
  @override
  late final GeneratedColumn<int> holidayPayMinor = GeneratedColumn<int>(
    'holiday_pay_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allowancesMinorMeta = const VerificationMeta(
    'allowancesMinor',
  );
  @override
  late final GeneratedColumn<int> allowancesMinor = GeneratedColumn<int>(
    'allowances_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobId,
    periodStart,
    periodEnd,
    paidAt,
    grossPayMinor,
    workedMinutesReported,
    overtimePayMinor,
    holidayPayMinor,
    allowancesMinor,
    notes,
    source,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'actual_payslips_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActualPayslipsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('job_id')) {
      context.handle(
        _jobIdMeta,
        jobId.isAcceptableOrUnknown(data['job_id']!, _jobIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jobIdMeta);
    }
    if (data.containsKey('period_start')) {
      context.handle(
        _periodStartMeta,
        periodStart.isAcceptableOrUnknown(
          data['period_start']!,
          _periodStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodStartMeta);
    }
    if (data.containsKey('period_end')) {
      context.handle(
        _periodEndMeta,
        periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta),
      );
    } else if (isInserting) {
      context.missing(_periodEndMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    if (data.containsKey('gross_pay_minor')) {
      context.handle(
        _grossPayMinorMeta,
        grossPayMinor.isAcceptableOrUnknown(
          data['gross_pay_minor']!,
          _grossPayMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_grossPayMinorMeta);
    }
    if (data.containsKey('worked_minutes_reported')) {
      context.handle(
        _workedMinutesReportedMeta,
        workedMinutesReported.isAcceptableOrUnknown(
          data['worked_minutes_reported']!,
          _workedMinutesReportedMeta,
        ),
      );
    }
    if (data.containsKey('overtime_pay_minor')) {
      context.handle(
        _overtimePayMinorMeta,
        overtimePayMinor.isAcceptableOrUnknown(
          data['overtime_pay_minor']!,
          _overtimePayMinorMeta,
        ),
      );
    }
    if (data.containsKey('holiday_pay_minor')) {
      context.handle(
        _holidayPayMinorMeta,
        holidayPayMinor.isAcceptableOrUnknown(
          data['holiday_pay_minor']!,
          _holidayPayMinorMeta,
        ),
      );
    }
    if (data.containsKey('allowances_minor')) {
      context.handle(
        _allowancesMinorMeta,
        allowancesMinor.isAcceptableOrUnknown(
          data['allowances_minor']!,
          _allowancesMinorMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActualPayslipsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActualPayslipsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_id'],
      )!,
      periodStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_start'],
      )!,
      periodEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_end'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      ),
      grossPayMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gross_pay_minor'],
      )!,
      workedMinutesReported: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}worked_minutes_reported'],
      ),
      overtimePayMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overtime_pay_minor'],
      ),
      holidayPayMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}holiday_pay_minor'],
      ),
      allowancesMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allowances_minor'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActualPayslipsTableTable createAlias(String alias) {
    return $ActualPayslipsTableTable(attachedDatabase, alias);
  }
}

class ActualPayslipsTableData extends DataClass
    implements Insertable<ActualPayslipsTableData> {
  final String id;
  final String jobId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime? paidAt;
  final int grossPayMinor;
  final int? workedMinutesReported;
  final int? overtimePayMinor;
  final int? holidayPayMinor;
  final int? allowancesMinor;
  final String? notes;
  final String source;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ActualPayslipsTableData({
    required this.id,
    required this.jobId,
    required this.periodStart,
    required this.periodEnd,
    this.paidAt,
    required this.grossPayMinor,
    this.workedMinutesReported,
    this.overtimePayMinor,
    this.holidayPayMinor,
    this.allowancesMinor,
    this.notes,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['job_id'] = Variable<String>(jobId);
    map['period_start'] = Variable<DateTime>(periodStart);
    map['period_end'] = Variable<DateTime>(periodEnd);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    map['gross_pay_minor'] = Variable<int>(grossPayMinor);
    if (!nullToAbsent || workedMinutesReported != null) {
      map['worked_minutes_reported'] = Variable<int>(workedMinutesReported);
    }
    if (!nullToAbsent || overtimePayMinor != null) {
      map['overtime_pay_minor'] = Variable<int>(overtimePayMinor);
    }
    if (!nullToAbsent || holidayPayMinor != null) {
      map['holiday_pay_minor'] = Variable<int>(holidayPayMinor);
    }
    if (!nullToAbsent || allowancesMinor != null) {
      map['allowances_minor'] = Variable<int>(allowancesMinor);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActualPayslipsTableCompanion toCompanion(bool nullToAbsent) {
    return ActualPayslipsTableCompanion(
      id: Value(id),
      jobId: Value(jobId),
      periodStart: Value(periodStart),
      periodEnd: Value(periodEnd),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
      grossPayMinor: Value(grossPayMinor),
      workedMinutesReported: workedMinutesReported == null && nullToAbsent
          ? const Value.absent()
          : Value(workedMinutesReported),
      overtimePayMinor: overtimePayMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(overtimePayMinor),
      holidayPayMinor: holidayPayMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(holidayPayMinor),
      allowancesMinor: allowancesMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(allowancesMinor),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActualPayslipsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActualPayslipsTableData(
      id: serializer.fromJson<String>(json['id']),
      jobId: serializer.fromJson<String>(json['jobId']),
      periodStart: serializer.fromJson<DateTime>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime>(json['periodEnd']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
      grossPayMinor: serializer.fromJson<int>(json['grossPayMinor']),
      workedMinutesReported: serializer.fromJson<int?>(
        json['workedMinutesReported'],
      ),
      overtimePayMinor: serializer.fromJson<int?>(json['overtimePayMinor']),
      holidayPayMinor: serializer.fromJson<int?>(json['holidayPayMinor']),
      allowancesMinor: serializer.fromJson<int?>(json['allowancesMinor']),
      notes: serializer.fromJson<String?>(json['notes']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jobId': serializer.toJson<String>(jobId),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
      'grossPayMinor': serializer.toJson<int>(grossPayMinor),
      'workedMinutesReported': serializer.toJson<int?>(workedMinutesReported),
      'overtimePayMinor': serializer.toJson<int?>(overtimePayMinor),
      'holidayPayMinor': serializer.toJson<int?>(holidayPayMinor),
      'allowancesMinor': serializer.toJson<int?>(allowancesMinor),
      'notes': serializer.toJson<String?>(notes),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ActualPayslipsTableData copyWith({
    String? id,
    String? jobId,
    DateTime? periodStart,
    DateTime? periodEnd,
    Value<DateTime?> paidAt = const Value.absent(),
    int? grossPayMinor,
    Value<int?> workedMinutesReported = const Value.absent(),
    Value<int?> overtimePayMinor = const Value.absent(),
    Value<int?> holidayPayMinor = const Value.absent(),
    Value<int?> allowancesMinor = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? source,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ActualPayslipsTableData(
    id: id ?? this.id,
    jobId: jobId ?? this.jobId,
    periodStart: periodStart ?? this.periodStart,
    periodEnd: periodEnd ?? this.periodEnd,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
    grossPayMinor: grossPayMinor ?? this.grossPayMinor,
    workedMinutesReported: workedMinutesReported.present
        ? workedMinutesReported.value
        : this.workedMinutesReported,
    overtimePayMinor: overtimePayMinor.present
        ? overtimePayMinor.value
        : this.overtimePayMinor,
    holidayPayMinor: holidayPayMinor.present
        ? holidayPayMinor.value
        : this.holidayPayMinor,
    allowancesMinor: allowancesMinor.present
        ? allowancesMinor.value
        : this.allowancesMinor,
    notes: notes.present ? notes.value : this.notes,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActualPayslipsTableData copyWithCompanion(ActualPayslipsTableCompanion data) {
    return ActualPayslipsTableData(
      id: data.id.present ? data.id.value : this.id,
      jobId: data.jobId.present ? data.jobId.value : this.jobId,
      periodStart: data.periodStart.present
          ? data.periodStart.value
          : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      grossPayMinor: data.grossPayMinor.present
          ? data.grossPayMinor.value
          : this.grossPayMinor,
      workedMinutesReported: data.workedMinutesReported.present
          ? data.workedMinutesReported.value
          : this.workedMinutesReported,
      overtimePayMinor: data.overtimePayMinor.present
          ? data.overtimePayMinor.value
          : this.overtimePayMinor,
      holidayPayMinor: data.holidayPayMinor.present
          ? data.holidayPayMinor.value
          : this.holidayPayMinor,
      allowancesMinor: data.allowancesMinor.present
          ? data.allowancesMinor.value
          : this.allowancesMinor,
      notes: data.notes.present ? data.notes.value : this.notes,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActualPayslipsTableData(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('paidAt: $paidAt, ')
          ..write('grossPayMinor: $grossPayMinor, ')
          ..write('workedMinutesReported: $workedMinutesReported, ')
          ..write('overtimePayMinor: $overtimePayMinor, ')
          ..write('holidayPayMinor: $holidayPayMinor, ')
          ..write('allowancesMinor: $allowancesMinor, ')
          ..write('notes: $notes, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jobId,
    periodStart,
    periodEnd,
    paidAt,
    grossPayMinor,
    workedMinutesReported,
    overtimePayMinor,
    holidayPayMinor,
    allowancesMinor,
    notes,
    source,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActualPayslipsTableData &&
          other.id == this.id &&
          other.jobId == this.jobId &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.paidAt == this.paidAt &&
          other.grossPayMinor == this.grossPayMinor &&
          other.workedMinutesReported == this.workedMinutesReported &&
          other.overtimePayMinor == this.overtimePayMinor &&
          other.holidayPayMinor == this.holidayPayMinor &&
          other.allowancesMinor == this.allowancesMinor &&
          other.notes == this.notes &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActualPayslipsTableCompanion
    extends UpdateCompanion<ActualPayslipsTableData> {
  final Value<String> id;
  final Value<String> jobId;
  final Value<DateTime> periodStart;
  final Value<DateTime> periodEnd;
  final Value<DateTime?> paidAt;
  final Value<int> grossPayMinor;
  final Value<int?> workedMinutesReported;
  final Value<int?> overtimePayMinor;
  final Value<int?> holidayPayMinor;
  final Value<int?> allowancesMinor;
  final Value<String?> notes;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ActualPayslipsTableCompanion({
    this.id = const Value.absent(),
    this.jobId = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.grossPayMinor = const Value.absent(),
    this.workedMinutesReported = const Value.absent(),
    this.overtimePayMinor = const Value.absent(),
    this.holidayPayMinor = const Value.absent(),
    this.allowancesMinor = const Value.absent(),
    this.notes = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActualPayslipsTableCompanion.insert({
    required String id,
    required String jobId,
    required DateTime periodStart,
    required DateTime periodEnd,
    this.paidAt = const Value.absent(),
    required int grossPayMinor,
    this.workedMinutesReported = const Value.absent(),
    this.overtimePayMinor = const Value.absent(),
    this.holidayPayMinor = const Value.absent(),
    this.allowancesMinor = const Value.absent(),
    this.notes = const Value.absent(),
    this.source = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jobId = Value(jobId),
       periodStart = Value(periodStart),
       periodEnd = Value(periodEnd),
       grossPayMinor = Value(grossPayMinor),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActualPayslipsTableData> custom({
    Expression<String>? id,
    Expression<String>? jobId,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<DateTime>? paidAt,
    Expression<int>? grossPayMinor,
    Expression<int>? workedMinutesReported,
    Expression<int>? overtimePayMinor,
    Expression<int>? holidayPayMinor,
    Expression<int>? allowancesMinor,
    Expression<String>? notes,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobId != null) 'job_id': jobId,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (paidAt != null) 'paid_at': paidAt,
      if (grossPayMinor != null) 'gross_pay_minor': grossPayMinor,
      if (workedMinutesReported != null)
        'worked_minutes_reported': workedMinutesReported,
      if (overtimePayMinor != null) 'overtime_pay_minor': overtimePayMinor,
      if (holidayPayMinor != null) 'holiday_pay_minor': holidayPayMinor,
      if (allowancesMinor != null) 'allowances_minor': allowancesMinor,
      if (notes != null) 'notes': notes,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActualPayslipsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jobId,
    Value<DateTime>? periodStart,
    Value<DateTime>? periodEnd,
    Value<DateTime?>? paidAt,
    Value<int>? grossPayMinor,
    Value<int?>? workedMinutesReported,
    Value<int?>? overtimePayMinor,
    Value<int?>? holidayPayMinor,
    Value<int?>? allowancesMinor,
    Value<String?>? notes,
    Value<String>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ActualPayslipsTableCompanion(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      paidAt: paidAt ?? this.paidAt,
      grossPayMinor: grossPayMinor ?? this.grossPayMinor,
      workedMinutesReported:
          workedMinutesReported ?? this.workedMinutesReported,
      overtimePayMinor: overtimePayMinor ?? this.overtimePayMinor,
      holidayPayMinor: holidayPayMinor ?? this.holidayPayMinor,
      allowancesMinor: allowancesMinor ?? this.allowancesMinor,
      notes: notes ?? this.notes,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jobId.present) {
      map['job_id'] = Variable<String>(jobId.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (grossPayMinor.present) {
      map['gross_pay_minor'] = Variable<int>(grossPayMinor.value);
    }
    if (workedMinutesReported.present) {
      map['worked_minutes_reported'] = Variable<int>(
        workedMinutesReported.value,
      );
    }
    if (overtimePayMinor.present) {
      map['overtime_pay_minor'] = Variable<int>(overtimePayMinor.value);
    }
    if (holidayPayMinor.present) {
      map['holiday_pay_minor'] = Variable<int>(holidayPayMinor.value);
    }
    if (allowancesMinor.present) {
      map['allowances_minor'] = Variable<int>(allowancesMinor.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActualPayslipsTableCompanion(')
          ..write('id: $id, ')
          ..write('jobId: $jobId, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('paidAt: $paidAt, ')
          ..write('grossPayMinor: $grossPayMinor, ')
          ..write('workedMinutesReported: $workedMinutesReported, ')
          ..write('overtimePayMinor: $overtimePayMinor, ')
          ..write('holidayPayMinor: $holidayPayMinor, ')
          ..write('allowancesMinor: $allowancesMinor, ')
          ..write('notes: $notes, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $JobsTableTable jobsTable = $JobsTableTable(this);
  late final $PayRuleSetsTableTable payRuleSetsTable = $PayRuleSetsTableTable(
    this,
  );
  late final $AdvancedPayRuleSetsTableTable advancedPayRuleSetsTable =
      $AdvancedPayRuleSetsTableTable(this);
  late final $OvertimeTierRulesTableTable overtimeTierRulesTable =
      $OvertimeTierRulesTableTable(this);
  late final $ShiftTemplatesTableTable shiftTemplatesTable =
      $ShiftTemplatesTableTable(this);
  late final $DifferentialRulesTableTable differentialRulesTable =
      $DifferentialRulesTableTable(this);
  late final $AllowanceRulesTableTable allowanceRulesTable =
      $AllowanceRulesTableTable(this);
  late final $AdvancedBreakRulesTableTable advancedBreakRulesTable =
      $AdvancedBreakRulesTableTable(this);
  late final $HolidayRuleSetsTableTable holidayRuleSetsTable =
      $HolidayRuleSetsTableTable(this);
  late final $ShiftPatternsTableTable shiftPatternsTable =
      $ShiftPatternsTableTable(this);
  late final $ShiftPatternEntriesTableTable shiftPatternEntriesTable =
      $ShiftPatternEntriesTableTable(this);
  late final $ShiftInstancesTableTable shiftInstancesTable =
      $ShiftInstancesTableTable(this);
  late final $ReminderRulesTableTable reminderRulesTable =
      $ReminderRulesTableTable(this);
  late final $PlanningSettingsTableTable planningSettingsTable =
      $PlanningSettingsTableTable(this);
  late final $AvailabilityRulesTableTable availabilityRulesTable =
      $AvailabilityRulesTableTable(this);
  late final $ActualPayslipsTableTable actualPayslipsTable =
      $ActualPayslipsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    jobsTable,
    payRuleSetsTable,
    advancedPayRuleSetsTable,
    overtimeTierRulesTable,
    shiftTemplatesTable,
    differentialRulesTable,
    allowanceRulesTable,
    advancedBreakRulesTable,
    holidayRuleSetsTable,
    shiftPatternsTable,
    shiftPatternEntriesTable,
    shiftInstancesTable,
    reminderRulesTable,
    planningSettingsTable,
    availabilityRulesTable,
    actualPayslipsTable,
  ];
}

typedef $$JobsTableTableCreateCompanionBuilder =
    JobsTableCompanion Function({
      required String id,
      required String name,
      required String colorHex,
      required String currencyCode,
      required int hourlyRateMinorUnits,
      Value<String?> payRuleSetId,
      Value<String?> holidayRuleSetId,
      Value<int?> defaultSleepLeadMinutes,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$JobsTableTableUpdateCompanionBuilder =
    JobsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> colorHex,
      Value<String> currencyCode,
      Value<int> hourlyRateMinorUnits,
      Value<String?> payRuleSetId,
      Value<String?> holidayRuleSetId,
      Value<int?> defaultSleepLeadMinutes,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$JobsTableTableReferences
    extends BaseReferences<_$AppDatabase, $JobsTableTable, JobsTableData> {
  $$JobsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PayRuleSetsTableTable, List<PayRuleSetsTableData>>
  _payRuleSetsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.payRuleSetsTable,
    aliasName: $_aliasNameGenerator(db.jobsTable.id, db.payRuleSetsTable.jobId),
  );

  $$PayRuleSetsTableTableProcessedTableManager get payRuleSetsTableRefs {
    final manager = $$PayRuleSetsTableTableTableManager(
      $_db,
      $_db.payRuleSetsTable,
    ).filter((f) => f.jobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _payRuleSetsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AdvancedPayRuleSetsTableTable,
    List<AdvancedPayRuleSetsTableData>
  >
  _advancedPayRuleSetsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.advancedPayRuleSetsTable,
        aliasName: $_aliasNameGenerator(
          db.jobsTable.id,
          db.advancedPayRuleSetsTable.jobId,
        ),
      );

  $$AdvancedPayRuleSetsTableTableProcessedTableManager
  get advancedPayRuleSetsTableRefs {
    final manager = $$AdvancedPayRuleSetsTableTableTableManager(
      $_db,
      $_db.advancedPayRuleSetsTable,
    ).filter((f) => f.jobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _advancedPayRuleSetsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShiftTemplatesTableTable,
    List<ShiftTemplatesTableData>
  >
  _shiftTemplatesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftTemplatesTable,
        aliasName: $_aliasNameGenerator(
          db.jobsTable.id,
          db.shiftTemplatesTable.jobId,
        ),
      );

  $$ShiftTemplatesTableTableProcessedTableManager get shiftTemplatesTableRefs {
    final manager = $$ShiftTemplatesTableTableTableManager(
      $_db,
      $_db.shiftTemplatesTable,
    ).filter((f) => f.jobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftTemplatesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $HolidayRuleSetsTableTable,
    List<HolidayRuleSetsTableData>
  >
  _holidayRuleSetsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.holidayRuleSetsTable,
        aliasName: $_aliasNameGenerator(
          db.jobsTable.id,
          db.holidayRuleSetsTable.jobId,
        ),
      );

  $$HolidayRuleSetsTableTableProcessedTableManager
  get holidayRuleSetsTableRefs {
    final manager = $$HolidayRuleSetsTableTableTableManager(
      $_db,
      $_db.holidayRuleSetsTable,
    ).filter((f) => f.jobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _holidayRuleSetsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShiftPatternsTableTable,
    List<ShiftPatternsTableData>
  >
  _shiftPatternsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftPatternsTable,
        aliasName: $_aliasNameGenerator(
          db.jobsTable.id,
          db.shiftPatternsTable.jobId,
        ),
      );

  $$ShiftPatternsTableTableProcessedTableManager get shiftPatternsTableRefs {
    final manager = $$ShiftPatternsTableTableTableManager(
      $_db,
      $_db.shiftPatternsTable,
    ).filter((f) => f.jobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftPatternsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShiftInstancesTableTable,
    List<ShiftInstancesTableData>
  >
  _shiftInstancesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftInstancesTable,
        aliasName: $_aliasNameGenerator(
          db.jobsTable.id,
          db.shiftInstancesTable.jobId,
        ),
      );

  $$ShiftInstancesTableTableProcessedTableManager get shiftInstancesTableRefs {
    final manager = $$ShiftInstancesTableTableTableManager(
      $_db,
      $_db.shiftInstancesTable,
    ).filter((f) => f.jobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftInstancesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ReminderRulesTableTable,
    List<ReminderRulesTableData>
  >
  _reminderRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.reminderRulesTable,
        aliasName: $_aliasNameGenerator(
          db.jobsTable.id,
          db.reminderRulesTable.jobId,
        ),
      );

  $$ReminderRulesTableTableProcessedTableManager get reminderRulesTableRefs {
    final manager = $$ReminderRulesTableTableTableManager(
      $_db,
      $_db.reminderRulesTable,
    ).filter((f) => f.jobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reminderRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PlanningSettingsTableTable,
    List<PlanningSettingsTableData>
  >
  _planningSettingsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.planningSettingsTable,
        aliasName: $_aliasNameGenerator(
          db.jobsTable.id,
          db.planningSettingsTable.jobId,
        ),
      );

  $$PlanningSettingsTableTableProcessedTableManager
  get planningSettingsTableRefs {
    final manager = $$PlanningSettingsTableTableTableManager(
      $_db,
      $_db.planningSettingsTable,
    ).filter((f) => f.jobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _planningSettingsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AvailabilityRulesTableTable,
    List<AvailabilityRulesTableData>
  >
  _availabilityRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.availabilityRulesTable,
        aliasName: $_aliasNameGenerator(
          db.jobsTable.id,
          db.availabilityRulesTable.jobId,
        ),
      );

  $$AvailabilityRulesTableTableProcessedTableManager
  get availabilityRulesTableRefs {
    final manager = $$AvailabilityRulesTableTableTableManager(
      $_db,
      $_db.availabilityRulesTable,
    ).filter((f) => f.jobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _availabilityRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActualPayslipsTableTable,
    List<ActualPayslipsTableData>
  >
  _actualPayslipsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.actualPayslipsTable,
        aliasName: $_aliasNameGenerator(
          db.jobsTable.id,
          db.actualPayslipsTable.jobId,
        ),
      );

  $$ActualPayslipsTableTableProcessedTableManager get actualPayslipsTableRefs {
    final manager = $$ActualPayslipsTableTableTableManager(
      $_db,
      $_db.actualPayslipsTable,
    ).filter((f) => f.jobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _actualPayslipsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$JobsTableTableFilterComposer
    extends Composer<_$AppDatabase, $JobsTableTable> {
  $$JobsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hourlyRateMinorUnits => $composableBuilder(
    column: $table.hourlyRateMinorUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payRuleSetId => $composableBuilder(
    column: $table.payRuleSetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get holidayRuleSetId => $composableBuilder(
    column: $table.holidayRuleSetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultSleepLeadMinutes => $composableBuilder(
    column: $table.defaultSleepLeadMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> payRuleSetsTableRefs(
    Expression<bool> Function($$PayRuleSetsTableTableFilterComposer f) f,
  ) {
    final $$PayRuleSetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payRuleSetsTable,
      getReferencedColumn: (t) => t.jobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayRuleSetsTableTableFilterComposer(
            $db: $db,
            $table: $db.payRuleSetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> advancedPayRuleSetsTableRefs(
    Expression<bool> Function($$AdvancedPayRuleSetsTableTableFilterComposer f)
    f,
  ) {
    final $$AdvancedPayRuleSetsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableFilterComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> shiftTemplatesTableRefs(
    Expression<bool> Function($$ShiftTemplatesTableTableFilterComposer f) f,
  ) {
    final $$ShiftTemplatesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftTemplatesTable,
      getReferencedColumn: (t) => t.jobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftTemplatesTableTableFilterComposer(
            $db: $db,
            $table: $db.shiftTemplatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> holidayRuleSetsTableRefs(
    Expression<bool> Function($$HolidayRuleSetsTableTableFilterComposer f) f,
  ) {
    final $$HolidayRuleSetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.holidayRuleSetsTable,
      getReferencedColumn: (t) => t.jobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HolidayRuleSetsTableTableFilterComposer(
            $db: $db,
            $table: $db.holidayRuleSetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shiftPatternsTableRefs(
    Expression<bool> Function($$ShiftPatternsTableTableFilterComposer f) f,
  ) {
    final $$ShiftPatternsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftPatternsTable,
      getReferencedColumn: (t) => t.jobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftPatternsTableTableFilterComposer(
            $db: $db,
            $table: $db.shiftPatternsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shiftInstancesTableRefs(
    Expression<bool> Function($$ShiftInstancesTableTableFilterComposer f) f,
  ) {
    final $$ShiftInstancesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftInstancesTable,
      getReferencedColumn: (t) => t.jobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftInstancesTableTableFilterComposer(
            $db: $db,
            $table: $db.shiftInstancesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reminderRulesTableRefs(
    Expression<bool> Function($$ReminderRulesTableTableFilterComposer f) f,
  ) {
    final $$ReminderRulesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderRulesTable,
      getReferencedColumn: (t) => t.jobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRulesTableTableFilterComposer(
            $db: $db,
            $table: $db.reminderRulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> planningSettingsTableRefs(
    Expression<bool> Function($$PlanningSettingsTableTableFilterComposer f) f,
  ) {
    final $$PlanningSettingsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.planningSettingsTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PlanningSettingsTableTableFilterComposer(
                $db: $db,
                $table: $db.planningSettingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> availabilityRulesTableRefs(
    Expression<bool> Function($$AvailabilityRulesTableTableFilterComposer f) f,
  ) {
    final $$AvailabilityRulesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.availabilityRulesTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AvailabilityRulesTableTableFilterComposer(
                $db: $db,
                $table: $db.availabilityRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> actualPayslipsTableRefs(
    Expression<bool> Function($$ActualPayslipsTableTableFilterComposer f) f,
  ) {
    final $$ActualPayslipsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.actualPayslipsTable,
      getReferencedColumn: (t) => t.jobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActualPayslipsTableTableFilterComposer(
            $db: $db,
            $table: $db.actualPayslipsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JobsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JobsTableTable> {
  $$JobsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hourlyRateMinorUnits => $composableBuilder(
    column: $table.hourlyRateMinorUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payRuleSetId => $composableBuilder(
    column: $table.payRuleSetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get holidayRuleSetId => $composableBuilder(
    column: $table.holidayRuleSetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultSleepLeadMinutes => $composableBuilder(
    column: $table.defaultSleepLeadMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JobsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JobsTableTable> {
  $$JobsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hourlyRateMinorUnits => $composableBuilder(
    column: $table.hourlyRateMinorUnits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payRuleSetId => $composableBuilder(
    column: $table.payRuleSetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get holidayRuleSetId => $composableBuilder(
    column: $table.holidayRuleSetId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultSleepLeadMinutes => $composableBuilder(
    column: $table.defaultSleepLeadMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> payRuleSetsTableRefs<T extends Object>(
    Expression<T> Function($$PayRuleSetsTableTableAnnotationComposer a) f,
  ) {
    final $$PayRuleSetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payRuleSetsTable,
      getReferencedColumn: (t) => t.jobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayRuleSetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.payRuleSetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> advancedPayRuleSetsTableRefs<T extends Object>(
    Expression<T> Function($$AdvancedPayRuleSetsTableTableAnnotationComposer a)
    f,
  ) {
    final $$AdvancedPayRuleSetsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> shiftTemplatesTableRefs<T extends Object>(
    Expression<T> Function($$ShiftTemplatesTableTableAnnotationComposer a) f,
  ) {
    final $$ShiftTemplatesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> holidayRuleSetsTableRefs<T extends Object>(
    Expression<T> Function($$HolidayRuleSetsTableTableAnnotationComposer a) f,
  ) {
    final $$HolidayRuleSetsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.holidayRuleSetsTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HolidayRuleSetsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.holidayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> shiftPatternsTableRefs<T extends Object>(
    Expression<T> Function($$ShiftPatternsTableTableAnnotationComposer a) f,
  ) {
    final $$ShiftPatternsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftPatternsTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftPatternsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> shiftInstancesTableRefs<T extends Object>(
    Expression<T> Function($$ShiftInstancesTableTableAnnotationComposer a) f,
  ) {
    final $$ShiftInstancesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftInstancesTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftInstancesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftInstancesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> reminderRulesTableRefs<T extends Object>(
    Expression<T> Function($$ReminderRulesTableTableAnnotationComposer a) f,
  ) {
    final $$ReminderRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.reminderRulesTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReminderRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.reminderRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> planningSettingsTableRefs<T extends Object>(
    Expression<T> Function($$PlanningSettingsTableTableAnnotationComposer a) f,
  ) {
    final $$PlanningSettingsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.planningSettingsTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PlanningSettingsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.planningSettingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> availabilityRulesTableRefs<T extends Object>(
    Expression<T> Function($$AvailabilityRulesTableTableAnnotationComposer a) f,
  ) {
    final $$AvailabilityRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.availabilityRulesTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AvailabilityRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.availabilityRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> actualPayslipsTableRefs<T extends Object>(
    Expression<T> Function($$ActualPayslipsTableTableAnnotationComposer a) f,
  ) {
    final $$ActualPayslipsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.actualPayslipsTable,
          getReferencedColumn: (t) => t.jobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActualPayslipsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.actualPayslipsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$JobsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JobsTableTable,
          JobsTableData,
          $$JobsTableTableFilterComposer,
          $$JobsTableTableOrderingComposer,
          $$JobsTableTableAnnotationComposer,
          $$JobsTableTableCreateCompanionBuilder,
          $$JobsTableTableUpdateCompanionBuilder,
          (JobsTableData, $$JobsTableTableReferences),
          JobsTableData,
          PrefetchHooks Function({
            bool payRuleSetsTableRefs,
            bool advancedPayRuleSetsTableRefs,
            bool shiftTemplatesTableRefs,
            bool holidayRuleSetsTableRefs,
            bool shiftPatternsTableRefs,
            bool shiftInstancesTableRefs,
            bool reminderRulesTableRefs,
            bool planningSettingsTableRefs,
            bool availabilityRulesTableRefs,
            bool actualPayslipsTableRefs,
          })
        > {
  $$JobsTableTableTableManager(_$AppDatabase db, $JobsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JobsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JobsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JobsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> hourlyRateMinorUnits = const Value.absent(),
                Value<String?> payRuleSetId = const Value.absent(),
                Value<String?> holidayRuleSetId = const Value.absent(),
                Value<int?> defaultSleepLeadMinutes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JobsTableCompanion(
                id: id,
                name: name,
                colorHex: colorHex,
                currencyCode: currencyCode,
                hourlyRateMinorUnits: hourlyRateMinorUnits,
                payRuleSetId: payRuleSetId,
                holidayRuleSetId: holidayRuleSetId,
                defaultSleepLeadMinutes: defaultSleepLeadMinutes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String colorHex,
                required String currencyCode,
                required int hourlyRateMinorUnits,
                Value<String?> payRuleSetId = const Value.absent(),
                Value<String?> holidayRuleSetId = const Value.absent(),
                Value<int?> defaultSleepLeadMinutes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => JobsTableCompanion.insert(
                id: id,
                name: name,
                colorHex: colorHex,
                currencyCode: currencyCode,
                hourlyRateMinorUnits: hourlyRateMinorUnits,
                payRuleSetId: payRuleSetId,
                holidayRuleSetId: holidayRuleSetId,
                defaultSleepLeadMinutes: defaultSleepLeadMinutes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JobsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                payRuleSetsTableRefs = false,
                advancedPayRuleSetsTableRefs = false,
                shiftTemplatesTableRefs = false,
                holidayRuleSetsTableRefs = false,
                shiftPatternsTableRefs = false,
                shiftInstancesTableRefs = false,
                reminderRulesTableRefs = false,
                planningSettingsTableRefs = false,
                availabilityRulesTableRefs = false,
                actualPayslipsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (payRuleSetsTableRefs) db.payRuleSetsTable,
                    if (advancedPayRuleSetsTableRefs)
                      db.advancedPayRuleSetsTable,
                    if (shiftTemplatesTableRefs) db.shiftTemplatesTable,
                    if (holidayRuleSetsTableRefs) db.holidayRuleSetsTable,
                    if (shiftPatternsTableRefs) db.shiftPatternsTable,
                    if (shiftInstancesTableRefs) db.shiftInstancesTable,
                    if (reminderRulesTableRefs) db.reminderRulesTable,
                    if (planningSettingsTableRefs) db.planningSettingsTable,
                    if (availabilityRulesTableRefs) db.availabilityRulesTable,
                    if (actualPayslipsTableRefs) db.actualPayslipsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (payRuleSetsTableRefs)
                        await $_getPrefetchedData<
                          JobsTableData,
                          $JobsTableTable,
                          PayRuleSetsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JobsTableTableReferences
                              ._payRuleSetsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JobsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).payRuleSetsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jobId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (advancedPayRuleSetsTableRefs)
                        await $_getPrefetchedData<
                          JobsTableData,
                          $JobsTableTable,
                          AdvancedPayRuleSetsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JobsTableTableReferences
                              ._advancedPayRuleSetsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JobsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).advancedPayRuleSetsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jobId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftTemplatesTableRefs)
                        await $_getPrefetchedData<
                          JobsTableData,
                          $JobsTableTable,
                          ShiftTemplatesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JobsTableTableReferences
                              ._shiftTemplatesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JobsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftTemplatesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jobId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (holidayRuleSetsTableRefs)
                        await $_getPrefetchedData<
                          JobsTableData,
                          $JobsTableTable,
                          HolidayRuleSetsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JobsTableTableReferences
                              ._holidayRuleSetsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JobsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).holidayRuleSetsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jobId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftPatternsTableRefs)
                        await $_getPrefetchedData<
                          JobsTableData,
                          $JobsTableTable,
                          ShiftPatternsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JobsTableTableReferences
                              ._shiftPatternsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JobsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftPatternsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jobId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftInstancesTableRefs)
                        await $_getPrefetchedData<
                          JobsTableData,
                          $JobsTableTable,
                          ShiftInstancesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JobsTableTableReferences
                              ._shiftInstancesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JobsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftInstancesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jobId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reminderRulesTableRefs)
                        await $_getPrefetchedData<
                          JobsTableData,
                          $JobsTableTable,
                          ReminderRulesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JobsTableTableReferences
                              ._reminderRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JobsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).reminderRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jobId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (planningSettingsTableRefs)
                        await $_getPrefetchedData<
                          JobsTableData,
                          $JobsTableTable,
                          PlanningSettingsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JobsTableTableReferences
                              ._planningSettingsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JobsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).planningSettingsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jobId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (availabilityRulesTableRefs)
                        await $_getPrefetchedData<
                          JobsTableData,
                          $JobsTableTable,
                          AvailabilityRulesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JobsTableTableReferences
                              ._availabilityRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JobsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).availabilityRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jobId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (actualPayslipsTableRefs)
                        await $_getPrefetchedData<
                          JobsTableData,
                          $JobsTableTable,
                          ActualPayslipsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JobsTableTableReferences
                              ._actualPayslipsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JobsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).actualPayslipsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jobId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$JobsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JobsTableTable,
      JobsTableData,
      $$JobsTableTableFilterComposer,
      $$JobsTableTableOrderingComposer,
      $$JobsTableTableAnnotationComposer,
      $$JobsTableTableCreateCompanionBuilder,
      $$JobsTableTableUpdateCompanionBuilder,
      (JobsTableData, $$JobsTableTableReferences),
      JobsTableData,
      PrefetchHooks Function({
        bool payRuleSetsTableRefs,
        bool advancedPayRuleSetsTableRefs,
        bool shiftTemplatesTableRefs,
        bool holidayRuleSetsTableRefs,
        bool shiftPatternsTableRefs,
        bool shiftInstancesTableRefs,
        bool reminderRulesTableRefs,
        bool planningSettingsTableRefs,
        bool availabilityRulesTableRefs,
        bool actualPayslipsTableRefs,
      })
    >;
typedef $$PayRuleSetsTableTableCreateCompanionBuilder =
    PayRuleSetsTableCompanion Function({
      required String id,
      required String jobId,
      Value<int?> overtimeThresholdDailyMinutes,
      Value<int?> overtimeThresholdWeeklyMinutes,
      required int overtimeMultiplierBps,
      Value<int?> doubleTimeThresholdMinutes,
      Value<int?> doubleTimeMultiplierBps,
      required String roundRule,
      Value<int> rowid,
    });
typedef $$PayRuleSetsTableTableUpdateCompanionBuilder =
    PayRuleSetsTableCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<int?> overtimeThresholdDailyMinutes,
      Value<int?> overtimeThresholdWeeklyMinutes,
      Value<int> overtimeMultiplierBps,
      Value<int?> doubleTimeThresholdMinutes,
      Value<int?> doubleTimeMultiplierBps,
      Value<String> roundRule,
      Value<int> rowid,
    });

final class $$PayRuleSetsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PayRuleSetsTableTable,
          PayRuleSetsTableData
        > {
  $$PayRuleSetsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JobsTableTable _jobIdTable(_$AppDatabase db) =>
      db.jobsTable.createAlias(
        $_aliasNameGenerator(db.payRuleSetsTable.jobId, db.jobsTable.id),
      );

  $$JobsTableTableProcessedTableManager get jobId {
    final $_column = $_itemColumn<String>('job_id')!;

    final manager = $$JobsTableTableTableManager(
      $_db,
      $_db.jobsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PayRuleSetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PayRuleSetsTableTable> {
  $$PayRuleSetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overtimeThresholdDailyMinutes => $composableBuilder(
    column: $table.overtimeThresholdDailyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overtimeThresholdWeeklyMinutes => $composableBuilder(
    column: $table.overtimeThresholdWeeklyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overtimeMultiplierBps => $composableBuilder(
    column: $table.overtimeMultiplierBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doubleTimeThresholdMinutes => $composableBuilder(
    column: $table.doubleTimeThresholdMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doubleTimeMultiplierBps => $composableBuilder(
    column: $table.doubleTimeMultiplierBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roundRule => $composableBuilder(
    column: $table.roundRule,
    builder: (column) => ColumnFilters(column),
  );

  $$JobsTableTableFilterComposer get jobId {
    final $$JobsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableFilterComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayRuleSetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PayRuleSetsTableTable> {
  $$PayRuleSetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overtimeThresholdDailyMinutes => $composableBuilder(
    column: $table.overtimeThresholdDailyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overtimeThresholdWeeklyMinutes => $composableBuilder(
    column: $table.overtimeThresholdWeeklyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overtimeMultiplierBps => $composableBuilder(
    column: $table.overtimeMultiplierBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doubleTimeThresholdMinutes => $composableBuilder(
    column: $table.doubleTimeThresholdMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doubleTimeMultiplierBps => $composableBuilder(
    column: $table.doubleTimeMultiplierBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roundRule => $composableBuilder(
    column: $table.roundRule,
    builder: (column) => ColumnOrderings(column),
  );

  $$JobsTableTableOrderingComposer get jobId {
    final $$JobsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableOrderingComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayRuleSetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayRuleSetsTableTable> {
  $$PayRuleSetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get overtimeThresholdDailyMinutes => $composableBuilder(
    column: $table.overtimeThresholdDailyMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overtimeThresholdWeeklyMinutes => $composableBuilder(
    column: $table.overtimeThresholdWeeklyMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overtimeMultiplierBps => $composableBuilder(
    column: $table.overtimeMultiplierBps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get doubleTimeThresholdMinutes => $composableBuilder(
    column: $table.doubleTimeThresholdMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get doubleTimeMultiplierBps => $composableBuilder(
    column: $table.doubleTimeMultiplierBps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get roundRule =>
      $composableBuilder(column: $table.roundRule, builder: (column) => column);

  $$JobsTableTableAnnotationComposer get jobId {
    final $$JobsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayRuleSetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayRuleSetsTableTable,
          PayRuleSetsTableData,
          $$PayRuleSetsTableTableFilterComposer,
          $$PayRuleSetsTableTableOrderingComposer,
          $$PayRuleSetsTableTableAnnotationComposer,
          $$PayRuleSetsTableTableCreateCompanionBuilder,
          $$PayRuleSetsTableTableUpdateCompanionBuilder,
          (PayRuleSetsTableData, $$PayRuleSetsTableTableReferences),
          PayRuleSetsTableData,
          PrefetchHooks Function({bool jobId})
        > {
  $$PayRuleSetsTableTableTableManager(
    _$AppDatabase db,
    $PayRuleSetsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayRuleSetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayRuleSetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayRuleSetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<int?> overtimeThresholdDailyMinutes =
                    const Value.absent(),
                Value<int?> overtimeThresholdWeeklyMinutes =
                    const Value.absent(),
                Value<int> overtimeMultiplierBps = const Value.absent(),
                Value<int?> doubleTimeThresholdMinutes = const Value.absent(),
                Value<int?> doubleTimeMultiplierBps = const Value.absent(),
                Value<String> roundRule = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PayRuleSetsTableCompanion(
                id: id,
                jobId: jobId,
                overtimeThresholdDailyMinutes: overtimeThresholdDailyMinutes,
                overtimeThresholdWeeklyMinutes: overtimeThresholdWeeklyMinutes,
                overtimeMultiplierBps: overtimeMultiplierBps,
                doubleTimeThresholdMinutes: doubleTimeThresholdMinutes,
                doubleTimeMultiplierBps: doubleTimeMultiplierBps,
                roundRule: roundRule,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                Value<int?> overtimeThresholdDailyMinutes =
                    const Value.absent(),
                Value<int?> overtimeThresholdWeeklyMinutes =
                    const Value.absent(),
                required int overtimeMultiplierBps,
                Value<int?> doubleTimeThresholdMinutes = const Value.absent(),
                Value<int?> doubleTimeMultiplierBps = const Value.absent(),
                required String roundRule,
                Value<int> rowid = const Value.absent(),
              }) => PayRuleSetsTableCompanion.insert(
                id: id,
                jobId: jobId,
                overtimeThresholdDailyMinutes: overtimeThresholdDailyMinutes,
                overtimeThresholdWeeklyMinutes: overtimeThresholdWeeklyMinutes,
                overtimeMultiplierBps: overtimeMultiplierBps,
                doubleTimeThresholdMinutes: doubleTimeThresholdMinutes,
                doubleTimeMultiplierBps: doubleTimeMultiplierBps,
                roundRule: roundRule,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PayRuleSetsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jobId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (jobId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jobId,
                                referencedTable:
                                    $$PayRuleSetsTableTableReferences
                                        ._jobIdTable(db),
                                referencedColumn:
                                    $$PayRuleSetsTableTableReferences
                                        ._jobIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PayRuleSetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayRuleSetsTableTable,
      PayRuleSetsTableData,
      $$PayRuleSetsTableTableFilterComposer,
      $$PayRuleSetsTableTableOrderingComposer,
      $$PayRuleSetsTableTableAnnotationComposer,
      $$PayRuleSetsTableTableCreateCompanionBuilder,
      $$PayRuleSetsTableTableUpdateCompanionBuilder,
      (PayRuleSetsTableData, $$PayRuleSetsTableTableReferences),
      PayRuleSetsTableData,
      PrefetchHooks Function({bool jobId})
    >;
typedef $$AdvancedPayRuleSetsTableTableCreateCompanionBuilder =
    AdvancedPayRuleSetsTableCompanion Function({
      required String id,
      required String jobId,
      Value<bool> enabled,
      Value<int> version,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AdvancedPayRuleSetsTableTableUpdateCompanionBuilder =
    AdvancedPayRuleSetsTableCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<bool> enabled,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$AdvancedPayRuleSetsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AdvancedPayRuleSetsTableTable,
          AdvancedPayRuleSetsTableData
        > {
  $$AdvancedPayRuleSetsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JobsTableTable _jobIdTable(_$AppDatabase db) =>
      db.jobsTable.createAlias(
        $_aliasNameGenerator(
          db.advancedPayRuleSetsTable.jobId,
          db.jobsTable.id,
        ),
      );

  $$JobsTableTableProcessedTableManager get jobId {
    final $_column = $_itemColumn<String>('job_id')!;

    final manager = $$JobsTableTableTableManager(
      $_db,
      $_db.jobsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $OvertimeTierRulesTableTable,
    List<OvertimeTierRulesTableData>
  >
  _overtimeTierRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.overtimeTierRulesTable,
        aliasName: $_aliasNameGenerator(
          db.advancedPayRuleSetsTable.id,
          db.overtimeTierRulesTable.advancedPayRuleSetId,
        ),
      );

  $$OvertimeTierRulesTableTableProcessedTableManager
  get overtimeTierRulesTableRefs {
    final manager =
        $$OvertimeTierRulesTableTableTableManager(
          $_db,
          $_db.overtimeTierRulesTable,
        ).filter(
          (f) =>
              f.advancedPayRuleSetId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _overtimeTierRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DifferentialRulesTableTable,
    List<DifferentialRulesTableData>
  >
  _differentialRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.differentialRulesTable,
        aliasName: $_aliasNameGenerator(
          db.advancedPayRuleSetsTable.id,
          db.differentialRulesTable.advancedPayRuleSetId,
        ),
      );

  $$DifferentialRulesTableTableProcessedTableManager
  get differentialRulesTableRefs {
    final manager =
        $$DifferentialRulesTableTableTableManager(
          $_db,
          $_db.differentialRulesTable,
        ).filter(
          (f) =>
              f.advancedPayRuleSetId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _differentialRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AllowanceRulesTableTable,
    List<AllowanceRulesTableData>
  >
  _allowanceRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.allowanceRulesTable,
        aliasName: $_aliasNameGenerator(
          db.advancedPayRuleSetsTable.id,
          db.allowanceRulesTable.advancedPayRuleSetId,
        ),
      );

  $$AllowanceRulesTableTableProcessedTableManager get allowanceRulesTableRefs {
    final manager =
        $$AllowanceRulesTableTableTableManager(
          $_db,
          $_db.allowanceRulesTable,
        ).filter(
          (f) =>
              f.advancedPayRuleSetId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _allowanceRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AdvancedBreakRulesTableTable,
    List<AdvancedBreakRulesTableData>
  >
  _advancedBreakRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.advancedBreakRulesTable,
        aliasName: $_aliasNameGenerator(
          db.advancedPayRuleSetsTable.id,
          db.advancedBreakRulesTable.advancedPayRuleSetId,
        ),
      );

  $$AdvancedBreakRulesTableTableProcessedTableManager
  get advancedBreakRulesTableRefs {
    final manager =
        $$AdvancedBreakRulesTableTableTableManager(
          $_db,
          $_db.advancedBreakRulesTable,
        ).filter(
          (f) =>
              f.advancedPayRuleSetId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _advancedBreakRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AdvancedPayRuleSetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AdvancedPayRuleSetsTableTable> {
  $$AdvancedPayRuleSetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$JobsTableTableFilterComposer get jobId {
    final $$JobsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableFilterComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> overtimeTierRulesTableRefs(
    Expression<bool> Function($$OvertimeTierRulesTableTableFilterComposer f) f,
  ) {
    final $$OvertimeTierRulesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.overtimeTierRulesTable,
          getReferencedColumn: (t) => t.advancedPayRuleSetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OvertimeTierRulesTableTableFilterComposer(
                $db: $db,
                $table: $db.overtimeTierRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> differentialRulesTableRefs(
    Expression<bool> Function($$DifferentialRulesTableTableFilterComposer f) f,
  ) {
    final $$DifferentialRulesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.differentialRulesTable,
          getReferencedColumn: (t) => t.advancedPayRuleSetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DifferentialRulesTableTableFilterComposer(
                $db: $db,
                $table: $db.differentialRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> allowanceRulesTableRefs(
    Expression<bool> Function($$AllowanceRulesTableTableFilterComposer f) f,
  ) {
    final $$AllowanceRulesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.allowanceRulesTable,
      getReferencedColumn: (t) => t.advancedPayRuleSetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllowanceRulesTableTableFilterComposer(
            $db: $db,
            $table: $db.allowanceRulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> advancedBreakRulesTableRefs(
    Expression<bool> Function($$AdvancedBreakRulesTableTableFilterComposer f) f,
  ) {
    final $$AdvancedBreakRulesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.advancedBreakRulesTable,
          getReferencedColumn: (t) => t.advancedPayRuleSetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedBreakRulesTableTableFilterComposer(
                $db: $db,
                $table: $db.advancedBreakRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AdvancedPayRuleSetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AdvancedPayRuleSetsTableTable> {
  $$AdvancedPayRuleSetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$JobsTableTableOrderingComposer get jobId {
    final $$JobsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableOrderingComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AdvancedPayRuleSetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdvancedPayRuleSetsTableTable> {
  $$AdvancedPayRuleSetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$JobsTableTableAnnotationComposer get jobId {
    final $$JobsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> overtimeTierRulesTableRefs<T extends Object>(
    Expression<T> Function($$OvertimeTierRulesTableTableAnnotationComposer a) f,
  ) {
    final $$OvertimeTierRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.overtimeTierRulesTable,
          getReferencedColumn: (t) => t.advancedPayRuleSetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OvertimeTierRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.overtimeTierRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> differentialRulesTableRefs<T extends Object>(
    Expression<T> Function($$DifferentialRulesTableTableAnnotationComposer a) f,
  ) {
    final $$DifferentialRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.differentialRulesTable,
          getReferencedColumn: (t) => t.advancedPayRuleSetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DifferentialRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.differentialRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> allowanceRulesTableRefs<T extends Object>(
    Expression<T> Function($$AllowanceRulesTableTableAnnotationComposer a) f,
  ) {
    final $$AllowanceRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.allowanceRulesTable,
          getReferencedColumn: (t) => t.advancedPayRuleSetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AllowanceRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.allowanceRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> advancedBreakRulesTableRefs<T extends Object>(
    Expression<T> Function($$AdvancedBreakRulesTableTableAnnotationComposer a)
    f,
  ) {
    final $$AdvancedBreakRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.advancedBreakRulesTable,
          getReferencedColumn: (t) => t.advancedPayRuleSetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedBreakRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.advancedBreakRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AdvancedPayRuleSetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AdvancedPayRuleSetsTableTable,
          AdvancedPayRuleSetsTableData,
          $$AdvancedPayRuleSetsTableTableFilterComposer,
          $$AdvancedPayRuleSetsTableTableOrderingComposer,
          $$AdvancedPayRuleSetsTableTableAnnotationComposer,
          $$AdvancedPayRuleSetsTableTableCreateCompanionBuilder,
          $$AdvancedPayRuleSetsTableTableUpdateCompanionBuilder,
          (
            AdvancedPayRuleSetsTableData,
            $$AdvancedPayRuleSetsTableTableReferences,
          ),
          AdvancedPayRuleSetsTableData,
          PrefetchHooks Function({
            bool jobId,
            bool overtimeTierRulesTableRefs,
            bool differentialRulesTableRefs,
            bool allowanceRulesTableRefs,
            bool advancedBreakRulesTableRefs,
          })
        > {
  $$AdvancedPayRuleSetsTableTableTableManager(
    _$AppDatabase db,
    $AdvancedPayRuleSetsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdvancedPayRuleSetsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AdvancedPayRuleSetsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AdvancedPayRuleSetsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AdvancedPayRuleSetsTableCompanion(
                id: id,
                jobId: jobId,
                enabled: enabled,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                Value<bool> enabled = const Value.absent(),
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AdvancedPayRuleSetsTableCompanion.insert(
                id: id,
                jobId: jobId,
                enabled: enabled,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AdvancedPayRuleSetsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                jobId = false,
                overtimeTierRulesTableRefs = false,
                differentialRulesTableRefs = false,
                allowanceRulesTableRefs = false,
                advancedBreakRulesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (overtimeTierRulesTableRefs) db.overtimeTierRulesTable,
                    if (differentialRulesTableRefs) db.differentialRulesTable,
                    if (allowanceRulesTableRefs) db.allowanceRulesTable,
                    if (advancedBreakRulesTableRefs) db.advancedBreakRulesTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (jobId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.jobId,
                                    referencedTable:
                                        $$AdvancedPayRuleSetsTableTableReferences
                                            ._jobIdTable(db),
                                    referencedColumn:
                                        $$AdvancedPayRuleSetsTableTableReferences
                                            ._jobIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (overtimeTierRulesTableRefs)
                        await $_getPrefetchedData<
                          AdvancedPayRuleSetsTableData,
                          $AdvancedPayRuleSetsTableTable,
                          OvertimeTierRulesTableData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$AdvancedPayRuleSetsTableTableReferences
                                  ._overtimeTierRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AdvancedPayRuleSetsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).overtimeTierRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.advancedPayRuleSetId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (differentialRulesTableRefs)
                        await $_getPrefetchedData<
                          AdvancedPayRuleSetsTableData,
                          $AdvancedPayRuleSetsTableTable,
                          DifferentialRulesTableData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$AdvancedPayRuleSetsTableTableReferences
                                  ._differentialRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AdvancedPayRuleSetsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).differentialRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.advancedPayRuleSetId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (allowanceRulesTableRefs)
                        await $_getPrefetchedData<
                          AdvancedPayRuleSetsTableData,
                          $AdvancedPayRuleSetsTableTable,
                          AllowanceRulesTableData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$AdvancedPayRuleSetsTableTableReferences
                                  ._allowanceRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AdvancedPayRuleSetsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).allowanceRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.advancedPayRuleSetId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (advancedBreakRulesTableRefs)
                        await $_getPrefetchedData<
                          AdvancedPayRuleSetsTableData,
                          $AdvancedPayRuleSetsTableTable,
                          AdvancedBreakRulesTableData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$AdvancedPayRuleSetsTableTableReferences
                                  ._advancedBreakRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AdvancedPayRuleSetsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).advancedBreakRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.advancedPayRuleSetId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AdvancedPayRuleSetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AdvancedPayRuleSetsTableTable,
      AdvancedPayRuleSetsTableData,
      $$AdvancedPayRuleSetsTableTableFilterComposer,
      $$AdvancedPayRuleSetsTableTableOrderingComposer,
      $$AdvancedPayRuleSetsTableTableAnnotationComposer,
      $$AdvancedPayRuleSetsTableTableCreateCompanionBuilder,
      $$AdvancedPayRuleSetsTableTableUpdateCompanionBuilder,
      (AdvancedPayRuleSetsTableData, $$AdvancedPayRuleSetsTableTableReferences),
      AdvancedPayRuleSetsTableData,
      PrefetchHooks Function({
        bool jobId,
        bool overtimeTierRulesTableRefs,
        bool differentialRulesTableRefs,
        bool allowanceRulesTableRefs,
        bool advancedBreakRulesTableRefs,
      })
    >;
typedef $$OvertimeTierRulesTableTableCreateCompanionBuilder =
    OvertimeTierRulesTableCompanion Function({
      required String id,
      required String advancedPayRuleSetId,
      required String periodType,
      required int thresholdMinutes,
      required int multiplierBps,
      required int priority,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$OvertimeTierRulesTableTableUpdateCompanionBuilder =
    OvertimeTierRulesTableCompanion Function({
      Value<String> id,
      Value<String> advancedPayRuleSetId,
      Value<String> periodType,
      Value<int> thresholdMinutes,
      Value<int> multiplierBps,
      Value<int> priority,
      Value<bool> enabled,
      Value<int> rowid,
    });

final class $$OvertimeTierRulesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OvertimeTierRulesTableTable,
          OvertimeTierRulesTableData
        > {
  $$OvertimeTierRulesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AdvancedPayRuleSetsTableTable _advancedPayRuleSetIdTable(
    _$AppDatabase db,
  ) => db.advancedPayRuleSetsTable.createAlias(
    $_aliasNameGenerator(
      db.overtimeTierRulesTable.advancedPayRuleSetId,
      db.advancedPayRuleSetsTable.id,
    ),
  );

  $$AdvancedPayRuleSetsTableTableProcessedTableManager
  get advancedPayRuleSetId {
    final $_column = $_itemColumn<String>('advanced_pay_rule_set_id')!;

    final manager = $$AdvancedPayRuleSetsTableTableTableManager(
      $_db,
      $_db.advancedPayRuleSetsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _advancedPayRuleSetIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OvertimeTierRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $OvertimeTierRulesTableTable> {
  $$OvertimeTierRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodType => $composableBuilder(
    column: $table.periodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get thresholdMinutes => $composableBuilder(
    column: $table.thresholdMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get multiplierBps => $composableBuilder(
    column: $table.multiplierBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  $$AdvancedPayRuleSetsTableTableFilterComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableFilterComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$OvertimeTierRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OvertimeTierRulesTableTable> {
  $$OvertimeTierRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodType => $composableBuilder(
    column: $table.periodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get thresholdMinutes => $composableBuilder(
    column: $table.thresholdMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get multiplierBps => $composableBuilder(
    column: $table.multiplierBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$AdvancedPayRuleSetsTableTableOrderingComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableOrderingComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$OvertimeTierRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OvertimeTierRulesTableTable> {
  $$OvertimeTierRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get periodType => $composableBuilder(
    column: $table.periodType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get thresholdMinutes => $composableBuilder(
    column: $table.thresholdMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get multiplierBps => $composableBuilder(
    column: $table.multiplierBps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$AdvancedPayRuleSetsTableTableAnnotationComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$OvertimeTierRulesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OvertimeTierRulesTableTable,
          OvertimeTierRulesTableData,
          $$OvertimeTierRulesTableTableFilterComposer,
          $$OvertimeTierRulesTableTableOrderingComposer,
          $$OvertimeTierRulesTableTableAnnotationComposer,
          $$OvertimeTierRulesTableTableCreateCompanionBuilder,
          $$OvertimeTierRulesTableTableUpdateCompanionBuilder,
          (OvertimeTierRulesTableData, $$OvertimeTierRulesTableTableReferences),
          OvertimeTierRulesTableData,
          PrefetchHooks Function({bool advancedPayRuleSetId})
        > {
  $$OvertimeTierRulesTableTableTableManager(
    _$AppDatabase db,
    $OvertimeTierRulesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OvertimeTierRulesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$OvertimeTierRulesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OvertimeTierRulesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> advancedPayRuleSetId = const Value.absent(),
                Value<String> periodType = const Value.absent(),
                Value<int> thresholdMinutes = const Value.absent(),
                Value<int> multiplierBps = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OvertimeTierRulesTableCompanion(
                id: id,
                advancedPayRuleSetId: advancedPayRuleSetId,
                periodType: periodType,
                thresholdMinutes: thresholdMinutes,
                multiplierBps: multiplierBps,
                priority: priority,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String advancedPayRuleSetId,
                required String periodType,
                required int thresholdMinutes,
                required int multiplierBps,
                required int priority,
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OvertimeTierRulesTableCompanion.insert(
                id: id,
                advancedPayRuleSetId: advancedPayRuleSetId,
                periodType: periodType,
                thresholdMinutes: thresholdMinutes,
                multiplierBps: multiplierBps,
                priority: priority,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OvertimeTierRulesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({advancedPayRuleSetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (advancedPayRuleSetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.advancedPayRuleSetId,
                                referencedTable:
                                    $$OvertimeTierRulesTableTableReferences
                                        ._advancedPayRuleSetIdTable(db),
                                referencedColumn:
                                    $$OvertimeTierRulesTableTableReferences
                                        ._advancedPayRuleSetIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OvertimeTierRulesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OvertimeTierRulesTableTable,
      OvertimeTierRulesTableData,
      $$OvertimeTierRulesTableTableFilterComposer,
      $$OvertimeTierRulesTableTableOrderingComposer,
      $$OvertimeTierRulesTableTableAnnotationComposer,
      $$OvertimeTierRulesTableTableCreateCompanionBuilder,
      $$OvertimeTierRulesTableTableUpdateCompanionBuilder,
      (OvertimeTierRulesTableData, $$OvertimeTierRulesTableTableReferences),
      OvertimeTierRulesTableData,
      PrefetchHooks Function({bool advancedPayRuleSetId})
    >;
typedef $$ShiftTemplatesTableTableCreateCompanionBuilder =
    ShiftTemplatesTableCompanion Function({
      required String id,
      required String jobId,
      required String name,
      required int startMinutesLocal,
      required int endMinutesLocal,
      required int unpaidBreakMinutes,
      required String category,
      Value<String?> defaultNote,
      Value<int> rowid,
    });
typedef $$ShiftTemplatesTableTableUpdateCompanionBuilder =
    ShiftTemplatesTableCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<String> name,
      Value<int> startMinutesLocal,
      Value<int> endMinutesLocal,
      Value<int> unpaidBreakMinutes,
      Value<String> category,
      Value<String?> defaultNote,
      Value<int> rowid,
    });

final class $$ShiftTemplatesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShiftTemplatesTableTable,
          ShiftTemplatesTableData
        > {
  $$ShiftTemplatesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JobsTableTable _jobIdTable(_$AppDatabase db) =>
      db.jobsTable.createAlias(
        $_aliasNameGenerator(db.shiftTemplatesTable.jobId, db.jobsTable.id),
      );

  $$JobsTableTableProcessedTableManager get jobId {
    final $_column = $_itemColumn<String>('job_id')!;

    final manager = $$JobsTableTableTableManager(
      $_db,
      $_db.jobsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $DifferentialRulesTableTable,
    List<DifferentialRulesTableData>
  >
  _differentialRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.differentialRulesTable,
        aliasName: $_aliasNameGenerator(
          db.shiftTemplatesTable.id,
          db.differentialRulesTable.shiftTemplateId,
        ),
      );

  $$DifferentialRulesTableTableProcessedTableManager
  get differentialRulesTableRefs {
    final manager =
        $$DifferentialRulesTableTableTableManager(
          $_db,
          $_db.differentialRulesTable,
        ).filter(
          (f) => f.shiftTemplateId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _differentialRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AllowanceRulesTableTable,
    List<AllowanceRulesTableData>
  >
  _allowanceRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.allowanceRulesTable,
        aliasName: $_aliasNameGenerator(
          db.shiftTemplatesTable.id,
          db.allowanceRulesTable.shiftTemplateId,
        ),
      );

  $$AllowanceRulesTableTableProcessedTableManager get allowanceRulesTableRefs {
    final manager =
        $$AllowanceRulesTableTableTableManager(
          $_db,
          $_db.allowanceRulesTable,
        ).filter(
          (f) => f.shiftTemplateId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _allowanceRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AdvancedBreakRulesTableTable,
    List<AdvancedBreakRulesTableData>
  >
  _advancedBreakRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.advancedBreakRulesTable,
        aliasName: $_aliasNameGenerator(
          db.shiftTemplatesTable.id,
          db.advancedBreakRulesTable.shiftTemplateId,
        ),
      );

  $$AdvancedBreakRulesTableTableProcessedTableManager
  get advancedBreakRulesTableRefs {
    final manager =
        $$AdvancedBreakRulesTableTableTableManager(
          $_db,
          $_db.advancedBreakRulesTable,
        ).filter(
          (f) => f.shiftTemplateId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _advancedBreakRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShiftPatternEntriesTableTable,
    List<ShiftPatternEntriesTableData>
  >
  _shiftPatternEntriesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftPatternEntriesTable,
        aliasName: $_aliasNameGenerator(
          db.shiftTemplatesTable.id,
          db.shiftPatternEntriesTable.shiftTemplateId,
        ),
      );

  $$ShiftPatternEntriesTableTableProcessedTableManager
  get shiftPatternEntriesTableRefs {
    final manager =
        $$ShiftPatternEntriesTableTableTableManager(
          $_db,
          $_db.shiftPatternEntriesTable,
        ).filter(
          (f) => f.shiftTemplateId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _shiftPatternEntriesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShiftInstancesTableTable,
    List<ShiftInstancesTableData>
  >
  _shiftInstancesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftInstancesTable,
        aliasName: $_aliasNameGenerator(
          db.shiftTemplatesTable.id,
          db.shiftInstancesTable.shiftTemplateId,
        ),
      );

  $$ShiftInstancesTableTableProcessedTableManager get shiftInstancesTableRefs {
    final manager =
        $$ShiftInstancesTableTableTableManager(
          $_db,
          $_db.shiftInstancesTable,
        ).filter(
          (f) => f.shiftTemplateId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _shiftInstancesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShiftTemplatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftTemplatesTableTable> {
  $$ShiftTemplatesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutesLocal => $composableBuilder(
    column: $table.startMinutesLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutesLocal => $composableBuilder(
    column: $table.endMinutesLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unpaidBreakMinutes => $composableBuilder(
    column: $table.unpaidBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultNote => $composableBuilder(
    column: $table.defaultNote,
    builder: (column) => ColumnFilters(column),
  );

  $$JobsTableTableFilterComposer get jobId {
    final $$JobsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableFilterComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> differentialRulesTableRefs(
    Expression<bool> Function($$DifferentialRulesTableTableFilterComposer f) f,
  ) {
    final $$DifferentialRulesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.differentialRulesTable,
          getReferencedColumn: (t) => t.shiftTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DifferentialRulesTableTableFilterComposer(
                $db: $db,
                $table: $db.differentialRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> allowanceRulesTableRefs(
    Expression<bool> Function($$AllowanceRulesTableTableFilterComposer f) f,
  ) {
    final $$AllowanceRulesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.allowanceRulesTable,
      getReferencedColumn: (t) => t.shiftTemplateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllowanceRulesTableTableFilterComposer(
            $db: $db,
            $table: $db.allowanceRulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> advancedBreakRulesTableRefs(
    Expression<bool> Function($$AdvancedBreakRulesTableTableFilterComposer f) f,
  ) {
    final $$AdvancedBreakRulesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.advancedBreakRulesTable,
          getReferencedColumn: (t) => t.shiftTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedBreakRulesTableTableFilterComposer(
                $db: $db,
                $table: $db.advancedBreakRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> shiftPatternEntriesTableRefs(
    Expression<bool> Function($$ShiftPatternEntriesTableTableFilterComposer f)
    f,
  ) {
    final $$ShiftPatternEntriesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftPatternEntriesTable,
          getReferencedColumn: (t) => t.shiftTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternEntriesTableTableFilterComposer(
                $db: $db,
                $table: $db.shiftPatternEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> shiftInstancesTableRefs(
    Expression<bool> Function($$ShiftInstancesTableTableFilterComposer f) f,
  ) {
    final $$ShiftInstancesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftInstancesTable,
      getReferencedColumn: (t) => t.shiftTemplateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftInstancesTableTableFilterComposer(
            $db: $db,
            $table: $db.shiftInstancesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShiftTemplatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftTemplatesTableTable> {
  $$ShiftTemplatesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutesLocal => $composableBuilder(
    column: $table.startMinutesLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutesLocal => $composableBuilder(
    column: $table.endMinutesLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unpaidBreakMinutes => $composableBuilder(
    column: $table.unpaidBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultNote => $composableBuilder(
    column: $table.defaultNote,
    builder: (column) => ColumnOrderings(column),
  );

  $$JobsTableTableOrderingComposer get jobId {
    final $$JobsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableOrderingComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftTemplatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftTemplatesTableTable> {
  $$ShiftTemplatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get startMinutesLocal => $composableBuilder(
    column: $table.startMinutesLocal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutesLocal => $composableBuilder(
    column: $table.endMinutesLocal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unpaidBreakMinutes => $composableBuilder(
    column: $table.unpaidBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get defaultNote => $composableBuilder(
    column: $table.defaultNote,
    builder: (column) => column,
  );

  $$JobsTableTableAnnotationComposer get jobId {
    final $$JobsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> differentialRulesTableRefs<T extends Object>(
    Expression<T> Function($$DifferentialRulesTableTableAnnotationComposer a) f,
  ) {
    final $$DifferentialRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.differentialRulesTable,
          getReferencedColumn: (t) => t.shiftTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DifferentialRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.differentialRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> allowanceRulesTableRefs<T extends Object>(
    Expression<T> Function($$AllowanceRulesTableTableAnnotationComposer a) f,
  ) {
    final $$AllowanceRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.allowanceRulesTable,
          getReferencedColumn: (t) => t.shiftTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AllowanceRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.allowanceRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> advancedBreakRulesTableRefs<T extends Object>(
    Expression<T> Function($$AdvancedBreakRulesTableTableAnnotationComposer a)
    f,
  ) {
    final $$AdvancedBreakRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.advancedBreakRulesTable,
          getReferencedColumn: (t) => t.shiftTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedBreakRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.advancedBreakRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> shiftPatternEntriesTableRefs<T extends Object>(
    Expression<T> Function($$ShiftPatternEntriesTableTableAnnotationComposer a)
    f,
  ) {
    final $$ShiftPatternEntriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftPatternEntriesTable,
          getReferencedColumn: (t) => t.shiftTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternEntriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftPatternEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> shiftInstancesTableRefs<T extends Object>(
    Expression<T> Function($$ShiftInstancesTableTableAnnotationComposer a) f,
  ) {
    final $$ShiftInstancesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftInstancesTable,
          getReferencedColumn: (t) => t.shiftTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftInstancesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftInstancesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShiftTemplatesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftTemplatesTableTable,
          ShiftTemplatesTableData,
          $$ShiftTemplatesTableTableFilterComposer,
          $$ShiftTemplatesTableTableOrderingComposer,
          $$ShiftTemplatesTableTableAnnotationComposer,
          $$ShiftTemplatesTableTableCreateCompanionBuilder,
          $$ShiftTemplatesTableTableUpdateCompanionBuilder,
          (ShiftTemplatesTableData, $$ShiftTemplatesTableTableReferences),
          ShiftTemplatesTableData,
          PrefetchHooks Function({
            bool jobId,
            bool differentialRulesTableRefs,
            bool allowanceRulesTableRefs,
            bool advancedBreakRulesTableRefs,
            bool shiftPatternEntriesTableRefs,
            bool shiftInstancesTableRefs,
          })
        > {
  $$ShiftTemplatesTableTableTableManager(
    _$AppDatabase db,
    $ShiftTemplatesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftTemplatesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftTemplatesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftTemplatesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> startMinutesLocal = const Value.absent(),
                Value<int> endMinutesLocal = const Value.absent(),
                Value<int> unpaidBreakMinutes = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> defaultNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftTemplatesTableCompanion(
                id: id,
                jobId: jobId,
                name: name,
                startMinutesLocal: startMinutesLocal,
                endMinutesLocal: endMinutesLocal,
                unpaidBreakMinutes: unpaidBreakMinutes,
                category: category,
                defaultNote: defaultNote,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                required String name,
                required int startMinutesLocal,
                required int endMinutesLocal,
                required int unpaidBreakMinutes,
                required String category,
                Value<String?> defaultNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftTemplatesTableCompanion.insert(
                id: id,
                jobId: jobId,
                name: name,
                startMinutesLocal: startMinutesLocal,
                endMinutesLocal: endMinutesLocal,
                unpaidBreakMinutes: unpaidBreakMinutes,
                category: category,
                defaultNote: defaultNote,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftTemplatesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                jobId = false,
                differentialRulesTableRefs = false,
                allowanceRulesTableRefs = false,
                advancedBreakRulesTableRefs = false,
                shiftPatternEntriesTableRefs = false,
                shiftInstancesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (differentialRulesTableRefs) db.differentialRulesTable,
                    if (allowanceRulesTableRefs) db.allowanceRulesTable,
                    if (advancedBreakRulesTableRefs) db.advancedBreakRulesTable,
                    if (shiftPatternEntriesTableRefs)
                      db.shiftPatternEntriesTable,
                    if (shiftInstancesTableRefs) db.shiftInstancesTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (jobId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.jobId,
                                    referencedTable:
                                        $$ShiftTemplatesTableTableReferences
                                            ._jobIdTable(db),
                                    referencedColumn:
                                        $$ShiftTemplatesTableTableReferences
                                            ._jobIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (differentialRulesTableRefs)
                        await $_getPrefetchedData<
                          ShiftTemplatesTableData,
                          $ShiftTemplatesTableTable,
                          DifferentialRulesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftTemplatesTableTableReferences
                              ._differentialRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftTemplatesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).differentialRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shiftTemplateId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (allowanceRulesTableRefs)
                        await $_getPrefetchedData<
                          ShiftTemplatesTableData,
                          $ShiftTemplatesTableTable,
                          AllowanceRulesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftTemplatesTableTableReferences
                              ._allowanceRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftTemplatesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).allowanceRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shiftTemplateId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (advancedBreakRulesTableRefs)
                        await $_getPrefetchedData<
                          ShiftTemplatesTableData,
                          $ShiftTemplatesTableTable,
                          AdvancedBreakRulesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftTemplatesTableTableReferences
                              ._advancedBreakRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftTemplatesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).advancedBreakRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shiftTemplateId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftPatternEntriesTableRefs)
                        await $_getPrefetchedData<
                          ShiftTemplatesTableData,
                          $ShiftTemplatesTableTable,
                          ShiftPatternEntriesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftTemplatesTableTableReferences
                              ._shiftPatternEntriesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftTemplatesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftPatternEntriesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shiftTemplateId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftInstancesTableRefs)
                        await $_getPrefetchedData<
                          ShiftTemplatesTableData,
                          $ShiftTemplatesTableTable,
                          ShiftInstancesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftTemplatesTableTableReferences
                              ._shiftInstancesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftTemplatesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftInstancesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shiftTemplateId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShiftTemplatesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftTemplatesTableTable,
      ShiftTemplatesTableData,
      $$ShiftTemplatesTableTableFilterComposer,
      $$ShiftTemplatesTableTableOrderingComposer,
      $$ShiftTemplatesTableTableAnnotationComposer,
      $$ShiftTemplatesTableTableCreateCompanionBuilder,
      $$ShiftTemplatesTableTableUpdateCompanionBuilder,
      (ShiftTemplatesTableData, $$ShiftTemplatesTableTableReferences),
      ShiftTemplatesTableData,
      PrefetchHooks Function({
        bool jobId,
        bool differentialRulesTableRefs,
        bool allowanceRulesTableRefs,
        bool advancedBreakRulesTableRefs,
        bool shiftPatternEntriesTableRefs,
        bool shiftInstancesTableRefs,
      })
    >;
typedef $$DifferentialRulesTableTableCreateCompanionBuilder =
    DifferentialRulesTableCompanion Function({
      required String id,
      required String advancedPayRuleSetId,
      required String type,
      required String combinationMode,
      Value<int?> multiplierBps,
      Value<int?> flatAmountMinor,
      Value<int?> startMinutesLocal,
      Value<int?> endMinutesLocal,
      Value<bool> appliesOnSaturday,
      Value<bool> appliesOnSunday,
      Value<String?> shiftTemplateId,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$DifferentialRulesTableTableUpdateCompanionBuilder =
    DifferentialRulesTableCompanion Function({
      Value<String> id,
      Value<String> advancedPayRuleSetId,
      Value<String> type,
      Value<String> combinationMode,
      Value<int?> multiplierBps,
      Value<int?> flatAmountMinor,
      Value<int?> startMinutesLocal,
      Value<int?> endMinutesLocal,
      Value<bool> appliesOnSaturday,
      Value<bool> appliesOnSunday,
      Value<String?> shiftTemplateId,
      Value<bool> enabled,
      Value<int> rowid,
    });

final class $$DifferentialRulesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DifferentialRulesTableTable,
          DifferentialRulesTableData
        > {
  $$DifferentialRulesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AdvancedPayRuleSetsTableTable _advancedPayRuleSetIdTable(
    _$AppDatabase db,
  ) => db.advancedPayRuleSetsTable.createAlias(
    $_aliasNameGenerator(
      db.differentialRulesTable.advancedPayRuleSetId,
      db.advancedPayRuleSetsTable.id,
    ),
  );

  $$AdvancedPayRuleSetsTableTableProcessedTableManager
  get advancedPayRuleSetId {
    final $_column = $_itemColumn<String>('advanced_pay_rule_set_id')!;

    final manager = $$AdvancedPayRuleSetsTableTableTableManager(
      $_db,
      $_db.advancedPayRuleSetsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _advancedPayRuleSetIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ShiftTemplatesTableTable _shiftTemplateIdTable(_$AppDatabase db) =>
      db.shiftTemplatesTable.createAlias(
        $_aliasNameGenerator(
          db.differentialRulesTable.shiftTemplateId,
          db.shiftTemplatesTable.id,
        ),
      );

  $$ShiftTemplatesTableTableProcessedTableManager? get shiftTemplateId {
    final $_column = $_itemColumn<String>('shift_template_id');
    if ($_column == null) return null;
    final manager = $$ShiftTemplatesTableTableTableManager(
      $_db,
      $_db.shiftTemplatesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DifferentialRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $DifferentialRulesTableTable> {
  $$DifferentialRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get combinationMode => $composableBuilder(
    column: $table.combinationMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get multiplierBps => $composableBuilder(
    column: $table.multiplierBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flatAmountMinor => $composableBuilder(
    column: $table.flatAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutesLocal => $composableBuilder(
    column: $table.startMinutesLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutesLocal => $composableBuilder(
    column: $table.endMinutesLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get appliesOnSaturday => $composableBuilder(
    column: $table.appliesOnSaturday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get appliesOnSunday => $composableBuilder(
    column: $table.appliesOnSunday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  $$AdvancedPayRuleSetsTableTableFilterComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableFilterComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ShiftTemplatesTableTableFilterComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftTemplateId,
      referencedTable: $db.shiftTemplatesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftTemplatesTableTableFilterComposer(
            $db: $db,
            $table: $db.shiftTemplatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DifferentialRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DifferentialRulesTableTable> {
  $$DifferentialRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get combinationMode => $composableBuilder(
    column: $table.combinationMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get multiplierBps => $composableBuilder(
    column: $table.multiplierBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flatAmountMinor => $composableBuilder(
    column: $table.flatAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutesLocal => $composableBuilder(
    column: $table.startMinutesLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutesLocal => $composableBuilder(
    column: $table.endMinutesLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appliesOnSaturday => $composableBuilder(
    column: $table.appliesOnSaturday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appliesOnSunday => $composableBuilder(
    column: $table.appliesOnSunday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$AdvancedPayRuleSetsTableTableOrderingComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableOrderingComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ShiftTemplatesTableTableOrderingComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shiftTemplateId,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableOrderingComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DifferentialRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DifferentialRulesTableTable> {
  $$DifferentialRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get combinationMode => $composableBuilder(
    column: $table.combinationMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get multiplierBps => $composableBuilder(
    column: $table.multiplierBps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get flatAmountMinor => $composableBuilder(
    column: $table.flatAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMinutesLocal => $composableBuilder(
    column: $table.startMinutesLocal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutesLocal => $composableBuilder(
    column: $table.endMinutesLocal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get appliesOnSaturday => $composableBuilder(
    column: $table.appliesOnSaturday,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get appliesOnSunday => $composableBuilder(
    column: $table.appliesOnSunday,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$AdvancedPayRuleSetsTableTableAnnotationComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ShiftTemplatesTableTableAnnotationComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shiftTemplateId,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DifferentialRulesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DifferentialRulesTableTable,
          DifferentialRulesTableData,
          $$DifferentialRulesTableTableFilterComposer,
          $$DifferentialRulesTableTableOrderingComposer,
          $$DifferentialRulesTableTableAnnotationComposer,
          $$DifferentialRulesTableTableCreateCompanionBuilder,
          $$DifferentialRulesTableTableUpdateCompanionBuilder,
          (DifferentialRulesTableData, $$DifferentialRulesTableTableReferences),
          DifferentialRulesTableData,
          PrefetchHooks Function({
            bool advancedPayRuleSetId,
            bool shiftTemplateId,
          })
        > {
  $$DifferentialRulesTableTableTableManager(
    _$AppDatabase db,
    $DifferentialRulesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DifferentialRulesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DifferentialRulesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DifferentialRulesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> advancedPayRuleSetId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> combinationMode = const Value.absent(),
                Value<int?> multiplierBps = const Value.absent(),
                Value<int?> flatAmountMinor = const Value.absent(),
                Value<int?> startMinutesLocal = const Value.absent(),
                Value<int?> endMinutesLocal = const Value.absent(),
                Value<bool> appliesOnSaturday = const Value.absent(),
                Value<bool> appliesOnSunday = const Value.absent(),
                Value<String?> shiftTemplateId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DifferentialRulesTableCompanion(
                id: id,
                advancedPayRuleSetId: advancedPayRuleSetId,
                type: type,
                combinationMode: combinationMode,
                multiplierBps: multiplierBps,
                flatAmountMinor: flatAmountMinor,
                startMinutesLocal: startMinutesLocal,
                endMinutesLocal: endMinutesLocal,
                appliesOnSaturday: appliesOnSaturday,
                appliesOnSunday: appliesOnSunday,
                shiftTemplateId: shiftTemplateId,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String advancedPayRuleSetId,
                required String type,
                required String combinationMode,
                Value<int?> multiplierBps = const Value.absent(),
                Value<int?> flatAmountMinor = const Value.absent(),
                Value<int?> startMinutesLocal = const Value.absent(),
                Value<int?> endMinutesLocal = const Value.absent(),
                Value<bool> appliesOnSaturday = const Value.absent(),
                Value<bool> appliesOnSunday = const Value.absent(),
                Value<String?> shiftTemplateId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DifferentialRulesTableCompanion.insert(
                id: id,
                advancedPayRuleSetId: advancedPayRuleSetId,
                type: type,
                combinationMode: combinationMode,
                multiplierBps: multiplierBps,
                flatAmountMinor: flatAmountMinor,
                startMinutesLocal: startMinutesLocal,
                endMinutesLocal: endMinutesLocal,
                appliesOnSaturday: appliesOnSaturday,
                appliesOnSunday: appliesOnSunday,
                shiftTemplateId: shiftTemplateId,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DifferentialRulesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({advancedPayRuleSetId = false, shiftTemplateId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (advancedPayRuleSetId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.advancedPayRuleSetId,
                                    referencedTable:
                                        $$DifferentialRulesTableTableReferences
                                            ._advancedPayRuleSetIdTable(db),
                                    referencedColumn:
                                        $$DifferentialRulesTableTableReferences
                                            ._advancedPayRuleSetIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (shiftTemplateId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shiftTemplateId,
                                    referencedTable:
                                        $$DifferentialRulesTableTableReferences
                                            ._shiftTemplateIdTable(db),
                                    referencedColumn:
                                        $$DifferentialRulesTableTableReferences
                                            ._shiftTemplateIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$DifferentialRulesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DifferentialRulesTableTable,
      DifferentialRulesTableData,
      $$DifferentialRulesTableTableFilterComposer,
      $$DifferentialRulesTableTableOrderingComposer,
      $$DifferentialRulesTableTableAnnotationComposer,
      $$DifferentialRulesTableTableCreateCompanionBuilder,
      $$DifferentialRulesTableTableUpdateCompanionBuilder,
      (DifferentialRulesTableData, $$DifferentialRulesTableTableReferences),
      DifferentialRulesTableData,
      PrefetchHooks Function({bool advancedPayRuleSetId, bool shiftTemplateId})
    >;
typedef $$AllowanceRulesTableTableCreateCompanionBuilder =
    AllowanceRulesTableCompanion Function({
      required String id,
      required String advancedPayRuleSetId,
      required String type,
      required int amountMinor,
      Value<bool> appliesOnHoliday,
      Value<String?> shiftTemplateId,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$AllowanceRulesTableTableUpdateCompanionBuilder =
    AllowanceRulesTableCompanion Function({
      Value<String> id,
      Value<String> advancedPayRuleSetId,
      Value<String> type,
      Value<int> amountMinor,
      Value<bool> appliesOnHoliday,
      Value<String?> shiftTemplateId,
      Value<bool> enabled,
      Value<int> rowid,
    });

final class $$AllowanceRulesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AllowanceRulesTableTable,
          AllowanceRulesTableData
        > {
  $$AllowanceRulesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AdvancedPayRuleSetsTableTable _advancedPayRuleSetIdTable(
    _$AppDatabase db,
  ) => db.advancedPayRuleSetsTable.createAlias(
    $_aliasNameGenerator(
      db.allowanceRulesTable.advancedPayRuleSetId,
      db.advancedPayRuleSetsTable.id,
    ),
  );

  $$AdvancedPayRuleSetsTableTableProcessedTableManager
  get advancedPayRuleSetId {
    final $_column = $_itemColumn<String>('advanced_pay_rule_set_id')!;

    final manager = $$AdvancedPayRuleSetsTableTableTableManager(
      $_db,
      $_db.advancedPayRuleSetsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _advancedPayRuleSetIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ShiftTemplatesTableTable _shiftTemplateIdTable(_$AppDatabase db) =>
      db.shiftTemplatesTable.createAlias(
        $_aliasNameGenerator(
          db.allowanceRulesTable.shiftTemplateId,
          db.shiftTemplatesTable.id,
        ),
      );

  $$ShiftTemplatesTableTableProcessedTableManager? get shiftTemplateId {
    final $_column = $_itemColumn<String>('shift_template_id');
    if ($_column == null) return null;
    final manager = $$ShiftTemplatesTableTableTableManager(
      $_db,
      $_db.shiftTemplatesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AllowanceRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AllowanceRulesTableTable> {
  $$AllowanceRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get appliesOnHoliday => $composableBuilder(
    column: $table.appliesOnHoliday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  $$AdvancedPayRuleSetsTableTableFilterComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableFilterComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ShiftTemplatesTableTableFilterComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftTemplateId,
      referencedTable: $db.shiftTemplatesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftTemplatesTableTableFilterComposer(
            $db: $db,
            $table: $db.shiftTemplatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AllowanceRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AllowanceRulesTableTable> {
  $$AllowanceRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appliesOnHoliday => $composableBuilder(
    column: $table.appliesOnHoliday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$AdvancedPayRuleSetsTableTableOrderingComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableOrderingComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ShiftTemplatesTableTableOrderingComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shiftTemplateId,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableOrderingComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AllowanceRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllowanceRulesTableTable> {
  $$AllowanceRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get appliesOnHoliday => $composableBuilder(
    column: $table.appliesOnHoliday,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$AdvancedPayRuleSetsTableTableAnnotationComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ShiftTemplatesTableTableAnnotationComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shiftTemplateId,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AllowanceRulesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllowanceRulesTableTable,
          AllowanceRulesTableData,
          $$AllowanceRulesTableTableFilterComposer,
          $$AllowanceRulesTableTableOrderingComposer,
          $$AllowanceRulesTableTableAnnotationComposer,
          $$AllowanceRulesTableTableCreateCompanionBuilder,
          $$AllowanceRulesTableTableUpdateCompanionBuilder,
          (AllowanceRulesTableData, $$AllowanceRulesTableTableReferences),
          AllowanceRulesTableData,
          PrefetchHooks Function({
            bool advancedPayRuleSetId,
            bool shiftTemplateId,
          })
        > {
  $$AllowanceRulesTableTableTableManager(
    _$AppDatabase db,
    $AllowanceRulesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllowanceRulesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllowanceRulesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AllowanceRulesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> advancedPayRuleSetId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<bool> appliesOnHoliday = const Value.absent(),
                Value<String?> shiftTemplateId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllowanceRulesTableCompanion(
                id: id,
                advancedPayRuleSetId: advancedPayRuleSetId,
                type: type,
                amountMinor: amountMinor,
                appliesOnHoliday: appliesOnHoliday,
                shiftTemplateId: shiftTemplateId,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String advancedPayRuleSetId,
                required String type,
                required int amountMinor,
                Value<bool> appliesOnHoliday = const Value.absent(),
                Value<String?> shiftTemplateId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllowanceRulesTableCompanion.insert(
                id: id,
                advancedPayRuleSetId: advancedPayRuleSetId,
                type: type,
                amountMinor: amountMinor,
                appliesOnHoliday: appliesOnHoliday,
                shiftTemplateId: shiftTemplateId,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AllowanceRulesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({advancedPayRuleSetId = false, shiftTemplateId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (advancedPayRuleSetId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.advancedPayRuleSetId,
                                    referencedTable:
                                        $$AllowanceRulesTableTableReferences
                                            ._advancedPayRuleSetIdTable(db),
                                    referencedColumn:
                                        $$AllowanceRulesTableTableReferences
                                            ._advancedPayRuleSetIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (shiftTemplateId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shiftTemplateId,
                                    referencedTable:
                                        $$AllowanceRulesTableTableReferences
                                            ._shiftTemplateIdTable(db),
                                    referencedColumn:
                                        $$AllowanceRulesTableTableReferences
                                            ._shiftTemplateIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$AllowanceRulesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllowanceRulesTableTable,
      AllowanceRulesTableData,
      $$AllowanceRulesTableTableFilterComposer,
      $$AllowanceRulesTableTableOrderingComposer,
      $$AllowanceRulesTableTableAnnotationComposer,
      $$AllowanceRulesTableTableCreateCompanionBuilder,
      $$AllowanceRulesTableTableUpdateCompanionBuilder,
      (AllowanceRulesTableData, $$AllowanceRulesTableTableReferences),
      AllowanceRulesTableData,
      PrefetchHooks Function({bool advancedPayRuleSetId, bool shiftTemplateId})
    >;
typedef $$AdvancedBreakRulesTableTableCreateCompanionBuilder =
    AdvancedBreakRulesTableCompanion Function({
      required String id,
      required String advancedPayRuleSetId,
      required int minutes,
      Value<String?> shiftTemplateId,
      Value<String?> shiftCategory,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$AdvancedBreakRulesTableTableUpdateCompanionBuilder =
    AdvancedBreakRulesTableCompanion Function({
      Value<String> id,
      Value<String> advancedPayRuleSetId,
      Value<int> minutes,
      Value<String?> shiftTemplateId,
      Value<String?> shiftCategory,
      Value<bool> enabled,
      Value<int> rowid,
    });

final class $$AdvancedBreakRulesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AdvancedBreakRulesTableTable,
          AdvancedBreakRulesTableData
        > {
  $$AdvancedBreakRulesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AdvancedPayRuleSetsTableTable _advancedPayRuleSetIdTable(
    _$AppDatabase db,
  ) => db.advancedPayRuleSetsTable.createAlias(
    $_aliasNameGenerator(
      db.advancedBreakRulesTable.advancedPayRuleSetId,
      db.advancedPayRuleSetsTable.id,
    ),
  );

  $$AdvancedPayRuleSetsTableTableProcessedTableManager
  get advancedPayRuleSetId {
    final $_column = $_itemColumn<String>('advanced_pay_rule_set_id')!;

    final manager = $$AdvancedPayRuleSetsTableTableTableManager(
      $_db,
      $_db.advancedPayRuleSetsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _advancedPayRuleSetIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ShiftTemplatesTableTable _shiftTemplateIdTable(_$AppDatabase db) =>
      db.shiftTemplatesTable.createAlias(
        $_aliasNameGenerator(
          db.advancedBreakRulesTable.shiftTemplateId,
          db.shiftTemplatesTable.id,
        ),
      );

  $$ShiftTemplatesTableTableProcessedTableManager? get shiftTemplateId {
    final $_column = $_itemColumn<String>('shift_template_id');
    if ($_column == null) return null;
    final manager = $$ShiftTemplatesTableTableTableManager(
      $_db,
      $_db.shiftTemplatesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AdvancedBreakRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AdvancedBreakRulesTableTable> {
  $$AdvancedBreakRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftCategory => $composableBuilder(
    column: $table.shiftCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  $$AdvancedPayRuleSetsTableTableFilterComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableFilterComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ShiftTemplatesTableTableFilterComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftTemplateId,
      referencedTable: $db.shiftTemplatesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftTemplatesTableTableFilterComposer(
            $db: $db,
            $table: $db.shiftTemplatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AdvancedBreakRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AdvancedBreakRulesTableTable> {
  $$AdvancedBreakRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftCategory => $composableBuilder(
    column: $table.shiftCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$AdvancedPayRuleSetsTableTableOrderingComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableOrderingComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ShiftTemplatesTableTableOrderingComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shiftTemplateId,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableOrderingComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AdvancedBreakRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdvancedBreakRulesTableTable> {
  $$AdvancedBreakRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<String> get shiftCategory => $composableBuilder(
    column: $table.shiftCategory,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$AdvancedPayRuleSetsTableTableAnnotationComposer get advancedPayRuleSetId {
    final $$AdvancedPayRuleSetsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.advancedPayRuleSetId,
          referencedTable: $db.advancedPayRuleSetsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AdvancedPayRuleSetsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.advancedPayRuleSetsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ShiftTemplatesTableTableAnnotationComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shiftTemplateId,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AdvancedBreakRulesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AdvancedBreakRulesTableTable,
          AdvancedBreakRulesTableData,
          $$AdvancedBreakRulesTableTableFilterComposer,
          $$AdvancedBreakRulesTableTableOrderingComposer,
          $$AdvancedBreakRulesTableTableAnnotationComposer,
          $$AdvancedBreakRulesTableTableCreateCompanionBuilder,
          $$AdvancedBreakRulesTableTableUpdateCompanionBuilder,
          (
            AdvancedBreakRulesTableData,
            $$AdvancedBreakRulesTableTableReferences,
          ),
          AdvancedBreakRulesTableData,
          PrefetchHooks Function({
            bool advancedPayRuleSetId,
            bool shiftTemplateId,
          })
        > {
  $$AdvancedBreakRulesTableTableTableManager(
    _$AppDatabase db,
    $AdvancedBreakRulesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdvancedBreakRulesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AdvancedBreakRulesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AdvancedBreakRulesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> advancedPayRuleSetId = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<String?> shiftTemplateId = const Value.absent(),
                Value<String?> shiftCategory = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AdvancedBreakRulesTableCompanion(
                id: id,
                advancedPayRuleSetId: advancedPayRuleSetId,
                minutes: minutes,
                shiftTemplateId: shiftTemplateId,
                shiftCategory: shiftCategory,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String advancedPayRuleSetId,
                required int minutes,
                Value<String?> shiftTemplateId = const Value.absent(),
                Value<String?> shiftCategory = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AdvancedBreakRulesTableCompanion.insert(
                id: id,
                advancedPayRuleSetId: advancedPayRuleSetId,
                minutes: minutes,
                shiftTemplateId: shiftTemplateId,
                shiftCategory: shiftCategory,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AdvancedBreakRulesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({advancedPayRuleSetId = false, shiftTemplateId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (advancedPayRuleSetId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.advancedPayRuleSetId,
                                    referencedTable:
                                        $$AdvancedBreakRulesTableTableReferences
                                            ._advancedPayRuleSetIdTable(db),
                                    referencedColumn:
                                        $$AdvancedBreakRulesTableTableReferences
                                            ._advancedPayRuleSetIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (shiftTemplateId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shiftTemplateId,
                                    referencedTable:
                                        $$AdvancedBreakRulesTableTableReferences
                                            ._shiftTemplateIdTable(db),
                                    referencedColumn:
                                        $$AdvancedBreakRulesTableTableReferences
                                            ._shiftTemplateIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$AdvancedBreakRulesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AdvancedBreakRulesTableTable,
      AdvancedBreakRulesTableData,
      $$AdvancedBreakRulesTableTableFilterComposer,
      $$AdvancedBreakRulesTableTableOrderingComposer,
      $$AdvancedBreakRulesTableTableAnnotationComposer,
      $$AdvancedBreakRulesTableTableCreateCompanionBuilder,
      $$AdvancedBreakRulesTableTableUpdateCompanionBuilder,
      (AdvancedBreakRulesTableData, $$AdvancedBreakRulesTableTableReferences),
      AdvancedBreakRulesTableData,
      PrefetchHooks Function({bool advancedPayRuleSetId, bool shiftTemplateId})
    >;
typedef $$HolidayRuleSetsTableTableCreateCompanionBuilder =
    HolidayRuleSetsTableCompanion Function({
      required String id,
      required String jobId,
      required int holidayMultiplierBps,
      required String holidaySource,
      Value<int> rowid,
    });
typedef $$HolidayRuleSetsTableTableUpdateCompanionBuilder =
    HolidayRuleSetsTableCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<int> holidayMultiplierBps,
      Value<String> holidaySource,
      Value<int> rowid,
    });

final class $$HolidayRuleSetsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HolidayRuleSetsTableTable,
          HolidayRuleSetsTableData
        > {
  $$HolidayRuleSetsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JobsTableTable _jobIdTable(_$AppDatabase db) =>
      db.jobsTable.createAlias(
        $_aliasNameGenerator(db.holidayRuleSetsTable.jobId, db.jobsTable.id),
      );

  $$JobsTableTableProcessedTableManager get jobId {
    final $_column = $_itemColumn<String>('job_id')!;

    final manager = $$JobsTableTableTableManager(
      $_db,
      $_db.jobsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HolidayRuleSetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HolidayRuleSetsTableTable> {
  $$HolidayRuleSetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get holidayMultiplierBps => $composableBuilder(
    column: $table.holidayMultiplierBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get holidaySource => $composableBuilder(
    column: $table.holidaySource,
    builder: (column) => ColumnFilters(column),
  );

  $$JobsTableTableFilterComposer get jobId {
    final $$JobsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableFilterComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HolidayRuleSetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HolidayRuleSetsTableTable> {
  $$HolidayRuleSetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get holidayMultiplierBps => $composableBuilder(
    column: $table.holidayMultiplierBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get holidaySource => $composableBuilder(
    column: $table.holidaySource,
    builder: (column) => ColumnOrderings(column),
  );

  $$JobsTableTableOrderingComposer get jobId {
    final $$JobsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableOrderingComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HolidayRuleSetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HolidayRuleSetsTableTable> {
  $$HolidayRuleSetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get holidayMultiplierBps => $composableBuilder(
    column: $table.holidayMultiplierBps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get holidaySource => $composableBuilder(
    column: $table.holidaySource,
    builder: (column) => column,
  );

  $$JobsTableTableAnnotationComposer get jobId {
    final $$JobsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HolidayRuleSetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HolidayRuleSetsTableTable,
          HolidayRuleSetsTableData,
          $$HolidayRuleSetsTableTableFilterComposer,
          $$HolidayRuleSetsTableTableOrderingComposer,
          $$HolidayRuleSetsTableTableAnnotationComposer,
          $$HolidayRuleSetsTableTableCreateCompanionBuilder,
          $$HolidayRuleSetsTableTableUpdateCompanionBuilder,
          (HolidayRuleSetsTableData, $$HolidayRuleSetsTableTableReferences),
          HolidayRuleSetsTableData,
          PrefetchHooks Function({bool jobId})
        > {
  $$HolidayRuleSetsTableTableTableManager(
    _$AppDatabase db,
    $HolidayRuleSetsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HolidayRuleSetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HolidayRuleSetsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HolidayRuleSetsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<int> holidayMultiplierBps = const Value.absent(),
                Value<String> holidaySource = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HolidayRuleSetsTableCompanion(
                id: id,
                jobId: jobId,
                holidayMultiplierBps: holidayMultiplierBps,
                holidaySource: holidaySource,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                required int holidayMultiplierBps,
                required String holidaySource,
                Value<int> rowid = const Value.absent(),
              }) => HolidayRuleSetsTableCompanion.insert(
                id: id,
                jobId: jobId,
                holidayMultiplierBps: holidayMultiplierBps,
                holidaySource: holidaySource,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HolidayRuleSetsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jobId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (jobId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jobId,
                                referencedTable:
                                    $$HolidayRuleSetsTableTableReferences
                                        ._jobIdTable(db),
                                referencedColumn:
                                    $$HolidayRuleSetsTableTableReferences
                                        ._jobIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HolidayRuleSetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HolidayRuleSetsTableTable,
      HolidayRuleSetsTableData,
      $$HolidayRuleSetsTableTableFilterComposer,
      $$HolidayRuleSetsTableTableOrderingComposer,
      $$HolidayRuleSetsTableTableAnnotationComposer,
      $$HolidayRuleSetsTableTableCreateCompanionBuilder,
      $$HolidayRuleSetsTableTableUpdateCompanionBuilder,
      (HolidayRuleSetsTableData, $$HolidayRuleSetsTableTableReferences),
      HolidayRuleSetsTableData,
      PrefetchHooks Function({bool jobId})
    >;
typedef $$ShiftPatternsTableTableCreateCompanionBuilder =
    ShiftPatternsTableCompanion Function({
      required String id,
      required String jobId,
      required String name,
      required int cycleLengthDays,
      required DateTime startDate,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$ShiftPatternsTableTableUpdateCompanionBuilder =
    ShiftPatternsTableCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<String> name,
      Value<int> cycleLengthDays,
      Value<DateTime> startDate,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$ShiftPatternsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShiftPatternsTableTable,
          ShiftPatternsTableData
        > {
  $$ShiftPatternsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JobsTableTable _jobIdTable(_$AppDatabase db) =>
      db.jobsTable.createAlias(
        $_aliasNameGenerator(db.shiftPatternsTable.jobId, db.jobsTable.id),
      );

  $$JobsTableTableProcessedTableManager get jobId {
    final $_column = $_itemColumn<String>('job_id')!;

    final manager = $$JobsTableTableTableManager(
      $_db,
      $_db.jobsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ShiftPatternEntriesTableTable,
    List<ShiftPatternEntriesTableData>
  >
  _shiftPatternEntriesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftPatternEntriesTable,
        aliasName: $_aliasNameGenerator(
          db.shiftPatternsTable.id,
          db.shiftPatternEntriesTable.patternId,
        ),
      );

  $$ShiftPatternEntriesTableTableProcessedTableManager
  get shiftPatternEntriesTableRefs {
    final manager = $$ShiftPatternEntriesTableTableTableManager(
      $_db,
      $_db.shiftPatternEntriesTable,
    ).filter((f) => f.patternId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftPatternEntriesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShiftPatternsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftPatternsTableTable> {
  $$ShiftPatternsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleLengthDays => $composableBuilder(
    column: $table.cycleLengthDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$JobsTableTableFilterComposer get jobId {
    final $$JobsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableFilterComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> shiftPatternEntriesTableRefs(
    Expression<bool> Function($$ShiftPatternEntriesTableTableFilterComposer f)
    f,
  ) {
    final $$ShiftPatternEntriesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftPatternEntriesTable,
          getReferencedColumn: (t) => t.patternId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternEntriesTableTableFilterComposer(
                $db: $db,
                $table: $db.shiftPatternEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShiftPatternsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftPatternsTableTable> {
  $$ShiftPatternsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleLengthDays => $composableBuilder(
    column: $table.cycleLengthDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$JobsTableTableOrderingComposer get jobId {
    final $$JobsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableOrderingComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftPatternsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftPatternsTableTable> {
  $$ShiftPatternsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get cycleLengthDays => $composableBuilder(
    column: $table.cycleLengthDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$JobsTableTableAnnotationComposer get jobId {
    final $$JobsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> shiftPatternEntriesTableRefs<T extends Object>(
    Expression<T> Function($$ShiftPatternEntriesTableTableAnnotationComposer a)
    f,
  ) {
    final $$ShiftPatternEntriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftPatternEntriesTable,
          getReferencedColumn: (t) => t.patternId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternEntriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftPatternEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShiftPatternsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftPatternsTableTable,
          ShiftPatternsTableData,
          $$ShiftPatternsTableTableFilterComposer,
          $$ShiftPatternsTableTableOrderingComposer,
          $$ShiftPatternsTableTableAnnotationComposer,
          $$ShiftPatternsTableTableCreateCompanionBuilder,
          $$ShiftPatternsTableTableUpdateCompanionBuilder,
          (ShiftPatternsTableData, $$ShiftPatternsTableTableReferences),
          ShiftPatternsTableData,
          PrefetchHooks Function({
            bool jobId,
            bool shiftPatternEntriesTableRefs,
          })
        > {
  $$ShiftPatternsTableTableTableManager(
    _$AppDatabase db,
    $ShiftPatternsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftPatternsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftPatternsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftPatternsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> cycleLengthDays = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftPatternsTableCompanion(
                id: id,
                jobId: jobId,
                name: name,
                cycleLengthDays: cycleLengthDays,
                startDate: startDate,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                required String name,
                required int cycleLengthDays,
                required DateTime startDate,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftPatternsTableCompanion.insert(
                id: id,
                jobId: jobId,
                name: name,
                cycleLengthDays: cycleLengthDays,
                startDate: startDate,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftPatternsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({jobId = false, shiftPatternEntriesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shiftPatternEntriesTableRefs)
                      db.shiftPatternEntriesTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (jobId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.jobId,
                                    referencedTable:
                                        $$ShiftPatternsTableTableReferences
                                            ._jobIdTable(db),
                                    referencedColumn:
                                        $$ShiftPatternsTableTableReferences
                                            ._jobIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shiftPatternEntriesTableRefs)
                        await $_getPrefetchedData<
                          ShiftPatternsTableData,
                          $ShiftPatternsTableTable,
                          ShiftPatternEntriesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftPatternsTableTableReferences
                              ._shiftPatternEntriesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftPatternsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftPatternEntriesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patternId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShiftPatternsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftPatternsTableTable,
      ShiftPatternsTableData,
      $$ShiftPatternsTableTableFilterComposer,
      $$ShiftPatternsTableTableOrderingComposer,
      $$ShiftPatternsTableTableAnnotationComposer,
      $$ShiftPatternsTableTableCreateCompanionBuilder,
      $$ShiftPatternsTableTableUpdateCompanionBuilder,
      (ShiftPatternsTableData, $$ShiftPatternsTableTableReferences),
      ShiftPatternsTableData,
      PrefetchHooks Function({bool jobId, bool shiftPatternEntriesTableRefs})
    >;
typedef $$ShiftPatternEntriesTableTableCreateCompanionBuilder =
    ShiftPatternEntriesTableCompanion Function({
      required String id,
      required String patternId,
      required int dayIndex,
      Value<String?> shiftTemplateId,
      Value<bool> isOffDay,
      Value<int> rowid,
    });
typedef $$ShiftPatternEntriesTableTableUpdateCompanionBuilder =
    ShiftPatternEntriesTableCompanion Function({
      Value<String> id,
      Value<String> patternId,
      Value<int> dayIndex,
      Value<String?> shiftTemplateId,
      Value<bool> isOffDay,
      Value<int> rowid,
    });

final class $$ShiftPatternEntriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShiftPatternEntriesTableTable,
          ShiftPatternEntriesTableData
        > {
  $$ShiftPatternEntriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftPatternsTableTable _patternIdTable(_$AppDatabase db) =>
      db.shiftPatternsTable.createAlias(
        $_aliasNameGenerator(
          db.shiftPatternEntriesTable.patternId,
          db.shiftPatternsTable.id,
        ),
      );

  $$ShiftPatternsTableTableProcessedTableManager get patternId {
    final $_column = $_itemColumn<String>('pattern_id')!;

    final manager = $$ShiftPatternsTableTableTableManager(
      $_db,
      $_db.shiftPatternsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patternIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ShiftTemplatesTableTable _shiftTemplateIdTable(_$AppDatabase db) =>
      db.shiftTemplatesTable.createAlias(
        $_aliasNameGenerator(
          db.shiftPatternEntriesTable.shiftTemplateId,
          db.shiftTemplatesTable.id,
        ),
      );

  $$ShiftTemplatesTableTableProcessedTableManager? get shiftTemplateId {
    final $_column = $_itemColumn<String>('shift_template_id');
    if ($_column == null) return null;
    final manager = $$ShiftTemplatesTableTableTableManager(
      $_db,
      $_db.shiftTemplatesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftPatternEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftPatternEntriesTableTable> {
  $$ShiftPatternEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOffDay => $composableBuilder(
    column: $table.isOffDay,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftPatternsTableTableFilterComposer get patternId {
    final $$ShiftPatternsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patternId,
      referencedTable: $db.shiftPatternsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftPatternsTableTableFilterComposer(
            $db: $db,
            $table: $db.shiftPatternsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShiftTemplatesTableTableFilterComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftTemplateId,
      referencedTable: $db.shiftTemplatesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftTemplatesTableTableFilterComposer(
            $db: $db,
            $table: $db.shiftTemplatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftPatternEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftPatternEntriesTableTable> {
  $$ShiftPatternEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOffDay => $composableBuilder(
    column: $table.isOffDay,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftPatternsTableTableOrderingComposer get patternId {
    final $$ShiftPatternsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patternId,
      referencedTable: $db.shiftPatternsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftPatternsTableTableOrderingComposer(
            $db: $db,
            $table: $db.shiftPatternsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShiftTemplatesTableTableOrderingComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shiftTemplateId,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableOrderingComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftPatternEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftPatternEntriesTableTable> {
  $$ShiftPatternEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<bool> get isOffDay =>
      $composableBuilder(column: $table.isOffDay, builder: (column) => column);

  $$ShiftPatternsTableTableAnnotationComposer get patternId {
    final $$ShiftPatternsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.patternId,
          referencedTable: $db.shiftPatternsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftPatternsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ShiftTemplatesTableTableAnnotationComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shiftTemplateId,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftPatternEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftPatternEntriesTableTable,
          ShiftPatternEntriesTableData,
          $$ShiftPatternEntriesTableTableFilterComposer,
          $$ShiftPatternEntriesTableTableOrderingComposer,
          $$ShiftPatternEntriesTableTableAnnotationComposer,
          $$ShiftPatternEntriesTableTableCreateCompanionBuilder,
          $$ShiftPatternEntriesTableTableUpdateCompanionBuilder,
          (
            ShiftPatternEntriesTableData,
            $$ShiftPatternEntriesTableTableReferences,
          ),
          ShiftPatternEntriesTableData,
          PrefetchHooks Function({bool patternId, bool shiftTemplateId})
        > {
  $$ShiftPatternEntriesTableTableTableManager(
    _$AppDatabase db,
    $ShiftPatternEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftPatternEntriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ShiftPatternEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftPatternEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patternId = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<String?> shiftTemplateId = const Value.absent(),
                Value<bool> isOffDay = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftPatternEntriesTableCompanion(
                id: id,
                patternId: patternId,
                dayIndex: dayIndex,
                shiftTemplateId: shiftTemplateId,
                isOffDay: isOffDay,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patternId,
                required int dayIndex,
                Value<String?> shiftTemplateId = const Value.absent(),
                Value<bool> isOffDay = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftPatternEntriesTableCompanion.insert(
                id: id,
                patternId: patternId,
                dayIndex: dayIndex,
                shiftTemplateId: shiftTemplateId,
                isOffDay: isOffDay,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftPatternEntriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patternId = false, shiftTemplateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (patternId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.patternId,
                                referencedTable:
                                    $$ShiftPatternEntriesTableTableReferences
                                        ._patternIdTable(db),
                                referencedColumn:
                                    $$ShiftPatternEntriesTableTableReferences
                                        ._patternIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (shiftTemplateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.shiftTemplateId,
                                referencedTable:
                                    $$ShiftPatternEntriesTableTableReferences
                                        ._shiftTemplateIdTable(db),
                                referencedColumn:
                                    $$ShiftPatternEntriesTableTableReferences
                                        ._shiftTemplateIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShiftPatternEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftPatternEntriesTableTable,
      ShiftPatternEntriesTableData,
      $$ShiftPatternEntriesTableTableFilterComposer,
      $$ShiftPatternEntriesTableTableOrderingComposer,
      $$ShiftPatternEntriesTableTableAnnotationComposer,
      $$ShiftPatternEntriesTableTableCreateCompanionBuilder,
      $$ShiftPatternEntriesTableTableUpdateCompanionBuilder,
      (ShiftPatternEntriesTableData, $$ShiftPatternEntriesTableTableReferences),
      ShiftPatternEntriesTableData,
      PrefetchHooks Function({bool patternId, bool shiftTemplateId})
    >;
typedef $$ShiftInstancesTableTableCreateCompanionBuilder =
    ShiftInstancesTableCompanion Function({
      required String id,
      required String jobId,
      Value<String?> shiftTemplateId,
      required DateTime startDateTime,
      required DateTime endDateTime,
      required int unpaidBreakMinutes,
      required String source,
      Value<String?> overrideType,
      Value<String?> note,
      Value<bool> isOffDay,
      Value<bool> isHoliday,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ShiftInstancesTableTableUpdateCompanionBuilder =
    ShiftInstancesTableCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<String?> shiftTemplateId,
      Value<DateTime> startDateTime,
      Value<DateTime> endDateTime,
      Value<int> unpaidBreakMinutes,
      Value<String> source,
      Value<String?> overrideType,
      Value<String?> note,
      Value<bool> isOffDay,
      Value<bool> isHoliday,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ShiftInstancesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShiftInstancesTableTable,
          ShiftInstancesTableData
        > {
  $$ShiftInstancesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JobsTableTable _jobIdTable(_$AppDatabase db) =>
      db.jobsTable.createAlias(
        $_aliasNameGenerator(db.shiftInstancesTable.jobId, db.jobsTable.id),
      );

  $$JobsTableTableProcessedTableManager get jobId {
    final $_column = $_itemColumn<String>('job_id')!;

    final manager = $$JobsTableTableTableManager(
      $_db,
      $_db.jobsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ShiftTemplatesTableTable _shiftTemplateIdTable(_$AppDatabase db) =>
      db.shiftTemplatesTable.createAlias(
        $_aliasNameGenerator(
          db.shiftInstancesTable.shiftTemplateId,
          db.shiftTemplatesTable.id,
        ),
      );

  $$ShiftTemplatesTableTableProcessedTableManager? get shiftTemplateId {
    final $_column = $_itemColumn<String>('shift_template_id');
    if ($_column == null) return null;
    final manager = $$ShiftTemplatesTableTableTableManager(
      $_db,
      $_db.shiftTemplatesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftInstancesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftInstancesTableTable> {
  $$ShiftInstancesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unpaidBreakMinutes => $composableBuilder(
    column: $table.unpaidBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overrideType => $composableBuilder(
    column: $table.overrideType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOffDay => $composableBuilder(
    column: $table.isOffDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHoliday => $composableBuilder(
    column: $table.isHoliday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$JobsTableTableFilterComposer get jobId {
    final $$JobsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableFilterComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShiftTemplatesTableTableFilterComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftTemplateId,
      referencedTable: $db.shiftTemplatesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftTemplatesTableTableFilterComposer(
            $db: $db,
            $table: $db.shiftTemplatesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftInstancesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftInstancesTableTable> {
  $$ShiftInstancesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unpaidBreakMinutes => $composableBuilder(
    column: $table.unpaidBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overrideType => $composableBuilder(
    column: $table.overrideType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOffDay => $composableBuilder(
    column: $table.isOffDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHoliday => $composableBuilder(
    column: $table.isHoliday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$JobsTableTableOrderingComposer get jobId {
    final $$JobsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableOrderingComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShiftTemplatesTableTableOrderingComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shiftTemplateId,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableOrderingComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftInstancesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftInstancesTableTable> {
  $$ShiftInstancesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unpaidBreakMinutes => $composableBuilder(
    column: $table.unpaidBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get overrideType => $composableBuilder(
    column: $table.overrideType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isOffDay =>
      $composableBuilder(column: $table.isOffDay, builder: (column) => column);

  GeneratedColumn<bool> get isHoliday =>
      $composableBuilder(column: $table.isHoliday, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$JobsTableTableAnnotationComposer get jobId {
    final $$JobsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShiftTemplatesTableTableAnnotationComposer get shiftTemplateId {
    final $$ShiftTemplatesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shiftTemplateId,
          referencedTable: $db.shiftTemplatesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftTemplatesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftTemplatesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftInstancesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftInstancesTableTable,
          ShiftInstancesTableData,
          $$ShiftInstancesTableTableFilterComposer,
          $$ShiftInstancesTableTableOrderingComposer,
          $$ShiftInstancesTableTableAnnotationComposer,
          $$ShiftInstancesTableTableCreateCompanionBuilder,
          $$ShiftInstancesTableTableUpdateCompanionBuilder,
          (ShiftInstancesTableData, $$ShiftInstancesTableTableReferences),
          ShiftInstancesTableData,
          PrefetchHooks Function({bool jobId, bool shiftTemplateId})
        > {
  $$ShiftInstancesTableTableTableManager(
    _$AppDatabase db,
    $ShiftInstancesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftInstancesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftInstancesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftInstancesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<String?> shiftTemplateId = const Value.absent(),
                Value<DateTime> startDateTime = const Value.absent(),
                Value<DateTime> endDateTime = const Value.absent(),
                Value<int> unpaidBreakMinutes = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> overrideType = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isOffDay = const Value.absent(),
                Value<bool> isHoliday = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftInstancesTableCompanion(
                id: id,
                jobId: jobId,
                shiftTemplateId: shiftTemplateId,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                unpaidBreakMinutes: unpaidBreakMinutes,
                source: source,
                overrideType: overrideType,
                note: note,
                isOffDay: isOffDay,
                isHoliday: isHoliday,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                Value<String?> shiftTemplateId = const Value.absent(),
                required DateTime startDateTime,
                required DateTime endDateTime,
                required int unpaidBreakMinutes,
                required String source,
                Value<String?> overrideType = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isOffDay = const Value.absent(),
                Value<bool> isHoliday = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ShiftInstancesTableCompanion.insert(
                id: id,
                jobId: jobId,
                shiftTemplateId: shiftTemplateId,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                unpaidBreakMinutes: unpaidBreakMinutes,
                source: source,
                overrideType: overrideType,
                note: note,
                isOffDay: isOffDay,
                isHoliday: isHoliday,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftInstancesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jobId = false, shiftTemplateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (jobId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jobId,
                                referencedTable:
                                    $$ShiftInstancesTableTableReferences
                                        ._jobIdTable(db),
                                referencedColumn:
                                    $$ShiftInstancesTableTableReferences
                                        ._jobIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (shiftTemplateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.shiftTemplateId,
                                referencedTable:
                                    $$ShiftInstancesTableTableReferences
                                        ._shiftTemplateIdTable(db),
                                referencedColumn:
                                    $$ShiftInstancesTableTableReferences
                                        ._shiftTemplateIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShiftInstancesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftInstancesTableTable,
      ShiftInstancesTableData,
      $$ShiftInstancesTableTableFilterComposer,
      $$ShiftInstancesTableTableOrderingComposer,
      $$ShiftInstancesTableTableAnnotationComposer,
      $$ShiftInstancesTableTableCreateCompanionBuilder,
      $$ShiftInstancesTableTableUpdateCompanionBuilder,
      (ShiftInstancesTableData, $$ShiftInstancesTableTableReferences),
      ShiftInstancesTableData,
      PrefetchHooks Function({bool jobId, bool shiftTemplateId})
    >;
typedef $$ReminderRulesTableTableCreateCompanionBuilder =
    ReminderRulesTableCompanion Function({
      required String id,
      required String jobId,
      required String type,
      required int leadMinutes,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$ReminderRulesTableTableUpdateCompanionBuilder =
    ReminderRulesTableCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<String> type,
      Value<int> leadMinutes,
      Value<bool> enabled,
      Value<int> rowid,
    });

final class $$ReminderRulesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReminderRulesTableTable,
          ReminderRulesTableData
        > {
  $$ReminderRulesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JobsTableTable _jobIdTable(_$AppDatabase db) =>
      db.jobsTable.createAlias(
        $_aliasNameGenerator(db.reminderRulesTable.jobId, db.jobsTable.id),
      );

  $$JobsTableTableProcessedTableManager get jobId {
    final $_column = $_itemColumn<String>('job_id')!;

    final manager = $$JobsTableTableTableManager(
      $_db,
      $_db.jobsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReminderRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderRulesTableTable> {
  $$ReminderRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leadMinutes => $composableBuilder(
    column: $table.leadMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  $$JobsTableTableFilterComposer get jobId {
    final $$JobsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableFilterComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderRulesTableTable> {
  $$ReminderRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leadMinutes => $composableBuilder(
    column: $table.leadMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$JobsTableTableOrderingComposer get jobId {
    final $$JobsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableOrderingComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderRulesTableTable> {
  $$ReminderRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get leadMinutes => $composableBuilder(
    column: $table.leadMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$JobsTableTableAnnotationComposer get jobId {
    final $$JobsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderRulesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderRulesTableTable,
          ReminderRulesTableData,
          $$ReminderRulesTableTableFilterComposer,
          $$ReminderRulesTableTableOrderingComposer,
          $$ReminderRulesTableTableAnnotationComposer,
          $$ReminderRulesTableTableCreateCompanionBuilder,
          $$ReminderRulesTableTableUpdateCompanionBuilder,
          (ReminderRulesTableData, $$ReminderRulesTableTableReferences),
          ReminderRulesTableData,
          PrefetchHooks Function({bool jobId})
        > {
  $$ReminderRulesTableTableTableManager(
    _$AppDatabase db,
    $ReminderRulesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderRulesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderRulesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderRulesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> leadMinutes = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderRulesTableCompanion(
                id: id,
                jobId: jobId,
                type: type,
                leadMinutes: leadMinutes,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                required String type,
                required int leadMinutes,
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderRulesTableCompanion.insert(
                id: id,
                jobId: jobId,
                type: type,
                leadMinutes: leadMinutes,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReminderRulesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jobId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (jobId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jobId,
                                referencedTable:
                                    $$ReminderRulesTableTableReferences
                                        ._jobIdTable(db),
                                referencedColumn:
                                    $$ReminderRulesTableTableReferences
                                        ._jobIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReminderRulesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderRulesTableTable,
      ReminderRulesTableData,
      $$ReminderRulesTableTableFilterComposer,
      $$ReminderRulesTableTableOrderingComposer,
      $$ReminderRulesTableTableAnnotationComposer,
      $$ReminderRulesTableTableCreateCompanionBuilder,
      $$ReminderRulesTableTableUpdateCompanionBuilder,
      (ReminderRulesTableData, $$ReminderRulesTableTableReferences),
      ReminderRulesTableData,
      PrefetchHooks Function({bool jobId})
    >;
typedef $$PlanningSettingsTableTableCreateCompanionBuilder =
    PlanningSettingsTableCompanion Function({
      required String id,
      required String jobId,
      Value<bool> planningAlertsEnabled,
      Value<int?> minimumRestMinutes,
      Value<int?> maxConsecutiveWorkDays,
      Value<int?> weeklyOvertimeCapMinutes,
      Value<int?> monthlyOvertimeCapMinutes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PlanningSettingsTableTableUpdateCompanionBuilder =
    PlanningSettingsTableCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<bool> planningAlertsEnabled,
      Value<int?> minimumRestMinutes,
      Value<int?> maxConsecutiveWorkDays,
      Value<int?> weeklyOvertimeCapMinutes,
      Value<int?> monthlyOvertimeCapMinutes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PlanningSettingsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PlanningSettingsTableTable,
          PlanningSettingsTableData
        > {
  $$PlanningSettingsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JobsTableTable _jobIdTable(_$AppDatabase db) =>
      db.jobsTable.createAlias(
        $_aliasNameGenerator(db.planningSettingsTable.jobId, db.jobsTable.id),
      );

  $$JobsTableTableProcessedTableManager get jobId {
    final $_column = $_itemColumn<String>('job_id')!;

    final manager = $$JobsTableTableTableManager(
      $_db,
      $_db.jobsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlanningSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlanningSettingsTableTable> {
  $$PlanningSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get planningAlertsEnabled => $composableBuilder(
    column: $table.planningAlertsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumRestMinutes => $composableBuilder(
    column: $table.minimumRestMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxConsecutiveWorkDays => $composableBuilder(
    column: $table.maxConsecutiveWorkDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyOvertimeCapMinutes => $composableBuilder(
    column: $table.weeklyOvertimeCapMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyOvertimeCapMinutes => $composableBuilder(
    column: $table.monthlyOvertimeCapMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$JobsTableTableFilterComposer get jobId {
    final $$JobsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableFilterComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanningSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanningSettingsTableTable> {
  $$PlanningSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get planningAlertsEnabled => $composableBuilder(
    column: $table.planningAlertsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumRestMinutes => $composableBuilder(
    column: $table.minimumRestMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxConsecutiveWorkDays => $composableBuilder(
    column: $table.maxConsecutiveWorkDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyOvertimeCapMinutes => $composableBuilder(
    column: $table.weeklyOvertimeCapMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyOvertimeCapMinutes => $composableBuilder(
    column: $table.monthlyOvertimeCapMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$JobsTableTableOrderingComposer get jobId {
    final $$JobsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableOrderingComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanningSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanningSettingsTableTable> {
  $$PlanningSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get planningAlertsEnabled => $composableBuilder(
    column: $table.planningAlertsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumRestMinutes => $composableBuilder(
    column: $table.minimumRestMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxConsecutiveWorkDays => $composableBuilder(
    column: $table.maxConsecutiveWorkDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyOvertimeCapMinutes => $composableBuilder(
    column: $table.weeklyOvertimeCapMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyOvertimeCapMinutes => $composableBuilder(
    column: $table.monthlyOvertimeCapMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$JobsTableTableAnnotationComposer get jobId {
    final $$JobsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanningSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanningSettingsTableTable,
          PlanningSettingsTableData,
          $$PlanningSettingsTableTableFilterComposer,
          $$PlanningSettingsTableTableOrderingComposer,
          $$PlanningSettingsTableTableAnnotationComposer,
          $$PlanningSettingsTableTableCreateCompanionBuilder,
          $$PlanningSettingsTableTableUpdateCompanionBuilder,
          (PlanningSettingsTableData, $$PlanningSettingsTableTableReferences),
          PlanningSettingsTableData,
          PrefetchHooks Function({bool jobId})
        > {
  $$PlanningSettingsTableTableTableManager(
    _$AppDatabase db,
    $PlanningSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanningSettingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PlanningSettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PlanningSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<bool> planningAlertsEnabled = const Value.absent(),
                Value<int?> minimumRestMinutes = const Value.absent(),
                Value<int?> maxConsecutiveWorkDays = const Value.absent(),
                Value<int?> weeklyOvertimeCapMinutes = const Value.absent(),
                Value<int?> monthlyOvertimeCapMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanningSettingsTableCompanion(
                id: id,
                jobId: jobId,
                planningAlertsEnabled: planningAlertsEnabled,
                minimumRestMinutes: minimumRestMinutes,
                maxConsecutiveWorkDays: maxConsecutiveWorkDays,
                weeklyOvertimeCapMinutes: weeklyOvertimeCapMinutes,
                monthlyOvertimeCapMinutes: monthlyOvertimeCapMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                Value<bool> planningAlertsEnabled = const Value.absent(),
                Value<int?> minimumRestMinutes = const Value.absent(),
                Value<int?> maxConsecutiveWorkDays = const Value.absent(),
                Value<int?> weeklyOvertimeCapMinutes = const Value.absent(),
                Value<int?> monthlyOvertimeCapMinutes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlanningSettingsTableCompanion.insert(
                id: id,
                jobId: jobId,
                planningAlertsEnabled: planningAlertsEnabled,
                minimumRestMinutes: minimumRestMinutes,
                maxConsecutiveWorkDays: maxConsecutiveWorkDays,
                weeklyOvertimeCapMinutes: weeklyOvertimeCapMinutes,
                monthlyOvertimeCapMinutes: monthlyOvertimeCapMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlanningSettingsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jobId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (jobId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jobId,
                                referencedTable:
                                    $$PlanningSettingsTableTableReferences
                                        ._jobIdTable(db),
                                referencedColumn:
                                    $$PlanningSettingsTableTableReferences
                                        ._jobIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlanningSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanningSettingsTableTable,
      PlanningSettingsTableData,
      $$PlanningSettingsTableTableFilterComposer,
      $$PlanningSettingsTableTableOrderingComposer,
      $$PlanningSettingsTableTableAnnotationComposer,
      $$PlanningSettingsTableTableCreateCompanionBuilder,
      $$PlanningSettingsTableTableUpdateCompanionBuilder,
      (PlanningSettingsTableData, $$PlanningSettingsTableTableReferences),
      PlanningSettingsTableData,
      PrefetchHooks Function({bool jobId})
    >;
typedef $$AvailabilityRulesTableTableCreateCompanionBuilder =
    AvailabilityRulesTableCompanion Function({
      required String id,
      required String jobId,
      required String type,
      required String state,
      Value<DateTime?> startDateTime,
      Value<DateTime?> endDateTime,
      Value<int?> weekday,
      Value<int?> startMinuteOfDay,
      Value<int?> endMinuteOfDay,
      Value<String?> note,
      Value<bool> isEnabled,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AvailabilityRulesTableTableUpdateCompanionBuilder =
    AvailabilityRulesTableCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<String> type,
      Value<String> state,
      Value<DateTime?> startDateTime,
      Value<DateTime?> endDateTime,
      Value<int?> weekday,
      Value<int?> startMinuteOfDay,
      Value<int?> endMinuteOfDay,
      Value<String?> note,
      Value<bool> isEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$AvailabilityRulesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AvailabilityRulesTableTable,
          AvailabilityRulesTableData
        > {
  $$AvailabilityRulesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JobsTableTable _jobIdTable(_$AppDatabase db) =>
      db.jobsTable.createAlias(
        $_aliasNameGenerator(db.availabilityRulesTable.jobId, db.jobsTable.id),
      );

  $$JobsTableTableProcessedTableManager get jobId {
    final $_column = $_itemColumn<String>('job_id')!;

    final manager = $$JobsTableTableTableManager(
      $_db,
      $_db.jobsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AvailabilityRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AvailabilityRulesTableTable> {
  $$AvailabilityRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinuteOfDay => $composableBuilder(
    column: $table.endMinuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$JobsTableTableFilterComposer get jobId {
    final $$JobsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableFilterComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AvailabilityRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AvailabilityRulesTableTable> {
  $$AvailabilityRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinuteOfDay => $composableBuilder(
    column: $table.endMinuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$JobsTableTableOrderingComposer get jobId {
    final $$JobsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableOrderingComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AvailabilityRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AvailabilityRulesTableTable> {
  $$AvailabilityRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinuteOfDay => $composableBuilder(
    column: $table.endMinuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$JobsTableTableAnnotationComposer get jobId {
    final $$JobsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AvailabilityRulesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AvailabilityRulesTableTable,
          AvailabilityRulesTableData,
          $$AvailabilityRulesTableTableFilterComposer,
          $$AvailabilityRulesTableTableOrderingComposer,
          $$AvailabilityRulesTableTableAnnotationComposer,
          $$AvailabilityRulesTableTableCreateCompanionBuilder,
          $$AvailabilityRulesTableTableUpdateCompanionBuilder,
          (AvailabilityRulesTableData, $$AvailabilityRulesTableTableReferences),
          AvailabilityRulesTableData,
          PrefetchHooks Function({bool jobId})
        > {
  $$AvailabilityRulesTableTableTableManager(
    _$AppDatabase db,
    $AvailabilityRulesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AvailabilityRulesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AvailabilityRulesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AvailabilityRulesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<DateTime?> startDateTime = const Value.absent(),
                Value<DateTime?> endDateTime = const Value.absent(),
                Value<int?> weekday = const Value.absent(),
                Value<int?> startMinuteOfDay = const Value.absent(),
                Value<int?> endMinuteOfDay = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AvailabilityRulesTableCompanion(
                id: id,
                jobId: jobId,
                type: type,
                state: state,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                weekday: weekday,
                startMinuteOfDay: startMinuteOfDay,
                endMinuteOfDay: endMinuteOfDay,
                note: note,
                isEnabled: isEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                required String type,
                required String state,
                Value<DateTime?> startDateTime = const Value.absent(),
                Value<DateTime?> endDateTime = const Value.absent(),
                Value<int?> weekday = const Value.absent(),
                Value<int?> startMinuteOfDay = const Value.absent(),
                Value<int?> endMinuteOfDay = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AvailabilityRulesTableCompanion.insert(
                id: id,
                jobId: jobId,
                type: type,
                state: state,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                weekday: weekday,
                startMinuteOfDay: startMinuteOfDay,
                endMinuteOfDay: endMinuteOfDay,
                note: note,
                isEnabled: isEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AvailabilityRulesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jobId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (jobId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jobId,
                                referencedTable:
                                    $$AvailabilityRulesTableTableReferences
                                        ._jobIdTable(db),
                                referencedColumn:
                                    $$AvailabilityRulesTableTableReferences
                                        ._jobIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AvailabilityRulesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AvailabilityRulesTableTable,
      AvailabilityRulesTableData,
      $$AvailabilityRulesTableTableFilterComposer,
      $$AvailabilityRulesTableTableOrderingComposer,
      $$AvailabilityRulesTableTableAnnotationComposer,
      $$AvailabilityRulesTableTableCreateCompanionBuilder,
      $$AvailabilityRulesTableTableUpdateCompanionBuilder,
      (AvailabilityRulesTableData, $$AvailabilityRulesTableTableReferences),
      AvailabilityRulesTableData,
      PrefetchHooks Function({bool jobId})
    >;
typedef $$ActualPayslipsTableTableCreateCompanionBuilder =
    ActualPayslipsTableCompanion Function({
      required String id,
      required String jobId,
      required DateTime periodStart,
      required DateTime periodEnd,
      Value<DateTime?> paidAt,
      required int grossPayMinor,
      Value<int?> workedMinutesReported,
      Value<int?> overtimePayMinor,
      Value<int?> holidayPayMinor,
      Value<int?> allowancesMinor,
      Value<String?> notes,
      Value<String> source,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ActualPayslipsTableTableUpdateCompanionBuilder =
    ActualPayslipsTableCompanion Function({
      Value<String> id,
      Value<String> jobId,
      Value<DateTime> periodStart,
      Value<DateTime> periodEnd,
      Value<DateTime?> paidAt,
      Value<int> grossPayMinor,
      Value<int?> workedMinutesReported,
      Value<int?> overtimePayMinor,
      Value<int?> holidayPayMinor,
      Value<int?> allowancesMinor,
      Value<String?> notes,
      Value<String> source,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ActualPayslipsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActualPayslipsTableTable,
          ActualPayslipsTableData
        > {
  $$ActualPayslipsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JobsTableTable _jobIdTable(_$AppDatabase db) =>
      db.jobsTable.createAlias(
        $_aliasNameGenerator(db.actualPayslipsTable.jobId, db.jobsTable.id),
      );

  $$JobsTableTableProcessedTableManager get jobId {
    final $_column = $_itemColumn<String>('job_id')!;

    final manager = $$JobsTableTableTableManager(
      $_db,
      $_db.jobsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActualPayslipsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActualPayslipsTableTable> {
  $$ActualPayslipsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grossPayMinor => $composableBuilder(
    column: $table.grossPayMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workedMinutesReported => $composableBuilder(
    column: $table.workedMinutesReported,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overtimePayMinor => $composableBuilder(
    column: $table.overtimePayMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get holidayPayMinor => $composableBuilder(
    column: $table.holidayPayMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowancesMinor => $composableBuilder(
    column: $table.allowancesMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$JobsTableTableFilterComposer get jobId {
    final $$JobsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableFilterComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActualPayslipsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActualPayslipsTableTable> {
  $$ActualPayslipsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grossPayMinor => $composableBuilder(
    column: $table.grossPayMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workedMinutesReported => $composableBuilder(
    column: $table.workedMinutesReported,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overtimePayMinor => $composableBuilder(
    column: $table.overtimePayMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get holidayPayMinor => $composableBuilder(
    column: $table.holidayPayMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowancesMinor => $composableBuilder(
    column: $table.allowancesMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$JobsTableTableOrderingComposer get jobId {
    final $$JobsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableOrderingComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActualPayslipsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActualPayslipsTableTable> {
  $$ActualPayslipsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<int> get grossPayMinor => $composableBuilder(
    column: $table.grossPayMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get workedMinutesReported => $composableBuilder(
    column: $table.workedMinutesReported,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overtimePayMinor => $composableBuilder(
    column: $table.overtimePayMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get holidayPayMinor => $composableBuilder(
    column: $table.holidayPayMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allowancesMinor => $composableBuilder(
    column: $table.allowancesMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$JobsTableTableAnnotationComposer get jobId {
    final $$JobsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jobId,
      referencedTable: $db.jobsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JobsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.jobsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActualPayslipsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActualPayslipsTableTable,
          ActualPayslipsTableData,
          $$ActualPayslipsTableTableFilterComposer,
          $$ActualPayslipsTableTableOrderingComposer,
          $$ActualPayslipsTableTableAnnotationComposer,
          $$ActualPayslipsTableTableCreateCompanionBuilder,
          $$ActualPayslipsTableTableUpdateCompanionBuilder,
          (ActualPayslipsTableData, $$ActualPayslipsTableTableReferences),
          ActualPayslipsTableData,
          PrefetchHooks Function({bool jobId})
        > {
  $$ActualPayslipsTableTableTableManager(
    _$AppDatabase db,
    $ActualPayslipsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActualPayslipsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActualPayslipsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActualPayslipsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jobId = const Value.absent(),
                Value<DateTime> periodStart = const Value.absent(),
                Value<DateTime> periodEnd = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
                Value<int> grossPayMinor = const Value.absent(),
                Value<int?> workedMinutesReported = const Value.absent(),
                Value<int?> overtimePayMinor = const Value.absent(),
                Value<int?> holidayPayMinor = const Value.absent(),
                Value<int?> allowancesMinor = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActualPayslipsTableCompanion(
                id: id,
                jobId: jobId,
                periodStart: periodStart,
                periodEnd: periodEnd,
                paidAt: paidAt,
                grossPayMinor: grossPayMinor,
                workedMinutesReported: workedMinutesReported,
                overtimePayMinor: overtimePayMinor,
                holidayPayMinor: holidayPayMinor,
                allowancesMinor: allowancesMinor,
                notes: notes,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jobId,
                required DateTime periodStart,
                required DateTime periodEnd,
                Value<DateTime?> paidAt = const Value.absent(),
                required int grossPayMinor,
                Value<int?> workedMinutesReported = const Value.absent(),
                Value<int?> overtimePayMinor = const Value.absent(),
                Value<int?> holidayPayMinor = const Value.absent(),
                Value<int?> allowancesMinor = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> source = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ActualPayslipsTableCompanion.insert(
                id: id,
                jobId: jobId,
                periodStart: periodStart,
                periodEnd: periodEnd,
                paidAt: paidAt,
                grossPayMinor: grossPayMinor,
                workedMinutesReported: workedMinutesReported,
                overtimePayMinor: overtimePayMinor,
                holidayPayMinor: holidayPayMinor,
                allowancesMinor: allowancesMinor,
                notes: notes,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActualPayslipsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jobId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (jobId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jobId,
                                referencedTable:
                                    $$ActualPayslipsTableTableReferences
                                        ._jobIdTable(db),
                                referencedColumn:
                                    $$ActualPayslipsTableTableReferences
                                        ._jobIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActualPayslipsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActualPayslipsTableTable,
      ActualPayslipsTableData,
      $$ActualPayslipsTableTableFilterComposer,
      $$ActualPayslipsTableTableOrderingComposer,
      $$ActualPayslipsTableTableAnnotationComposer,
      $$ActualPayslipsTableTableCreateCompanionBuilder,
      $$ActualPayslipsTableTableUpdateCompanionBuilder,
      (ActualPayslipsTableData, $$ActualPayslipsTableTableReferences),
      ActualPayslipsTableData,
      PrefetchHooks Function({bool jobId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$JobsTableTableTableManager get jobsTable =>
      $$JobsTableTableTableManager(_db, _db.jobsTable);
  $$PayRuleSetsTableTableTableManager get payRuleSetsTable =>
      $$PayRuleSetsTableTableTableManager(_db, _db.payRuleSetsTable);
  $$AdvancedPayRuleSetsTableTableTableManager get advancedPayRuleSetsTable =>
      $$AdvancedPayRuleSetsTableTableTableManager(
        _db,
        _db.advancedPayRuleSetsTable,
      );
  $$OvertimeTierRulesTableTableTableManager get overtimeTierRulesTable =>
      $$OvertimeTierRulesTableTableTableManager(
        _db,
        _db.overtimeTierRulesTable,
      );
  $$ShiftTemplatesTableTableTableManager get shiftTemplatesTable =>
      $$ShiftTemplatesTableTableTableManager(_db, _db.shiftTemplatesTable);
  $$DifferentialRulesTableTableTableManager get differentialRulesTable =>
      $$DifferentialRulesTableTableTableManager(
        _db,
        _db.differentialRulesTable,
      );
  $$AllowanceRulesTableTableTableManager get allowanceRulesTable =>
      $$AllowanceRulesTableTableTableManager(_db, _db.allowanceRulesTable);
  $$AdvancedBreakRulesTableTableTableManager get advancedBreakRulesTable =>
      $$AdvancedBreakRulesTableTableTableManager(
        _db,
        _db.advancedBreakRulesTable,
      );
  $$HolidayRuleSetsTableTableTableManager get holidayRuleSetsTable =>
      $$HolidayRuleSetsTableTableTableManager(_db, _db.holidayRuleSetsTable);
  $$ShiftPatternsTableTableTableManager get shiftPatternsTable =>
      $$ShiftPatternsTableTableTableManager(_db, _db.shiftPatternsTable);
  $$ShiftPatternEntriesTableTableTableManager get shiftPatternEntriesTable =>
      $$ShiftPatternEntriesTableTableTableManager(
        _db,
        _db.shiftPatternEntriesTable,
      );
  $$ShiftInstancesTableTableTableManager get shiftInstancesTable =>
      $$ShiftInstancesTableTableTableManager(_db, _db.shiftInstancesTable);
  $$ReminderRulesTableTableTableManager get reminderRulesTable =>
      $$ReminderRulesTableTableTableManager(_db, _db.reminderRulesTable);
  $$PlanningSettingsTableTableTableManager get planningSettingsTable =>
      $$PlanningSettingsTableTableTableManager(_db, _db.planningSettingsTable);
  $$AvailabilityRulesTableTableTableManager get availabilityRulesTable =>
      $$AvailabilityRulesTableTableTableManager(
        _db,
        _db.availabilityRulesTable,
      );
  $$ActualPayslipsTableTableTableManager get actualPayslipsTable =>
      $$ActualPayslipsTableTableTableManager(_db, _db.actualPayslipsTable);
}
