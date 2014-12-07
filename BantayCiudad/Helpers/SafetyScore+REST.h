//
//  SafetyScore+REST.h
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "SafetyScore.h"
@class RKObjectMapping, RKManagedObjectStore;

@interface SafetyScore (REST)

+ (RKObjectMapping *)objectMappingForStore:(RKManagedObjectStore *)store;

@end
