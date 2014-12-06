//
//  FeedCell.m
//  BantayCiudad
//
//  Created by Mylene Bayan on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "FeedCell.h"

#import "Alert.h"
#import "UIImageView+UIActivityIndicator.h"

@implementation FeedCell

+ (NSString *)reuseIdentifier{
    return NSStringFromClass([self class]);
}

+ (UINib *)nib{
    return [UINib nibWithNibName:[self reuseIdentifier] bundle:[NSBundle mainBundle]];
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)cellForAlert:(Alert *)alert forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.descriptionLabel.text = alert.alertDescription;
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:@"avatar"] placeholderImage:[UIImage imageNamed:@"avatar"] usingActivityIndicatorStyle:None];
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"avatar"] usingActivityIndicatorStyle:None];
}



@end
