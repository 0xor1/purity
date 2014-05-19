/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class SourceReady extends Transmission implements ISourceReady{}
abstract class ISourceReady{
  Base src;
}