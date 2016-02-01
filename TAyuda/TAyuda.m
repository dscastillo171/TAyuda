//
//  TAyuda.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/16/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "TAyuda.h"

#define API_URL @"http://www.test-tayuda.tk/api/v1"

@interface TAyuda()

@property (strong, nonatomic) HttpHandler *httpHandler;

@property (strong, nonatomic) ContextProvider *contextProvider;

@end

@implementation TAyuda

- (HttpHandler *)httpHandler{
    if(!_httpHandler){
        _httpHandler = [[HttpHandler alloc] init];
    }
    return _httpHandler;
}

- (ContextProvider *)contextProvider{
    if(!_contextProvider){
        _contextProvider = [[ContextProvider alloc] init];
    }
    return _contextProvider;
}

- (NSManagedObjectContext *)getMainContext{
    return self.contextProvider.mainContext;
}

- (void)updateTemas{
    NSURL *url = [NSURL URLWithString:API_URL];
    url = [url URLByAppendingPathComponent:@"temas"];
    NSManagedObjectContext *context = self.contextProvider.privateContext;
    [self.httpHandler requestWithURL:url completion:^(NSInteger statusCode, id response) {
        if(statusCode == 200 && [response isKindOfClass:[NSArray class]]){
            NSMutableArray *actualTemas = [[Tema getAllTemasInContext:context] mutableCopy];
            NSMutableArray *temas = [NSMutableArray arrayWithCapacity:[response count]];
            for(NSDictionary *apiObject in response){
                Tema *tema = [Tema temaFromAPIObject:apiObject inContext:context];
                if(tema){
                    [self updateSubtemasFromTema:tema];
                    [temas addObject:tema];
                }
            }
            NSArray *deletedObjects = [TAyuda removeObjectsFromArray:actualTemas inArray:temas];
            for(Tema *tema in deletedObjects){
                tema.relevant = [NSNumber numberWithBool:NO];
            }
            [context save:nil];
        }
    } inContext:context];
}

- (void)updateSubtemasFromTema:(Tema *)tema{
    NSString *temaId = tema.id;
    NSString *stringURL = [NSString stringWithFormat:@"%@/subtemas?tema_id=%@", API_URL, temaId];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSManagedObjectContext *context = self.contextProvider.privateContext;
    [self.httpHandler requestWithURL:url completion:^(NSInteger statusCode, id response) {
        if(statusCode == 200 && [response isKindOfClass:[NSArray class]]){
            Tema *temaObj = [Tema getTemaWithId:temaId inContext:context];
            if(temaObj){
                NSMutableArray *subtemas = [NSMutableArray arrayWithCapacity:[response count]];
                for(NSDictionary *apiObject in response){
                    Subtema *subtema = [Subtema subtemaFromAPIObject:apiObject tema:temaObj inContext:context];
                    if(subtema){
                        [subtemas addObject:subtema];
                    }
                }
                NSMutableArray *currentObjs = [[temaObj.subtemas allObjects] mutableCopy];
                NSArray *deletedObjects = [TAyuda removeObjectsFromArray:currentObjs inArray:subtemas];
                for(Subtema *subtema in deletedObjects){
                    subtema.relevant = [NSNumber numberWithBool:NO];
                }
                [context save:nil];
            }
        }
    } inContext:context];
}

- (void)updateTramites{
    NSURL *url = [NSURL URLWithString:API_URL];
    url = [url URLByAppendingPathComponent:@"tramites"];
    NSManagedObjectContext *context = self.contextProvider.privateContext;
    [self.httpHandler requestWithURL:url completion:^(NSInteger statusCode, id response) {
        if(statusCode == 200 && [response isKindOfClass:[NSArray class]]){
            NSMutableArray *actualTramites = [[Tramite getAllTramitesInContext:context] mutableCopy];
            NSMutableArray *tramites = [NSMutableArray arrayWithCapacity:[response count]];
            for(NSDictionary *apiObject in response){
                Tramite *tramite = [Tramite tramiteFromAPIObject:apiObject inContext:context];
                if(tramite){
                    [tramites addObject:tramite];
                }
            }
            NSArray *deletedObjects = [TAyuda removeObjectsFromArray:actualTramites inArray:tramites];
            for(Tramite *tramite in deletedObjects){
                tramite.relevant = [NSNumber numberWithBool:NO];
            }
            [context save:nil];
        }
    } inContext:context];
}

- (void)updateTramiteInfo:(Tramite *)tramite completionBlock:(void (^)(BOOL completed))completion{
    NSString *stringURL = [NSString stringWithFormat:@"%@/tramite/?tramite_id=%@", API_URL, tramite.id];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSManagedObjectContext *context = self.contextProvider.privateContext;
    [self.httpHandler requestWithURL:url completion:^(NSInteger statusCode, id response) {
        if(statusCode == 200){
            [Tramite tramiteFromAPIObject:response inContext:context];
            [context save:nil];
            completion(true);
        } else{
            completion(false);
        }
    } inContext:context];
}

- (void)updateLugaresForTramite:(Tramite *)tramite completionBlock:(void (^)(BOOL completed))completion{
    NSString *tramiteId = tramite.id;
    NSString *stringURL = [NSString stringWithFormat:@"%@/lugar/?tramite_id=%@", API_URL, tramiteId];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSManagedObjectContext *context = self.contextProvider.privateContext;
    [self.httpHandler requestWithURL:url completion:^(NSInteger statusCode, id response) {
        Tramite *tramiteObj = [Tramite getTramiteWithId:tramiteId inContext:context];
        if(statusCode == 200 && tramiteObj){
            if([response isKindOfClass:[NSArray class]]){
                NSMutableArray *currentObjs = [[tramiteObj.lugares allObjects] mutableCopy];
                NSMutableArray *lugares = [NSMutableArray arrayWithCapacity:[response count]];
                for(NSDictionary *apiObject in response){
                    Lugar *lugar = [Lugar lugarFromAPIObject:apiObject inContext:context];
                    if(lugar){
                        [lugares addObject:lugar];
                        [tramiteObj addLugaresObject:lugar];
                    }
                }
                NSArray *deletedObjects = [TAyuda removeObjectsFromArray:currentObjs inArray:lugares];
                for(Lugar *lugar in deletedObjects){
                    lugar.relevant = [NSNumber numberWithBool:NO];
                }
                [context save:nil];
            }
            completion(true);
        } else{
            completion(false);
        }
    } inContext:context];
}

- (void)updatePreguntasForSubtema:(Subtema *)subtema completionBlock:(void (^)(BOOL completed))completion{
    NSString *temaId = subtema.tema.id;
    NSString *subtemaId = subtema.id;
    NSString *stringURL = [NSString stringWithFormat:@"%@/preguntas?subtema_id=%@", API_URL, subtema.id];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSManagedObjectContext *context = self.contextProvider.privateContext;
    [self.httpHandler requestWithURL:url completion:^(NSInteger statusCode, id response) {
        Tema *temaObj = [Tema getTemaWithId:temaId inContext:context];
        Subtema *subtemaObj = [Subtema getSubtemaWithId:subtemaId tema:temaObj inContext:context];
        if(statusCode == 200 && subtemaObj){
            if([response isKindOfClass:[NSArray class]]){
                NSMutableArray *currentObjs = [[subtemaObj.preguntas allObjects] mutableCopy];
                NSMutableArray *preguntas = [NSMutableArray arrayWithCapacity:[response count]];
                for(NSDictionary *apiObject in response){
                    Pregunta *pregunta = [Pregunta preguntaFromApiObject:apiObject inContext:context];
                    if(pregunta){
                        [preguntas addObject:pregunta];
                        pregunta.subtema = subtemaObj;
                    }
                }
                NSArray *deletedObjects = [TAyuda removeObjectsFromArray:currentObjs inArray:preguntas];
                for(Pregunta *pregunta in deletedObjects){
                    pregunta.relevant = [NSNumber numberWithBool:NO];
                }
                [context save:nil];
            }
            completion(true);
        } else{
            completion(false);
        }
    } inContext:context];
}

- (void)updatePreguntasForTramite:(Tramite *)tramite completionBlock:(void (^)(BOOL completed))completion{
    completion(true);
}

- (void)searchPreguntas:(NSString *)keyword completionBlock:(void (^)(NSArray *preguntas))completion{
    NSString *stringURL = [NSString stringWithFormat:@"%@/busqueda_preguntas?s=%@", API_URL, [keyword lowercaseString]];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSManagedObjectContext *context = self.contextProvider.privateContext;
    [self.httpHandler requestWithURL:url completion:^(NSInteger statusCode, id response) {
        if(statusCode == 200 && [response isKindOfClass:[NSArray class]]){
            NSMutableArray *preguntas = [NSMutableArray arrayWithCapacity:[response count]];
            for(NSDictionary *apiObject in response){
                Pregunta *pregunta = [Pregunta preguntaFromApiObject:apiObject inContext:context];
                if(pregunta){
                    [preguntas addObject:pregunta];
                }
            }
            [context save:nil];
            completion(preguntas);
        } else{
            completion(nil);
        }
    } inContext:context];
}

- (void)getBannerContent:(void (^)(NSDictionary *bannerContent))completion{
    NSString *stringURL = [NSString stringWithFormat:@"%@/patrocinador", API_URL];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSManagedObjectContext *context = self.contextProvider.privateContext;
    [self.httpHandler requestWithURL:url completion:^(NSInteger statusCode, id response) {
        if(statusCode == 200 && [response isKindOfClass:[NSDictionary class]]){
            completion(response);
        } else{
            completion(nil);
        }
    } inContext:context];
}

- (void)sendConsulta:(NSString *)consulta correo:(NSString *)correo completionBlock:(void (^)(BOOL completed))completion{
    NSString *stringURL = [NSString stringWithFormat:@"%@/consulta", API_URL];
    NSURL *url = [NSURL URLWithString:stringURL];
    [self.httpHandler requestWithURL:url httpMethod:HttpPost data:@{@"correo": correo, @"mensaje": consulta} completion:^(NSInteger statusCode, id response) {
        if(statusCode == 200){
            completion(true);
        } else{
            completion(false);
        }
    } additionalHeaders:nil];
}

- (void)deleteUnrelevantObjects{
    if(![NSThread isMainThread]){
        [self performSelectorOnMainThread:@selector(deleteUnrelevantObjects) withObject:nil waitUntilDone:YES];
        return;
    }
    [TAyudaObject deleteIrelevantObjectsInContext:[self getMainContext]];
}

- (Tema *)checkDefaultTemasInContext:(NSManagedObjectContext *)context{
    NSDictionary *defaultTema = @{
        @"id": [NSNumber numberWithInt:99],
        @"nombre": @"TU CONSULTA",
        @"publicado": [NSNumber numberWithInt:1],
        @"posicion": @"99"
    };
    return [Tema temaFromAPIObject:defaultTema inContext:context];
}

+ (NSArray *)removeObjectsFromArray:(NSArray *)source inArray:(NSArray *)array{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[source count]];
    NSMutableArray *arrayCopy = array? [array mutableCopy]: [NSMutableArray new];
    for(id object in source){
        BOOL matchedOject = NO;
        NSInteger i = 0;
        while(!matchedOject && i < [arrayCopy count]){
            matchedOject = [object isKindOfClass:[TAyudaObject class]] && [object isEqualToTAyudaObject:[arrayCopy objectAtIndex:i]];
            i = matchedOject? i: i + 1;
        }
        if(matchedOject){
            [arrayCopy removeObjectAtIndex:i];
        } else{
            [result addObject:object];
        }
    }
    return result;
}

@end
