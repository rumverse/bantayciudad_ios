//
//  AlertsRequest.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "RESTRequest.h"

typedef NS_ENUM(NSInteger, Severity) {
    Info,
    Warning,
    Emergency
};

typedef NS_ENUM(NSInteger, UserType) {
    Authority,
    System,
    Normal
};

typedef NS_ENUM(NSInteger, AlertType) {
    Traffic,
    Fire,
    Violence,
    Medical,
    Disaster,
    Crime,
    Unknown
};

@interface AlertsRequest : RESTRequest

@property (nonatomic, strong) NSString *severity;
@property (nonatomic, strong) NSString *alertDescription;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) Severity severityType;
@property (nonatomic, assign) UserType userType;
@property (nonatomic, assign) AlertType alertType;
@property (nonatomic, assign) NSInteger zipCode;

+ (RKObjectMapping *)requestMapping;

@end
