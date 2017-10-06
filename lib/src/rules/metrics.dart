// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:linter/src/analyzer.dart';
import 'package:linter/src/metrics/store.dart';

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

class _Visitor extends SimpleAstVisitor {
  final LintRule rule;
  final MetricsStore store;
  _Visitor(this.rule) : store = new MetricsStore() {
    store.changes
        .debounceTime(const Duration(seconds: 5))
        .listen((projectReport) {
      print(projectReport.compute());
    });
  }

  @override
  void visitCompilationUnit(CompilationUnit node) {
    store.addCompilationUnit(node);
  }
}
