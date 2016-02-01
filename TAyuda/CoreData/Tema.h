//
//  Tema.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MediaHandler.h"
#import "TAyudaObject.h"

@class Pregunta, Subtema;

NS_ASSUME_NONNULL_BEGIN

@interface Tema : TAyudaObject

+ (Tema *)temaFromAPIObject:(NSDictionary *)apiObject inContext: (NSManagedObjectContext *)context;

+ (Tema *)getTemaWithId:(NSString *)id inContext:(NSManagedObjectContext *)context;

+ (NSArray *)getAllTemasInContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)getFetchedResultsController:(NSManagedObjectContext *)context;

- (BOOL)isEqualToTema:(id)tema;

@end

NS_ASSUME_NONNULL_END

#import "Tema+CoreDataProperties.h"
