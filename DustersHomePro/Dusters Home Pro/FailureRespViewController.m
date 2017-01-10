//
//  FailureRespViewController.m
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 31/12/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import "FailureRespViewController.h"

@interface FailureRespViewController ()

@end

@implementation FailureRespViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender
{
    [super cancelAction:sender];
    
}

- (void)tryAgainAction:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [super tryAgainAction:sender];
    
}

//- (void) ResponseNew:(NSNotification *)message {
//    if ([message.name isEqualToString:@"FAILED_DICT"])
//    {
//        //You will get the failed transaction details in below log and in jsondict.
//        NSLog(@"Response json data = %@",[message object]);
//    }
//}

@end
