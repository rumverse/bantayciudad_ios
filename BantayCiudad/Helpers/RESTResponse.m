//
//  RESTResponse.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "RESTResponse.h"
#import <RestKit/RestKit.h>

@implementation RESTResponse

+ (RKMapping *)responseMappingForResult:(NSString *)keyPath mapping:(RKMapping *)resultMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{@"status":@"status",
                                                  @"error":@"error",
                                                  @"result.alertid":@"alertID",
                                                  @"result":@"isSuccess"}];
    if ( resultMapping != nil ) {
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:keyPath
                                                                                toKeyPath:@"result"
                                                                              withMapping:resultMapping]];
    }
    return mapping;
}

@end
