//
//  GeoNamesResponse.m
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "GeoNamesResponse.h"
#import <RestKit/RestKit.h>

@implementation GeoNamesResponse

+ (RKMapping *)responseMappingForResult:(NSString *)keyPath mapping:(RKMapping *)resultMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{@"postalCode":@"postalCode"}];
    if ( resultMapping != nil ) {
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:keyPath
                                                                                toKeyPath:@"postalCodes"
                                                                              withMapping:resultMapping]];
    }
    return mapping;
}

@end
