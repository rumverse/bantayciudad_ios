//
//  RESTAlertService.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "RESTAlertService.h"

#import "RESTResponse.h"

#import "Alert+REST.h"


static NSString *const kEndpointGetAlert = @"/alerts/feeds";
static NSString *const kEndpointSendAlert = @"/alerts";

@implementation RESTAlertService

+ (void)configureEndpoints:(RKObjectManager *)manager{
    NSIndexSet *okStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    /**
     *  Request Descriptors
     */
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[AlertsRequest requestMapping]
                                                                        objectClass:[AlertsRequest class]
                                                                        rootKeyPath:nil
                                                                             method:RKRequestMethodAny]];
    
    /**
     *  Response Descriptor
     */
    
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RESTResponse responseMappingForResult:@"result" mapping:[Alert objectMappingForStore:manager.managedObjectStore]]
                                                                                method:RKRequestMethodGET
                                                                           pathPattern:kEndpointGetAlert
                                                                               keyPath:nil
                                                                           statusCodes:okStatusCodes]];
    
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RESTResponse responseMappingForResult:nil mapping:nil]
                                                                                method:RKRequestMethodPOST
                                                                           pathPattern:kEndpointSendAlert
                                                                               keyPath:nil
                                                                           statusCodes:okStatusCodes]];

}

- (void)getAlertWithRequest:(AlertsRequest *)request withCompletion:(void (^)(RESTResponse *, NSError *))completion{
    [self handleStandardGETObject:request forEntity:YES path:kEndpointGetAlert parameters:nil authRequired:NO finished:^(id result, NSError *error) {
        RESTResponse *response = (RESTResponse *)result;
        completion(response, completion);
    }];
}

- (void)sendAlertWithRequest:(AlertsRequest *)request withCompletion:(void (^)(RESTResponse *, NSError *))completion{
    [self handleStandardPOSTObject:request path:kEndpointSendAlert parameters:nil authRequired:NO finished:^(id result, NSError *error) {
        RESTResponse *response = (RESTResponse *)result;
        completion(response, error);
    }];
}

@end
