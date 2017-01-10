//
//  PaymentSummary.h
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 06/11/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingModel.h"
#import "BookedJobModel.h"

@class PaymentSummary;

@protocol PaymentSummaryDelegate <NSObject>
- (void)payDueBtnTapped:(PaymentSummary *)summery;
- (void)successfullyPayedDue:(PaymentSummary *)summary;
@end

@interface PaymentSummary : UIView

@property (strong, nonatomic) BookingModel *bookingModel;
@property (weak, nonatomic) id<PaymentSummaryDelegate> delegate;

- (void)show;
- (void)hide;

@end
