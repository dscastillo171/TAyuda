//
//  Subtema.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TAyudaObject.h"

@class Tema, Pregunta;

NS_ASSUME_NONNULL_BEGIN

@interface Subtema : TAyudaObject

+ (Subtema *)subtemaFromAPIObject:(NSDictionary *)apiObject tema:(Tema *)tema inContext: (NSManagedObjectContext *)context;

+ (Subtema *)getSubtemaWithId:(NSString *)id tema:(Tema *)tema inContext:(NSManagedObjectContext *)context;

+ (NSArray *)getAllSubtemasForTema:(Tema *)tema inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)getFetchedResultsControllerForTema:(Tema *)tema inContext:(NSManagedObjectContext *)context;

- (BOOL)isEqualToSubtema:(id)subtema;

@end

NS_ASSUME_NONNULL_END

#import "Subtema+CoreDataProperties.h"
