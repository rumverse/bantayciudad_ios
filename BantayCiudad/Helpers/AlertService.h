//
//  AlertService.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

@class AlertsRequest;
@protocol AlertService <NSObject>

- (void)getAlertsWithRequest:(AlertsRequest *)request withCompletion:(void (^)(RESTResponse *response, NSError *error))completion;

- (void)sendAlertWithRequest:(AlertsRequest *)request withCompletion:(void (^)(RESTResponse *response, NSError *error))completion;

- (void)getAlertDetailWithRequest:(AlertsRequest *)request withCompletion:(void (^)(RESTResponse *response, NSError *error))completion;


@end
