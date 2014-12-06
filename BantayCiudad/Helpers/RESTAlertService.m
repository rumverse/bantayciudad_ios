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


static NSString *const kEndpointGetAlerts = @"/alerts/feeds";
static NSString *const kEndpointGetAlertDetail = @"/alerts";
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
                                                                           pathPattern:kEndpointGetAlerts
                                                                               keyPath:nil
                                                                           statusCodes:okStatusCodes]];
    
    
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RESTResponse responseMappingForResult:@"result" mapping:[Alert objectMappingForStore:manager.managedObjectStore]]
                                                                                method:RKRequestMethodGET
                                                                           pathPattern:kEndpointGetAlertDetail
                                                                               keyPath:nil
                                                                           statusCodes:okStatusCodes]];
    
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RESTResponse responseMappingForResult:nil mapping:nil]
                                                                                method:RKRequestMethodGET
                                                                           pathPattern:kEndpointGetAlertDetail
                                                                               keyPath:nil
                                                                           statusCodes:okStatusCodes]];

}

- (void)getAlertsWithRequest:(AlertsRequest *)request withCompletion:(void (^)(RESTResponse *, NSError *))completion{
    [self handleStandardGETObject:request forEntity:YES path:kEndpointGetAlerts parameters:nil authRequired:NO finished:^(id result, NSError *error) {
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

- (void)getAlertDetailWithRequest:(AlertsRequest *)request withCompletion:(void (^)(RESTResponse *, NSError *))completion{
    [self handleStandardPOSTObject:request path:kEndpointGetAlertDetail parameters:nil authRequired:NO finished:^(id result, NSError *error) {
        RESTResponse *response = (RESTResponse *)result;
        completion(response, error);
    }];
}

@end
