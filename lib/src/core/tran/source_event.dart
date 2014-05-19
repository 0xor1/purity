/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * Transmits [Event]s from [Source]s over to [Proxy]s.
 */
class SourceEvent extends Transmission implements ISourceEvent{}
abstract class ISourceEvent{
  Proxy proxy;
  Transmittable data;
}