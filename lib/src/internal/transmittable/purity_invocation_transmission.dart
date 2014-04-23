/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

class PurityInvocationTransmission extends PurityTransmission implements IPurityInvocationTransmission{}
abstract class IPurityInvocationTransmission{
  PurityClientModel model;
  Symbol method;
  List<dynamic> posArgs;
  Map<Symbol, dynamic> namArgs;
}