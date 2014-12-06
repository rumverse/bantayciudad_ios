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

}

- (void)getAlertWithRequest:(AlertsRequest *)request withCompletion:(void (^)(RESTResponse *, NSError *))completion{
    [self handleStandardGETObject:request path:kEndpointGetAlert parameters:nil authRequired:NO finished:^(RESTResponse *response, NSError *error) {
        NSLog(@"Results: %@",response.result);
        completion(response, error);
    }];
}

@end
