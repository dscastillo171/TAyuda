//
//  TAyudaObject.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/24/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "TAyudaObject.h"

@implementation TAyudaObject

- (void)setUp{
    self.relevant = [NSNumber numberWithBool:YES];
}

- (BOOL)isEqualToTAyudaObject:(id)object{
    return YES;
}

+ (void)deleteIrelevantObjectsInContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([TAyudaObject class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == NO"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if(!error){
        for(NSManagedObject *object in result){
            [context deleteObject:object];
        }
    }
    [context save:nil];
}

@end
