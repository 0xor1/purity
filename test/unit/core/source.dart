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

  });

}