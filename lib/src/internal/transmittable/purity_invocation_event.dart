/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

class PurityInvocationEvent extends PurityEvent implements IPurityInvocationEvent{}
abstract class IPurityInvocationEvent{
  Symbol method;
  List<dynamic> positionalArguments;
  Map<Symbol, dynamic> namedArguments;
}