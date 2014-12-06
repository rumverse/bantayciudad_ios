//
//  GeoNamesRequest.m
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "GeoNamesRequest.h"

@implementation GeoNamesRequest
+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"latitude": @"lat",
                                                  @"longitude" : @"lng",
                                                  @"bugmenotuser" : @"username"
                                                  }];
    
    return mapping;
}
@end
