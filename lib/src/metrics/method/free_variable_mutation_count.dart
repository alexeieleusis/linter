import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:shuttlecock/shuttlecock.dart';

class FreeVariableMutationCountMethodMetric extends MethodMetric {
  FreeVariableMutationCountMethodMetric(
      {IterableMonad<MetricEvaluation<AstNode>> values})
      : super('method_free_variable_mutation_count',
            'Number of assignments to variables captured in scope', '', values);

  @override
  num computation(
      MethodDeclaration target, IterableMonad<CompilationUnit> units) {
    final visitor = new _Visitor(target.body);
    target.body.visitChildren(visitor);
    return visitor._count;
  }

  @override
  FreeVariableMutationCountMethodMetric copy(
          IterableMonad<MetricEvaluation<MethodDeclaration>> values) =>
      new FreeVariableMutationCountMethodMetric(values: values ?? this.values);
}

/// Counts arguments and variables in parent scope, includes arguments.
class _Visitor extends RecursiveAstVisitor {
  final FunctionBody body;
  int _count = 0;

  _Visitor(this.body);

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    if (node.leftHandSide is! SimpleIdentifier) {
      return;
    }

    final identifier = node.leftHandSide as SimpleIdentifier;
    final computeNode = identifier.bestElement.computeNode();
    if (computeNode.getAncestor((n) => n == body) != null) {
      _incrementCounter();
    }
  }

  void _incrementCounter() {
    _count++;
  }
}
