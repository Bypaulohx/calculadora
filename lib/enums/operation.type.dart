enum OperationType {
  addition('+'),
  subtraction('-'),
  multiplication('x'),
  division('÷');

  final String symbol;
  const OperationType(this.symbol);
}