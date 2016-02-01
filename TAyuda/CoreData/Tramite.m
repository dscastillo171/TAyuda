//
//  Tramite.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "Tramite.h"

@implementation Tramite

+ (Tramite *)tramiteFromAPIObject:(NSDictionary *)apiObject inContext: (NSManagedObjectContext *)context{
    NSString *id = [[apiObject objectForKey:@"id"] stringValue];
    NSString *nombre = [apiObject objectForKey:@"nombre"];
    NSString *posicion = [[apiObject objectForKey:@"posicion"] stringValue];
    NSString *descripcion = [apiObject objectForKey:@"descripcion"];
    NSString *enLinea = [apiObject objectForKey:@"comentario_es_en_linea"];
    NSString *esGratuito = [apiObject objectForKey:@"comentario_es_gratuito"];
    NSString *documentos = [apiObject objectForKey:@"documentosYRequisitos"];
    NSString *direccion = [apiObject objectForKey:@"direccionGeneral"];
    
    Tramite *tramite = [Tramite getTramiteWithId:id inContext:context];
    if(id && nombre){
        if(!tramite){
            tramite = (Tramite *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Tramite class]) inManagedObjectContext:context];
            [tramite setUp];
            tramite.id = id;
        }
        if(!tramite.nombre || ![tramite.nombre isEqualToString:nombre]){
            tramite.nombre = nombre;
        }
        if(!tramite.texto || (descripcion && ![tramite.texto isEqualToString:descripcion])){
            tramite.texto = descripcion;
        }
        if(!tramite.posicion || (posicion && ![tramite.posicion isEqualToString:posicion])){
            tramite.posicion = posicion;
        }
        if(!tramite.linea || (enLinea && ![tramite.linea isEqualToString:enLinea])){
            tramite.linea = enLinea;
        }
        if(!tramite.gratuito || (esGratuito && ![tramite.gratuito isEqualToString:esGratuito])){
            tramite.gratuito = esGratuito;
        }
        if(!tramite.documentos || (documentos && ![tramite.documentos isEqualToString:documentos])){
            tramite.documentos = documentos;
        }
        if(!tramite.direccion || (direccion && ![tramite.direccion isEqualToString:direccion])){
            tramite.direccion = direccion;
        }
    }
    return tramite;
}

+ (Tramite *)getTramiteWithId:(NSString *)id inContext:(NSManagedObjectContext *)context{
    Tramite *tramite;
    if(id){
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Tramite class])];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES && id == %@", id];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setFetchLimit:1];
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        if(!error){
            tramite = [result firstObject];
        } else{
            NSLog(@"Error fetching object: %@", error);
        }
    }
    return tramite;
}

+ (NSArray *)getAllTramitesInContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Tramite class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"Error fetching object: %@", error);
    }
    return  result;
}

+ (NSFetchedResultsController *)getFetchedResultsControllerInContext:(NSManagedObjectContext *)context{
    NSString *cacheName = @"com.tayuda.tramites";
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Tramite class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES"];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"posicion" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    [NSFetchedResultsController deleteCacheWithName:cacheName];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:cacheName];
    
    NSError *error = nil;
    if(![controller performFetch:&error]){
        controller = nil;
        NSLog(@"Error creating a fetched results controller for Tramites. %@", error);
    }
    
    return controller;
}

- (BOOL)isEqualToTramite:(id)tramite{
    BOOL result = false;
    if([tramite isKindOfClass:[Tramite class]] && [((Tramite *)tramite).id isEqualToString:self.id]){
        result = true;
    }
    return result;
}

- (BOOL)isEqualToTAyudaObject:(id)object{
    return [object isKindOfClass:[Tramite class]] && [self.id isEqualToString:[object id]];
}

@end
