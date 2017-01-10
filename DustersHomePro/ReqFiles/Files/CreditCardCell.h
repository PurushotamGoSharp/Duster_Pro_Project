//
//  CreditCardCell.h
//  
//
//  Created on 15/09/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditCardCell : UITableViewCell

@property (nonatomic,retain)IBOutlet UIButton *selectCardTypeButton,*makePaymentButton,*infoBtn;
@property (nonatomic,retain)IBOutlet UILabel *nameOnCardLabel,*cardNumberLabel,*cardExpiryLabel,*cardCvvLabel,*saleAmountLabel,*selectedCardNameLabel,*selectedCardExpiryLabel,*selectedCountryNameLabel,*saveThisCardLabel;

@property (nonatomic,retain) IBOutlet UIImageView *selectedImgForCreditCard;

@property (nonatomic,retain)IBOutlet UIImageView *selectedImageView;

@property (nonatomic,retain)IBOutlet UIView *showIssueView,*outsideCountryView;

@property (nonatomic,retain)IBOutlet UILabel *outsideCountryNameLabel,*outsideCountryAddressLabel,*outsideCountryCityLabel,*outsideCountryPostalCode,*outsideCountryCountryNameLabel;

@property (nonatomic,retain)IBOutlet UIButton *selectCountry;

@property (nonatomic,retain)IBOutlet UIButton *saveCardBtn;


@property (nonatomic,retain) IBOutlet UIButton *cvv_ImageBtn;


-(IBAction)infoBtn:(id)sender;
-(IBAction)cvv_ImageBtn:(id)sender;

@end
