/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class PurityLib extends TranLib{
  const PurityLib(String fullNamespace, String shortNamespace): super(fullNamespace, shortNamespace);
}

class PurityType extends TranCodec{
  const PurityType(String identifier, TranEncode encode, TranDecode decode): super(identifier, encode, decode);
}

class PurityEventData extends TranSubtype{
  const PurityEventData(identifier, EventDataConstructor constructor):super(identifier, constructor);
}

typedef EventData EventDataConstructor();

class PurityModel{
  final String identifier;
  final ModelConstructor constructor;
  const PurityModel(this.identifier, this.constructor);
}

typedef Model ModelConstructor();

class PurityMethod{
  final String identifier;
  final Map<String, Symbol> namArgs;
  const PurityMethod(this.identifier, [this.namArgs = null]);
}

class _TypeWithPurityMeta<T>{
  final Type type;
  final T purityMeta;
  const _TypeWithPurityMeta(this.type, this.purityMeta);
}

// this overrides the default registration behaviour in the transmittable/lib/src/annotation.dart file.
// this is done purely to allow the PurityModel annotation to just require a Constructor function, this
// then wraps it inside a TranCodec registration, so it can handle serializing the _purityId without
// exposing it as a public value.
// TODO, This method also creates a map of Types and their PurityMethods.
bool _purityRegistrationsInitialised = false;
void _initPurityRegistrations(){

  if(_purityRegistrationsInitialised) return;
  _purityRegistrationsInitialised = true;

  _registerPurityCoreTranTypes();

  //get all libs labeled as TranLibs
  var purityLibs = new Map<LibraryMirror, PurityLib>();
  var libs = currentMirrorSystem().libraries;

  libs.forEach((uri, lib){

   lib.metadata.forEach((metaMirror){

     var meta = metaMirror.reflectee;
     if(meta.runtimeType == PurityLib){
       purityLibs[lib] = meta;
     }

   });

  });

  purityLibs.forEach((lib, purityLib){
   var codecs = new Map<String, _TypeWithPurityMeta<PurityType>>();
   var subtypes = new Map<String, _TypeWithPurityMeta<PurityEventData>>();

   lib.declarations.forEach((symbol, dec){
     if(dec is! ClassMirror) return;

     dec.metadata.forEach((metaMirror){

       var meta = metaMirror.reflectee;
       if(meta.runtimeType == PurityEventData){

         if(subtypes.containsKey(meta.identifier))
           throw new DuplicatedPurityModelIdentifierError(purityLib.fullNamespace, meta.identifier);
         subtypes[meta.identifier] = new _TypeWithPurityMeta(dec.reflectedType, meta);

       }else if(meta.runtimeType == PurityType){

         if(codecs.containsKey(meta.identifier))
           throw new DuplicatedPurityModelIdentifierError(purityLib.fullNamespace, meta.identifier);
         codecs[meta.identifier] = new _TypeWithPurityMeta(dec.reflectedType, meta);

       }else if(meta.runtimeType == PurityModel){

         if(codecs.containsKey(meta.identifier))
           throw new DuplicatedPurityModelIdentifierError(purityLib.fullNamespace, meta.identifier);
         codecs[meta.identifier] = new _TypeWithPurityMeta(dec.reflectedType, new PurityType(meta.identifier, _processModelToString, _generateProcessStringToModel(meta.constructor)));
         _registerPurityMethods(dec);

       }

     });
   });

   var sortedCodecIds = codecs.keys.toList()..sort((a, b) => a.compareTo(b));
   var sortedSubtypeIds = subtypes.keys.toList()..sort((a, b) => a.compareTo(b));
   var regs = new List<TranRegistration>();

   for(var i = 0; i < sortedCodecIds.length; i++){
     var typeWithMeta = codecs[sortedCodecIds[i]];
     regs.add(new TranRegistration.codec(typeWithMeta.type, typeWithMeta.purityMeta.encode, typeWithMeta.purityMeta.decode));
   }

   for(var i = 0; i < sortedSubtypeIds.length; i++){
     var typeWithMeta = subtypes[sortedSubtypeIds[i]];
     regs.add(new TranRegistration.subtype(typeWithMeta.type, typeWithMeta.purityMeta.constructor));
   }

   var registrar = generateRegistrar(purityLib.fullNamespace, purityLib.shortNamespace, regs);
   registrar();
  });
}

String _processModelToString(Model m) => m._purityId.toHexString();

TranDecode _generateProcessStringToModel(ModelConstructor constructor) => (String s) => constructor().._purityId = new ObjectId.fromHexString(s) .._isProxy = true;

final Map<Type, Map<String, _MethodInvocationInfo>> _invocationInfoMapping = new Map<Type, Map<String, _MethodInvocationInfo>>();

class _MethodInvocationInfo{
  final Symbol methodName;
  final Map<String, Symbol> namArgs;
  const _MethodInvocationInfo(this.methodName, [this.namArgs = null]);
}

void _registerPurityMethods(ClassMirror classMirror){

  if(_invocationInfoMapping.containsKey(classMirror.reflectedType)) return;

  var superClass = classMirror.superclass;
  if(superClass.reflectedType != Model){
    _registerPurityMethods(superClass);
  }


  var methodMap = _invocationInfoMapping[classMirror.reflectedType] = new Map<String, _MethodInvocationInfo>();

  var parentMapping = _invocationInfoMapping[superClass.reflectedType];
  if(parentMapping != null){
    parentMapping.forEach((key, invoInfo){
      methodMap[key] = invoInfo;
    });
  }

  classMirror.declarations.forEach((symbol, memberDec){

    if(memberDec is! MethodMirror || memberDec.isRegularMethod == false) return;

    memberDec.metadata.forEach((metaMirror){
      if(metaMirror.reflectee.runtimeType == PurityMethod){
        PurityMethod meta = metaMirror.reflectee;
        if(methodMap.containsKey(meta.identifier))
          throw new DuplicatedPurityMethodIdentifierError(classMirror.reflectedType, meta.identifier);
        methodMap[meta.identifier] = new _MethodInvocationInfo(memberDec.simpleName, meta.namArgs);
      }
    });
  });
}