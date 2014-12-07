//
//  DetailViewController.m
//  BantayCiudad
//
//  Created by Jeniean Las Pobres on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "DetailViewController.h"
#import "CircularImageView.h"

#import "RESTAlertService.h"

#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "Alert.h"

#import "UIImageView+UIActivityIndicator.h"

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
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    Alert *alert = [Alert MR_findFirstByAttribute:@"alertID" withValue:@"5483488231fc4808e238594f"];
    if (alert == nil) {
        id <AlertService> service = [[RESTAlertService alloc]initWithObjectManager:[AppDelegate delegate].mainObjectManager];
        
        [service getAlertDetailForID:@"5483488231fc4808e238594f" withCompletion:^(RESTResponse *response, NSError *error) {
            if (response.result) {
                NSLog(@"response: %@",response.result);
            }
            else{
                NSLog(@"Error: %@",error.localizedDescription);
            }
        }];
    }
    else{
        [self setData:alert];
        [self.descriptionLabel sizeToFit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.  
}

- (void)setData:(Alert *)alert{
    self.nameLabel.text = alert.userName;
    self.locationLabel.text = @"Pasig, City";
    self.titleLabel.text = @"I am the title";
    [self.avatar setImageWithURL:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@",alert.userName.MD5String].urlValue placeholderImage:[UIImage imageNamed:@"avatar"] usingActivityIndicatorStyle:None];
    if (alert.photo) {
        [self.imageView setImageWithURL:alert.photo.urlValue placeholderImage:[UIImage imageNamed:@""] usingActivityIndicatorStyle:None];
    }
    else{
        self.imageViewHeightConstraint.constant = 0.0;
    }
    self.descriptionLabel.text = alert.alertDescription;
    
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
