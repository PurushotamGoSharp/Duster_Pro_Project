//
//  PaymentSuccessViewController.h
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 30/12/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentSuccessViewController : UIViewController

@property (strong, nonatomic) NSString *orderNo;
@property (assign, nonatomic) CGFloat totalAmount;
@property (strong, nonatomic) NSString *plannedDate;

- (void)setupForPayLaterSuccess;

@end
