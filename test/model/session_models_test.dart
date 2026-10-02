import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/session_models.dart';

void main() {
  test('ModeState.parse reads current mode and keeps every mode', () {
    final m = ModeState.parse({
      'currentModeId': 'code',
      'availableModes': [
        {
          'id': 'ask',
          'name': 'Ask',
          'description': 'd',
          '_meta': {'a': 1}
        },
        {'id': 'code', 'name': 'Code'},
      ],
      'meta': {'by': 'u'},
    })!;
    expect(m.currentModeId, 'code');
    expect(m.availableModes.map((x) => x.id), ['ask', 'code']);
    expect(m.availableModes.first.extras, {
      '_meta': {'a': 1}
    });
    expect(m.meta, {'by': 'u'});
  });

  test('a list entry without an id is kept, not dropped', () {
    final m = ModeState.parse({
      'availableModes': [
        {'name': 'x'}
      ]
    })!;
    expect(m.availableModes.single.id, isNull);
    expect(m.availableModes.single.name, 'x');
  });

  test('AgentState.parse reads agentInfo, capabilities and auth methods', () {
    final a = AgentState.parse({
      'protocolVersion': 1,
      'agentInfo': {'name': 'claude', 'title': 'Claude', 'version': '2'},
      'agentCapabilities': {'loadSession': true},
      'authMethods': [
        {'id': 'oauth', 'name': 'OAuth'}
      ],
      'meta': {'m': 1},
      'future': 'kept',
    })!;
    expect(a.protocolVersion, 1);
    expect(a.agentInfo!.title, 'Claude');
    expect(a.agentCapabilities, {'loadSession': true});
    expect(a.authMethods.single.id, 'oauth');
    expect(a.extras, {'future': 'kept'});
  });

  test('CommandsState and ConfigState keep their entries', () {
    final c = CommandsState.parse({
      'commands': [
        {
          'name': 'plan',
          'description': 'd',
          'input': {'hint': 'h'}
        }
      ],
    })!;
    expect(c.commands.single.input, {'hint': 'h'});
    final cfg = ConfigState.parse({
      'options': [
        {
          'id': 'model',
          'name': 'Model',
          'category': 'model',
          'type': 'select',
          'currentValue': 'a',
          'options': [
            {'value': 'a', 'name': 'A'}
          ],
        },
      ],
    })!;
    expect(cfg.options.single.currentValue, 'a');
    expect(cfg.options.single.choices.single['value'], 'a');
  });

  test('UsageState.parse reads used, size and cost', () {
    final u = UsageState.parse({
      'used': 10,
      'size': 100,
      'cost': {'amount': 0.5, 'currency': 'USD'},
    })!;
    expect(u.used, 10);
    expect(u.size, 100);
    expect(u.cost!.currency, 'USD');
  });

  test('SessionInfo.parse maps updated_at', () {
    final s = SessionInfo.parse({'title': 'T', 'updated_at': '2026-10-01'})!;
    expect(s.title, 'T');
    expect(s.updatedAt, '2026-10-01');
  });

  test('PlansState.parse reads by-id and legacy plans', () {
    final p = PlansState.parse({
      'by-id': {
        'p1': {
          'entries': [
            {'content': 'do', 'priority': 'high', 'status': 'pending'}
          ]
        },
        'p2': {'uri': 'file:///plan.md'},
        'p3': {'markdown': '# plan'},
      },
      'legacy': {'entries': []},
    })!;
    expect(p.byId['p1']!.entries!.single.priority, 'high');
    expect(p.byId['p2']!.uri, 'file:///plan.md');
    expect(p.byId['p3']!.markdown, '# plan');
    expect(p.legacy!.entries, isEmpty);
  });

  test('parse returns null only for non-maps', () {
    expect(ModeState.parse('x'), isNull);
    expect(UsageState.parse(null), isNull);
    expect(UsageState.parse({}), isNotNull);
  });
}
