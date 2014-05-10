/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * Emitted by [SourceEndPoint]s if the [Host] creating the [SourceEndPoint]s was constructed with verbose = true.
 */
class EndPointMessageEvent extends Event implements IEndPointMessageEvent{}
abstract class IEndPointMessageEvent{
  String endPointName;
  bool isProxyToSource;
  String message;
}