//
//  SafetyScore+REST.m
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "SafetyScore+REST.h"
#import <RestKit/RestKit.h>
@implementation SafetyScore(REST)

+ (RKObjectMapping *)objectMappingForStore:(RKManagedObjectStore *)store{
    RKEntityMapping *alertMapping = [RKEntityMapping mappingForEntityForName:[[self class] description] inManagedObjectStore:store];
    //alertMapping.identificationAttributes = @[@"zip"];
    alertMapping.discardsInvalidObjectsOnInsert = YES;
    [alertMapping addAttributeMappingsFromDictionary:@{@"disaster":@"disaster",
                                                       @"drugs":@"drugs",
                                                       @"violence":@"violence",
                                                       @"overall":@"overall",
                                                       @"fire":@"fire",
                                                       @"traffic":@"traffic",
                                                       }];
    return alertMapping;
}


@end
