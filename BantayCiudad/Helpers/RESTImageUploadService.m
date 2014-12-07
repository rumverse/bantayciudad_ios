//
//  RESTImageUploadService.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "RESTImageUploadService.h"
#import <AFHTTPClient.h>

@implementation RESTImageUploadService

- (void)uploadImage:(UIImage *)image withCompletion:(void (^)(id , NSError *))completion{
    
//    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    NSMutableURLRequest *request = [objectManager multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:@"images" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[self compressImage:image]
                                    name:@"article[image]"
                                fileName:@"photo.png"
                                mimeType:@"image/png"];
        
    }];
    
    [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    
    [self doUploadOperationForRequest:request withCompletion:^(id response, NSError *error) {
        NSLog(@"Response: %@",response);
        completion(response, error);
    }];
}

#pragma mark - Private

- (void)doUploadOperationForRequest:(NSMutableURLRequest *)request withCompletion:(void (^)(NSDictionary *, NSError *))completion
{
    RKHTTPRequestOperation *requestOperation = [[RKHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseData) {
        NSError* error;
        NSDictionary* responseObject = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:kNilOptions
                                                               error:&error];
        completion(responseObject, error);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *resultError = nil;
        if ( completion != nil ) {
            completion(nil, resultError);
        }
    }];
    
    [requestOperation start];
}


#pragma mark - Utilities

- (NSData *)compressImage:(UIImage *) imageToCompress
{
    float actualHeight = imageToCompress.size.height;
    float actualWidth = imageToCompress.size.width;
    float maxHeight = 768.0;
    float maxWidth = 1024.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [imageToCompress drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return imageData;
}

@end
