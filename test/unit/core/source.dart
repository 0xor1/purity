/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core.test;

void _runSourceTests(){

  group('source:', (){

    test('it is not possible to invoke any memebers of EventEmiiter / EventDetector / Source.', (){
      var restrictedSet = new Set<Symbol>();
      restrictedSet.addAll(reflectClass(EventDetector).instanceMembers.keys);
      restrictedSet.addAll(reflectClass(EventEmitter).instanceMembers.keys);
      restrictedSet.addAll(reflectClass(Source).instanceMembers.keys);
      var src = new Source();
      restrictedSet.forEach((symbol){
        expect(() => src.invoke(new ProxyInvocation()..method = symbol), throwsA(new isInstanceOf<RestrictedMethodError>()));
      });
    });

    test('when events are emitted the data becomes locked', (){
      Source src = new Source();
      Event<Transmittable> caughtEvent = null;
      src.addEventAction(Transmittable, (Event<Transmittable> event){
        caughtEvent = event;
      });
      src.emitEvent(new Transmittable()..pi = 3.142);
      Timer.run(expectAsync(() => expect(() => caughtEvent.data.pi = 2.178, throwsA(new isInstanceOf<TransmittableLockedError>()))));
    });

  });

}