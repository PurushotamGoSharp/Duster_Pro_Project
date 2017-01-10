//
//  CreditAndDebitCardCell.h
//  
//
//  Created on 13/09/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditAndDebitCardCell : UITableViewCell<UITextFieldDelegate>{

}
@property (nonatomic,retain)IBOutlet UIButton *selectCardTypeButton,*makePaymentButton,*saveCardBtn;

@property (nonatomic,retain)IBOutlet UILabel *nameOnCardLabel,*cardNumberLabel,*cardExpiryLabel,*cardCvvLabel,*saleAmountLabel,*selectedCardNameLabel,*selectedCardExpiryLabel,*saveThisCardLabel;

@property (nonatomic,retain)IBOutlet UIImageView *selectedImageView;

@property (nonatomic,retain)IBOutlet UILabel *cvvAndExpiryLabel;

//@property (nonatomic,retain)IBOutlet UITextField *nameTextField,*cardNumberOneTextField,*cardNumberTwoTextField,*cardNumberThreeTextField,*cardNumberFourTextField,*cvvNumberTextField;
//

@property (nonatomic,retain) IBOutlet UIButton *infoBtn;

@property (nonatomic,retain) IBOutlet UIButton *cvv_ImageBtn;

-(IBAction)infoBtn:(id)sender;

-(IBAction)cvv_ImageBtn:(id)sender;

@end


