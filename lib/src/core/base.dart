/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * The base class for [Source] and [_Proxy] objects.
 *
 * The [_Base] gives each of it's subtypes a unique ID within
 * the purity framework so [_ProxyInvocation]s and [Event]s can be
 * routed to their [Source] or [_Proxy] on the connected [_EndPoint] respectively.
 */
abstract class _Base extends Object with Emitter, Receiver{
  final ObjectId _purityId;
  _Base(this._purityId);
  int get hashCode => _purityId.hashCode;
  bool operator ==(other) => other is _Base && _purityId == other._purityId;
}
