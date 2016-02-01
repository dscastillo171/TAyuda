//
//  Lugar+CoreDataProperties.h
//  TAyuda
//
//  Created by Santiago Castillo on 1/31/16.
//  Copyright © 2016 tayuda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Lugar.h"

NS_ASSUME_NONNULL_BEGIN

@interface Lugar (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *nombre;
@property (nullable, nonatomic, retain) NSString *direccion;
@property (nullable, nonatomic, retain) NSString *ciudad;
@property (nullable, nonatomic, retain) NSSet<Tramite *> *tramites;

@end

@interface Lugar (CoreDataGeneratedAccessors)

- (void)addTramitesObject:(Tramite *)value;
- (void)removeTramitesObject:(Tramite *)value;
- (void)addTramites:(NSSet<Tramite *> *)values;
- (void)removeTramites:(NSSet<Tramite *> *)values;

@end

NS_ASSUME_NONNULL_END
