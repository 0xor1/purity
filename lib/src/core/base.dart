/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * The base class for [Source] and [Proxy] objects.
 *
 * The [Base] gives each of it's subtypes a unique ID within
 * the purity framework so [ProxyInvocation]s and [Event]s can be
 * routed to their [Source] or [Proxy] on the connected [EndPoint] respectively.
 */
abstract class Base extends Object with EventEmitter, EventDetector{
  final ObjectId purityId;
  Base(this.purityId);
  int get hashCode => purityId.hashCode;
  bool operator ==(other) => other is Base && purityId == other.purityId;
}
