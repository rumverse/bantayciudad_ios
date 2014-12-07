//
//  RESTResponse.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKMapping;

@interface RESTResponse : NSObject

@property (nonatomic, strong) id result;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *alertID;

+ (RKMapping *)responseMappingForResult:(NSString *)keyPath mapping:(RKMapping *)resultMapping;

@end
