/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Internal;

class SessionInitialisedTransmission extends Transmittable implements ISessionInitialisedTransmission{}
abstract class ISessionInitialisedTransmission{
  ClientModel model;
}