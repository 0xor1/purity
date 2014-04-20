/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

class PurityAppSessionInitialisedTransmission extends PurityTransmission implements IPurityAppSessionInitialisedTransmission{}
abstract class IPurityAppSessionInitialisedTransmission{
  PurityModelBase model;
}