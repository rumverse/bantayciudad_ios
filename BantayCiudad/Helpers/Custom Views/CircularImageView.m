//
//  CircularImageView.m
//  VoloProject
//
//  Created by Patrick Gorospe on 2/10/14.
//  Copyright (c) 2014 Volo International, Inc. All rights reserved.
//

#import "CircularImageView.h"

@interface CircularImageView ()

- (void)addMaskToBounds:(CGRect)bounds;
- (void)setup;

@end

@implementation CircularImageView

#pragma mark -
#pragma mark - UIImageView override methods
- (id)init
{
    self = [super init];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Public methods
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self addMaskToBounds:frame];
}

- (void)addMaskToBounds:(CGRect)maskBounds
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	
    CGPathRef maskPath = CGPathCreateWithEllipseInRect(maskBounds, NULL);
    maskLayer.bounds = maskBounds;
	maskLayer.path = maskPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGPoint point = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2);
    maskLayer.position = point;
    
	[self.layer setMask:maskLayer];
}

- (void)setup
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
}

@end
