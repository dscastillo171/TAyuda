//
//  Subtema+CoreDataProperties.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/24/15.
//  Copyright © 2015 tayuda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Subtema.h"

NS_ASSUME_NONNULL_BEGIN

@interface Subtema (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *imagen;
@property (nullable, nonatomic, retain) NSString *nombre;
@property (nullable, nonatomic, retain) NSString *posicion;
@property (nullable, nonatomic, retain) NSNumber *publicado;
@property (nullable, nonatomic, retain) NSSet<Pregunta *> *preguntas;
@property (nullable, nonatomic, retain) Tema *tema;

@end

@interface Subtema (CoreDataGeneratedAccessors)

- (void)addPreguntasObject:(Pregunta *)value;
- (void)removePreguntasObject:(Pregunta *)value;
- (void)addPreguntas:(NSSet<Pregunta *> *)values;
- (void)removePreguntas:(NSSet<Pregunta *> *)values;

@end

NS_ASSUME_NONNULL_END
