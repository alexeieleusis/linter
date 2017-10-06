import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:shuttlecock/shuttlecock.dart';
import 'package:tuple/tuple.dart';

class LinesOfCodeMethodMetric extends MethodMetric {
  LinesOfCodeMethodMetric({IterableMonad<MetricEvaluation<AstNode>> values})
      : super('Method lines of code', 'Statements count in a method', values);

  @override
  num computation(
      MethodDeclaration target, IterableMonad<CompilationUnit> units) {
    final visitor = new _StatementCounterVisitor();
    target.visitChildren(visitor);
    return visitor._count;
  }

  @override
  LinesOfCodeMethodMetric copy(
          IterableMonad<MetricEvaluation<MethodDeclaration>> values) =>
      new LinesOfCodeMethodMetric(values: values ?? this.values);
}

class _StatementCounterVisitor extends SimpleAstVisitor {
  final _counter = new StreamController<Tuple2<int, String>>();
  int _count = 0;

  @override
  void visitAdjacentStrings(AdjacentStrings node) {
    node.visitChildren(this);
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitAwaitExpression(AwaitExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitBlock(Block node) {
    node.visitChildren(this);
  }

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    node.visitChildren(this);
  }

  @override
  void visitBreakStatement(BreakStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitCascadeExpression(CascadeExpression node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitCatchClause(CatchClause node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitConstructorFieldInitializer(ConstructorFieldInitializer node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitContinueStatement(ContinueStatement node) {
    _incrementCounter(node);
  }

  @override
  void visitDoStatement(DoStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {
    node.visitChildren(this);
  }

  @override
  void visitExpressionStatement(ExpressionStatement node) {
    if (node.expression == null) {
      return;
    }

    node.visitChildren(this);
  }

  @override
  void visitForEachStatement(ForEachStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitForStatement(ForStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitIfStatement(IfStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitIndexExpression(IndexExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitInterpolationExpression(InterpolationExpression node) {
    if (node.leftBracket != null) {
      _incrementCounter(node);
    }
    node.visitChildren(this);
  }

  @override
  void visitInterpolationString(InterpolationString node) {
    node.visitChildren(this);
  }

  @override
  void visitIsExpression(IsExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitLabeledStatement(LabeledStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitListLiteral(ListLiteral node) {
    node.visitChildren(this);
  }

  @override
  void visitMapLiteral(MapLiteral node) {
    node.visitChildren(this);
  }

  @override
  void visitMapLiteralEntry(MapLiteralEntry node) {
    node.visitChildren(this);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitRethrowExpression(RethrowExpression node) {
    _incrementCounter(node);
  }

  @override
  void visitReturnStatement(ReturnStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    node.visitChildren(this);
  }

  @override
  void visitSwitchCase(SwitchCase node) {
    node.visitChildren(this);
  }

  @override
  void visitSwitchDefault(SwitchDefault node) {
    node.visitChildren(this);
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitTryStatement(TryStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    if (node.initializer != null) {
      _incrementCounter(node);
    }
    node.visitChildren(this);
  }

  @override
  void visitVariableDeclarationList(VariableDeclarationList node) {
    node.visitChildren(this);
  }

  @override
  void visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitYieldStatement(YieldStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  void _incrementCounter(AstNode node) {
    _count++;
    _counter.add(new Tuple2(1, node.toString()));
  }
}
