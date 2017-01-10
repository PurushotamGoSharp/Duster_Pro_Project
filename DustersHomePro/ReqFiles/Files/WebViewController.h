//
//  WebViewController.h
//  
//
//  Created on 9/17/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "MRMSiOS.h"
#import "ResponseViewController.h"

#import "TIMERUIApplication.h"

@interface WebViewController : UIViewController <UIWebViewDelegate>
{
    
    NSTimer *idleTimer;
    
    IBOutlet UIWebView *listWebView;
    NSString *paymentAmtString;
    NSString *strCode;

    NSString *strSaleAmount;
    NSString *strDescription;
    NSString *strBillingName;
    NSString *strBillingAddress;
    NSString *strBillingCity;
    NSString *strBillingState;
    NSString *strBillingPostal;
    NSString *strBillingCountry;
    NSString *strBillingEmail;
    NSString *strBillingTelephone;
    NSString *strDeliveryName;
    NSString *strDeliveryAddress;
    NSString *strDeliveryCity;
    NSString *strDeliveryState;
    NSString *strDeliveryPostal;
    NSString *strDeliveryCountry;
    NSString *strDeliveryTelephone;

    NSString *strCardName;
    NSString *strCardNumber;
    NSString *strCardExpiry;
    NSString *strCardCvv;
    

    NSString *strChannel;
    NSString *strAvailableStatus;

    NSString *strPaymentMode;

    NSString *strPaymentModeId;
    
    NSString *strCardId;
    
    NSString *POST_URL;
    
    
    NSString *ACC_ID;
    NSString *SECRET_KEY;
    
    NSString *isLIVE;
    NSString *ALGORITHM;
    NSString *MODE;
    NSString *PAGE_ID;
    
    NSDictionary *dictPlist;
    
  
}

- (void)sendEvent:(UIEvent *)event ;


@property (nonatomic,retain) UIAlertView *webviewcancelAlertview;
@property (nonatomic,retain)UIAlertView *sessionalert;



@property (nonatomic,retain) NSString *strCardId;

@property (nonatomic,retain) NSString *strPaymentModeId;

@property (nonatomic,retain) NSString *strSaleAmount;
@property (nonatomic,retain) NSString *strDescription;
@property (nonatomic,retain) NSString *strBillingName;
@property (nonatomic,retain) NSString *strBillingAddress;
@property (nonatomic,retain) NSString *strBillingCity;
@property (nonatomic,retain) NSString *strBillingState;
@property (nonatomic,retain) NSString *strBillingPostal;
@property (nonatomic,retain) NSString *strBillingCountry;
@property (nonatomic,retain) NSString *strBillingEmail;
@property (nonatomic,retain) NSString *strBillingTelephone;
@property (nonatomic,retain) NSString *strDeliveryName;
@property (nonatomic,retain) NSString *strDeliveryAddress;
@property (nonatomic,retain) NSString *strDeliveryCity;
@property (nonatomic,retain) NSString *strDeliveryState;
@property (nonatomic,retain) NSString *strDeliveryPostal;
@property (nonatomic,retain) NSString *strDeliveryCountry;
@property (nonatomic,retain) NSString *strDeliveryTelephone;

@property (nonatomic,retain) NSString *strCardName;
@property (nonatomic,retain) NSString *strCardNumber;
@property (nonatomic,retain) NSString *strCardExpiry;
@property (nonatomic,retain) NSString *strCardCvv;

@property (nonatomic,retain) NSString *strChannel;
@property (nonatomic,retain) NSString *strAvailableStatus;
@property (nonatomic,retain) NSString *strPaymentMode;


@property (nonatomic,retain)NSMutableString *hashedString;

@property (nonatomic,retain) NSString *paymentAmtString;

@property (nonatomic,retain) NSString *strCode;

@property (nonatomic,retain)UIView *loadingView;

@property (nonatomic,retain)UIActivityIndicatorView *activity;

@property (nonatomic,retain) NSString *strCurrency;
@property (nonatomic,retain) NSString *strDisplayCurrency;

@property (nonatomic,retain) NSString *mobileType;
@property (nonatomic,retain) NSString *packageName;
@property (nonatomic,retain) NSString *saveCard_Status;

@property (nonatomic,retain)  NSString *session;
@property(nonatomic,retain)NSString *reference_no;

//StoreCard Cvv_texfield
@property (nonatomic,retain)NSString *Cvv_textfield;


@property (nonatomic,retain) NSMutableDictionary *dynamicDictionary;

@property (nonatomic,retain) NSMutableDictionary *dynamicKeyValueDictionary;

@property (nonatomic,retain) NSString *transactionStatus;

@property (nonatomic,retain) NSString *amount;



-(IBAction)backBtn:(id)sender;

@end
