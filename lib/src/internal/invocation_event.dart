/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Internal;

class InvocationEvent extends Event implements IInvocationEvent{}
abstract class IInvocationEvent{
  String method;
  List<dynamic> positionalArguments;
  Map<String, dynamic> namedArguments;
}