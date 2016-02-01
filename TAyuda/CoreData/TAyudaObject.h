//
//  TAyudaObject.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/24/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAyudaObject : NSManagedObject

- (void)setUp;

- (BOOL)isEqualToTAyudaObject:(id)object;

+ (void)deleteIrelevantObjectsInContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "TAyudaObject+CoreDataProperties.h"
