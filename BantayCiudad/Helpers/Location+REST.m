//
//  Location+REST.m
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "Location+REST.h"
#import "SafetyScore+REST.h"
#import <RestKit/RestKit.h>

@implementation Location (REST)


+ (RKObjectMapping *)objectMappingForStore:(RKManagedObjectStore *)store{
    RKEntityMapping *alertMapping = [RKEntityMapping mappingForEntityForName:[[self class] description] inManagedObjectStore:store];
    alertMapping.identificationAttributes = @[@"zip"];
    alertMapping.discardsInvalidObjectsOnInsert = YES;

    [alertMapping addAttributeMappingsFromDictionary:@{@"zip":@"zip",
                                                       @"locationid":@"locationid",
                                                       @"safety_message":@"safety_message",
                                                       @"fulltext_location":@"location",
                                                       }];
    
    RKObjectMapping *scoreMapping = [SafetyScore objectMappingForStore:store];
    
    [alertMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"safety_score" toKeyPath:@"safety" withMapping:scoreMapping]];

    return alertMapping;
}


@end
