//
//  AppDelegate.h
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class RKManagedObjectStore, RKObjectManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) RKObjectManager *mainObjectManager;
@property (nonatomic, strong) RKManagedObjectStore *managedObjectStore;



@end

