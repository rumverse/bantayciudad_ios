//
//  GeoNamesRequest.h
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GeoNamesRequest : NSObject
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

+ (RKObjectMapping *)requestMapping;
@end
