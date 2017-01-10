//
//  ThankViewController.h
//  TestKit
//
//  Created by Saravana Kumar on 12/08/15.
//  Copyright (c) 2015 Saravana Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import "MRMSiOS.h"
#import "PaymentModeViewController.h"


@interface ResponseViewController : UIViewController
{
    
    UILabel *tiltLabel;
    
    NSMutableData *responseData;
    
    NSDictionary *jsonDict;
    
    UIActivityIndicatorView *activity;
    
    UIView *loadingView;
    
    NSString *session;

    NSString *ACC_ID;
    NSString *SECRET_KEY;
    
    NSString *isLIVE;
    NSString *ALGORITHM;
    NSString *MODE;
    NSString *PAGE_ID;
    
    NSString *CANCEL_VIEWCONTROLLER;
    NSString *TRANSACTION_MESSAGE;
    NSString *SHOW_REFERENCE;
    
    NSDictionary *dictPlist;


}
@property(nonatomic,retain)IBOutlet UILabel *TransactionIdLabel;
@property(nonatomic,retain)IBOutlet UIButton *okBtn;
@property (nonatomic,retain)  NSString *session;

@property (nonatomic,retain) NSMutableDictionary *dynamicKeyValueDictionary;

@property (nonatomic,retain) NSString *transactionStatus;

@property (nonatomic,retain) NSString *transaction_id;
-(IBAction)submitAction:(id)sender;

-(IBAction)tryAgainAction:(id)sender;

-(IBAction)cancelAction:(id)sender;


@property (nonatomic,retain) NSString *amount;
@property (nonatomic,retain) NSString *reference_no;


@end
