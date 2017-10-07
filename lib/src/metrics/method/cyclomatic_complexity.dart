import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:shuttlecock/shuttlecock.dart';
import 'package:tuple/tuple.dart';

// https://www.ndepend.com/docs/code-metrics#CC
// if | while | for | foreach | case | default | continue | goto | && | || | catch | ternary operator ?: | ??
class CyclomaticComplexityMethodMetric extends MethodMetric {
  CyclomaticComplexityMethodMetric(
      {IterableMonad<MetricEvaluation<AstNode>> values})
      : super('Method cyclomatic complexity', '', values);

  @override
  num computation(
      MethodDeclaration target, IterableMonad<CompilationUnit> units) {
    final visitor = new _CyclomaticComplexityVisitor();
    target.visitChildren(visitor);
    return visitor._count;
  }

  @override
  CyclomaticComplexityMethodMetric copy(
          IterableMonad<MetricEvaluation<MethodDeclaration>> values) =>
      new CyclomaticComplexityMethodMetric(values: values ?? this.values);
}

class _CyclomaticComplexityVisitor extends SimpleAstVisitor {
  final _counter = new StreamController<Tuple2<int, String>>();
  int _count = 1;

  @override
  void visitAdjacentStrings(AdjacentStrings node) {
    node.visitChildren(this);
  }

  @override
  void visitArgumentList(ArgumentList node) {
    node.visitChildren(this);
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitAwaitExpression(AwaitExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    final operatorType = node.operator.type;
    const booleanOperators = const <TokenType>[
      TokenType.AMPERSAND_AMPERSAND,
      TokenType.BAR_BAR,
      TokenType.QUESTION_QUESTION,
      TokenType.QUESTION_QUESTION_EQ,
      TokenType.QUESTION
    ];
    if (booleanOperators.contains(operatorType)) {
      _incrementCounter(node);
    }
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
  void visitCascadeExpression(CascadeExpression node) {
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
  void visitDoStatement(DoStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitExpressionStatement(ExpressionStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitFieldFormalParameter(FieldFormalParameter node) {
    node.visitChildren(this);
  }

  @override
  void visitForEachStatement(ForEachStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitFormalParameterList(FormalParameterList node) {
    node.visitChildren(this);
  }

  @override
  void visitForStatement(ForStatement node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitFunctionDeclarationStatement(FunctionDeclarationStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
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
    node.visitChildren(this);
  }

  @override
  void visitInterpolationExpression(InterpolationExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitInterpolationString(InterpolationString node) {
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
    node.visitChildren(this);
  }

  @override
  void visitParenthesizedExpression(ParenthesizedExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitPrefixExpression(PrefixExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitReturnStatement(ReturnStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    node.visitChildren(this);
  }

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    node.visitChildren(this);
  }

  @override
  void visitSuperExpression(SuperExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitSwitchCase(SwitchCase node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitSwitchDefault(SwitchDefault node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitTryStatement(TryStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitTypeArgumentList(TypeArgumentList node) {
    node.visitChildren(this);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
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
    node.visitChildren(this);
  }

  void _incrementCounter(AstNode node) {
    _count++;
    _counter.add(new Tuple2(1, node.toString()));
  }
}
