/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.local;

/// Thrown if [initConsumerSettings] is called more than once.
class ConsumerSettingsUninitialisedError extends Error{
  String get message => 'initConsumerSettings must be called before a local Host can begin creating endpoint pairs.';
}