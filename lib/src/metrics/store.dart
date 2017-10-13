import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:linter/src/metrics/method/assignment_count.dart';
import 'package:linter/src/metrics/method/cyclomatic_complexity.dart';
import 'package:linter/src/metrics/method/efferent_coupling.dart';
import 'package:linter/src/metrics/method/free_variable_mutation_count.dart';
import 'package:linter/src/metrics/method/mutable_variable_count.dart';
import 'package:linter/src/metrics/method/nesting_depth.dart';
import 'package:linter/src/metrics/method/optional_parameter_count.dart';
import 'package:linter/src/metrics/method/parameter_count.dart';
import 'package:linter/src/metrics/method/statement_count.dart';
import 'package:linter/src/metrics/method/variable_count.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:linter/src/util/dart_type_utilities.dart';
import 'package:meta/meta.dart';
import 'package:shuttlecock/shuttlecock.dart';

class MetricsStore extends Store<ProjectReport> {
  final StreamController<EndoFunction<ProjectReport>> _controller;

  factory MetricsStore() {
    final controller =
        new StreamController<EndoFunction<ProjectReport>>.broadcast();
    return new MetricsStore._(controller);
  }

  MetricsStore._(this._controller)
      : super(
            new ProjectReport(),
            new IterableMonad.fromIterable(
                [new StreamMonad(_controller.stream)]));

  void addCompilationUnit(CompilationUnit unit) {
    _controller.add((report) => DartTypeUtilities
        .traverseNodesInDFS(unit)
        .where((n) => n is MethodDeclaration)
        .fold(report, (r, m) => r.addMethod(m))
        .addCompilationUnit(unit));
  }

  void compute() {
    _controller.add((report) => report.compute());
  }
}

@immutable
class ProjectReport {
  final IterableMonad<CompilationUnit> _units;
  final Report<MethodDeclaration> _methodsReport;

  ProjectReport(
      {IterableMonad<MethodDeclaration> methods,
      IterableMonad<CompilationUnit> compilationUnits,
      Report<MethodDeclaration> methodsReport})
      : _methodsReport = methodsReport ??
            new Report<MethodDeclaration>(
                methods ?? new Set(),
                [
                  new AssignmentCountMethodMetric(),
                  new CyclomaticComplexityMethodMetric(),
                  new EfferentCouplingMethodMetric(),
                  new FreeVariableMutationCountMethodMetric(),
                  new MutableVariableCountMethodMetric(),
                  new NestingDepthMethodMetric(),
                  new OptionalParameterCountMethodMetric(),
                  new ParameterCountMethodMetric(),
                  new StatementCountMethodMetric(),
                  new VariableCountMethodMetric(),
                ].toSet(),
                compilationUnits ?? new IterableMonad<CompilationUnit>()),
        _units = compilationUnits ??
            new IterableMonad.fromIterable(new Set<CompilationUnit>());

  Report<MethodDeclaration> get methodsReport => _methodsReport;

  IterableMonad<CompilationUnit> get units => _units;

  ProjectReport addCompilationUnit(CompilationUnit unit) {
    final newUnits = new IterableMonad.fromIterable(_units.toSet()..add(unit));
    return copy(compilationUnits: newUnits);
  }

  ProjectReport addMethod(MethodDeclaration method) => copy(
      methodsReport: _methodsReport.copy(
          targets: _methodsReport.targets.toSet()..add(method)));

  ProjectReport compute() => copy(methodsReport: _methodsReport.compute());

  ProjectReport copy(
          {IterableMonad<CompilationUnit> compilationUnits,
          Report<MethodDeclaration> methodsReport}) =>
      new ProjectReport(
          compilationUnits: compilationUnits ?? _units,
          methodsReport: methodsReport ?? _methodsReport);

  @override
  String toString() => 'ProjectReport{_methodsReport: $_methodsReport}';
}

@immutable
class Report<T extends AstNode> {
  final IterableMonad<T> targets;
  final IterableMonad<Metric<T>> _metrics;
  final IterableMonad<CompilationUnit> _units;

  Report(Set<T> targets, Set<Metric<T>> metrics,
      IterableMonad<CompilationUnit> units)
      : this.targets = new IterableMonad.fromIterable(targets),
        this._metrics = new IterableMonad.fromIterable(metrics),
        this._units = units;

  IterableMonad<Metric<T>> get metrics => _metrics;

  Report<T> compute() => copy(
      metrics:
          _metrics.map((metric) => metric.evaluate(targets, _units)).toSet());

  Report<T> copy(
          {Set<T> targets,
          Set<Metric<T>> metrics,
          IterableMonad<CompilationUnit> units}) =>
      new Report(targets ?? this.targets.toSet(), metrics ?? _metrics.toSet(),
          units ?? _units);

  @override
  String toString() {
    StringBuffer buffer =
        new StringBuffer('Report{level: ${targets.first.runtimeType}'
            '\n_metrics:\n');
    _metrics.forEach((metric) {
      buffer.writeln('\t$metric');
    });
    buffer.write('\n}');
    return buffer.toString();
  }
}
