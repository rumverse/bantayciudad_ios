//
//  AppConfiguration.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKManagedObjectStore;

@interface AppConfiguration : NSObject

+ (id)sharedConfiguration;

- (void)defaultConfiguration;

- (RKManagedObjectStore *)setupCoreDataStack;

- (RKObjectManager *)setMainObjectManager;

- (void)setRESTEndpoints;

@end
