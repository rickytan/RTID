//
//  ViewController.m
//  Demo
//
//  Created by ricky on 14-6-5.
//  Copyright (c) 2014年 ricky. All rights reserved.
//

#import "ViewController.h"
#import "RTID.h"

@interface ViewController ()
@property (nonatomic, assign) IBOutlet UITextField * textField;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [RTID setIDType:RTIDTypeUDID];
    [RTID setDebug:YES];
    self.textField.text = [UIDevice currentDevice].RTID;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
