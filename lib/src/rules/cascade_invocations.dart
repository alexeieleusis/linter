// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library linter.src.rules.cascade_invocations;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:linter/src/linter.dart';

const _desc = r'Cascade consecutive method invocations on the same reference.';

const _details = r'''

**DO** Use the cascading style when succesively invoking methods on the same
 reference.

**BAD:**
```
SomeClass someReference = new SomeClass();
someReference.firstMethod();
someReference.secondMethod();
```

**BAD:**
```
SomeClass someReference = new SomeClass();
...
someReference.firstMethod();
someReference.secondMethod();
```

**GOOD:**
```
SomeClass someReference = new SomeClass()
    ..firstMethod()
    ..secondMethod();
```

**GOOD:**
```
SomeClass someReference = new SomeClass();
...
someReference
    ..firstMethod()
    ..secondMethod();
```

''';

class CascadeInvocations extends LintRule {
  _Visitor _visitor;
  CascadeInvocations()
      : super(
            name: 'cascade_invocations',
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
  _Visitor(this.rule);


  @override
  void visitExpressionStatement(ExpressionStatement node) {
    if (node.expression is! MethodInvocation && node.expression is! PrefixedIdentifier) {
      return;
    }

    final simpleIdentifier = _findTarget(node);
    Block body = node.getAncestor((n) => n is Block);
    Iterable previousNodes =
    body.childEntities.takeWhile((n) => n != node);
    if (previousNodes.isEmpty) {
      return;
    }


    final previousNode = previousNodes.last;
    final SimpleIdentifier previousIdentifier = _findTarget(previousNode);
    if (previousIdentifier != null && previousIdentifier.staticElement == simpleIdentifier.staticElement) {
      rule.reportLint(node);
    }

    if (previousNode is VariableDeclarationStatement) {
      _reportIfDeclarationFollowedByMethodInvocation(
          previousNodes, simpleIdentifier, node);
    }
  }

  bool _previousIsMethodInvocation(AstNode previousNode) =>
      previousNode is ExpressionStatement &&
      previousNode is MethodInvocation;

  bool _previousIsSingleVariableDeclaration(
          Iterable previousChilds, VariableDeclarationStatement variables) =>
      previousChilds.isNotEmpty &&
      variables != null &&
      variables.variables.variables.length == 1;

  void _reportIfConsecutiveInvocationsOnSameTarget(AstNode previousNode,
      SimpleIdentifier simpleIdentifier, AstNode node) {
    ExpressionStatement previousStatement = previousChilds.last;
    MethodInvocation previousInvocation = previousStatement.expression;
    if (previousInvocation.realTarget is SimpleIdentifier &&
        simpleIdentifier.staticElement ==
            (previousInvocation.realTarget as SimpleIdentifier).staticElement) {
      rule.reportLint(node);
    }
  }

  void _reportIfDeclarationFollowedByMethodInvocation(Iterable previousChilds,
      SimpleIdentifier simpleIdentifier, AstNode node) {
    VariableDeclarationStatement variables =
        previousChilds.last as VariableDeclarationStatement;
    if (_previousIsSingleVariableDeclaration(previousChilds, variables)) {
      if (variables.variables.variables.first.name.staticElement ==
          simpleIdentifier.staticElement) {
        rule.reportLint(node);
      }
    }
  }
}

SimpleIdentifier _findTarget(ExpressionStatement node) {
  if (node.expression is MethodInvocation) {
    return (node.expression as MethodInvocation).realTarget;
  }

  if (node.expression is PrefixedIdentifier) {
    return (node.expression as PrefixedIdentifier).prefix;
  }

  return null;
}
