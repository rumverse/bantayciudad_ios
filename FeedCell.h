//
//  FeedCell.h
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alert;

@interface FeedCell : UITableViewCell

+ (NSString *)reuseIdentifier;
+ (UINib *)nib;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)cellForAlert:(Alert *)alert forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
