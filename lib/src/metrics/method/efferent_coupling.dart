import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:linter/src/metrics/metric.dart';
import 'package:shuttlecock/shuttlecock.dart';

class EfferentCouplingMethodMetric extends MethodMetric {
  EfferentCouplingMethodMetric(
      {IterableMonad<MetricEvaluation<AstNode>> values})
      : super('Method efferent coupling',
            'Count of methods and functions a method depends on.', values);

  @override
  num computation(
      MethodDeclaration target, IterableMonad<CompilationUnit> units) {
    final visitor = new _EfferentCouplingVisitor();
    target.visitChildren(visitor);
    return visitor._invocationsDeclarations.length;
  }

  @override
  EfferentCouplingMethodMetric copy(
          IterableMonad<MetricEvaluation<MethodDeclaration>> values) =>
      new EfferentCouplingMethodMetric(values: values ?? this.values);
}

class _EfferentCouplingVisitor extends SimpleAstVisitor {
  final Set<AstNode> _invocationsDeclarations = new Set<AstNode>();

  @override
  void visitAdjacentStrings(AdjacentStrings node) {
    node.visitChildren(this);
  }

  @override
  void visitAssertStatement(AssertStatement node) {
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
    node.visitChildren(this);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitDeclaredIdentifier(DeclaredIdentifier node) {
    node.visitChildren(this);
  }

  @override
  void visitDoStatement(DoStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitDottedName(DottedName node) {
    node.visitChildren(this);
  }

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {
    node.visitChildren(this);
  }

  @override
  void visitExpressionStatement(ExpressionStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitForEachStatement(ForEachStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitFormalParameterList(FormalParameterList node) {
    node.visitChildren(this);
  }

  @override
  void visitForStatement(ForStatement node) {
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
  void visitFunctionTypeAlias(FunctionTypeAlias node) {
    node.visitChildren(this);
  }

  @override
  void visitFunctionTypedFormalParameter(FunctionTypedFormalParameter node) {
    node.visitChildren(this);
  }

  @override
  void visitIfStatement(IfStatement node) {
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
  void visitMethodDeclaration(MethodDeclaration node) {
    node.visitChildren(this);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    _incrementCounter(node.methodName.bestElement);
    node.visitChildren(this);
  }

  @override
  void visitNamedExpression(NamedExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitParenthesizedExpression(ParenthesizedExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitPostfixExpression(PostfixExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    node.visitChildren(this);
  }

  @override
  void visitPrefixExpression(PrefixExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    _incrementCounter(node.propertyName.bestElement);
    node.visitChildren(this);
  }

  @override
  void visitRedirectingConstructorInvocation(
      RedirectingConstructorInvocation node) {
    node.visitChildren(this);
  }

  @override
  void visitRethrowExpression(RethrowExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitReturnStatement(ReturnStatement node) {
    node.visitChildren(this);
  }

  @override
  void visitSimpleFormalParameter(SimpleFormalParameter node) {
    node.visitChildren(this);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    node.visitChildren(this);
  }

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    node.visitChildren(this);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    node.visitChildren(this);
  }

  @override
  void visitSuperExpression(SuperExpression node) {
    // Count dependencies of the method on the base class.
    node.bestParameterElement?.computeNode()?.accept(this);
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
    node.visitChildren(this);
  }

  @override
  void visitThisExpression(ThisExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    node.visitChildren(this);
  }

  @override
  void visitTryStatement(TryStatement node) {
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
    node.visitChildren(this);
  }

  @override
  void visitYieldStatement(YieldStatement node) {
    node.visitChildren(this);
  }

  void _incrementCounter(Element element) {
    if (element == null) {
      return;
    }

    _invocationsDeclarations.add(element.computeNode());
  }
}
