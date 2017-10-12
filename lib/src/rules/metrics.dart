// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:linter/src/analyzer.dart';
import 'package:linter/src/metrics/store.dart';
import 'package:shuttlecock/shuttlecock.dart';

const _desc = r' ';

const _details = r'''

**DO** ...

**BAD:**
```

```

**GOOD:**
```

```

''';

Future<_MethodRow> _toRow(
    MethodDeclaration method, ProjectReport report) async {
  final CompilationUnit unit = method.root;
  final path = unit.element.source.toString();
  final ClassDeclaration clazz =
      method.getAncestor((a) => a is ClassDeclaration);
  final className = clazz.name.name;
  final values = new IterableMonad.fromIterable(report.methodsReport.metrics
      .map((metric) =>
          metric.values.firstWhere((v) => v.target == method).value));
  final String sourceCode = new File(path).readAsStringSync();
  final matches = new RegExp('\n').allMatches(sourceCode).toList();
  final startLine =
      1 + matches.indexOf(matches.lastWhere((m) => m.start < method.offset));
  final endLine = 1 +
      matches.indexOf(
          matches.lastWhere((m) => m.start < method.offset + method.length));
  var methodRow = new _MethodRow(path, className, method, startLine, endLine, values);
  return methodRow;
}

// Elastography
// Documentation todos.
// TODO: This rule's visitor has state and should be used only once per program run.
class Metrics extends LintRule {
  _Visitor _visitor;

  Metrics()
      : super(
            name: 'metrics',
            description: _desc,
            details: _details,
            group: Group.style) {
    _visitor = new _Visitor(this);
  }

  @override
  AstVisitor getVisitor() => _visitor;
}

class _MethodRow {
  final String filePath;
  final String className;
  final MethodDeclaration method;
  final int startLine;
  final int endLine;
  final IterableMonad<num> values;

  _MethodRow(this.filePath, this.className, this.method, this.startLine,
      this.endLine, this.values);

  @override
  String toString() =>
      '$filePath, $className, ${method.name.name}, $startLine, $endLine, ${values.join(', ')}';
}

class _Visitor extends SimpleAstVisitor {
  final LintRule rule;
  final MetricsStore store;
  _Visitor(this.rule) : store = new MetricsStore() {
    store.changes
        .debounceTime(const Duration(seconds: 5))
        .listen((projectReport) {
      final report = projectReport.compute();
      Future
          .wait(report.methodsReport.targets.map((m) => _toRow(m, report)))
          .then((rows) {
        rows.forEach(print);
      });
    });
  }

  @override
  void visitCompilationUnit(CompilationUnit node) {
    store.addCompilationUnit(node);
  }
}
