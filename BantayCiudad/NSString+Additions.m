//
//  NSString+Additions.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSURL *)urlValue{
    return [NSURL URLWithString:self];
}

- (BOOL)isEmpty{
    return self.length == 0;
}

@end
