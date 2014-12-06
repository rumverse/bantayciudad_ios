//
//  NSString+Additions.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonCrypto.h>

static inline NSString *ReturnCCHashedString(unsigned char *(encryption)(const void *data, CC_LONG len, unsigned char *md), CC_LONG digestLength, NSString *string)
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[digestLength];
    
    encryption(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:digestLength * 2];
    
    for (int i = 0; i < digestLength; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


@implementation NSString (Additions)

- (NSString *)MD5String {
    return ReturnCCHashedString(CC_MD5, CC_MD5_DIGEST_LENGTH, self);
}


- (NSURL *)urlValue{
    return [NSURL URLWithString:self];
}

- (BOOL)isEmpty{
    return self.length == 0;
}

@end
