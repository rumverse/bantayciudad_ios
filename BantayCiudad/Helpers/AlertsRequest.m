//
//  AlertsRequest.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "AlertsRequest.h"

@interface AlertsRequest ()


@property (nonatomic, strong) NSString *userTypeStr;
@property (nonatomic, strong) NSString *alertTypeStr;
@property (nonatomic, strong) NSNumber *zipCodeNum;
@property (nonatomic, strong) NSNumber *longitudeNum;
@property (nonatomic, strong) NSNumber *latitudeNum;
@property (nonatomic, strong) NSNumber *userIDNum;

@end

@implementation AlertsRequest

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"alertDescription": @"description",
                                                  @"zipCodeNum" : @"zip",
                                                  @"latitudeNum" : @"latitude",
                                                  @"longitudeNum": @"longitude",
                                                  @"severity": @"severity",
                                                  @"alertTypeStr" : @"alert",
                                                  @"userTypeStr" : @"user_type",
                                                  @"userIDNum" : @"user_id",
                                                  @"userName" : @"username",
                                                  @"apiKey":@"api_key"
                                                  }];
    
    return mapping;
}

- (void)setUserType:(UserType)userType{
    switch (userType) {
        case Authority:
            self.userTypeStr = @"authority";
            break;
        case System:
            self.userTypeStr = @"system";
            break;
        case Normal:
            self.userTypeStr = @"normal";
            break;
            
        default:
            break;
    }
}

- (void)setAlertType:(AlertType)alertType{
    switch (alertType) {
        case Traffic:
            self.alertTypeStr = @"traffic";
            break;
        case Fire:
            self.alertTypeStr = @"fire";
            break;
        case Violence:
            self.alertTypeStr = @"violence";
            break;
        case Medical:
            self.alertTypeStr = @"medical";
            break;
        case Disaster:
            self.alertTypeStr = @"disaster";
            break;
        case Crime:
            self.alertTypeStr = @"crime";
            break;
            
        default:
            break;
    }
}

- (void)setSeverityType:(Severity)severityType{
    switch (severityType) {
        case Info:
            self.severity = @"info";
            break;
        case Warning:
            self.severity = @"warning";
            break;
        case Emergency:
            self.severity = @"emergency";
            break;
            
        default:
            break;
    }
}

-(void)setZipCode:(NSInteger)zipCode{
    self.zipCodeNum = [NSNumber numberWithInteger:zipCode];
}

- (void)setUserID:(NSInteger)userID{
    self.userIDNum = [NSNumber numberWithInteger:userID];
}

- (void)setLatitude:(double)latitude{
    self.latitudeNum = [NSNumber numberWithDouble:latitude];
}

- (void)setLongitude:(double)longitude{
    self.longitudeNum = [NSNumber numberWithDouble:longitude];
}

@end
