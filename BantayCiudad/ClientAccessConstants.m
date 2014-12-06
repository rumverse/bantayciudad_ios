//
//  ClientAccessConstants.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "ClientAccessConstants.h"

NSString *const ErrorDomainClientAccess = @"ClientAccessError";

const NSInteger ErrorCodeClientAccessUnknownError = 0;
const NSInteger ErrorCodeClientAccessUnableToPerformAction = -2;

const NSInteger ErrorCodeClientAccessAuthorizationRequired = 11;
const NSInteger ErrorCodeClientAccessForbidden = 12;

const NSInteger ErrorCodeClientAccessConnectionError = 50;

const NSInteger ErrorCodeClientAccessValidationFailure = 100;

const NSInteger ErrorCodeClientRemoteServerError = 500;

const NSInteger ErrorCodeExpiredCredentials = -1;
