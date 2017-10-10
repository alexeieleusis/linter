import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:shuttlecock/shuttlecock.dart';
import 'package:tuple/tuple.dart';

class VariableCountMethodMetric extends MethodMetric {
  VariableCountMethodMetric({IterableMonad<MetricEvaluation<AstNode>> values})
      : super(
            'Method number of variables', 'Variable count in a method', values);

  @override
  num computation(
      MethodDeclaration target, IterableMonad<CompilationUnit> units) {
    print('computation ${target.name.name}');
    final visitor = new _VariableCounterVisitor();
    target.body.visitChildren(visitor);
    return visitor._count;
  }

  @override
  VariableCountMethodMetric copy(
          IterableMonad<MetricEvaluation<MethodDeclaration>> values) =>
      new VariableCountMethodMetric(values: values ?? this.values);
}

class _VariableCounterVisitor extends RecursiveAstVisitor {
  final _counter = new StreamController<Tuple2<int, String>>();
  int _count = 0;

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    // Do nothing as we do not want to count variables inside the function.
  }

  @override
  void visitEmptyFunctionBody(EmptyFunctionBody node) {}

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {}

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {}

  @override
  void visitFunctionDeclarationStatement(FunctionDeclarationStatement node) {}

  @override
  void visitFunctionExpression(FunctionExpression node) {}

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {}

  @override
  void visitFunctionTypeAlias(FunctionTypeAlias node) {}

  @override
  void visitFunctionTypedFormalParameter(FunctionTypedFormalParameter node) {}

  @override
  void visitGenericFunctionType(GenericFunctionType node) {}

  @override
  void visitNativeFunctionBody(NativeFunctionBody node) {}

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    _incrementCounter(node);
  }

  void _incrementCounter(AstNode node) {
    print('_incrementCounter $node');
    _count++;
    _counter.add(new Tuple2(1, node.toString()));
  }
}
