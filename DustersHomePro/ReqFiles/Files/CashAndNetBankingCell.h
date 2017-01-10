//
//  CashAndNetBankingCell.h
//
//
//  Created on 13/09/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashAndNetBankingCell : UITableViewCell{

}

@property (nonatomic,retain)IBOutlet UIButton *selectCardTypeButton;
@property (nonatomic,retain)IBOutlet UILabel *cardNameLabel;
@property (nonatomic,retain)IBOutlet UIButton *makePaymentButton;
@property (nonatomic,retain)IBOutlet UILabel *saleAmountLabel;

@property (nonatomic,retain)IBOutlet UIImageView *selectedImageView;
@property (nonatomic,retain)IBOutlet UILabel *selectedCardNameLabel;

@end
