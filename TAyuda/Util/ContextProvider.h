//
//  ContextProvider.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/16/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol ContextProviderDelegate;

@interface ContextProvider : NSObject
// Root managed object context.
@property (strong, nonatomic, readonly) NSManagedObjectContext *privateContext;
// Main managed object context.
@property (strong, nonatomic, readonly) NSManagedObjectContext *mainContext;
@end
