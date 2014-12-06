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

- (void)handleStandardGETObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters authRequired:(const BOOL)authRequired finished:(void (^)(id, NSError *))callback{
    return [self handleStandardGETObject:object forEntity:NO path:path parameters:parameters authRequired:authRequired finished:callback];
}


- (void)handleStandardRequest:(NSString *)path parameters:(NSDictionary *)parameters authRequired:(const BOOL)authRequired
                     finished:( void (^)(id result, NSError *error) )callback {
    if ( authRequired && [self isClientAuthenticationAvailable] == NO ) {
        if ( callback != nil ) {
            callback(nil, [NSError errorWithDomain:ErrorDomainClientAccess code:ErrorCodeClientAccessAuthorizationRequired userInfo:nil]);
        }
        return;
    }
    [objectManager getObjectsAtPath:path
                         parameters:parameters
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                RESTResponse *response = mappingResult.firstObject;
                                NSError *resultError = nil;
                                if (!response.error.isEmpty ) {
                                    NSLog(@"Error");
                                }
                                if ( callback != nil ) {
                                    callback(response.result, resultError);
                                }
                            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"Error");
                                if ( callback != nil ) {
                                    callback(nil, error);
                                }
                            }];
}

- (void)handleStandardPOSTObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters authRequired:(const BOOL)authRequired
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
        RESTResponse *response = mappingResult.firstObject;
        NSError *resultError = nil;
        if (!response.error.isEmpty ) {
            NSLog(@"Error");
        }
        // invoke callback with either the repsonse object or, if none provided, the request object
        id responseObject = (response.result != nil ? response.result : object);
        if ( callback != nil ) {
            callback(responseObject, resultError);
        }
    };
    
    void (^failure)(RKObjectRequestOperation *operation, NSError *error) = ^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
        if ( callback != nil ) {
            callback(nil, error);
        }
    };
    
    // RestKit will merge our object and parameters into request parameters, which we DON'T want, so we manually create the request here
    NSMutableURLRequest *request = [objectManager requestWithObject:object method:RKRequestMethodPOST path:path parameters:nil];
    NSURL *postURL = [objectManager requestWithObject:nil method:RKRequestMethodGET path:path parameters:parameters].URL;
    request.URL = postURL;
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
            if (response.error.isEmpty) {
                //                resultError = [self errorForFailedRequest:response operation:operation.HTTPRequestOperation error:nil];
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
        NSError *resultError;
        //        resultError = [self errorForFailedRequest:nil operation:operation.HTTPRequestOperation error:error];
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

@end
