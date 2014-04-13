/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

class PurityAppSessionInitialisedTransmission extends PurityTransmission implements IPurityAppSessionInitialisedTransmission{}
abstract class IPurityAppSessionInitialisedTransmission{
  PurityModelBase model;
}