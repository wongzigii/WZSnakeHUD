//
//  ViewController.m
//  WZSnakeHudDemo
//
//  Created by Wongzigii on 11/19/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import "ViewController.h"
#import "WZSnakeHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showHUD:(id)sender {
    [WZSnakeHUD show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
