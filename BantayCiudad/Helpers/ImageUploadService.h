//
//  ImageUploadService.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageUploadService <NSObject>

- (void)uploadImage:(UIImage *)image withCompletion:(void (^)(NSDictionary *, NSError *))completion;

@end