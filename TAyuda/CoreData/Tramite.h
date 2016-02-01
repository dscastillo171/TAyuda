//
//  Tramite.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TAyudaObject.h"

@class Pregunta;
@class Lugar;

NS_ASSUME_NONNULL_BEGIN

@interface Tramite : TAyudaObject

+ (Tramite *)tramiteFromAPIObject:(NSDictionary *)apiObject inContext: (NSManagedObjectContext *)context;

+ (Tramite *)getTramiteWithId:(NSString *)id inContext:(NSManagedObjectContext *)context;

+ (NSArray *)getAllTramitesInContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)getFetchedResultsControllerInContext:(NSManagedObjectContext *)context;

- (BOOL)isEqualToTramite:(id)tramite;

@end

NS_ASSUME_NONNULL_END

#import "Tramite+CoreDataProperties.h"
