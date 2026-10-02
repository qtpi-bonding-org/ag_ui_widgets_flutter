// lib/src/model/session_models.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'wire_parse.dart';

part 'session_models.freezed.dart';

@freezed
abstract class ElicitationScope with _$ElicitationScope {
  const ElicitationScope._();
  const factory ElicitationScope({
    String? kind,
    String? requestId,
    String? sessionId,
    String? toolCallId,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ElicitationScope;

  static const _known = {'kind', 'request_id', 'session_id', 'tool_call_id'};

  static ElicitationScope? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ElicitationScope(
      kind: asString(m['kind']),
      requestId: asString(m['request_id']),
      sessionId: asString(m['session_id']),
      toolCallId: asString(m['tool_call_id']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class AuthMethod with _$AuthMethod {
  const AuthMethod._();
  const factory AuthMethod({
    String? id,
    String? name,
    String? description,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _AuthMethod;

  static const _known = {'id', 'name', 'description'};

  static AuthMethod? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return AuthMethod(
      id: asString(m['id']),
      name: asString(m['name']),
      description: asString(m['description']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class ModeState with _$ModeState {
  const ModeState._();
  const factory ModeState({
    String? currentModeId,
    @Default(<SessionMode>[]) List<SessionMode> availableModes,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ModeState;

  static const _known = {'currentModeId', 'availableModes', 'meta'};

  static ModeState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ModeState(
      currentModeId: asString(m['currentModeId']),
      availableModes: [
        for (final e in asJsonMapList(m['availableModes']))
          SessionMode.parse(e)!,
      ],
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class SessionMode with _$SessionMode {
  const SessionMode._();
  const factory SessionMode({
    String? id,
    String? name,
    String? description,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _SessionMode;

  static const _known = {'id', 'name', 'description'};

  static SessionMode? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return SessionMode(
      id: asString(m['id']),
      name: asString(m['name']),
      description: asString(m['description']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class AgentInfo with _$AgentInfo {
  const AgentInfo._();
  const factory AgentInfo({
    String? name,
    String? title,
    String? version,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _AgentInfo;

  static const _known = {'name', 'title', 'version'};

  static AgentInfo? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return AgentInfo(
      name: asString(m['name']),
      title: asString(m['title']),
      version: asString(m['version']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class AgentState with _$AgentState {
  const AgentState._();
  const factory AgentState({
    int? protocolVersion,
    AgentInfo? agentInfo,
    Map<String, dynamic>? agentCapabilities,
    @Default(<AuthMethod>[]) List<AuthMethod> authMethods,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _AgentState;

  static const _known = {
    'protocolVersion',
    'agentInfo',
    'agentCapabilities',
    'authMethods',
    'meta',
  };

  static AgentState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return AgentState(
      protocolVersion: asInt(m['protocolVersion']),
      agentInfo: AgentInfo.parse(m['agentInfo']),
      agentCapabilities: asJsonMap(m['agentCapabilities']),
      authMethods: [
        for (final e in asJsonMapList(m['authMethods'])) AuthMethod.parse(e)!,
      ],
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class AvailableCommand with _$AvailableCommand {
  const AvailableCommand._();
  const factory AvailableCommand({
    String? name,
    String? description,
    Map<String, dynamic>? input,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _AvailableCommand;

  static const _known = {'name', 'description', 'input'};

  static AvailableCommand? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return AvailableCommand(
      name: asString(m['name']),
      description: asString(m['description']),
      input: asJsonMap(m['input']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class CommandsState with _$CommandsState {
  const CommandsState._();
  const factory CommandsState({
    @Default(<AvailableCommand>[]) List<AvailableCommand> commands,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _CommandsState;

  static const _known = {'commands', 'meta'};

  static CommandsState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return CommandsState(
      commands: [
        for (final e in asJsonMapList(m['commands']))
          AvailableCommand.parse(e)!,
      ],
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class ConfigOption with _$ConfigOption {
  const ConfigOption._();
  const factory ConfigOption({
    String? id,
    String? name,
    String? description,
    String? category,
    String? type,
    Object? currentValue,
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> choices,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ConfigOption;

  static const _known = {
    'id',
    'name',
    'description',
    'category',
    'type',
    'currentValue',
    'options',
  };

  static ConfigOption? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ConfigOption(
      id: asString(m['id']),
      name: asString(m['name']),
      description: asString(m['description']),
      category: asString(m['category']),
      type: asString(m['type']),
      currentValue: m['currentValue'],
      choices: asJsonMapList(m['options']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class ConfigState with _$ConfigState {
  const ConfigState._();
  const factory ConfigState({
    @Default(<ConfigOption>[]) List<ConfigOption> options,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _ConfigState;

  static const _known = {'options', 'meta'};

  static ConfigState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return ConfigState(
      options: [
        for (final e in asJsonMapList(m['options'])) ConfigOption.parse(e)!,
      ],
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class UsageCost with _$UsageCost {
  const UsageCost._();
  const factory UsageCost({
    num? amount,
    String? currency,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _UsageCost;

  static const _known = {'amount', 'currency'};

  static UsageCost? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    final amount = m['amount'];
    return UsageCost(
      amount: amount is num ? amount : null,
      currency: asString(m['currency']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class UsageState with _$UsageState {
  const UsageState._();
  const factory UsageState({
    int? used,
    int? size,
    UsageCost? cost,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _UsageState;

  static const _known = {'used', 'size', 'cost', 'meta'};

  static UsageState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return UsageState(
      used: asInt(m['used']),
      size: asInt(m['size']),
      cost: UsageCost.parse(m['cost']),
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class SessionInfo with _$SessionInfo {
  const SessionInfo._();
  const factory SessionInfo({
    String? title,
    String? updatedAt,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _SessionInfo;

  static const _known = {'title', 'updated_at', 'meta'};

  static SessionInfo? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return SessionInfo(
      title: asString(m['title']),
      updatedAt: asString(m['updated_at']),
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class PlanEntry with _$PlanEntry {
  const PlanEntry._();
  const factory PlanEntry({
    String? content,
    String? priority,
    String? status,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _PlanEntry;

  static const _known = {'content', 'priority', 'status'};

  static PlanEntry? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return PlanEntry(
      content: asString(m['content']),
      priority: asString(m['priority']),
      status: asString(m['status']),
      extras: extrasOf(m, _known),
    );
  }
}

/// One plan: entries, or a file (`uri`), or markdown. [entries] is null for a
/// file or markdown plan.
@freezed
abstract class PlanState with _$PlanState {
  const PlanState._();
  const factory PlanState({
    List<PlanEntry>? entries,
    String? uri,
    String? markdown,
    Map<String, dynamic>? meta,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _PlanState;

  static const _known = {'entries', 'uri', 'markdown', 'meta'};

  static PlanState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    return PlanState(
      entries: m['entries'] is List
          ? [for (final e in asJsonMapList(m['entries'])) PlanEntry.parse(e)!]
          : null,
      uri: asString(m['uri']),
      markdown: asString(m['markdown']),
      meta: asJsonMap(m['meta']),
      extras: extrasOf(m, _known),
    );
  }
}

@freezed
abstract class PlansState with _$PlansState {
  const PlansState._();
  const factory PlansState({
    @Default(<String, PlanState>{}) Map<String, PlanState> byId,
    PlanState? legacy,
    @Default(<String, dynamic>{}) Map<String, dynamic> extras,
  }) = _PlansState;

  static const _known = {'by-id', 'legacy'};

  static PlansState? parse(Object? raw) {
    final m = asJsonMap(raw);
    if (m == null) return null;
    final byId = asJsonMap(m['by-id']) ?? const <String, dynamic>{};
    return PlansState(
      byId: {
        for (final e in byId.entries)
          if (PlanState.parse(e.value) case final plan?) e.key: plan,
      },
      legacy: PlanState.parse(m['legacy']),
      extras: extrasOf(m, _known),
    );
  }
}
