//
//  SafetyScore.h
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface SafetyScore : NSManagedObject

@property (nonatomic, retain) NSString * disaster;
@property (nonatomic, retain) NSString * drugs;
@property (nonatomic, retain) NSString * violence;
@property (nonatomic, retain) NSString * overall;
@property (nonatomic, retain) NSString * fire;
@property (nonatomic, retain) NSString * traffic;
@property (nonatomic, retain) Location *location;

@end
