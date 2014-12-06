//
//  Location+REST.h
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "Location.h"

@class RKObjectMapping, RKManagedObjectStore;
@interface Location (REST)

+ (RKObjectMapping *)objectMappingForStore:(RKManagedObjectStore *)store;

@end
