/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

class PurityGarbageCollectionReportTransmission extends PurityTransmission implements IPurityGarbageCollectionReportTransmission{}
abstract class IPurityGarbageCollectionReportTransmission{
  Set<PurityModelBase> models;
}