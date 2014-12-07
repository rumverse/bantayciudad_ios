//
//  Location.h
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SafetyScore;
@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * locationid;
@property (nonatomic, retain) NSString * safety_message;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) SafetyScore *safety;

@end
