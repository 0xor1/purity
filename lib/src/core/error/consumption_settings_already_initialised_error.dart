/**
 * Author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class ConsumptionSettingsAlreadyInitialisedError{
  String get message => 'Consumption settings may only be initialised once.';
}