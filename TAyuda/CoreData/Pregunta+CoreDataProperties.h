//
//  Pregunta+CoreDataProperties.h
//  TAyuda
//
//  Created by Santiago Castillo on 1/30/16.
//  Copyright © 2016 tayuda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Pregunta.h"

NS_ASSUME_NONNULL_BEGIN

@interface Pregunta (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *enlaceExterno;
@property (nullable, nonatomic, retain) NSString *posicion;
@property (nullable, nonatomic, retain) NSString *pregunta;
@property (nullable, nonatomic, retain) NSString *respuesta;
@property (nullable, nonatomic, retain) Subtema *subtema;
@property (nullable, nonatomic, retain) Tramite *tramite;

@end

NS_ASSUME_NONNULL_END
