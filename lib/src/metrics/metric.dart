import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';
import 'package:shuttlecock/shuttlecock.dart';

int metricEvaluationComparator<T extends AstNode>(
        MetricEvaluation<T> a, MetricEvaluation<T> b) =>
    a.value.compareTo(b.value);

@immutable
abstract class MethodMetric extends Metric<MethodDeclaration> {
  MethodMetric(
      String name, String description, IterableMonad<MetricEvaluation> values)
      : super(name, description, values: values);
}

@immutable
abstract class Metric<T extends AstNode> {
  final String name;
  final String description;

  final IterableMonad<MetricEvaluation<T>> values;

  Metric(this.name, this.description,
      {IterableMonad<MetricEvaluation<T>> values})
      : values = values ?? new IterableMonad.fromIterable(new Set());

  @protected
  num computation(T target, IterableMonad<CompilationUnit> units);

  Metric<T> copy(IterableMonad<MetricEvaluation<T>> values);

  Metric<AstNode> evaluate(
      IterableMonad<T> targets, IterableMonad<CompilationUnit> units) {
    final newValues = targets.map(
        (target) => new MetricEvaluation(target, computation(target, units)));
    newValues.forEach(print);
    return copy(newValues);
  }
}

@immutable
class MetricEvaluation<T extends AstNode> {
  final T target;
  final num value;

  MetricEvaluation(this.target, this.value);

  @override
  String toString() => 'MetricEvaluation{target: $target, value: $value}';
}
