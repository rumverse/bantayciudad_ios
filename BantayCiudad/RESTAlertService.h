//
//  RESTAlertService.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "RESTServiceSupport.h"
#import "AlertService.h"
#import "AlertsRequest.h"

@interface RESTAlertService : RESTServiceSupport<AlertService>

+ (void)configureEndpoints:(RKObjectManager *)manager;

@end
