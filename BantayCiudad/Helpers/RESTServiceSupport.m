//
//  RESTServiceSupport.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "RESTServiceSupport.h"

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "ClientAccessConstants.h"

#import <AFNetworking.h>


@implementation RESTServiceSupport{
    RKObjectManager *objectManager;
}

- (instancetype)initWithObjectManager:(RKObjectManager *)theObjectManager {
    if ( (self = [super init]) ) {
        objectManager = theObjectManager;
    }
    return self;
}

#pragma mark - Request Support
- (BOOL)isClientAuthenticationAvailable {
    return ([objectManager.HTTPClient defaultValueForHeader:@"Authorization"] != nil);
}

- (void)handleStandardGETRequest:(NSString *)path parameters:(NSDictionary *)parameters authRequired:(const BOOL)authRequired
                        finished:( void (^)(id result, NSError *error) )callback {
    [self handleStandardGETObject:nil forEntity:NO path:path parameters:parameters authRequired:authRequired finished:callback];
}

- (void)handleStandardPOSTObject:(id)object
                            path:(NSString *)path
                      parameters:(NSDictionary *)parameters
                    authRequired:(const BOOL)authRequired
                        finished:( void (^)(id result, NSError *error) )callback {
    
    return [self handleStandardPOSTObject:object forEntity:NO path:path parameters:parameters authRequired:authRequired finished:callback];
}

- (void)handleStandardPOSTObject:(id)object
                       forEntity:(const BOOL)asEntity
                            path:(NSString *)path
                      parameters:(NSDictionary *)parameters
                    authRequired:(const BOOL)authRequired
                        finished:( void (^)(id result, NSError *error) )callback {
    if ( authRequired && [self isClientAuthenticationAvailable] == NO ) {
        if ( callback != nil ) {
            callback(nil, [NSError errorWithDomain:ErrorDomainClientAccess code:ErrorCodeClientAccessAuthorizationRequired userInfo:nil]);
        }
        return;
    }
    
    void (^success)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        if([mappingResult.firstObject isKindOfClass:[RESTResponse class]])
        {
            RESTResponse *response = mappingResult.firstObject;
            NSError *resultError = nil;
            if (!response) {
                resultError = [self errorForFailedRequest:response operation:operation.HTTPRequestOperation error:nil];
            }
            
            if ( callback != nil ) {
                callback(response, resultError);
            }
        }
        else
        {
            if ( callback != nil ) {
                callback(mappingResult.firstObject, nil);
            }
        }
        
    };
    
    void (^failure)(RKObjectRequestOperation *operation, NSError *error) = ^(RKObjectRequestOperation *operation, NSError *error) {
        NSError *resultError = [self errorForFailedRequest:nil operation:operation.HTTPRequestOperation error:error];
        if ( callback != nil ) {
            callback(nil, resultError);
        }
    };
    
    // RestKit will merge our object and parameters into request parameters, which we DON'T want, so we manually create the request here
    NSMutableURLRequest *request = [objectManager requestWithObject:object method:RKRequestMethodPOST path:path parameters:parameters];
    RKObjectRequestOperation *op;
    if ( asEntity || [object isKindOfClass:[NSManagedObject class]] ) {
        op = [objectManager managedObjectRequestOperationWithRequest:request
                                                managedObjectContext:[NSManagedObjectContext MR_defaultContext]
                                                             success:success
                                                             failure:failure];
    } else {
        op = [objectManager objectRequestOperationWithRequest:request success:success failure:failure];
    }
    
    [objectManager enqueueObjectRequestOperation:op];
}

- (void)handleStandardGETObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters authRequired:(const BOOL)authRequired finished:(void (^)(id, NSError *))callback{
    return [self handleStandardGETObject:object forEntity:NO path:path parameters:parameters authRequired:authRequired finished:callback];
}

- (void)handleStandardGETObject:(id)object forEntity:(const BOOL)asEntity path:(NSString *)path parameters:(NSDictionary *)parameters authRequired:(const BOOL)authRequired finished:(void (^)(id, NSError *))callback{
    if ( authRequired && [self isClientAuthenticationAvailable] == NO ) {
        if ( callback != nil ) {
            callback(nil, [NSError errorWithDomain:ErrorDomainClientAccess code:ErrorCodeClientAccessAuthorizationRequired userInfo:nil]);
        }
        return;
    }
    
    void (^success)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if([mappingResult.firstObject isKindOfClass:[RESTResponse class]])
        {
            RESTResponse *response = mappingResult.firstObject;
            NSError *resultError = nil;
            if (!response) {
                resultError = [self errorForFailedRequest:response operation:operation.HTTPRequestOperation error:nil];
            }
            if ( callback != nil ) {
                callback(response, resultError);
            }
        }
        else
        {
            if ( callback != nil ) {
                callback(mappingResult.firstObject, nil);
            }
        }
        
    };
    
    void (^failure)(RKObjectRequestOperation *operation, NSError *error) = ^(RKObjectRequestOperation *operation, NSError *error){
        NSError *resultError = [self errorForFailedRequest:nil operation:operation.HTTPRequestOperation error:error];
        if ( callback != nil ) {
            callback(nil, resultError);
        }
        
    };
    
    NSMutableURLRequest *request = [objectManager requestWithObject:object method:RKRequestMethodGET path:path parameters:parameters];
    RKObjectRequestOperation *op;
    if ( asEntity || [object isKindOfClass:[NSManagedObject class]] ) {
        op = [objectManager managedObjectRequestOperationWithRequest:request
                                                managedObjectContext:[NSManagedObjectContext MR_defaultContext]
                                                             success:success
                                                             failure:failure];
        [objectManager enqueueObjectRequestOperation:op];
    } else {
        [objectManager getObjectsAtPath:path parameters:parameters success:success failure:failure];
    }
    
}

+ (void)cancelRequest{
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
}



#pragma mark - Error support

- (NSInteger)errorCodeForErrorResponse:(id)errorResponse
{
    NSInteger errorCode = 4000;//Unrecognized Error
    
    if ([errorResponse isEqualToString:@"cannot find user"]){
        
    }
    
    return errorCode;
}

- (NSString *)constructErrorMessageForError:(id)error
{
    NSString *errorMessage;
    
    if ([error isKindOfClass:[NSString class]])
        errorMessage = (NSString *)error;
    else
        errorMessage = @"Error is not a String";
    
    return errorMessage;
}

- (NSString *)errorDomain
{
    return @"RESTServiceReportErrorDomain";
}

- (NSError *)errorForFailedRequest:(RESTResponse *)response operation:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    
    NSInteger code = ErrorCodeClientAccessUnknownError;
    const NSInteger httpStatusCode = [operation.response statusCode];
    NSError *result = nil;
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:4];
    switch ( httpStatusCode ) {
        case 302:
        case 401:
            code = ErrorCodeClientAccessAuthorizationRequired;
            break;
            
        case 403:
        case 404:
            // note we include 404 here because our paths are known in advance so should not get a 404
            code = ErrorCodeClientAccessForbidden;
            break;
            
        case 422:
        {
            // bad data, i.e. invalid password, etc
            RESTResponse *errorResponse = [[error userInfo][RKObjectMapperErrorObjectsKey] lastObject];
            if (!errorResponse.error.isEmpty) {
                userInfo[NSLocalizedDescriptionKey] = [self constructErrorMessageForError:response.error];
            }
            if ( httpStatusCode == 422 ) {
                code = ErrorCodeClientAccessValidationFailure;
            } else {
                code = ErrorCodeClientRemoteServerError;
            }
        }
            break;
            
        case 500:
        case 503:
            code = ErrorCodeClientRemoteServerError;
            break;
    }
    if (!response.error.isEmpty) {
        // here is a good place to switch on restStatusCode and map to a more specific code
        code = [self errorCodeForErrorResponse:response.error];
        NSString *errorMessage = [self constructErrorMessageForError:response.error];
        if ( [errorMessage length] > 0 ) {
            userInfo[NSLocalizedDescriptionKey] = errorMessage;
        }
    }
    if ( result == nil ) {
        if ( error != nil ) {
            userInfo[NSUnderlyingErrorKey] = error;
        }
        if ( [[error domain] isEqualToString:NSURLErrorDomain] ) {
            // presume to be a network failure
            userInfo[NSLocalizedDescriptionKey] = [error localizedDescription];
            result = [NSError errorWithDomain:[self errorDomain] code:ErrorCodeClientAccessConnectionError userInfo:userInfo];
        } else {
            result = [NSError errorWithDomain:[self errorDomain] code:code userInfo:userInfo];
        }
    }
    return result;
}



@end
