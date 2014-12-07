//
//  RESTServiceSupport.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RKObjectManager+App.h"
#import <RestKit/RestKit.h>
#import "RESTResponse.h"



@interface RESTServiceSupport : NSObject

@property (nonatomic, readonly) RKObjectManager *objectManager;

- (instancetype)initWithObjectManager:(RKObjectManager *)theObjectManager;

- (void)handleStandardGETObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters authRequired:(const BOOL)authRequired finished:(void (^)(id, NSError *))callback;

- (void)handleStandardGETObject:(id)object forEntity:(const BOOL)asEntity path:(NSString *)path parameters:(NSDictionary *)parameters authRequired:(const BOOL)authRequired finished:(void (^)(id, NSError *))callback;

- (void)handleStandardPOSTObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters authRequired:(const BOOL)authRequired
                        finished:( void (^)(id result, NSError *error) )callback;

- (void)handleStandardPOSTObject:(id)object
                       forEntity:(const BOOL)asEntity
                            path:(NSString *)path
                      parameters:(NSDictionary *)parameters
                    authRequired:(const BOOL)authRequired
                        finished:( void (^)(id result, NSError *error) )callback;

@end
