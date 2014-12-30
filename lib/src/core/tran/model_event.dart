/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _ModelEvent extends _Transmission{
  Model get model => get('model');
  void set model (Model o){set('model', o);}
  EventData get eventData => get('eventData');
  void set eventData (EventData o){set('eventData', o);}
}