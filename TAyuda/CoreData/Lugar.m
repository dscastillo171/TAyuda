//
//  Lugar.m
//  TAyuda
//
//  Created by Santiago Castillo on 1/30/16.
//  Copyright © 2016 tayuda. All rights reserved.
//

#import "Lugar.h"
#import "Tramite.h"

@implementation Lugar

+ (Lugar *)lugarFromAPIObject:(NSDictionary *)apiObject inContext: (NSManagedObjectContext *)context{
    NSString *id = [[apiObject objectForKey:@"id"] stringValue];
    NSString *nombre = [apiObject objectForKey:@"nombre"];
    NSString *ciudad = [apiObject objectForKey:@"ciudad"];
    NSString *direccion = [apiObject objectForKey:@"direccion"];
    
    Lugar *lugar = [Lugar getLugarWithId:id inContext:context];
    if(id && nombre && ciudad && direccion){
        if(!lugar){
            lugar = (Lugar *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Lugar class]) inManagedObjectContext:context];
            [lugar setUp];
            lugar.id = id;
        }
        if(!lugar.nombre || ![lugar.nombre isEqualToString:nombre]){
            lugar.nombre = nombre;
        }
        if(!lugar.ciudad || ![lugar.ciudad isEqualToString:ciudad]){
            lugar.ciudad = ciudad;
        }
        if(!lugar.direccion || ![lugar.direccion isEqualToString:direccion]){
            lugar.direccion = direccion;
        }
    }
    return lugar;
}

+ (Lugar *)getLugarWithId:(NSString *)id inContext:(NSManagedObjectContext *)context{
    Lugar *lugar;
    if(id){
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Lugar class])];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES && id == %@", id];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setFetchLimit:1];
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        if(!error){
            lugar = [result firstObject];
        } else{
            NSLog(@"Error fetching object: %@", error);
        }
    }
    return lugar;
}

- (BOOL)isEqualToTAyudaObject:(id)object{
    return [object isKindOfClass:[Lugar class]] && [self.id isEqualToString:[object id]];
}

@end
