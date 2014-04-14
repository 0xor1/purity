/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityClient;

abstract class PurityView extends PurityModelConsumer implements Control{

  /**
   * Can drop this decorator pattern when mixins can use classes that don't inherit from Object
   * then just use:
   *  
   *   class PurityView extends PurityModelConsumer with Control
   *
   */
  Control _controlInternal;
  DivElement get html => _controlInternal.html;
  int get controlId => _controlInternal.controlId;
  String get id => _controlInternal.id;
  void set id(String s){ _controlInternal.id = s; }
  void focus() => _controlInternal.focus();
  void blur() => _controlInternal.blur();
  bool get isStaged => _controlInternal.isStaged;
  bool isOnPage() => _controlInternal.isOnPage();
  void stage() => _controlInternal.stage();
  bool get hasFocus => _controlInternal.hasFocus;
  CssStyleDeclaration get style => _controlInternal.style;
  Stream<Control> get onFocus => _controlInternal.onFocus;
  Stream<Control> get onBlur => _controlInternal.onBlur;
  
  
  PurityView(PurityModelBase model):super(model){
    _controlInternal = new _PurityViewControl();
  }
}