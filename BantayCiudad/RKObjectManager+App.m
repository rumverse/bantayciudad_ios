//
//  RKObjectManager+App.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "RKObjectManager+App.h"

NSString *const kBaseURL = @"http://104.131.55.35";
NSString *const kImageURL = @"http://bantayciudad.com/image_api/";

@implementation RKObjectManager (App)

+ (RKObjectManager *)managerInStore:(RKManagedObjectStore *)store{
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:kBaseURL.urlValue];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class]
                               forMIMEType:@"text/html"];
    objectManager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    objectManager.managedObjectStore = store;
    return objectManager;
}

+ (RKObjectManager *)managerForImageUpload
{
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:kImageURL.urlValue];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class]
                               forMIMEType:@"text/html"];
    objectManager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    return objectManager;
}

+ (void)configureEndpoints:(NSArray *)endpointProviders forManager:(RKObjectManager *)objectManager  {
    for ( id obj in endpointProviders ) {
        if ( [obj respondsToSelector:@selector(configureEndpoints:)] ) {
            [obj configureEndpoints:objectManager];
        }
    }
}

+ (Class)managedObjectClass:(Class)entityClass inStore:(RKManagedObjectStore *)store {
    // NOTE how [XYZ class] and this method return different objects; RestKit uses an isEqual: comparison on classes, so we need to use this method for the comparison to work
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(entityClass) inManagedObjectContext:store.mainQueueManagedObjectContext];
    return NSClassFromString([entity managedObjectClassName]);
}


@end
