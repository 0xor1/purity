/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityClient;

abstract class PurityView extends PurityModelConsumer implements Control{

  
  PurityView(PurityModelBase model):super(model){
    
  }

}