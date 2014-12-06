//
//  UIImageView+UIActivityIndicator.h
//  UIActivityIndicator for SDWebImage
//
//  Created by Patrick Gorospe.
//  Copyright (c) 2014 Volo International, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>

typedef NS_ENUM(NSInteger, ActivityIndicator) {
    None,
    WhiteLarge,
    White,
    Gray,
};

@interface UIImageView (UIActivityIndicatorForSDWebImage)

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
- (void)setImageAnimated:(UIImage *)image;
- (void)setImageWithURL:(NSURL *)url usingActivityIndicatorStyle:(ActivityIndicator)activityStyle;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder usingActivityIndicatorStyle:(ActivityIndicator)activityStyle;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingActivityIndicatorStyle:(ActivityIndicator)activityStyle;
- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(ActivityIndicator)activityStyle;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(ActivityIndicator)activityStyle;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(ActivityIndicator)activityStyle;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(ActivityIndicator)activityStyle;

- (void)removeActivityIndicator;

@end
