import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:shuttlecock/shuttlecock.dart';

class OptionalParameterCountMethodMetric extends MethodMetric {
  OptionalParameterCountMethodMetric(
      {IterableMonad<MetricEvaluation<AstNode>> values})
      : super(
            'method_optional_parameter_count',
            'Method optional parameters count',
            'As a proxy to method overload',
            values);

  @override
  num computation(
          MethodDeclaration target, IterableMonad<CompilationUnit> units) =>
      target.parameters?.parameters
          ?.where((p) => p.kind != ParameterKind.REQUIRED)
          ?.length ??
      0;

  @override
  OptionalParameterCountMethodMetric copy(
          IterableMonad<MetricEvaluation<MethodDeclaration>> values) =>
      new OptionalParameterCountMethodMetric(values: values ?? this.values);
}
