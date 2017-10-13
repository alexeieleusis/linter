import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:shuttlecock/shuttlecock.dart';

class MutableVariableCountMethodMetric extends MethodMetric {
  MutableVariableCountMethodMetric(
      {IterableMonad<MetricEvaluation<AstNode>> values})
      : super('method_mutable_variable_count',
            'Number of mutable variables in a method', '', values);

  @override
  num computation(
      MethodDeclaration target, IterableMonad<CompilationUnit> units) {
    final visitor = new _Visitor();
    target.body.visitChildren(visitor);
    return visitor._count;
  }

  @override
  MutableVariableCountMethodMetric copy(
          IterableMonad<MetricEvaluation<MethodDeclaration>> values) =>
      new MutableVariableCountMethodMetric(values: values ?? this.values);
}

class _Visitor extends RecursiveAstVisitor {
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
    if (!node.isFinal && !node.isConst && !node.isSynthetic) {
      node.visitChildren(this);
      return;
    }
    _incrementCounter(node);
  }

  void _incrementCounter(AstNode node) {
    _count++;
  }
}
