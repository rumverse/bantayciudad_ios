//
//  PostAlertViewController.m
//  BantayCiudad
//
//  Created by Jeniean Las Pobres on 12/7/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "PostAlertViewController.h"
#import "RESTAlertService.h"
#import "NSString+Additions.h"
#import "RESTImageUploadService.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

@interface PostAlertViewController () <UITextViewDelegate>
{
    AlertsRequest *request;
    NSString *hashtag;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *alertTypeControl;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;

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
    
    [self.addPhotoBtn addTarget:self action:@selector(launchCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    request = [AlertsRequest new];
    [request setSeverityType:Information];
    
    self.imageView.hidden = YES;
}

-(void)startsWithPound:(NSString *)str {
    NSRange range = [str rangeOfString:@"#"];
    
    if(range.length) {
        NSRange rangeend = [str rangeOfString:@" " options:NSLiteralSearch range:NSMakeRange(range.location,[str length] - range.location - 1)];
        if(rangeend.length) {
            hashtag =  [str substringWithRange:NSMakeRange(range.location,rangeend.location - range.location)];
        }
        else
        {
            hashtag = [str substringFromIndex:range.location];
        }
    }
    else {
        hashtag = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self startsWithPound:self.descriptionTextView.text];
}

-(IBAction) segmentedIndexChanged:(id) sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    switch (segment.selectedSegmentIndex) {
        case 0:
            [request setSeverityType:Information];
            break;
        case 1:
            [request setSeverityType:InfoWarning];
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
            NSLog(@"Alert ID:%@",response.alertID);
        }
        else{
            NSLog(@"Error: %@",error.localizedDescription);
        }
        
        [self uploadImage];
    }];
    
}

- (void)uploadImage{
    id <ImageUploadService> service = [[RESTImageUploadService alloc]initWithObjectManager:[AppDelegate delegate].mainObjectManager];
    
    [service uploadImage:self.imageView.image withCompletion:^(NSDictionary *response, NSError *error) {
        if (!error) {
            
        }
    }];
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
    [self.descriptionTextView resignFirstResponder];
}


#pragma mark - Photo Action Sheet Delegate
-(void)launchCamera:(id)sender{
    
    self.addPhotoBtn.hidden = YES;
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:NO completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *capturedImage = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(capturedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    self.imageView.hidden = NO;
    self.imageView.image = capturedImage;
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if( error )
    {
        NSLog(@"image:didFinishSavingWithError:contextInfo: %@", error.description );
    }
}


@end
