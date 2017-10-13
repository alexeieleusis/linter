import 'package:analyzer/dart/ast/ast.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:shuttlecock/shuttlecock.dart';

class ParameterCountMethodMetric extends MethodMetric {
  ParameterCountMethodMetric({IterableMonad<MetricEvaluation<AstNode>> values})
      : super('method_parameter_count', 'Method parameters count', '', values);

  @override
  num computation(
          MethodDeclaration target, IterableMonad<CompilationUnit> units) =>
      target.parameters?.parameters?.length ?? 0;

  @override
  ParameterCountMethodMetric copy(
          IterableMonad<MetricEvaluation<MethodDeclaration>> values) =>
      new ParameterCountMethodMetric(values: values ?? this.values);
}
