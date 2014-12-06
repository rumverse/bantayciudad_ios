//
//  AppConfiguration.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "AppConfiguration.h"

#import <RestKit/RestKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "RKObjectManager+App.h"

#import "RESTAlertService.h"

// Use a class extension to expose access to MagicalRecord's private setter methods; necessary to work with RestKit
@interface NSManagedObjectContext ()
+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;
@end


@implementation AppConfiguration

+ (id)sharedConfiguration{
    static AppConfiguration *sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc]init];
    });
    return sharedConfig;
}

- (id)init{
    if (self = [super init]) {
  
    }
    return self;
}

- (RKManagedObjectStore *)setupCoreDataStack{
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelWarn];
    [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"BantayCiudad.sqlite"];
#ifdef DEBUG
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
#endif
    
    RKManagedObjectStore *mos = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
    [mos createManagedObjectContexts];
    [NSManagedObjectContext MR_setRootSavingContext:mos.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:mos.mainQueueManagedObjectContext];
    
    return mos;
}

- (RKObjectManager *)setMainObjectManager{
    return [RKObjectManager managerInStore:[AppDelegate delegate].managedObjectStore];
}

- (void)defaultConfiguration{
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:97.0/255.0 green:5.0/255.0 blue:106.0/255.0 alpha:1.0]];
    
    [self setRESTEndpoints];
}

- (void)setRESTEndpoints{
   	[RKObjectManager configureEndpoints:@[[RESTAlertService class]]
                             forManager:[[AppDelegate delegate]mainObjectManager]];
}



@end
