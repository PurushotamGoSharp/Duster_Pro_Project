//
//  PaymentSuccessViewController.m
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 30/12/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import "PaymentSuccessViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "PaymentModeViewController.h"
#import "Constant.h"

@interface PaymentSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionIdTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *successTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *bookAnotherBtn;

@end

@implementation PaymentSuccessViewController
{
    NSDictionary *jsondict;
    AppDelegate *appDel;
    NSDateFormatter *dateFormatter;
    
    BOOL shouldUpdateForBookLater;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseNew:)
                                                 name:@"JSON_NEW"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JSON_DICT"
                                                        object:nil
                                                      userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(completedSuccessfully:)
                                                 name:@"PAYMENT_COMPLETED_SUCCESS"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(completedWithFailure:)
                                                 name:@"PAYMENT_COMPLETED_FAILURE"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
    if (shouldUpdateForBookLater)
    {
        [self setupUIForPayLaterSuccess];
    }
}

- (void)responseNew:(NSNotification *)message
{
    if ([message.name isEqualToString:@"JSON_NEW"])
    {
        NSLog(@"Response = %@",[message object]);
        jsondict = [message object];
        
        if (jsondict[@"error"] == nil)
        {
            if ([jsondict[@"ResponseCode"] integerValue] == 0)
            {
                BOOL fromPayNow = NO;
                
                NSString *fromPayNowKey = [NSString stringWithFormat:@"%@_fromPayNowKey", jsondict[@"MerchantRefNo"]];
                fromPayNow = [[NSUserDefaults standardUserDefaults] boolForKey:fromPayNowKey];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:fromPayNowKey];
                
                if (fromPayNow)
                {
                    [self.bookAnotherBtn setTitle:@"Book Another" forState:(UIControlStateNormal)];
                }else
                {
                    [self.bookAnotherBtn setTitle:@"Ok" forState:(UIControlStateNormal)];
                }
                
                self.title = @"Success";
                self.transactionIdTitleLabel.hidden = NO;
                
                appDel = [UIApplication sharedApplication].delegate;
                [MBProgressHUD showHUDAddedTo:appDel.window animated:YES];
                self.descriptionLabel.text = [NSString stringWithFormat:@"Your payment of %@%.2f is successful.",kRUPPEE_SYMBOL ,[jsondict[@"Amount"] floatValue]];
                self.orderNumberLabel.text = jsondict[@"MerchantRefNo"];
                self.transactionIDLabel.text = jsondict[@"TransactionId"];
                self.dateLabel.text = jsondict[@"DateCreated"];
                self.amountLabel.text = [NSString stringWithFormat:@"%@%@",kRUPPEE_SYMBOL,jsondict[@"Amount"]];
            }else
            {
                [self setUpForFailureTranscation:jsondict];
            }
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYMENT_CANCEL_NOTIFICATION"
                                                                object:jsondict
                                                              userInfo:nil];
        }
    }
}


- (void)setUpForFailureTranscation:(NSDictionary *)response
{
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    BOOL fromPayNow = NO;
    
    NSString *fromPayNowKey = [NSString stringWithFormat:@"%@_fromPayNowKey", jsondict[@"MerchantRefNo"]];
    fromPayNow = [[NSUserDefaults standardUserDefaults] boolForKey:fromPayNowKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:fromPayNowKey];
    
    if (fromPayNow)
    {
        [self.bookAnotherBtn setTitle:@"Book Another" forState:(UIControlStateNormal)];
    }else
    {
        [self.bookAnotherBtn setTitle:@"Ok" forState:(UIControlStateNormal)];
    }
    self.title = @"FAILURE";

    self.successTitleLabel.text = @"FAILURE!";
    self.successTitleLabel.textColor = [UIColor redColor];
    NSString *totalCost = [[NSUserDefaults standardUserDefaults] objectForKey:@"strSaleAmount"];
    NSString *orderCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"reference_no"];
    
    dateFormatter.dateFormat = @"dd MMM YYYY, hh:mm a";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    self.descriptionLabel.text = [NSString stringWithFormat:@"Your payment of %@%@ is failed.",kRUPPEE_SYMBOL , totalCost];
    self.orderNumberLabel.text = orderCode;
    self.transactionIDLabel.text = response[@"TransactionId"];
//    self.transactionIdTitleLabel.hidden = YES;
    self.dateLabel.text = dateString;
    self.amountLabel.text = [NSString stringWithFormat:@"%@%@",kRUPPEE_SYMBOL,totalCost];
}

- (void)setupForPayLaterSuccess
{
    shouldUpdateForBookLater = YES;
}

- (void)setupUIForPayLaterSuccess
{
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    self.title = @"Success";
    
    self.successTitleLabel.text = @"SUCCESS!";
//    self.successTitleLabel.textColor = [UIColor greenColor];
    
    dateFormatter.dateFormat = @"dd MMM YYYY, hh:mm a";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    self.descriptionLabel.text = [NSString stringWithFormat:@"Your order has been booked successfully."];
    self.orderNumberLabel.text = self.orderNo;
    self.transactionIDLabel.text = @"";
    self.transactionIdTitleLabel.hidden = YES;
    self.dateLabel.text = dateString;
    self.amountLabel.text = [NSString stringWithFormat:@"%@%.2f",kRUPPEE_SYMBOL,self.totalAmount];
}

- (void)completedSuccessfully:(NSNotification *)message
{
    [MBProgressHUD hideAllHUDsForView:appDel.window animated:YES];
}

- (void)completedWithFailure:(NSNotification *)message
{
    NSLog(@"Failure of update API after Payment");
    [MBProgressHUD hideAllHUDsForView:appDel.window animated:YES];
}

- (IBAction)BookAnotherButton:(UIButton *)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYMENT_SUCCESSFUL_NOTIFICATION"
                                                        object:jsondict
                                                      userInfo:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
