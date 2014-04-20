/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

class PurityInvocationEvent extends PurityEvent implements IPurityInvocationEvent{}
abstract class IPurityInvocationEvent{
  Symbol method;
  List<dynamic> posArgs;
  Map<Symbol, dynamic> namArgs;
}