//
//  PostAlertViewController.m
//  BantayCiudad
//
//  Created by Jeniean Las Pobres on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "PostAlertViewController.h"
#import "RESTAlertService.h"

@interface PostAlertViewController () <UITextViewDelegate>
{
    AlertsRequest *request; 
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *alertTypeControl;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation PostAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    [self.alertTypeControl addTarget:self action:@selector(segmentedIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    request = [AlertsRequest new];
}

-(IBAction) segmentedIndexChanged:(id) sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    switch (segment.selectedSegmentIndex) {
        case 0:
            [request setSeverityType:Info];
            break;
        case 1:
            [request setSeverityType:Warning];
            break;
        case 2:
            [request setSeverityType:Emergency];
            break;
    }
}

-(void)sendButtonPressed:(id)sender{
    id<AlertService> service = [[RESTAlertService alloc]initWithObjectManager:[[AppDelegate delegate]mainObjectManager]];
    
    request.zipCode = 1605;
    request.latitude = 121.65;
    request.longitude = 54.1212;
    request.alertDescription = self.descriptionTextView.text;
    request.userType = Authority;
    request.alertType = Traffic;
    request.userName = @"mylene@onvolo.com";
    request.userID = 2;

    [service sendAlertWithRequest:request withCompletion:^(RESTResponse *response, NSError *error) {
        if (!response.error.isEmpty) {
            NSLog(@"Alert ID:%li",response.alertID);
        }
        else{
            NSLog(@"Error: %@",error.localizedDescription);
        }
    }];

}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

@end
