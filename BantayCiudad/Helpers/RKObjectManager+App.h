//
//  RKObjectManager+App.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@protocol RESTEndpointConfigurationProvider

+ (void)configureEndpoints:(RKObjectManager *)manager;

@end

@interface RKObjectManager (App)

+ (RKObjectManager *)managerInStore:(RKManagedObjectStore *)store;

+ (RKObjectManager *)managerForImageUpload;

+ (void)configureEndpoints:(NSArray *)endpointProviders forManager:(RKObjectManager *)objectManager;

+ (Class)managedObjectClass:(Class)entityClass inStore:(RKManagedObjectStore *)store;

@end
