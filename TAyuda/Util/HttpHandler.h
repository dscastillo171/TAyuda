//
//  HttpHandler.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/16/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// HTTP methods.
typedef enum{
    HttpPost, // HTTP method POST.
    HttpPut, // HTTP method PUT.
    HttpGet, // HTTP method GET.
    HttpDelete // HTTP method DELETE.
} HttpMethod;

@interface HttpHandler : NSObject <NSURLSessionTaskDelegate>

// Launch a simple GET request without parameters.
- (void)requestWithURL:(NSURL *)url completion:(void (^)(NSInteger statusCode, id response))completionHandle;

// Launch a simple GET request without parameters, returns on the given context's thread.
- (void)requestWithURL:(NSURL *)url completion:(void (^)(NSInteger statusCode, id response))completionHandle inContext:(NSManagedObjectContext *)context;

- (void)requestWithURL:(NSURL *)url httpMethod:(HttpMethod)method data:(id)data completion:(void (^)(NSInteger statusCode, id response))completion additionalHeaders:(NSDictionary *)headers;

@end
