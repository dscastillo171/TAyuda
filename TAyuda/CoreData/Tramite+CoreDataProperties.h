//
//  Tramite+CoreDataProperties.h
//  TAyuda
//
//  Created by Santiago Castillo on 1/31/16.
//  Copyright © 2016 tayuda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tramite.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tramite (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *nombre;
@property (nullable, nonatomic, retain) NSString *texto;
@property (nullable, nonatomic, retain) NSString *posicion;
@property (nullable, nonatomic, retain) NSString *linea;
@property (nullable, nonatomic, retain) NSString *gratuito;
@property (nullable, nonatomic, retain) NSString *documentos;
@property (nullable, nonatomic, retain) NSString *direccion;
@property (nullable, nonatomic, retain) NSSet<Pregunta *> *preguntas;
@property (nullable, nonatomic, retain) NSSet<Lugar *> *lugares;

@end

@interface Tramite (CoreDataGeneratedAccessors)

- (void)addPreguntasObject:(Pregunta *)value;
- (void)removePreguntasObject:(Pregunta *)value;
- (void)addPreguntas:(NSSet<Pregunta *> *)values;
- (void)removePreguntas:(NSSet<Pregunta *> *)values;

- (void)addLugaresObject:(Lugar *)value;
- (void)removeLugaresObject:(Lugar *)value;
- (void)addLugares:(NSSet<Lugar *> *)values;
- (void)removeLugares:(NSSet<Lugar *> *)values;

@end

NS_ASSUME_NONNULL_END
