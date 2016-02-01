//
//  Lugar.h
//  TAyuda
//
//  Created by Santiago Castillo on 1/30/16.
//  Copyright © 2016 tayuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TAyudaObject.h"

@class Tramite;

NS_ASSUME_NONNULL_BEGIN

@interface Lugar : TAyudaObject

+ (Lugar *)getLugarWithId:(NSString *)id inContext:(NSManagedObjectContext *)context;

+ (Lugar *)lugarFromAPIObject:(NSDictionary *)apiObject inContext: (NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Lugar+CoreDataProperties.h"
