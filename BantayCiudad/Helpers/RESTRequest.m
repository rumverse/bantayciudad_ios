//
//  RESTRequest.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "RESTRequest.h"

@implementation RESTRequest

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _apiKey = @"1234";

    return self;
}

@end
