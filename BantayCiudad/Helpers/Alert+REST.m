//
//  Alert+REST.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "Alert+REST.h"

#import <RestKit/RestKit.h>

@implementation Alert (REST)


+ (RKObjectMapping *)objectMappingForStore:(RKManagedObjectStore *)store{
    RKEntityMapping *alertMapping = [RKEntityMapping mappingForEntityForName:[[self class] description] inManagedObjectStore:store];
    alertMapping.identificationAttributes = @[@"alertID"];
    alertMapping.discardsInvalidObjectsOnInsert = YES;
    [alertMapping addAttributeMappingsFromDictionary:@{@"alertid":@"alertID",
                                                       @"description":@"alertDescription",
                                                       @"severity":@"severity",
                                                       @"type":@"alertType",
                                                       @"zip":@"zip",
                                                       @"latitude":@"latitude",
                                                       @"longitude":@"longitude",
                                                       @"createdAt":@"dateCreated",
                                                       @"user_type":@"userType",
                                                       @"username":@"userName",
                                                       @"photo":@"photo"}];
    return alertMapping;
}

@end
