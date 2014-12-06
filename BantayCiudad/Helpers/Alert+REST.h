//
//  Alert+REST.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "Alert.h"


@class RKObjectMapping, RKManagedObjectStore;

@interface Alert (REST)

+ (RKObjectMapping *)objectMappingForStore:(RKManagedObjectStore *)store;

@end
