import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:shuttlecock/shuttlecock.dart';

class AssignmentCountMethodMetric extends MethodMetric {
  AssignmentCountMethodMetric({IterableMonad<MetricEvaluation<AstNode>> values})
      : super('method_assignment_count', 'Method assignments',
            'Statements count in a method', values);

  @override
  num computation(
      MethodDeclaration target, IterableMonad<CompilationUnit> units) {
    final visitor = new _Visitor();
    target.visitChildren(visitor);
    return visitor._count;
  }

  @override
  AssignmentCountMethodMetric copy(
          IterableMonad<MetricEvaluation<MethodDeclaration>> values) =>
      new AssignmentCountMethodMetric(values: values ?? this.values);
}

class _Visitor extends RecursiveAstVisitor {
  int _count = 0;

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    _incrementCounter(node);
    node.visitChildren(this);
  }

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    // Do nothing as we do not want to count variables inside the function.
  }

  void _incrementCounter(AstNode node) {
    _count++;
  }
}
