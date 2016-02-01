//
//  HttpHandler.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/16/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "HttpHandler.h"

@interface HttpHandler()
// Shared session.
@property (strong, nonatomic) NSURLSession *urlSession;
// Concurrent requests.
@property (nonatomic) NSInteger requestCount;
@end

@implementation HttpHandler

// Initialize the counter.
- (id)init{
    self = [super init];
    if(self){
        self.requestCount = 0;
    }
    return  self;
}

// Lazy instantiate the shared session.
- (NSURLSession *)urlSession{
    if(!_urlSession){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForResource = 20.0;
        configuration.HTTPAdditionalHeaders = @{@"application/json": @"Accept", @"utf-8": @"Accept-Charset"};
        _urlSession = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _urlSession;
}

#pragma mark-
#pragma mark Utilities
#pragma mark-

// URL encode the given string. Uses UTF-8 encoding.
+ (NSString *)urlEncode:(NSString *)string{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)(string), NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

// Return the http method as a string.
+ (NSString *)stringHTTPMethod:(HttpMethod)httpMethod{
    NSString *result;
    if(httpMethod == HttpPost){
        result = @"POST";
    } else if(httpMethod == HttpPut){
        result = @"PUT";
    } else if(httpMethod == HttpDelete){
        result = @"DELETE";
    } else{
        result = @"GET";
    }
    return result;
}

// Started a new request.
- (void)newRequest{
    if(self.requestCount == 0){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    self.requestCount++;
}

// Finished a request.
- (void)finishRequest {
    self.requestCount--;
    if(self.requestCount == 0){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

#pragma mark - Public stuff

// Lauch a request with the given parameters and headers.
- (void)requestWithURL:(NSURL *)url httpMethod:(HttpMethod)method data:(id)data completion:(void (^)(NSInteger statusCode, id response))completion additionalHeaders:(NSDictionary *)headers{
    // Keep count of the active requests.
    [self newRequest];
    void (^completionHandle)(NSInteger statusCode, id response) = ^(NSInteger statusCode, id response){
        [self finishRequest];
        completion(statusCode, response);
    };
    
    // Parse the data according to the http method given.
    NSData *requestData = nil;
    NSError *JSONError = nil;
    NSURL *requestURL = url;
    if((method == HttpPost || method == HttpPut || method == HttpDelete) && data){
        requestData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&JSONError];
    } else if(data && [data isKindOfClass:[NSDictionary class]]){
        // The default http method is get.
        NSMutableArray *queryParameters = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for(NSString *key in data){
            [queryParameters addObject: [NSString stringWithFormat:@"%@=%@", [HttpHandler urlEncode:key], [HttpHandler urlEncode:[[data objectForKey:key] description]]]];
        }
        
        // Format the URL to include the parameters.
        if([queryParameters count]){
            NSString *query = [queryParameters componentsJoinedByString:@"&"];
            requestURL = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:@"%@%@", [url query] ? @"&": @"?", query]];
        }
    }
    
    // If the data couldn't be parsed, call the completion handler.
    if(JSONError || !requestURL){
        if(completionHandle){
            completionHandle(0, nil);
        }
    } else{
        // Create HTTP request.
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
        [request setHTTPMethod:[HttpHandler stringHTTPMethod:method]];
        if(method != HttpGet){
            [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:requestData];
        }
        
        // Add additional headers.
        if(headers){
            for(id headerName in headers){
                id headerValue = [headers objectForKey:headerName];
                if([headerName isKindOfClass:[NSString class]] && ([headerValue isKindOfClass:[NSString class]] || [headerValue isKindOfClass:[NSNumber class]])){
                    [request setValue:headerValue forHTTPHeaderField:headerName];
                }
            }
        }
        
        // Create the task and save the completion handler.
        NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // Retrieve status code.
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger statusCode = error? 0: [httpResponse statusCode];
            
            // Parse the response.
            id JSONresponse = nil;
            if(data){
                JSONresponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            }
            
            // Call the completion handle.
            if(completionHandle){
                completionHandle(statusCode, JSONresponse);
            }
        }];
        [task resume];
    }
}

// Launch a simple GET request without parameters.
- (void)requestWithURL:(NSURL *)url completion:(void (^)(NSInteger statusCode, id response))completionHandle{
    [self requestWithURL:url httpMethod:HttpGet data:nil completion:completionHandle additionalHeaders:nil];
}

// Launch a simple GET request without parameters, returns on the given context's thread.
- (void)requestWithURL:(NSURL *)url completion:(void (^)(NSInteger statusCode, id response))completionHandle inContext:(NSManagedObjectContext *)context{
    void (^customCompletion)(NSInteger, id) = ^(NSInteger statusCode, id response){
        [context performBlock:^{
            completionHandle(statusCode, response);
        }];
    };
    [self requestWithURL:url httpMethod:HttpGet data:nil completion:customCompletion additionalHeaders:nil];
}

@end
