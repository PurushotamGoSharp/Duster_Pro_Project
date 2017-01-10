//
//  PaymentModeViewController.h
//
//
//  Created on 13/09/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>

#define API_URL @"https://qa.secure.ebs.in/api/"


#import "CashAndNetBankingCell.h"
#import "CreditAndDebitCardCell.h"
#import "CreditCardCell.h"

#import "CashAndNetBankingCell_iPad.h"
#import "CreditCardCell_iPad.h"
#import "DebitCardCell_iPad.h"

#import "StoredCardCell_iPhone.h"
#import "StoredCardCell_iPad.h"

#import "AsyncImageView.h"


#import "MRMSiOS.h"

#define RETURN_URL  @"http://qa.secure.ebs.in/v3/response.php"


@interface PaymentModeViewController : UIViewController < UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource >
{
    float CELLHEIGHT;
    //For Displaying Activity Indicator
    UIActivityIndicatorView *activity;
    
    UIView *loadingView;
    
    NSMutableData *webData,*surchargeData;
    NSMutableDictionary *paymentDictionary,*surchargeDictionary;
    NSURLConnection *paymentConnection,*surchargeConnection;
    NSString *email_Id;

    
    
    NSInteger SelectedRowMonth;
    NSInteger SelectedRowYear;
    IBOutlet UIButton *btnAvlOnCard,*btnNotAvlOnCard;
    IBOutlet UIButton *btnInside,*btnOutside;

    IBOutlet UIButton *backButton;
    IBOutlet UITableView *listTableView;

    NSArray *paymentModeArray;

    NSArray *listOfCardAndBankArray;

    NSMutableArray *expandAndCollapseArray,*imagesArray;

    NSInteger selectedNameString;

    UIButton *doneButton;

    NSMutableArray *logoURLArray;

    NSMutableArray *codeArray;

    NSMutableArray *sortArray;

    NSString *selectedCardNameString,*selectedBankNameString,*selectedDebitCardNameString,*selectedCreditCardNameString;

    UIImage *cashCardImg,*netBankingImg,*debitCardImg,*creditCardImg;

    UIPickerView *datePicker;
    UIToolbar *pickerToolbar;

    NSMutableArray *years,*months;
    NSString *strMonth;
    NSString *strMonth1;
    NSString *strTotal;

    UIToolbar* keyboardDoneButtonView;

    NSString *stringForComparingHeaders;

    BOOL boolIssueStatus;
    NSMutableArray *showIssueArray;
    BOOL boolCountryStatus;

    BOOL boolShowAvlOption;
    NSMutableArray *showAvlOptionArray;
    BOOL boolAvlStatus;

    NSMutableArray *countryArray, *countryNameValuesArray;
    NSString *strCode;


    NSString *strAvailableStatus;

    IBOutlet UILabel *debitExpiryLbl;

    NSUserDefaults *reloadDefaults;
    BOOL boolSectionFlag;

    NSMutableArray *arrTemp4;

    BOOL amexCardSelected;
    
    UIView *storedCardView;
    UILabel *viewLabel;
    UITextField *cvvTxtFld;
    NSString *strCard_Name;
    NSString *strCardId;
    
    int saveCard_Status;
    int debit_saveCard_Status;
    
    UIView *infoWebview;
    UIView *transparentview;
    
    NSMutableArray *netbankingCodeArray;
    NSMutableArray *cashCardCodeArray;


    
    NSString *ACC_ID;
    NSString *SECRET_KEY;
    
    NSString *isLIVE;
    NSString *ALGORITHM;
    NSString *MODE;
    NSString *PAGE_ID;
    
    NSDictionary *dictPlist;
    
    
    NSString *strInputSHA1;
    NSString *strSHA1;
    
    
}

@property (nonatomic,retain) NSString *strAvailableStatus;

@property (nonatomic,retain) NSString *strSaleAmount;

@property (nonatomic,retain) NSString *strCurrency;
@property (nonatomic,retain) NSString *strDisplayCurrency;

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

//TODO
@property (nonatomic,retain) NSString *cardType;
@property (nonatomic,retain) NSString *cardnumber;
@property (nonatomic,retain) NSString *NameonCard;


@property (nonatomic,retain)IBOutlet UIView *navigationBarView;

@property (nonatomic,retain) NSMutableDictionary *valuesDictionary;

@property (nonatomic,retain)  IBOutlet CashAndNetBankingCell *cashAndNetBankCell;
@property (nonatomic, retain) IBOutlet CreditAndDebitCardCell *creditAndDebitCell;
@property (nonatomic, retain) IBOutlet CreditCardCell *creditCardCell;

@property (nonatomic,retain) IBOutlet CreditCardCell_iPad *creditCardCelliPad;

@property (nonatomic,retain) IBOutlet StoredCardCell_iPhone *storedCard_iPhone;

@property (nonatomic,retain) IBOutlet StoredCardCell_iPad *storedCard_iPad;



@property (nonatomic,retain)IBOutlet UITextField *nameTextField,*cardNumberOneTextField,*cardNumberTwoTextField,*cardNumberThreeTextField,*cardNumberFourTextField,*cvvNumberTextField;


@property (nonatomic,retain)IBOutlet UITextField *CCnameTextField,*CCcardNumberOneTextField,*CCcardNumberTwoTextField,*CCcardNumberThreeTextField,*CCcardNumberFourTextField,*CCcvvNumberTextField;

@property (nonatomic,retain)    NSString *stringForComparingHeaders;

@property (nonatomic,retain)IBOutlet UITableView *listOfCardsTableView;
@property (nonatomic,retain)IBOutlet UIView *optionsView;

@property (nonatomic,retain)IBOutlet UITextField *outsideCountryFirstNameTF, *outsideCountryMiddleNameTF,*outsideCountryLastNameTF, *outsideCountryAddressTF,*outsideCountryCityTF,*outsideCountryPostalCodeTF;

@property (nonatomic,retain)IBOutlet UILabel *outsideCountryNameLabel;

@property (nonatomic,retain)IBOutlet UILabel *outsideCountryCountryNameLabel;
@property (nonatomic,retain)IBOutlet UIButton *countryNameButton;

@property (nonatomic,retain)IBOutlet UIView *cvvAvlView,*expiryDetailsView;

@property (nonatomic,retain)    IBOutlet UIButton *btnAvlOnCard,*btnNotAvlOnCard;

@property (nonatomic,retain) IBOutlet UITableView *listOfCountryTableView;
@property (nonatomic,retain) IBOutlet UIView *viewForCountryTableView;

@property (nonatomic,retain)IBOutlet UILabel *cardExpiryLabel;
@property (nonatomic,retain)NSString *selectedDate;

@property (nonatomic,assign)int channel;

@property (nonatomic,retain)NSString *paymentAmtString,*selectedCountryName;

@property (nonatomic,retain)NSString *descriptionString,*phoneNumberString;


@property (nonatomic,retain)NSMutableString *hashedString;

@property (nonatomic,retain)NSString *creditStringDate,*debitStringDate;

@property (nonatomic,retain)NSArray *genderArray;

@property (nonatomic,retain)IBOutlet UIView *genderView;
@property (nonatomic,retain)IBOutlet UITableView *genderTableView;
@property (nonatomic,retain)IBOutlet UILabel *genderSelectedLabel;

@property (nonatomic,retain)NSString *selectedStrForOutsideCountry;


@property (nonatomic,retain) IBOutlet CashAndNetBankingCell_iPad *iPadCashAndNetBankCell;
@property (nonatomic,retain) IBOutlet CreditCardCell_iPad *iPadCreditCardCell;
@property (nonatomic,retain) IBOutlet DebitCardCell_iPad *iPadDebitCardCell;


// Stored Cards
@property (nonatomic,retain)NSMutableDictionary *StoredCardDictionary;
@property (nonatomic,retain)NSString *is_storedCard_enabled;
@property (nonatomic,retain)NSString *Cvv_textfield;


@property (nonatomic,retain)  NSString *session;

@property(nonatomic,retain)NSString *reference_no;


@property (nonatomic,retain) NSString *PAYMENT_MODE;

@property (nonatomic,retain)NSMutableDictionary *sortDictionary;

// NSMutable Dictionary for sorting
@property (nonatomic,retain) NSMutableDictionary *dynamicDictionary;

@property (nonatomic,retain) NSMutableDictionary *dynamicKeyValueDictionary;


//Netbanking
@property (nonatomic,retain)NSMutableDictionary *netBankingArray;

//Activity Indicator
-(void)create_ActivityIndicator:(NSNumber*)isStart;

//Reachability
-(BOOL) checkNetworkAvailability;


@property (nonatomic,retain)UIImageView *radioimg;

- (IBAction)countryNameBtnClk:(id)sender;

- (IBAction)optionsDoneBtnClk:(id)sender;

- (IBAction)backButtonClk:(id)sender;

-(IBAction)btnInsideIndia:(id)sender;

-(IBAction)btnOutsideIndia:(id)sender;

- (IBAction)btnAvlOnCardClk:(id)sender;
- (IBAction)btnNotAvlOnCardClk:(id)sender;

- (IBAction)genderBtnClk:(id)sender;

- (IBAction)genderDoneBtnClk:(id)sender;

-(BOOL)validateCard:(NSString *)cardNumber;

- (BOOL)validateCardBrand:(NSString *)card_Brand :(NSString *)cardNumber;

-(IBAction)saveCard:(id)sender;


//@property (nonatomic,retain) IBOutlet UIButton *infoBtn;
@property (nonatomic,retain) IBOutlet UIButton *majorCardBtn ;
-(IBAction)infoBtn:(id)sender;
-(IBAction)infoCloseAction:(id)sender;

-(IBAction)cvv_ImageBtn:(id)sender;
-(IBAction)cvv_CloseAction:(id)sender;

@end
