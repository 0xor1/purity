/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * Thrown if [EndPoint.open] is called more than once.
 */
class EndPointAlreadyOpenError{
  String get message => 'EndPoints can only be opened once.';
  final EndPoint endPoint;
  const EndPointAlreadyOpenError(this.endPoint);
}