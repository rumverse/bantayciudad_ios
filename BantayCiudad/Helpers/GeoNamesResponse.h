//
//  GeoNamesResponse.h
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKMapping;

@interface GeoNamesResponse : NSObject

@property (nonatomic, strong) id postalCodes;

@property (nonatomic, strong) NSString *postalCode;

+ (RKMapping *)responseMappingForResult:(NSString *)keyPath mapping:(RKMapping *)resultMapping;

@end