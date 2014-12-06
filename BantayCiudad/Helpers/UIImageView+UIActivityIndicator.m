//
//  UIImageView+UIActivityIndicator.m
//  UIActivityIndicator for SDWebImage
//
//  Created by Giacomo Saccardo.
//  Copyright (c) 2014 Volo International, Inc. All rights reserved.
//

#import "UIImageView+UIActivityIndicator.h"
#import <objc/runtime.h>

static char TAG_ACTIVITY_INDICATOR;

@interface UIImageView (Private)

-(void)createActivityIndicatorWithStyle:(ActivityIndicator) activityStyle;

@end

@implementation UIImageView (UIActivityIndicatorForSDWebImage)

@dynamic activityIndicator;

- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)createActivityIndicatorWithStyle:(ActivityIndicator) activityStyle {
    
    if ([self activityIndicator] == nil) {
        
        if(activityStyle == None)
            return;
        else if(activityStyle == WhiteLarge)
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        else if(activityStyle == White)
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        else if(activityStyle == Gray)
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        else
            return;
        
        CGRect activityIndicatorBounds = self.activityIndicator.bounds;
        float x = ((self.bounds.size.width - activityIndicatorBounds.size.width) / 2.0f) + 0.2f;
        float y = ((self.bounds.size.height - activityIndicatorBounds.size.height) / 2.0f) + 0.3f;
        self.activityIndicator.frame = CGRectMake(x, y, activityIndicatorBounds.size.width, activityIndicatorBounds.size.height);

        self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self addSubview:self.activityIndicator];
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.activityIndicator startAnimating];
    });
    
}

- (void)removeActivityIndicator {
    if ([self activityIndicator]) {
       [[self activityIndicator] removeFromSuperview];
       self.activityIndicator = nil;
    }
}

#pragma mark - Methods

- (void)setImageAnimated:(UIImage *)image
{
    CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
    [animation setValue:@"kCATransitionFade" forKey:@"type"];
    animation.duration = 0.4;
    [self.layer addAnimation:animation forKey:nil];
    
    self.image = image;
}

- (void)setImageWithURL:(NSURL *)url usingActivityIndicatorStyle:(ActivityIndicator)activityStyle {
    
    [self createActivityIndicatorWithStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
        [animation setValue:@"kCATransitionFade" forKey:@"type"];
        animation.duration = 0.4;
        [weakSelf.layer addAnimation:animation forKey:nil];
        [weakSelf removeActivityIndicator];
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder usingActivityIndicatorStyle:(ActivityIndicator)activityStyle {
    
    [self createActivityIndicatorWithStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
                       [animation setValue:@"kCATransitionFade" forKey:@"type"];
                       animation.duration = 0.4;
                       [weakSelf.layer addAnimation:animation forKey:nil];
                       [weakSelf removeActivityIndicator];
                   }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingActivityIndicatorStyle:(ActivityIndicator)activityStyle{
    
    [self createActivityIndicatorWithStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
                       [animation setValue:@"kCATransitionFade" forKey:@"type"];
                       animation.duration = 0.4;
                       [weakSelf.layer addAnimation:animation forKey:nil];
                       [weakSelf removeActivityIndicator];
                   }];
    
    
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(ActivityIndicator)activityStyle {
    
    [self createActivityIndicatorWithStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
                       [animation setValue:@"kCATransitionFade" forKey:@"type"];
                       animation.duration = 0.4;
                       [weakSelf.layer addAnimation:animation forKey:nil];
                       [weakSelf removeActivityIndicator];
                   }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(ActivityIndicator)activityStyle {
    
    [self createActivityIndicatorWithStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
                       [animation setValue:@"kCATransitionFade" forKey:@"type"];
                       animation.duration = 0.4;
                       [weakSelf.layer addAnimation:animation forKey:nil];
                       [weakSelf removeActivityIndicator];
                   }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(ActivityIndicator)activityStyle {
    
    [self createActivityIndicatorWithStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
                       [animation setValue:@"kCATransitionFade" forKey:@"type"];
                       animation.duration = 0.4;
                       [weakSelf.layer addAnimation:animation forKey:nil];
                       [weakSelf removeActivityIndicator];
                   }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(ActivityIndicator)activityStyle {
    
    [self createActivityIndicatorWithStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
                       [animation setValue:@"kCATransitionFade" forKey:@"type"];
                       animation.duration = 0.4;
                       [weakSelf.layer addAnimation:animation forKey:nil];
                       [weakSelf removeActivityIndicator];
                   }];
}


@end
