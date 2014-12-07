//
//  ViewController.m
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "ViewController.h"

#import "RESTImageUploadService.h"

#import <AFNetworking/AFHTTPRequestOperation.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    id <ImageUploadService> service = [[RESTImageUploadService alloc]initWithObjectManager:[AppDelegate delegate].mainObjectManager];
    
    [service uploadImage:[UIImage imageNamed:@"fire.png"] withCompletion:^(NSDictionary *response, NSError *error) {
        if (!error) {
         
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
