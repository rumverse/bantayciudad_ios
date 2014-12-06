//
//  Alert.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Alert : NSManagedObject

@property (nonatomic, retain) NSString * alertDescription;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * zip;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * severity;
@property (nonatomic, retain) NSString * alertType;
@property (nonatomic, retain) NSString * alertID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userType;
@property (nonatomic, retain) NSString * photo;

@end
