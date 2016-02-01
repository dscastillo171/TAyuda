//
//  Tema+CoreDataProperties.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/24/15.
//  Copyright © 2015 tayuda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tema.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tema (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *imagen;
@property (nullable, nonatomic, retain) NSString *imagenHash;
@property (nullable, nonatomic, retain) NSString *nombre;
@property (nullable, nonatomic, retain) NSString *posicion;
@property (nullable, nonatomic, retain) NSNumber *publicado;
@property (nullable, nonatomic, retain) NSSet<Subtema *> *subtemas;

@end

@interface Tema (CoreDataGeneratedAccessors)

- (void)addSubtemasObject:(Subtema *)value;
- (void)removeSubtemasObject:(Subtema *)value;
- (void)addSubtemas:(NSSet<Subtema *> *)values;
- (void)removeSubtemas:(NSSet<Subtema *> *)values;

@end

NS_ASSUME_NONNULL_END
