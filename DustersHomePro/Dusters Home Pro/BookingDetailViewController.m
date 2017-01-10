#import "BookingDetailViewController.h"
#import "RescheduleBookingView.h"
#import "TotalCostDetailView.h"
#import "Postman.h"
#import "Constant.h"
#import "TotalCostDetailModel.h"
#import "RateView.h"
#import "BookedJobModel.h"
#import "GetImageModel.h"
#import "PaymentSummary.h"
#import "MBProgressHUD.h"
#import "UserAddressModel.h"

#import "SWRevealViewController.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import "MRMSiOS.h"
#import "PaymentModeViewController.h"
#import "VMEnvironment.h"

#define NULL_CHECKER(X) ([X isKindOfClass:[NSNull class]] ? nil : X)

@interface BookingDetailViewController ()<RateViewDelegate,UIAlertViewDelegate, PaymentSummaryDelegate>

@property (strong, nonatomic) IBOutlet UIView *CustomerDetailView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *TimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *representativeImageView;
@property (strong, nonatomic) IBOutlet UILabel *representativeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *reprasentativePhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *representativeAddressLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *navigationBackBarButton;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstantofRepresentativeDetail;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstantOfRescheduleButtonView;
@property (strong, nonatomic) IBOutlet UIView *representativeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *representiveLabelHeight;
@property (strong, nonatomic) IBOutlet UIView *cancelButtonView;
@property (strong, nonatomic) IBOutlet RateView *ratingView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ratingViewHeight;
@property (strong, nonatomic) IBOutlet UIControl *ratingControlView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ratingtextViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *subCatogryLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryName;
@property (strong, nonatomic) IBOutlet UITextView *ratingTextView;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ratingLabelHeight;
@property (strong, nonatomic) IBOutlet UIButton *submit;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *submitHeight;
@property (strong, nonatomic) IBOutlet UIView *simpleview;
@property (strong, nonatomic) IBOutlet UILabel *defaultLabel;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *summaryButton;
@property (weak, nonatomic) IBOutlet UIButton *rescheduleBotton;

@end

@implementation BookingDetailViewController
{
    RescheduleBookingView *rescheduleView;
    Postman *postman;
    NSMutableArray *detailArray,*loginDetailArray;
    UIAlertView *alertView2,*alertView1;
    float ratingValue;
    
    NSString *orderStatusCode;
    NSDateFormatter *dateFormatter;
    
    PaymentSummary *paymentSummary;
    
    UserAddressModel *userAddressModel;
    NSDictionary *paymentSuccessRespDict;
    
    NSArray *relatedOrders;
    
    BookingModel *previousModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc] init];
    [self navigationBackBarButtonSpacing];
    postman =[[Postman alloc]init];
    _ratingView.fullSelectedImage=[UIImage imageNamed:@"Rating-star-selected"];
    // _ratingView.halfSelectedImage=[UIImage imageNamed:@""];
    _ratingView.notSelectedImage=[UIImage imageNamed:@"Rating-star-unselected"];
    _ratingView.maxRating=5;
    _ratingView.editable=YES;
    _ratingView.midMargin=0;
    _ratingView.delegate = self;
    
    _ratingTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _ratingTextView.layer.borderWidth=1;
    _ratingTextView.layer.cornerRadius=5;

    [self registerForKeyboardNotifications];
    
    self.summaryButton.layer.cornerRadius = 5;
    self.summaryButton.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUIForModel];
    [self.revealViewController.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)updateUIForModel
{
    if (self.model.isParentOrder)
    {
        [self retriveChildOrdersFor:self.model.code];
    }
    [self defaultValues];
    [self setupDueUI];
    orderStatusCode = self.model.orderStatusCode;
    
    if ([orderStatusCode isEqualToString:openCode])
    {
        [self setForProcessing];
        
    }else if ([orderStatusCode isEqualToString:confirmedCode])
    {
        //Assigned - Reshedule and Cancelation
        [self setForAssinged:YES];
        
    }else if ([@[startCode, stopCode, IncpectionAcceptCode, InspectionStop] containsObject:orderStatusCode])
    {
        //Assigned (WITHOUT Reshedule and Cancelation)
        [self setForAssinged:NO];
        
    }else if ([@[IncpectionRejectCode, closedCode, PartialClose] containsObject:orderStatusCode])
    {
        [self setForCompleted];
        
    }else if ([orderStatusCode isEqualToString:cancelledCode])
    {
        [self setForCancelled];
    }

}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating
{
    if (rating<=3) {
        _ratingTextView.hidden=NO;
        _defaultLabel.hidden=NO;
        UIColor *color = [UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1];
        self.defaultLabel.attributedText =
        [[NSAttributedString alloc] initWithString:@"Please provide your feedback to improve our service" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName : [UIFont systemFontOfSize:15]}];
        _ratingViewHeight.constant=132;
        ratingValue = rating;
    }
    else{
        _ratingTextView.hidden=YES;
        _ratingViewHeight.constant=52;
        ratingValue = rating;
        _defaultLabel.hidden=YES;
    }
}


- (BOOL)shouldShowDueUI
{
    if (!self.model.isParentOrder)
        return NO;
    return [self.model dueOfAllRelatedOrder] > 0.001;
}

- (void)setupDueUI
{
    if ([self shouldShowDueUI])
    {
        [self.summaryButton setTitle:@"MAKE PAYMENT" forState:(UIControlStateNormal)];
        [self.summaryButton setImage:[UIImage imageNamed:@"make Payment"] forState:(UIControlStateNormal)];
        self.totalLabel.text = @"DUE";
        self.totalAmount.text = [NSString stringWithFormat:@"%@%.2f", kRUPPEE_SYMBOL, [self.model dueOfAllRelatedOrder]];
    }else
    {
        [self.summaryButton setTitle:@"PAYMENT SUMMARY" forState:(UIControlStateNormal)];
        [self.summaryButton setImage:[UIImage imageNamed:@"Payment Summary"] forState:(UIControlStateNormal)];
        self.totalLabel.text = @"TOTAL";
        self.totalAmount.text = [NSString stringWithFormat:@"%@%.2f", kRUPPEE_SYMBOL, [self.model totalAfterDiscount]];
    }
}

- (BOOL)hasTimePassedForCanceling
{
    NSInteger timeIntervel = [[NSDate date] timeIntervalSinceDate:self.model.plannedStartDate];
    NSLog(@"Cur %@ , %@", [NSDate date], self.model.plannedStartDate);
    BOOL passed = timeIntervel > -60*60;
    return passed;
}

- (void)setForProcessing
{
    _heightConstantofRepresentativeDetail.constant = 0;
    _ratingControlView.hidden = YES;
    _ratingLabel.hidden = YES;
    _submitHeight.constant = 0;
    _submit.hidden = YES;
    _ratingLabelHeight.constant = 0;
    _ratingViewHeight.constant = 0;
    _representiveLabelHeight.constant = 0;
    _representativeView.hidden = YES;
    _representativeDetailLabel.hidden = YES;
    
    if (self.model.isParentOrder)
    {
        [self.rescheduleBotton setTitle:@"Reshedule" forState:(UIControlStateNormal)];

        if ([self hasTimePassedForCanceling])
        {
            _cancelButtonView.hidden = YES;
            _heightConstantOfRescheduleButtonView.constant=0;
        }else
        {
            _cancelButtonView.hidden=NO;
            _heightConstantOfRescheduleButtonView.constant=40;
        }
    }else
    {
        _cancelButtonView.hidden=NO;
        _heightConstantOfRescheduleButtonView.constant=40;
        [self.rescheduleBotton setTitle:@"Take me to Parent order" forState:(UIControlStateNormal)];
    }
}

- (void)setForAssinged:(BOOL)orderDateChange
{
    _heightConstantofRepresentativeDetail.constant=86;
    _representiveLabelHeight.constant=21;
    _ratingLabel.hidden=YES;
    _ratingLabelHeight.constant=0;
    _ratingControlView.hidden=YES;
    _submitHeight.constant=0;
    _submit.hidden=YES;
    _ratingViewHeight.constant=0;
    _representativeView.hidden=NO;
    _representativeDetailLabel.hidden=NO;
    
    if (self.model.isParentOrder)
    {
        if (orderDateChange)
        {
            if ([self hasTimePassedForCanceling])
            {
                _cancelButtonView.hidden = YES;
                _heightConstantOfRescheduleButtonView.constant=0;
            }else
            {
                _cancelButtonView.hidden=NO;
                _heightConstantOfRescheduleButtonView.constant=40;
            }
        }else
        {
            _cancelButtonView.hidden = YES;
            _heightConstantOfRescheduleButtonView.constant=0;
        }
    }else
    {
        _cancelButtonView.hidden=NO;
        _heightConstantOfRescheduleButtonView.constant=40;
        [self.rescheduleBotton setTitle:@"Take me to Parent order" forState:(UIControlStateNormal)];
    }
}

- (void)setForCompleted
{
    _heightConstantofRepresentativeDetail.constant=86;
    _ratingControlView.hidden=NO;
    _ratingLabel.hidden=NO;
//    _submitHeight.constant=34;
//    _submit.hidden=NO;
    _ratingLabelHeight.constant=21;
    _ratingViewHeight.constant=52;
    _representiveLabelHeight.constant=21;
    _representativeView.hidden=NO;
    _representativeDetailLabel.hidden=NO;
    [self checkRating];
    
    if (self.model.isParentOrder)
    {
        _heightConstantOfRescheduleButtonView.constant=0;
        _cancelButtonView.hidden=YES;
    }
    else
    {
        _cancelButtonView.hidden=NO;
        _heightConstantOfRescheduleButtonView.constant=40;
        [self.rescheduleBotton setTitle:@"Take me to Parent order" forState:(UIControlStateNormal)];
    }
}

- (void)setForCancelled
{
    _heightConstantofRepresentativeDetail.constant=0;
    _ratingControlView.hidden=YES;
    _submitHeight.constant=0;
    _submit.hidden=YES;
    _ratingLabel.hidden=YES;
    _ratingLabelHeight.constant=0;
    _ratingViewHeight.constant=0;
    _representiveLabelHeight.constant=0;
    _representativeView.hidden=YES;
    _representativeDetailLabel.hidden=NO;
    if (self.model.isParentOrder)
    {
        _heightConstantOfRescheduleButtonView.constant=0;
        _cancelButtonView.hidden=YES;
    }
    else
    {
        _cancelButtonView.hidden=NO;
        _heightConstantOfRescheduleButtonView.constant=40;
        [self.rescheduleBotton setTitle:@"Take me to Parent order" forState:(UIControlStateNormal)];
    }
}

- (void)checkRating
{
    if (_model.rating>0)
    {
        _submit.hidden = YES;
        _submitHeight.constant = 0;
        _ratingControlView.userInteractionEnabled=NO;
        [_ratingView setRating:(int)_model.rating];
        _ratingTextView.hidden=YES;
        _ratingViewHeight.constant=52;
        _defaultLabel.hidden=YES;
    }
    else
    {
        _submit.hidden = NO;
        _submitHeight.constant = 34;
        _ratingControlView.userInteractionEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)defaultValues
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    loginDetailArray = [defaults valueForKey:@"login"];
    _categoryName.text=_model.categoryName;
    _subCatogryLabel.text = [self getSubCategoryName];
    self.address.text = [NSString stringWithFormat:@"%@, %@, %@",self.model.userAddressModel.street,self.model.userAddressModel.city,self.model.userAddressModel.pincode];
    
    dateFormatter.dateFormat = @"dd MMM YYYY";
    self.dateLabel.text = [dateFormatter stringFromDate:self.model.plannedStartDate];
    
    dateFormatter.dateFormat = @"hh:mm a";
    self.TimeLabel.text = [dateFormatter stringFromDate:self.model.plannedStartDate];
    _codeLabel.text= [NSString stringWithFormat:@"Order Code: %@", _model.code] ;
    
    if (self.model.serviceProviderCode)
    {
        self.reprasentativePhoneLabel.text = self.model.serviceProviderMobile;
        self.representativeImageView.image = nil;

        NSString *urlString = [NSString stringWithFormat:@"%@%@%@",base_url ,kUSER_DETAILS_URL, self.model.serviceProviderCode];
        [postman get:urlString withParameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if ([responseObject[@"Success"] boolValue])
                 {
                     NSDictionary *user = responseObject[@"User"];
                     self.model.serviceProviderMobile = user[@"MobileNumber"];
                     
                     NSDictionary *addressAt0 = [user[@"Address"][@"ViewModels"] firstObject];
                     if (addressAt0)
                     {
                         NSString *addressJSON = addressAt0[@"Address"];
                         NSData *addressData = [addressJSON dataUsingEncoding:NSUTF8StringEncoding];
                         NSDictionary *addressDict = [NSJSONSerialization JSONObjectWithData:addressData
                                                                                     options:kNilOptions
                                                                                       error:nil];
                         if (addressDict)
                         {
                             if (addressDict[@"StreetLine2"])
                             {
                                 self.model.serviceProviderAdress = [NSString stringWithFormat:@"%@,%@,%@-%@", addressDict[@"StreetLine1"], addressDict[@"StreetLine2"], addressDict[@"City"],addressDict[@"Pincode"]];
                             }else
                             {
                                 self.model.serviceProviderAdress = [NSString stringWithFormat:@"%@,%@-%@", addressDict[@"StreetLine1"], addressDict[@"City"],addressDict[@"Pincode"]];
                             }
                         }
                     }
                     
                     self.model.imageData = user[@"DocumentDetails"];
                     
                     if (self.model.imageData)
                     {
                         if (self.model.serviceProviderImage == nil)
                         {
                             GetImageModel *getImage = [[GetImageModel alloc] init];
                             [getImage getJsonData:self.model.imageData
                                        onComplete:^(UIImage *image) {
                                            self.model.serviceProviderImage = image;
                                            self.representativeImageView.image = image;
                                        } onError:^(NSError *error) {
                                            self.representativeImageView.image = nil;
                                        }];
                         }else
                         {
                             self.representativeImageView.image = self.model.serviceProviderImage;
                         }
                     }
                     
                     self.model.serviceProviderAdress = self.model.serviceProviderAdress;
                     self.reprasentativePhoneLabel.text = self.model.serviceProviderMobile;
                     self.representativeAddressLabel.text = self.model.serviceProviderAdress;

                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
             }];
    }
    
    self.representativeNameLabel.text = self.model.serviceProviderName;
    
}

- (IBAction)Reschedule:(id)sender
{
    if (self.model.isParentOrder)
    {
        [self refreshOrderFor:self.model.code withCompletion:^(BOOL success) {
            if (success)
            {
                if (self.model.canReschedule)
                {
                    if (rescheduleView==nil)
                    {
                        rescheduleView =[[RescheduleBookingView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+5,100, self.view.frame.size.width-100,214)];
                    }
                    rescheduleView.model=_model;
                    [rescheduleView showXibView];
                    rescheduleView.delegate=self;
                }else
                {
                    [self toastMessage:@"This order can not be rescheduled"];
                }
            }else
            {
                [self toastMessage:@"Some error occured. Please try again."];
            }
        }];
    }else
    {
        [self refreshOrderFor:self.model.referenceCode withCompletion:^(BOOL success) {
            
        }];
    }
}

- (void)refreshModel:(NSString *)orderCode with:(void (^)(BOOL, BookingModel *))completionHHandler
{
    [self refreshOrderFor:orderCode withCompletion:^(BOOL success) {
        completionHHandler(success, self.model);
    }];
}

- (void)popToMyBooking
{
    [self toastMessage:@"Your Order has been Rescheduled."];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)call:(id)sender
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:_reprasentativePhoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)getHeightOfRatingView:(CGFloat)frameHeight
{
    _ratingViewHeight.constant=frameHeight;
}

- (IBAction)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBackBarButtonSpacing
{
    UIBarButtonItem *fixedbarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedbarbutton.width=-10;
    self.navigationItem.leftBarButtonItems=@[fixedbarbutton,_navigationBackBarButton];
}


- (IBAction)gestureRecg:(id)sender
{
    [_ratingTextView endEditing:YES];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect,_totalCostDetailView .frame.origin) ) {
//        [self.scrollView scrollRectToVisible:_totalCostDetailView.frame animated:YES];
//    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
- (NSString*)getSubCategoryName
{
    return self.model.orderName;
}

//- (void)toastMessageInWindow:(NSString *)message
//{
//    
//    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hubHUD.mode=MBProgressHUDModeText;
//    hubHUD.detailsLabelText= message;
//    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
//    hubHUD.margin=20.f;
//    hubHUD.yOffset=150.f;
//    hubHUD.removeFromSuperViewOnHide = YES;
//    [hubHUD hide:YES afterDelay:1];
//}

- (void)toastMessage:(NSString *)message
{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText= message;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:3];
}

- (IBAction)submit:(id)sender
{
    if (self.ratingTextView.text.length == 0 && self.ratingView.rating <= 3)
    {
        [self toastMessage:@"Please provide your feedback."];
        return;
    }
    
    NSString *url=[NSString stringWithFormat:@"%@%@%@",base_url,ratingUrl,_model.code];
    NSString *parameter=[NSString stringWithFormat:@"{\"Rating\": \"%f\",\"RatedBy\": \"%@\",\"FeedBack\":\"%@\",\"RatedTo\":\"%li\",\"Status\": 1,\"UserID\": %@}",ratingValue,loginDetailArray[3],_ratingTextView.text, (long)self.model.serviceProviderId,loginDetailArray[3]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self processRating:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)processRating:(id)responseObject
{
    NSString *message;
    NSDictionary *dict=responseObject;
    if ([dict[@"Success"] integerValue]==1) {
        message = @"Thanks for rating";
        self.model.rating = ratingValue;
        ratingValue = 0;
        [self checkRating];
    }else
    {
        message = responseObject[@"Message"];
    }
    
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.labelText= message;
    hubHUD.labelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:1];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.defaultLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.defaultLabel.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.defaultLabel.hidden = ([txtView.text length] > 0);
}

- (IBAction)showPaymentDetails:(UIButton *)sender
{
    if (self.model.relatedOrders.count == 0 && self.model.isParentOrder)
    {
        [self toastMessage:@"Some error occured. Please refresh and try again later."];
        return;
    }
    if (!paymentSummary)
    {
        paymentSummary = [[PaymentSummary alloc] initWithFrame:(CGRectMake(0, 0, 300, 250))];
        paymentSummary.delegate = self;
    }
    paymentSummary.bookingModel = self.model;
    [paymentSummary show];
}

- (void)successfullyPayedDue:(PaymentSummary *)summary
{
    [self refreshOrderFor:self.model.code withCompletion:^(BOOL success) {
        
    }];
}

- (void)payDueBtnTapped:(PaymentSummary *)summery
{
    if (!self.model.isParentOrder)
    {
        [self toastMessage:@"Can make payment only on Main Order."];
        return;
    }
    
    previousModel = self.model;
    [self refreshModel:self.model.code with:^(BOOL success, BookingModel *bookingModel) {
        if (success)
        {
            self.model = bookingModel;
            [paymentSummary hide];
            
            if ([@[stopCode, InspectionStop] containsObject:orderStatusCode])
            {
                if ([bookingModel dueOfAllRelatedOrder] == [previousModel dueOfAllRelatedOrder])
                {
                    previousModel = nil;
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(responseNew:)
                                                                 name:@"PAYMENT_SUCCESSFUL_NOTIFICATION"
                                                               object:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(responseNew:)
                                                                 name:@"PAYMENT_CANCEL_NOTIFICATION"
                                                               object:nil];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(responseNew:)
                                                                 name:@"JSON_NEW"
                                                               object:nil];
                    
                    [self buyAction];
                }else
                {
                    paymentSummary.bookingModel = bookingModel;
                    [paymentSummary show];
                    [self toastMessage:@"There had been change in Due."];
                    
                }
            }else
            {
                [self toastMessage:@"Please wait till the service is finished."];
            }
            
        }else
        {
            [self toastMessage:@"Some error occurred. Please try again."];
        }
    }];
}



- (void)buyAction
{
    PaymentModeViewController *paymentView = [[PaymentModeViewController alloc] init];
    paymentView.strSaleAmount = [NSString stringWithFormat:@"%.2f",[self.model dueOfAllRelatedOrder]];//Edit
    paymentView.reference_no = self.model.code;//Edit
    paymentView.paymentAmtString = [NSString stringWithFormat:@"%.2f",[self.model dueOfAllRelatedOrder]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%.2f",[self.model dueOfAllRelatedOrder]] forKey:@"strSaleAmount"];//Edit
    [defaults setObject:self.model.code forKey:@"reference_no"];//Edit
    NSString *fromPayNowKey = [NSString stringWithFormat:@"%@_fromPayNowKey", self.model.code];
    [defaults setBool:NO forKey:fromPayNowKey];

    [defaults synchronize];
    
    paymentView.descriptionString = @"DUSTERS TOTAL SOLUTIONS SERVICES PVT LTD";
    paymentView.strCurrency = @"INR";
    paymentView.strDisplayCurrency = @"INR";
    paymentView.strDescription = @"Test Description";
    
    userAddressModel = self.model.userAddressModel;
    NSArray *userDetails = [defaults objectForKey:@"login"];//0. name, 1.Mobile, 2.EmailID, 3.ID, 4.Code
    paymentView.strBillingName = @"Test";
    paymentView.strBillingAddress = [NSString stringWithFormat:@"%@ %@",userAddressModel.street, userAddressModel.area];
    paymentView.strBillingCity = userAddressModel.city;
    paymentView.strBillingState = @"";
    paymentView.strBillingPostal = userAddressModel.pincode;
    paymentView.strBillingCountry = @"IND";
    paymentView.strBillingEmail = userDetails[2];
    paymentView.strBillingTelephone = userDetails[1];
    
    paymentView.strDeliveryName = @"";
    paymentView.strDeliveryAddress = @"";
    paymentView.strDeliveryCity = @"";
    paymentView.strDeliveryState = @"";
    paymentView.strDeliveryPostal =@"";
    paymentView.strDeliveryCountry = @"";
    paymentView.strDeliveryTelephone =@"";
    

    [self.revealViewController.navigationController pushViewController:paymentView animated:NO];
}

- (void)responseNew:(NSNotification *)message
{
    if ([message.name isEqualToString:@"PAYMENT_SUCCESSFUL_NOTIFICATION"])
    {
        [self.revealViewController.navigationController popToViewController:self.revealViewController animated:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSLog(@"Response = %@",[message object]);
        
    }else if ([message.name isEqualToString:@"JSON_NEW"])
    {
        NSDictionary *dict = [message object];
        if (dict[@"error"] == nil)
        {
            if ([dict[@"ResponseCode"] integerValue] == 0)
            {
                paymentSuccessRespDict = [message object];
                [self updatePaymentStatus];
            }
        }else
        {
            NSLog(@"Error in Payment gate way...");
        }
    }else if ([message.name isEqualToString:@"PAYMENT_CANCEL_NOTIFICATION"])
    {
        [self.revealViewController.navigationController popToViewController:self.revealViewController animated:NO];
    }
}

- (void)updatePaymentStatus
{
    if (postman == nil)
    {
        postman = [[Postman alloc] init];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", base_url, kUPDATE_ORDER_URL, self.model.code];
    NSMutableDictionary *jsonDict = [self.model.extraJSONDict mutableCopy];
    NSMutableDictionary *transactionMutDict = [jsonDict[@"TransactionDetails"] mutableCopy];
    transactionMutDict[@"DueAmount"] = @0;
    NSMutableArray *paymentArray = [transactionMutDict[@"PaymentDetails"] mutableCopy];
    [paymentArray addObject:@{@"PaymentType": kONLINE_PAYMENT_CODE, @"Amount":@([self.model dueOfAllRelatedOrder])}];
    transactionMutDict[@"PaymentDetails"] = paymentArray;
    jsonDict[@"TransactionDetails"] = transactionMutDict;
    
    NSMutableDictionary *parameterdict = [@{@"CategoryCode":self.model.categoryCode, @"CustomerId":@(self.model.customerID), @"UserID":@(self.model.customerID), @"JSON":jsonDict, @"OrderStatusCode":self.model.orderStatusCode, @"PaymentStatusCode":kPAYMENT_STATUS_PAYED_CODE} mutableCopy];
    if (self.model.serviceProviderId)
    {
        parameterdict[@"ServiceProviderId"] = [NSString stringWithFormat:@"%li", (long)self.model.serviceProviderId];
    }
    
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:parameterdict options:kNilOptions error:nil];
    NSString *parameter = [[NSString alloc] initWithData:parameterData encoding:NSUTF8StringEncoding];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [postman put:urlString withParameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"%@", [operation responseString]);
             [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
             [self parseUpdatePaymentResponse:responseObject];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@", error);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYMENT_COMPLETED_FAILURE"
                                                                 object:nil
                                                               userInfo:nil];
             [self toastMessage:@"Some error occurred. Please try again."];
             [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
         }];
}

- (void)parseUpdatePaymentResponse:(id)response
{
    if ([response[@"Success"] boolValue])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYMENT_COMPLETED_SUCCESS"
                                                            object:nil
                                                          userInfo:nil];

    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYMENT_COMPLETED_FAILURE"
                                                            object:nil
                                                          userInfo:nil];

        [self toastMessage:response[@"Message"]];
    }
}

- (void)updateUI
{
    [self setupDueUI];
}

- (void)refreshOrderFor:(NSString *)orderCode withCompletion:(void(^)(BOOL success))completionHandler
{
    NSString *url=[NSString stringWithFormat:@"%@%@",base_url,searchOrderURL];
    NSString *parameter=[NSString stringWithFormat:@"{\"OrderCode\":\"%@\",\"CustomerId\": \"\",\"ServiceProviderId\": \"\",\"OrderStatusCode\": \"\"}",orderCode];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:url withParameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              self.model = [[self processResponseData:responseObject] firstObject];
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              [self updateUIForModel];
              completionHandler(YES);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              completionHandler(NO);
          }];
}

- (NSArray *)processResponseData:(id)responseObject
{
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    NSDictionary *dict=responseObject;
    if([dict[@"Success"]integerValue]==1)
    {
        NSArray *array=dict[@"ViewModels"];
        for(NSDictionary *dictionary in array)
        {
            BookingModel *model = [[BookingModel alloc] init];

            if(![dictionary[@"OrderStatusCode"] isEqualToString:rescheduleCode])
            {
                
                NSString *dateTimeString= NULL_CHECKER(dictionary[@"PlannedStartTime"]);
                NSArray *seperatedDate=[dateTimeString componentsSeparatedByString:@"T"];
                [dateFormatter setDateFormat:@"YYYY-MM-dd"];
                NSDate *date=[dateFormatter dateFromString:seperatedDate[0]];
                [dateFormatter setDateFormat:@"dd MMMM"];
                NSString *str=[dateFormatter stringFromDate:date];
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                NSDate *time=[dateFormatter dateFromString:seperatedDate[1]];
                [dateFormatter setDateFormat:@"hh:mm a"];

                NSString *str1=[dateFormatter stringFromDate:time];
                
                model.code = NULL_CHECKER(dictionary[@"Code"]);
                model.date = NULL_CHECKER(dictionary[@"PlannedStartTime"]);
                model.orderStatusCode = NULL_CHECKER(dictionary[@"OrderStatusCode"]);
                model.dateAndTime = [NSString stringWithFormat:@"%@, %@",str,str1];
                model.categoryStartTime = [self dateForString:dictionary[@"CategoryStartTime"] forFormat:@"HH:mm:ss"];
                model.categoryEndTime = [self dateForString:dictionary[@"CategoryEndTime"] forFormat:@"HH:mm:ss"];
                model.plannedStartDate = [self dateForString:dictionary[@"PlannedStartTime"] forFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                model.categoryCode = NULL_CHECKER(dictionary[@"CategoryCode"]);
                model.categoryName = NULL_CHECKER(dictionary[@"CategoryName"]);
                
                model.serviceProviderId = [NULL_CHECKER(dictionary[@"ServiceProviderId"]) integerValue];
                model.serviceProviderCode = NULL_CHECKER(dictionary[@"ServiceProviderCode"]);
                model.serviceProviderName = NULL_CHECKER(dictionary[@"ServiceProviderName"]);
                model.estPrice = [NULL_CHECKER(dictionary[@"EstPrice"]) floatValue];
                model.actPrice = [NULL_CHECKER(dictionary[@"ActPrice"]) floatValue];
                model.estHours = [NULL_CHECKER(dictionary[@"EstHours"]) floatValue];
                
                model.customerCode = NULL_CHECKER(dictionary[@"CustomerCode"]);
                model.customerID = [NULL_CHECKER(dictionary[@"CustomerId"]) integerValue];
                model.customerName = NULL_CHECKER(dictionary[@"CustomerName"]);
                
                model.isParentOrder = [NULL_CHECKER(dictionary[@"IsParentOrder"]) boolValue];
                model.referenceCode = NULL_CHECKER(dictionary[@"ReferenceOrderCode"]);
                
                model.totalOfAll = [NULL_CHECKER(dictionary[@"TotalOrderPrice"]) floatValue];
                
                model.canReschedule = [NULL_CHECKER(dictionary[@"CanReschedule"]) boolValue];

                model.isInspection = [NULL_CHECKER(dictionary[@"IsInspection"]) boolValue];

                if (NULL_CHECKER(dictionary[@"Rating"]) != [NSNull null])
                {
                    model.rating=[NULL_CHECKER(dictionary[@"Rating"])intValue];
                }
                
                NSString *address=NULL_CHECKER(dictionary[@"Address"]);
                if (address)
                {
                    NSData *JsonData=[address dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:JsonData options:kNilOptions error:nil];
                    model.userAddressModel=[[UserAddressModel alloc]init];
                    model.userAddressModel.street=jsonDict[@"StreetLine1"];
                    model.userAddressModel.street2=jsonDict[@"StreetLine2"];
                    model.userAddressModel.city=jsonDict[@"City"];
                    model.userAddressModel.cityCode = jsonDict[@"citycode"];

                    model.userAddressModel.pincode=jsonDict[@"Pincode"];
                }
                NSDictionary *jobDict=NULL_CHECKER(dictionary[@"Jobs"]);
                model.jobsArray = [self arrayOfJobs:jobDict[@"ViewModels"]];
                
                NSString *jsonExtra = NULL_CHECKER(dictionary[@"JSON"]);
                if (jsonExtra)
                {
                    NSData *jsonExtraData = [jsonExtra dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *jsonExtraDict = [NSJSONSerialization JSONObjectWithData:jsonExtraData
                                                                                  options:kNilOptions
                                                                                    error:nil];
                    model.extraJSONDict = jsonExtraDict;
                    model.taxForOrder = [NULL_CHECKER(jsonExtraDict[@"TaxDetails"][@"ServiceTax"]) floatValue];
                    
                    model.hasCoupon = [NULL_CHECKER(jsonExtraDict[@"CouponDetails"][@"HasCoupon"]) boolValue];
                    
                    if (model.hasCoupon)
                    {
                        NSDictionary *couponDict = jsonExtraDict[@"CouponDetails"];
                        model.couponCode = couponDict[@"CouponCode"];
                        model.couponPercentage = [couponDict[@"CouponPercent"] floatValue];
                        if (model.isParentOrder)
                        {
                            model.couponValue = [couponDict[@"CouponValue"] floatValue];
                        }else
                        {
                            CGFloat initTotal = [self initialEstPriceFromJobsFor:model];
                            initTotal += initTotal * model.taxForOrder/100;
                            model.couponValue = initTotal * model.couponPercentage / 100;
                        }
                    }
                    
                    model.discountGiven = [NULL_CHECKER(jsonExtraDict[@"DiscountDetails"]) floatValue];

                    model.dueAmount = [NULL_CHECKER(jsonExtraDict[@"TransactionDetails"][@"DueAmount"]) floatValue];
                    model.paymentsArray = NULL_CHECKER(jsonExtraDict[@"TransactionDetails"][@"PaymentDetails"]);
                    model.orderName = NULL_CHECKER(jsonExtraDict[@"JobName"]);
                }
                [mutArray addObject:model];
            }
        }
    }
    
    return mutArray;
}

- (CGFloat)initialEstPriceFromJobsFor:(BookingModel *)model
{
    CGFloat total = 0.0;
    for (BookedJobModel *jobModel in model.jobsArray)
    {
        total += jobModel.estPrice;
    }
    
    return total;
}

- (NSDate *)dateForString:(NSString *)dateString forFormat:(NSString *)format;
{
    //2015-11-02T15:00:00
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:dateString];
}

- (NSArray *)arrayOfJobs:(NSArray *)jobsResponse
{
    if ([jobsResponse isKindOfClass:[NSArray class]])
    {
        NSMutableArray *jobsArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in jobsResponse)
        {
            BookedJobModel *job = [[BookedJobModel alloc] init];
            job.jobID = [NULL_CHECKER(dict[@"Id"]) integerValue];
            job.code = NULL_CHECKER(dict[@"Code"]);
            job.orderCode = NULL_CHECKER(dict[@"OrderCode"]);
            job.categoryCode = NULL_CHECKER(dict[@"CategoryCode"]);
            job.subCategoryCode = NULL_CHECKER(dict[@"SubCategoryCode"]);
            job.serviceTypeCode = NULL_CHECKER(dict[@"ServiceTypeCode"]);
            job.optionCode = NULL_CHECKER(dict[@"OptionCode"]);
            job.categoryName = NULL_CHECKER(dict[@"CategoryName"]);
            job.subCategoryName = NULL_CHECKER(dict[@"SubCategoryName"]);
            job.serviceTypeName = NULL_CHECKER(dict[@"ServiceTypeName"]);
            job.optionName = NULL_CHECKER(dict[@"OptionName"]);
            
            job.hourlyRate = [NULL_CHECKER(dict[@"HourlyPrice"]) floatValue];
            job.estPrice = [NULL_CHECKER(dict[@"EstPrice"]) floatValue];
            
            NSString *durationInString = NULL_CHECKER(dict[@"Duration"]);
            NSArray *splitValues = [durationInString componentsSeparatedByString:@":"];
            if (splitValues.count == 3)
            {
                job.serviceDurationInMins = [splitValues[0] integerValue]*60 + [splitValues[1] integerValue];
            }
            
            [jobsArray addObject:job];
        }
        
        return jobsArray;
    }
    
    return nil;
}

- (void)retriveChildOrdersFor:(NSString *)refrenceCode
{
    NSString *url = [NSString stringWithFormat:@"%@%@",base_url,searchOrderURL];
    NSString *parameter = [NSString stringWithFormat:@"{\"OrderCode\":\"\",\"CustomerId\": \"\",\"ServiceProviderId\": \"\",\"OrderStatusCode\": \"\",\"ReferenceOrderCode\":\"%@\" }",refrenceCode];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [postman post:url withParameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              self.model.relatedOrders = [self processResponseData:responseObject];
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              
          }];

}

@end
