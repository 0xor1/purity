/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityClient;

/**
 * this class can be deleted when mixins can come from classes that don't extend off of object
 */

class _PurityViewControl extends Control{
  
  static const String CLASS = 'purity-view-control';
  
  _PurityViewControl(){
    _purityViewControlStyle.insert();
    html.classes.add(CLASS);
  }
  
  static final _purityViewControlStyle = new Style('''

    .$CLASS
    {
    }

  ''');
}