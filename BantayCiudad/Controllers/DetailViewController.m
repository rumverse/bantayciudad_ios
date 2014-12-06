//
//  DetailViewController.m
//  BantayCiudad
//
//  Created by Jeniean Las Pobres on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "DetailViewController.h"
#import "CircularImageView.h"

@interface DetailViewController ()


@property (weak, nonatomic) IBOutlet CircularImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLabelHeightConstraints;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainContentViewHeightConstraints;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setData];
    [self.descriptionLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.  
}

- (void)setData{
    self.nameLabel.text = @"Jeniean Las Pobres";
    self.locationLabel.text = @"Pasig, City";
    self.titleLabel.text = @"I am the title";
    self.imageView.image = [UIImage imageNamed:@"noImage.jpg"];
    self.descriptionLabel.text = @"Pasig is Pasig smsfmdfmfmdjfskfsffsdfndncjcjcjcncsdjhaihfsfnckajsncjsahfckasjkhsajfbjasbfasjbcmsabcjasifhskfnckanfkasnfksnakcnskafnksajfkasjfcsjfajfkascfasnfkwjfiejfkwjdkamd,samccmcmmcmcmcmcmcmsdsjfejsanfkasfkjsknasksajfhwqfowfwfnfknwqkfkwjfkmalfnkajfelmflaowjflamflsmflasmflmslnsdkgksmfglajoisajfsmfalmjascnskcniscmndkncksmcsadmcmsc kmcds c";
    
    CGSize maximumLabelSize = CGSizeMake(self.descriptionLabel.frame.size.width,CGFLOAT_MAX);
    CGSize expectedLabelSize = [[self.descriptionLabel text] boundingRectWithSize: maximumLabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: [self.descriptionLabel font] } context: nil].size;
    
    self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f];
    [self.descriptionLabel setTextColor:[UIColor darkGrayColor]];
    
    //adjust the label the the new height.
    CGRect newFrame = self.descriptionLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    self.descriptionLabel.frame = newFrame;
}

- (void)updateViewConstraints
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    self.imageViewHeightConstraint.constant = self.imageView.frame.size.height;
    self.descriptionLabelHeightConstraints.constant = self.descriptionLabel.frame.size.height;
    self.descriptionViewHeightConstraint.constant = self.descriptionLabel.frame.size.height + 10;
    self.mainContentViewHeightConstraints.constant = screenHeight + self.descriptionViewHeightConstraint.constant;
    
    [super updateViewConstraints];
}

@end
