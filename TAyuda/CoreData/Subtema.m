//
//  Subtema.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "Subtema.h"
#import "Tema.h"

@implementation Subtema

+ (Subtema *)subtemaFromAPIObject:(NSDictionary *)apiObject tema:(Tema *)tema inContext: (NSManagedObjectContext *)context{
    NSString *id = [[apiObject objectForKey:@"id"] stringValue];
    NSString *nombre = [apiObject objectForKey:@"nombre"];
    NSNumber *publicado = [NSNumber numberWithInt:1]; //[apiObject objectForKey:@"publicado"];
    NSString *posicion = [[apiObject objectForKey:@"posicion"] stringValue];
    
    Subtema *subtema = [Subtema getSubtemaWithId:id tema:tema inContext:context];
    if(id && nombre && publicado){
        if(!subtema){
            subtema = (Subtema *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Subtema class]) inManagedObjectContext:context];
            [subtema setUp];
            subtema.id = id;
            subtema.tema = tema;
        }
        if(!subtema.nombre || ![subtema.nombre isEqualToString:nombre]){
            subtema.nombre = nombre;
        }
        if(!subtema.publicado || ![subtema.publicado isEqualToNumber:publicado]){
            subtema.publicado = publicado;
        }
        if(!subtema.posicion || (posicion && ![subtema.posicion isEqualToString:posicion])){
            subtema.posicion = posicion;
        }
    }
    return subtema;
}

+ (Subtema *)getSubtemaWithId:(NSString *)id tema:(Tema *)tema inContext:(NSManagedObjectContext *)context{
    Subtema *subtema;
    if(id && tema){
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Subtema class])];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES && tema == %@ && id == %@", tema, id];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setFetchLimit:1];
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        if(!error){
            subtema = [result firstObject];
        } else{
            NSLog(@"Error fetching object: %@", error);
        }
    }
    return subtema;
}

+ (NSArray *)getAllSubtemasForTema:(Tema *)tema inContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Subtema class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES && tema == %@", tema];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"Error fetching object: %@", error);
    }
    return  result;
}

+ (NSFetchedResultsController *)getFetchedResultsControllerForTema:(Tema *)tema inContext:(NSManagedObjectContext *)context{
    NSString *cacheName = [@"com.tayuda.subtemas." stringByAppendingString:tema.id];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Subtema class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES && publicado == YES && tema == %@", tema];
    fetchRequest.predicate = predicate;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"posicion" ascending:YES];
    NSSortDescriptor *secondarysSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor, secondarysSortDescriptor];
    
    [NSFetchedResultsController deleteCacheWithName:cacheName];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:cacheName];
    
    NSError *error = nil;
    if(![controller performFetch:&error]){
        controller = nil;
        NSLog(@"Error creating a fetched results controller for Subtemas. %@", error);
    }
    
    return controller;
}

- (BOOL)isEqualToSubtema:(id)subtema{
    BOOL result = false;
    if([subtema isKindOfClass:[Subtema class]] && [((Subtema *)subtema).id isEqualToString:self.id]){
        result = true;
    }
    return result;
}

- (BOOL)isEqualToTAyudaObject:(id)object{
    return [object isKindOfClass:[Subtema class]] && [self.id isEqualToString:[object id]];
}

@end
