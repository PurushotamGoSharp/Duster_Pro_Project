//
//  CreditCardCell_iPad.h
//  
//
//  Created on 24/09/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditCardCell_iPad : UITableViewCell

@property (nonatomic,retain)IBOutlet UIButton *selectCardTypeButton,*makePaymentButton;

@property (nonatomic,retain)IBOutlet UILabel *nameOnCardLabel,*cardNumberLabel,*cardExpiryLabel,*cardCvvLabel,*selectedCardNameLabel,*selectedCardExpiryLabel,*saveThisCardLabel,*selectedCountryNameLabel;

@property (nonatomic,retain)IBOutlet UILabel *saleAmountLabel;

@property (nonatomic,retain) IBOutlet UIImageView *selectedImgForCreditCard;

@property (nonatomic,retain)IBOutlet UIImageView *selectedImageView;

@property(nonatomic,retain)IBOutlet UIView *showIssueView,*outsideCountryView;

//@property (nonatomic,retain)IBOutlet UIView *showIssueView,*outsideCountryView;

@property (nonatomic,retain)IBOutlet UILabel *outsideCountryNameLabel,*outsideCountryAddressLabel,*outsideCountryCityLabel,*outsideCountryPostalCode,*outsideCountryCountryNameLabel;

@property (nonatomic,retain)IBOutlet UIButton *saveCardBtn;

@property (nonatomic,retain) IBOutlet UIButton *cvv_ImageBtn;

-(IBAction)infoBtn:(id)sender;
-(IBAction)cvv_ImageBtn:(id)sender;

@end
