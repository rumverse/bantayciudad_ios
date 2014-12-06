//
//  ViewController.m
//  BantayCiudad
//
//  Created by Patrick Gorospe on 12/6/14.
//  Copyright (c) 2014 Bantay Ciudad. All rights reserved.
//

#import "ViewController.h"

#import "RESTAlertService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    id<AlertService> service = [[RESTAlertService alloc]initWithObjectManager:[[AppDelegate delegate]mainObjectManager]];
    
    AlertsRequest *request = [AlertsRequest new];
    request.zipCode = 1228;
    
    [service getAlertWithRequest:request withCompletion:^(RESTResponse *response, NSError *error) {
        NSLog(@"done");
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
