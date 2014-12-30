/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/// Thrown if set or clear is called on an [EventData] after it's been locked.
class EventDataLockedError extends Error{
  String get message => 'EventData is locked making write changes is illegal.';
}