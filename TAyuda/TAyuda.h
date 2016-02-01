//
//  TAyuda.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/16/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpHandler.h"
#import "ContextProvider.h"
#import "Tema.h"
#import "Subtema.h"
#import "Pregunta.h"
#import "Tramite.h"
#import "Lugar.h"

@interface TAyuda : NSObject

- (NSManagedObjectContext *)getMainContext;

- (void)updateTemas;

- (void)updateTramites;

- (void)updateTramiteInfo:(Tramite *)tramite completionBlock:(void (^)(BOOL completed))completion;

- (void)updatePreguntasForSubtema:(Subtema *)subtema completionBlock:(void (^)(BOOL completed))completion;

- (void)updatePreguntasForTramite:(Tramite *)tramite completionBlock:(void (^)(BOOL completed))completion;

- (void)searchPreguntas:(NSString *)keyword completionBlock:(void (^)(NSArray *preguntas))completion;

- (void)updateLugaresForTramite:(Tramite *)tramite completionBlock:(void (^)(BOOL completed))completion;

- (void)getBannerContent:(void (^)(NSDictionary *bannerContent))completion;

- (void)sendConsulta:(NSString *)consulta correo:(NSString *)correo completionBlock:(void (^)(BOOL completed))completion;

+ (NSArray *)removeObjectsFromArray:(NSArray *)source inArray:(NSArray *)array;

- (void)deleteUnrelevantObjects;

@end
