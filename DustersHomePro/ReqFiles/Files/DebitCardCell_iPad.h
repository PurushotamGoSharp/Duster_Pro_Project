//
//  DebitCardCell_iPad.h
//  
//
//  Created on 29/09/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebitCardCell_iPad : UITableViewCell

@property (nonatomic,retain)IBOutlet UIButton *selectCardTypeButton,*makePaymentButton;




@property (nonatomic,retain)IBOutlet UILabel *nameOnCardLabel,*cardExpiryLabel,*cardCvvLabel,*saleAmountLabel,*selectedCardNameLabel,*selectedCardExpiryLabel;

@property (nonatomic,retain)IBOutlet UIImageView *selectedImageView;

@property (nonatomic,retain)IBOutlet UILabel *cardNumberLabel;

@property (nonatomic,retain)IBOutlet UILabel *cvvAndExpiryLabel;

@property (nonatomic,retain)IBOutlet UIButton *saveCardBtn;

@property (nonatomic,retain)IBOutlet UILabel *saveThisCardLabel;

@property (nonatomic,retain) IBOutlet UIButton *infoBtn;

-(IBAction)infoBtn:(id)sender;

@property (nonatomic,retain) IBOutlet UIButton *cvv_ImageBtn;
-(IBAction)cvv_ImageBtn:(id)sender;

@end
