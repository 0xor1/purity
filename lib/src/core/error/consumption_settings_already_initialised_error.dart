/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * Thrown if [initConsumerSettings] is called more than once.
 */
class ConsumerSettingsAlreadyInitialisedError{
  String get message => 'Consumer settings may only be initialised once.';
}