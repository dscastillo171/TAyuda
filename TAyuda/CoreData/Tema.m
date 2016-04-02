//
//  Tema.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "Tema.h"

@implementation Tema

+ (Tema *)temaFromAPIObject:(NSDictionary *)apiObject inContext: (NSManagedObjectContext *)context{
    NSString *id = [[apiObject objectForKey:@"id"] stringValue];
    NSString *nombre = [apiObject objectForKey:@"nombre"];
    NSNumber *publicado = [NSNumber numberWithInt:1]; //[apiObject objectForKey:@"publicado"];
    NSString *imagen = [apiObject objectForKey:@"imagen"];
    NSString *posicion = [apiObject objectForKey:@"posicion"];
    if(!posicion){
        posicion = [[Tema defaultPositionForTema:nombre] stringValue];
    }
    
    Tema *tema = [Tema getTemaWithId:id inContext:context];
    if(id && nombre && publicado){
        if(!tema){
            tema = (Tema *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Tema class]) inManagedObjectContext:context];
            tema.id = id;
            [tema setUp];
        }
        if(!tema.nombre || ![tema.nombre isEqualToString:nombre]){
            tema.nombre = nombre;
        }
        if(!tema.publicado || ![tema.publicado isEqualToNumber:publicado]){
            tema.publicado = publicado;
        }
        if(imagen){
            [Tema loadImageForTema:tema fromURL:imagen];
        }
        if((!tema.posicion && posicion) || (posicion && ![tema.posicion isEqualToString:posicion])){
            tema.posicion = posicion;
        }
    }
    return tema;
}

// Load the profile image from the given URL associated with the given company.
+ (void)loadImageForTema:(Tema *)tema fromURL:(NSString *)imageURL{
    // Download the image.
    void (^methodBlock)(void) = ^{
        NSURL *url = [NSURL URLWithString:imageURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *pitureHash = [MediaHandler hashFromData:data];
        UIImage *image = [[UIImage alloc] initWithData:data];
        if(image && ![tema.imagenHash isEqualToString:pitureHash]){
            [MediaHandler saveImageToDisk:image forId:tema.id imageFormatType:PNG wait:NO completion:^(BOOL completed, NSString *imagePath) {
                if(completed){
                    [tema.managedObjectContext performBlock:^{
                        tema.imagen = imagePath;
                        tema.imagenHash = pitureHash;
                        [tema.managedObjectContext save:nil];
                    }];
                }
            }];
        }
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), methodBlock);
}

+ (Tema *)getTemaWithId:(NSString *)id inContext:(NSManagedObjectContext *)context{
    Tema *tema;
    if(id){
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Tema class])];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES && id == %@", id];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setFetchLimit:1];
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        if(!error){
            tema = [result firstObject];
        } else{
            NSLog(@"Error fetching object: %@", error);
        }
    }
    return tema;
}

+ (NSArray *)getAllTemasInContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Tema class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"Error fetching object: %@", error);
    }
    return  result;
}

+ (NSFetchedResultsController *)getFetchedResultsController:(NSManagedObjectContext *)context{
    NSString *cacheName = @"com.tayuda.temas";
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Tema class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relevant == YES && publicado == YES", self];
    fetchRequest.predicate = predicate;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"posicion" ascending:YES];
    NSSortDescriptor *secondarysSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor, secondarysSortDescriptor];
    
    [NSFetchedResultsController deleteCacheWithName:cacheName];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:cacheName];
    
    NSError *error = nil;
    if(![controller performFetch:&error]){
        controller = nil;
        NSLog(@"Error creating a fetched results controller for Temas. %@", error);
    }
    
    return controller;
}

- (BOOL)isEqualToTema:(id)tema{
    BOOL result = false;
    if([tema isKindOfClass:[Tema class]] && [((Tema *)tema).id isEqualToString:self.id]){
        result = true;
    }
    return result;
}

- (BOOL)isEqualToTAyudaObject:(id)object{
    return [object isKindOfClass:[Tema class]] && [self.id isEqualToString:[object id]];
}

+ (NSNumber *)defaultPositionForTema: (NSString *)tema{
    NSNumber *position;
    if([tema isEqualToString:@"TU CONSUMIDOR"]){
        position = [NSNumber numberWithInt:4];
    } else if([tema isEqualToString:@"TU FAMILIA"]){
        position = [NSNumber numberWithInt:0];
    } else if([tema isEqualToString:@"TU NEGOCIO"]){
        position = [NSNumber numberWithInt:2];
    } else if([tema isEqualToString:@"TU SALUD"]){
        position = [NSNumber numberWithInt:5];
    } else if([tema isEqualToString:@"TU TRABAJO"]){
        position = [NSNumber numberWithInt:1];
    } else if([tema isEqualToString:@"TU TRAMITE"]){
        position = [NSNumber numberWithInt:3];
    } else if([tema isEqualToString:@"TU VIVIENDA"]){
        position = [NSNumber numberWithInt:6];
    } else if([tema isEqualToString:@"TUS IMPUESTOS"]){
        position = [NSNumber numberWithInt:8];
    } else if([tema isEqualToString:@"TUS TEMAS DE INTERES"]){
        position = [NSNumber numberWithInt:7];
    } else if([tema isEqualToString:@"TU CONSULTA"]){
        position = [NSNumber numberWithInt:9];
    }
    return position;
}

@end
