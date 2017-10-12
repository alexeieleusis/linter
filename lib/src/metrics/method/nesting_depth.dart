import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:shuttlecock/shuttlecock.dart';

// https://next.sonarqube.com/sonarqube/coding_rules#rule_key=c%3AS134
// https://www.ndepend.com/docs/code-metrics#ILNestingDepth
class NestingDepthMethodMetric extends MethodMetric {
  NestingDepthMethodMetric({IterableMonad<MetricEvaluation<AstNode>> values})
      : super('Method nesting depth metric', '', values);

  @override
  num computation(
      MethodDeclaration target, IterableMonad<CompilationUnit> units) {
    final visitor = new _Visitor();
    target.body.visitChildren(visitor);
    return visitor._maxDepth;
  }

  @override
  NestingDepthMethodMetric copy(
          IterableMonad<MetricEvaluation<MethodDeclaration>> values) =>
      new NestingDepthMethodMetric(values: values ?? this.values);
}

class _Visitor extends RecursiveAstVisitor {
  int _depth = 0;
  int _maxDepth = 0;

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    if (node.operator.type != TokenType.QUESTION_QUESTION_EQ) {
      node.visitChildren(this);
      return;
    }

    _countNesting(node);
  }

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    _countNesting(node);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    _countNesting(node);
  }

  @override
  void visitDoStatement(DoStatement node) {
    _countNesting(node);
  }

  @override
  void visitForEachStatement(ForEachStatement node) {
    _countNesting(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    _countNesting(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    _countNesting(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.operator?.type != TokenType.QUESTION_PERIOD) {
      node.visitChildren(this);
      return;
    }

    _countNesting(node);
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    _countNesting(node);
  }

  @override
  void visitTryStatement(TryStatement node) {
    _countNesting(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    _countNesting(node);
  }

  void _countNesting(AstNode node) {
    _incrementCounter();
    node.visitChildren(this);
    _decrementCounter();
  }

  void _decrementCounter() {
    _depth--;
  }

  void _incrementCounter() {
    _depth++;
    if (_depth > _maxDepth) {
      _maxDepth = _depth;
    }
  }
}
