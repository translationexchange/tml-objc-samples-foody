//
//  ApiClient.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "ApiClient.h"

@implementation ApiClient

static ApiClient *sharedInstance = nil;

// Shared instance of ApiClient
+ (ApiClient *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] init];
    });
    return sharedInstance;
}

- (NSString *) apiFullPath: (NSString *) path {
    if ([path rangeOfString:@"http"].location != NSNotFound)
        return path;
    return [NSString stringWithFormat:@"%@/api/v1/%@", @"http://localhost:5000", path];
}

- (NSDictionary *) apiParameters: (NSDictionary *) params {
    return params;
}

- (NSString *) urlEncode: (id) object {
    NSString *string = [NSString stringWithFormat: @"%@", object];
    return [string stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLFragmentAllowedCharacterSet]];
}

- (NSString*) urlEncodedStringFromParams: (NSDictionary *) params {
    NSMutableArray *parts = [NSMutableArray array];
    for (id paramKey in params) {
        id paramValue = [params objectForKey: paramKey];
        NSString *part = [NSString stringWithFormat: @"%@=%@", [self urlEncode: paramKey], [self urlEncode: paramValue]];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

- (NSDictionary *) parseData: (NSData *) data {
    //    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    TmlDebug(@"Response: %@", json);
    
    NSError *error = nil;
    NSObject *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        TMLDebug(@"Error trace: %@", error);
        return nil;
    }
    
    NSDictionary *responseData = (NSDictionary *) responseObject;
    if ([responseData valueForKey:@"error"] != nil) {
        TMLDebug(@"Error trace: %@", [responseData valueForKey:@"error"]);
        return nil;
    }
    
    return responseData;
}

- (void) processResponseWithData: (NSData *)data
                           error: (NSError *)error
                         options: (NSDictionary *) options
                         success: (void (^)(NSDictionary *responseObject)) success
                         failure: (void (^)(NSError *error)) failure {
    if (error) {
        TMLDebug(@"Error: %@", error);
        failure(error);
        return;
    }
    
    if (!data) {
        success(nil);
        return;
    }
    
    success([self parseData:data]);
}

- (void) request: (NSURLRequest *) request
         options: (NSDictionary *) options
         success: (void (^)(NSDictionary *responseObject)) success
         failure: (void (^)(NSError *error)) failure {
    
    [[[NSURLSession sharedSession] dataTaskWithRequest: request
                                     completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
                                         dispatch_async(dispatch_get_main_queue(), ^(void){
                                             [self processResponseWithData:data error:error options:options success:success failure:failure];
                                         });
                                     }] resume];
}

- (void) get: (NSString *) path
      params: (NSDictionary *) params
     options: (NSDictionary *) options
     success: (void (^)(NSDictionary *responseObject)) success
     failure: (void (^)(NSError *error)) failure {
    
    NSString *fullPathWithQuery = [NSString stringWithFormat:@"%@?%@", [self apiFullPath: path], [self urlEncodedStringFromParams: [self apiParameters: params]]];

    TMLDebug(@"GET %@", fullPathWithQuery);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullPathWithQuery]];
    [self request:request options:options success:success failure:failure];
}

- (void) post: (NSString *) path
       params: (NSDictionary *) params
      options: (NSDictionary *) options
      success: (void (^)(NSDictionary *responseObject)) success
      failure: (void (^)(NSError *error)) failure {
    
    TMLDebug(@"POST %@", [self apiFullPath: path]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self apiFullPath: path]]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[self urlEncodedStringFromParams: [self apiParameters: params]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self request:request options:options success:success failure:failure];
}

- (void) del: (NSString *) path
      params: (NSDictionary *) params
     options: (NSDictionary *) options
     success: (void (^)(NSDictionary *responseObject)) success
     failure: (void (^)(NSError *error)) failure {

    NSString *fullPathWithQuery = [NSString stringWithFormat:@"%@?%@", [self apiFullPath: path], [self urlEncodedStringFromParams: [self apiParameters: params]]];

    TMLDebug(@"DELETE %@", fullPathWithQuery);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullPathWithQuery]];
    [request setHTTPMethod:@"DELETE"];
    
    [self request:request options:options success:success failure:failure];
}

- (void)    put: (NSString *) path
         params: (NSDictionary *) params
        options: (NSDictionary *) options
        success: (void (^)(NSDictionary *responseObject)) success
        failure: (void (^)(NSError *error)) failure {
    
    TMLDebug(@"PUT %@", [self apiFullPath: path]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self apiFullPath: path]]];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:[[self urlEncodedStringFromParams: [self apiParameters: params]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self request:request options:options success:success failure:failure];
}

@end
