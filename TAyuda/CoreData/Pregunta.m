//
//  Pregunta.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "Pregunta.h"
#import "Tema.h"
#import "Subtema.h"
#import "Tramite.h"

@implementation Pregunta

+ (Pregunta *)preguntaFromApiObject:(NSDictionary *)apiObject inContext:(NSManagedObjectContext *)context{
    NSString *pregunta = [apiObject objectForKey:@"pregunta"];
    NSString *respuesta = [apiObject objectForKey:@"respuesta"];
    NSString *enlaceExterno = [apiObject objectForKey:@"enlaceExterno"];
    NSDictionary *tramite = [apiObject objectForKey:@"tramite"];
    NSString *tramiteId = ![tramite isKindOfClass:[NSNull class]]? [[tramite objectForKey:@"id"] stringValue ]: nil;
    NSDictionary *tema = [apiObject objectForKey:@"tema"];
    NSString *temaId = ![tema isKindOfClass:[NSNull class]]? [[tema objectForKey:@"id"] stringValue ]: nil;
    NSDictionary *subtema = [apiObject objectForKey:@"subtema"];
    NSString *subtemaId = ![subtema isKindOfClass:[NSNull class]]? [[subtema objectForKey:@"id"] stringValue ]: nil;
    
    Pregunta *result = [Pregunta getPregunta:pregunta inContext:context];
    if(pregunta && respuesta){
        if(!result){
            result = (Pregunta *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Pregunta class]) inManagedObjectContext:context];
            result.pregunta = pregunta;
            [result setUp];
        }
        if(!result.respuesta || ![result.respuesta isEqualToString:respuesta]){
            result.respuesta = respuesta;
        }
        if(!result.enlaceExterno || (enlaceExterno && ![result.enlaceExterno isEqualToString:enlaceExterno])){
            result.enlaceExterno = enlaceExterno;
        }
        if(tramiteId){
            Tramite *tramite = [Tramite getTramiteWithId:tramiteId inContext:context];
            if(tramite && (!result.tramite || ![result.tramite isEqualToTramite:tramite])){
                result.tramite = tramite;
            }
        }
        if(temaId && subtemaId){
            Tema *tema = [Tema getTemaWithId:temaId inContext:context];
            Subtema *subtema = [Subtema getSubtemaWithId:subtemaId tema:tema inContext:context];
            if(tema && subtema && (!result.subtema || ![result.subtema isEqualToSubtema:subtema])){
                result.subtema = subtema;
            }
        }
    }
    return result;
}

+ (Pregunta *)getPregunta:(NSString *)pregunta inContext:(NSManagedObjectContext *)context{
    Pregunta *result;
    if(pregunta){
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Pregunta class])];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES && pregunta == %@", pregunta];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setFetchLimit:1];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
        if(!error){
            result = [results firstObject];
        } else{
            NSLog(@"Error fetching object: %@", error);
        }
    }
    return result;
}

+ (NSArray *)getAllPreguntasForSubtema:(Subtema *)subtema inContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Pregunta class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES && subtema == %@", subtema];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"posicion" ascending:YES];
    NSSortDescriptor *secondarysSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pregunta" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor, secondarysSortDescriptor];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"Error fetching object: %@", error);
    }
    return  result;
}

+ (NSArray *)getAllPreguntasForTramite:(Tramite *)tramite inContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Pregunta class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES && tramite == %@", tramite];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"posicion" ascending:YES];
    NSSortDescriptor *secondarysSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pregunta" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor, secondarysSortDescriptor];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"Error fetching object: %@", error);
    }
    return  result;
}

- (BOOL)isEqualToTAyudaObject:(id)object{
    return [object isKindOfClass:[Pregunta class]] && [self.pregunta isEqualToString:[object pregunta]];
}

@end
