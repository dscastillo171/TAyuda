//
//  Pregunta.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TAyudaObject.h"

@class Subtema, Tramite;

NS_ASSUME_NONNULL_BEGIN

@interface Pregunta : TAyudaObject

+ (Pregunta *)preguntaFromApiObject:(NSDictionary *)apiObject inContext:(NSManagedObjectContext *)context;

+ (NSArray *)getAllPreguntasForSubtema:(Subtema *)subtema inContext:(NSManagedObjectContext *)context;

+ (NSArray *)getAllPreguntasForTramite:(Tramite *)tramite inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Pregunta+CoreDataProperties.h"
