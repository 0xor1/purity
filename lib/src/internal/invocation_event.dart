/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Internal;

class InvocationEvent extends Event implements IInvocationEvent{}
abstract class IInvocationEvent{
  Symbol method;
  List<dynamic> positionalArguments;
  Map<Symbol, dynamic> namedArguments;
}