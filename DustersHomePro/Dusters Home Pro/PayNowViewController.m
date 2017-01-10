#import "PayNowViewController.h"
#import "TotalCostDetailView.h"
#import "OptionModel.h"
#import "TypeModel.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "Postman.h"
#import "SubCategoryModel.h"
#import "BookingSummaryView.h"
#import "ServicesSelectionViewController.h"
#import "TaxManager.h"
#import "SWRevealViewController.h"
#import "BookingModel.h"
#import "AppDelegate.h"
#import "PaymentSuccessViewController.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import "MRMSiOS.h"
#import "PaymentModeViewController.h"
#import "VMEnvironment.h"

#define NULL_CHECKER(X) ([X isKindOfClass:[NSNull class]] ? nil : X)

@interface PayNowViewController ()<UITextFieldDelegate,heightOfCostDetailView,UIAlertViewDelegate,payNowProtocol>
@property (weak, nonatomic) IBOutlet UIButton *payNow;
@property (weak, nonatomic) IBOutlet UIButton *payLater;
//@property (strong, nonatomic) IBOutlet UITextField *accountNumberTF;
//@property (strong, nonatomic) IBOutlet UITextField *accountNumber1TF;
//@property (strong, nonatomic) IBOutlet UITextField *acct2TF;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;
@end

@implementation PayNowViewController
{
    UIControl *activeField;
    Postman *postman;
    BookingSummaryView *bookingView;
    UIAlertView *successAlert;
    
    __block NSInteger completedBookingCount;
    __block NSInteger successfulBookingCount;
    NSInteger totalOrdersToCreate;
    
    NSDictionary *paymentSuccessRespDict;
    
    AppDelegate *appDel;
    NSDateFormatter *formatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    [self navigationBackBarButtonSpacing];
//    [self textFieldPadding];
    [self registerForKeyboardNotifications];
    _totalCost.delegateForHeightofCostDetailView = self;
    _totalCost.catModel = self.categoryModel;
    postman = [[Postman alloc]init];
    [self serviceData];

    [self.proceedButton setTitle:@"Book Now" forState:(UIControlStateNormal)];
    self.payLater.selected=YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseNew:) name:@"PAYMENT_SUCCESSFUL_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseNew:) name:@"PAYMENT_CANCEL_NOTIFICATION" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseNew:)
                                                 name:@"JSON_NEW"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JSON_DICT"
                                                        object:nil
                                                      userInfo:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=_categoryModel.name;
    
    self.revealViewController.navigationController.navigationBarHidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)payNow:(id)sender
{
    [self.proceedButton setTitle:@"Pay Now" forState:(UIControlStateNormal)];

    self.payNow.selected=YES;
    self.payLater.selected=NO;
}

- (IBAction)paylater:(id)sender
{
    [self.proceedButton setTitle:@"Book Now" forState:(UIControlStateNormal)];

    self.payLater.selected=YES;
    self.payNow.selected=NO;
}

//- (void)textFieldPadding
//{
//    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
//    _accountNumber1TF.leftView=view;
//    _accountNumber1TF.leftViewMode=3;
//    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
//    _accountNumberTF.leftView=view1;
//    _accountNumberTF.leftViewMode=3;
//    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
//    _acct2TF.leftView=view2;
//    _acct2TF.leftViewMode=3;
//    _accountNumber1TF.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    _accountNumber1TF.layer.borderWidth=1;
//    _accountNumber1TF.layer.cornerRadius=5;
//    _acct2TF.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    _acct2TF.layer.borderWidth=1;
//    _acct2TF.layer.cornerRadius=5;
//    _accountNumber1TF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"25/22"attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1]}];
//    _accountNumberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"58xxxxxxxxxxxxxxxxxxx"attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1]}];
//    _acct2TF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"xxx"attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1]}];
//}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)navigationBackBarButtonSpacing{
    UIBarButtonItem *fixedbarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedbarbutton.width=-10;
    self.navigationItem.leftBarButtonItems=@[fixedbarbutton,_navigationBackBarButton];
}

- (IBAction)gestureRecognizer:(id)sender {
    [self.view endEditing:YES];
}

- (void)getHeightOfCostDetailView:(CGFloat)frameHeight{
    _totalCostDetailViewHeight.constant=frameHeight;
}

- (void)serviceData{
    self.totalCost.detailArray = [self.categoryModel totalCostDetailObjects];
    [self.totalCost updateView];
}

- (IBAction)paynow:(id)sender
{
    if(!([self.payNow isSelected] | [self.payLater isSelected]))
    {
        [self toastMessage:@"Select payment"];
    }
    else {
        if (bookingView==nil)
            bookingView=[[BookingSummaryView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10, 100, self.view.frame.size.width-20,self.view.frame.size.height-100)];
        
        if([self.payLater isSelected])
            bookingView.buttonTitle=@"Book Now";
        else
            bookingView.buttonTitle=@"Proceed To Pay";
        
        bookingView.selectTimeAndDate=@[_selectedTimeAndDate[0],_selectedTimeAndDate[1]];
        bookingView.userModel=_userAddressModel;
        bookingView.totalCostString=_totalCost.totalCost.text;
        bookingView.categoryModel = self.categoryModel;
        bookingView.delegateForPayNow=self;
        bookingView.delegate=self;
        [bookingView showView];

    }
}

- (void)makeOrder
{
   // NSArray *groupJobs = [self groupJobs];
    NSArray *groupJobs = [self jobsInArray];
    
    totalOrdersToCreate = groupJobs.count;
    completedBookingCount = 0;
    successfulBookingCount = 0;
    
    NSString *url=[NSString stringWithFormat:@"%@%@",base_url,orderItemURL];
    NSString *parameter = [self parameterForJobs:groupJobs withRefCode:nil];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];

        if ([responseObject[@"Success"] intValue]==1)
        {
            if (responseObject[@"ServiceAvailable"] == nil)
            {
                _categoryModel.orderCode = responseObject[@"Code"];
                
                if ([self.payNow isSelected])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self BuyAction:nil];
                    });
                }else
                {
//                    successAlert =[[UIAlertView alloc]initWithTitle:@"Booked" message:@"Booking completed." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                    [successAlert show];
                    
                    [self performSegueWithIdentifier:@"BookNowSuccessSegue" sender:self];
                }
                
            }else
            {
                [self toastMessage:responseObject[@"Message"]];
            }
        } else
        {
            [self toastMessage:responseObject[@"Message"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completedBookingCount ++;
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

- (NSString *)parameterForJobs:(NSArray *)jobs withRefCode:(NSString *)refCode
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *loginarray=[defaults valueForKey:@"login"];
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc]init];
    }
    [formatter setDateFormat:@"dd MMM yyyy"];
    NSDate *date=[formatter dateFromString:_selectedTimeAndDate[1]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[formatter stringFromDate:date];
    [formatter setDateFormat:@"hh:mm a"];
    NSDate *selectedTime = [formatter dateFromString:_selectedTimeAndDate[0]];
    [formatter setDateFormat:@"HH:mm:s"];
    NSString *selectedTimeString = [formatter stringFromDate:selectedTime];
    NSString *plannedStartTime = [NSString stringWithFormat:@"%@ %@",dateString,selectedTimeString];
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];
    parameterDict[@"CategoryCode"] = _categoryModel.code;
    parameterDict[@"CustomerId"] = loginarray[3];
    parameterDict[@"OrderStatusCode"] = @"PXR1Y5";
    parameterDict[@"PlannedStartTime"] = plannedStartTime;
    parameterDict[@"PaymentStatusCode"] = [self.payNow isSelected] ? kPAYMENT_STATUS_PENDING_CODE:kPAYMENT_STATUS_DUE_CODE;

    // need to add city code
    parameterDict[@"Address"] = @{@"StreetLine1":_userAddressModel.street, @"StreetLine2": _userAddressModel.street2,@"City": _userAddressModel.city,@"State": @"",@"Country": @"",@"Pincode":_userAddressModel.pincode, @"citycode":_userAddressModel.cityCode};
    
    parameterDict[@"Status"] = @"1";
    parameterDict[@"UserID"] = loginarray[3];
    
    parameterDict[@"OrderMethodCode"] = @"E7KSHJ";

    CGFloat estimatedPriceOfJob = 0.0;

    for (NSDictionary *jobDict in jobs)
    {
        estimatedPriceOfJob += [jobDict[@"EstPrice"] floatValue];
    }

//    parameterDict[@"EstPrice"] = [NSString stringWithFormat:@"%.2f", estimatedPriceOfJob];
    parameterDict[@"EstPrice"] = @(estimatedPriceOfJob);
    parameterDict[@"ActPrice"] = @([_categoryModel totalCostAfterDisount]);

    __block CGFloat currentTax = 0.0;

    [[TaxManager sharedInstance] currentTax:^(BOOL success, CGFloat tax) {
        currentTax = tax;
    }];
    
    NSDictionary *taxDetails = @{@"ServiceTax": [NSString stringWithFormat:@"%.2f",currentTax]};
    CGFloat priceIncludingTax = estimatedPriceOfJob + estimatedPriceOfJob*currentTax/100;
    CGFloat copounValue = priceIncludingTax * _categoryModel.couponDiscountPercentage/100;
    
    NSDictionary *coupon = @{@"HasCoupon":@(_categoryModel.hasAppliedCoupon), @"CouponCode": _categoryModel.couponCode?:@"", @"CouponPercent":[@(_categoryModel.couponDiscountPercentage) description], @"CouponValue":@(copounValue)};
    
    CGFloat totalAfterDisount = priceIncludingTax - copounValue;
    
    NSMutableDictionary *payment = [@{@"DueAmount":@(totalAfterDisount), @"PaymentDetails":@[]} mutableCopy];
    
    BOOL isInspection = NO;

    parameterDict[@"JSON"] = @{@"CouponDetails": coupon, @"TaxDetails":taxDetails, @"TransactionDetails": payment, @"IsInspection":@(isInspection), @"DiscountDetails":@0, @"ExtraHoursCount":@0, @"JobName": @"", @"InitialActAmount": [@([_categoryModel totalCostAfterDisount]) description]};

    parameterDict[@"Jobs"] = jobs;
    
    if (refCode)
    {
        parameterDict[@"ReferenceOrderCode"] = refCode;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterDict options:kNilOptions error:nil];
    NSString *parameter = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return parameter;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([successAlert isEqual:alertView])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (NSArray *)jobsInArray
{
    NSMutableArray *JobsModelArray =[[NSMutableArray alloc]init];
    for (SubCategoryModel *submodel in _categoryModel.selectedSubCats) {
        BOOL multiselection = submodel.multiSelection;
        if (multiselection == YES) {
            for (TypeModel *typeModel in submodel.typeModels) {
                if (typeModel.selected==YES)
                {
                    [JobsModelArray addObject:[self jobDictFor:typeModel andSubCat:submodel]];
                }
            }
        } else {
            
            NSInteger selectedType=submodel.selectedTypeIndex;
            TypeModel *typeModel=submodel.typeModels[selectedType];
            [JobsModelArray addObject:[self jobDictFor:typeModel andSubCat:submodel]];
        }
    }
    return JobsModelArray;
}

- (NSDictionary *)jobDictFor:(TypeModel *)typeModel andSubCat:(SubCategoryModel *)submodel
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *loginarray=[defaults valueForKey:@"login"];

    NSInteger selectedOtion=typeModel.selectedOptionIndex;
    OptionModel *optionModel=typeModel.optionModels[selectedOtion];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"CategoryCode"] =_categoryModel.code;
    dict[@"SubCategoryCode"] =submodel.code;
    dict[@"ServiceTypeCode"] =typeModel.code;
    dict[@"OptionCode"] = optionModel.code;
    dict[@"EstPrice"] = @(optionModel.servicePrice);

    dict[@"Status"] = @(1);
    dict[@"UserID"] = loginarray[3];

    // adding parameter in job array
    
    dict[@"CategoryName"] = self.categoryModel.name;
    dict[@"SubCategoryName"] = submodel.serviceTitle;
    dict[@"ServiceTypeName"] = typeModel.serviceTitle;
    dict[@"OptionName"] = optionModel.serviceTitle;
    
    dict[@"CategoryInspection"] = @(NO);
    dict[@"SubCategoryInspection"] = @(NO);
    dict[@"ServiceTypeInspection"] = @(NO);
    dict[@"OptionInspection"] = @(NO);

    dict[@"IsInspection"] = @(NO);

    if (_categoryModel.isInspectionRequired)
    {
        dict[@"CategoryInspection"] = @(YES);
        dict[@"SubCategoryInspection"] = @(YES);
        dict[@"ServiceTypeInspection"] = @(YES);
        dict[@"OptionInspection"] = @(YES);
        dict[@"IsInspection"] = @(YES);

    }else if (submodel.isInspectionRequired)
    {
        dict[@"SubCategoryInspection"] = @(YES);
        dict[@"ServiceTypeInspection"] = @(YES);
        dict[@"OptionInspection"] = @(YES);
        dict[@"IsInspection"] = @(YES);

    }else if (typeModel.isInspectionRequired)
    {
        dict[@"ServiceTypeInspection"] = @(YES);
        dict[@"OptionInspection"] = @(YES);
        dict[@"IsInspection"] = @(YES);

    }else if (optionModel.isInspectionRequired)
    {
        dict[@"OptionInspection"] = @(YES);
        dict[@"IsInspection"] = @(YES);

    }

    return dict;
}

- (void)backToService
{
    NSLog(@"%@",self.navigationController.viewControllers);
    ServicesSelectionViewController *serviceSelection=self.navigationController.viewControllers[1];
    NSLog(@"%@",serviceSelection);
    [self.navigationController popToViewController:serviceSelection animated:YES];
}

- (void)toastMessage:(NSString *)message
{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText= message;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:1];
}

- (IBAction)BuyAction:(id)sender
{
    PaymentModeViewController *paymentView = [[PaymentModeViewController alloc] init];
    paymentView.strSaleAmount = [NSString stringWithFormat:@"%.2f",[_categoryModel totalCostAfterDisount]];//Edit
    paymentView.reference_no = self.categoryModel.orderCode;//Edit
    paymentView.paymentAmtString = [NSString stringWithFormat:@"%.2f",[_categoryModel totalCostAfterDisount]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%.2f",[_categoryModel totalCostAfterDisount]] forKey:@"strSaleAmount"];//Edit
    [defaults setObject:self.categoryModel.orderCode forKey:@"reference_no"];//Edit
    NSString *fromPayNowKey = [NSString stringWithFormat:@"%@_fromPayNowKey", self.categoryModel.orderCode];
    [defaults setBool:YES forKey:fromPayNowKey];
    [defaults synchronize];
    
    paymentView.descriptionString = @"DUSTERS TOTAL SOLUTIONS SERVICES PVT LTD";
    paymentView.strCurrency = @"INR";
    paymentView.strDisplayCurrency = @"INR";
    paymentView.strDescription = @"DUSTERS TOTAL SOLUTIONS SERVICES PVT LTD";

    NSArray *userDetails = [defaults objectForKey:@"login"];//0. name, 1.Mobile, 2.EmailID, 3.ID, 4.Code
    paymentView.strBillingName = @"DUSTERS TOTAL SOLUTIONS SERVICES PVT LTD";
    paymentView.strBillingAddress = [NSString stringWithFormat:@"%@ %@, %@",self.userAddressModel.street, self.userAddressModel.street2, self.userAddressModel.area];
    paymentView.strBillingCity = self.userAddressModel.city;
    paymentView.strBillingState = @"";
    paymentView.strBillingPostal = self.userAddressModel.pincode;
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

//    paymentView.dynamicKeyValueDictionary = [@{@"FromPayNow" : @(YES)} mutableCopy];
    
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
                [self pullPendingOrderForCode:self.categoryModel.orderCode andUpdate:YES];
            }
        }else
        {
            NSLog(@"Error in Payment gate way...");
        }
    }else if ([message.name isEqualToString:@"PAYMENT_CANCEL_NOTIFICATION"])
    {
        [self.revealViewController.navigationController popToViewController:self.revealViewController animated:YES];
    }
}

- (void)pullPendingOrderForCode:(NSString *)orderCode andUpdate:(BOOL)update
{
    NSString *url=[NSString stringWithFormat:@"%@%@%@",base_url,kORDER_BY_CODE, orderCode];
    [postman get:url withParameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];

             if([responseObject[@"Success"]integerValue]==1)
             {
                 NSDictionary *dictionary = responseObject[@"ViewModels"];
                     if(![dictionary[@"OrderStatusCode"] isEqualToString:rescheduleCode])
                     {
                         BookingModel *model=[[BookingModel alloc]init];
                         model.code = NULL_CHECKER(dictionary[@"Code"]);
                         model.categoryCode = NULL_CHECKER(dictionary[@"CategoryCode"]);
                         model.customerID = [NULL_CHECKER(dictionary[@"CustomerId"]) integerValue];
                         NSData *jsonExtraData = [NULL_CHECKER(dictionary[@"JSON"]) dataUsingEncoding:NSUTF8StringEncoding];
                         NSDictionary *jsonExtraDict = [NSJSONSerialization JSONObjectWithData:jsonExtraData
                                                                                       options:kNilOptions
                                                                                         error:nil];
                         model.extraJSONDict = jsonExtraDict;
                         [self callUpdateForPaymentSuccess:model];
                     }
             }

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];

         }];
}

//- (void)pullOrderForOrderCode:(NSString *)orderCode andUpdate:(BOOL)update
//{
//    NSString *url=[NSString stringWithFormat:@"%@%@",baseUrl,searchOrderURL];
//    NSString *parameter=[NSString stringWithFormat:@"{\"OrderCode\":\"%@\",\"CustomerId\": \"\",\"ServiceProviderId\": \"\",\"OrderStatusCode\": \"\"}",orderCode];
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        BookingModel *bookingModel = [self processResponseData:responseObject];
//        if (update)
//        {
//            [self callUpdateForPaymentSuccess:bookingModel];
//        }
//        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
//    }];
//}
//
//- (BookingModel *)processResponseData:(id)responseObject
//{
//    BookingModel *model;
//    NSDictionary *dict=responseObject;
//    if([dict[@"Success"]integerValue]==1)
//    {
//        NSArray *array = dict[@"ViewModels"];
//        for(NSDictionary *dictionary in array)
//        {
//            if(![dictionary[@"OrderStatusCode"] isEqualToString:rescheduleCode])
//            {
//                model=[[BookingModel alloc]init];
//                model.code = NULL_CHECKER(dictionary[@"Code"]);
//                model.categoryCode = NULL_CHECKER(dictionary[@"CategoryCode"]);
//                model.customerID = [NULL_CHECKER(dictionary[@"CustomerId"]) integerValue];
//                
//                NSData *jsonExtraData = [NULL_CHECKER(dictionary[@"JSON"]) dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary *jsonExtraDict = [NSJSONSerialization JSONObjectWithData:jsonExtraData
//                                                                              options:kNilOptions
//                                                                                error:nil];
//                model.extraJSONDict = jsonExtraDict;
//            }
//        }
//    }
//    
//    return model;
//}

- (void)callUpdateForPaymentSuccess:(BookingModel *)bookingModel
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",base_url, kUPDATE_ORDER_URL, bookingModel.code];
    NSString *paramter = [self successUpdateParameter:bookingModel];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    [postman put:url withParameters:paramter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYMENT_COMPLETED_SUCCESS"
                                                                 object:nil
                                                               userInfo:nil];

             [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYMENT_COMPLETED_FAILURE"
                                                                 object:nil
                                                               userInfo:nil];
             [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
         }];
}

- (NSString *)successUpdateParameter:(BookingModel *)bookingModel
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *loginarray=[defaults valueForKey:@"login"];
    
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];

    parameterDict[@"UserID"] = loginarray[3];
    parameterDict[@"CategoryCode"] = bookingModel.categoryCode;
    parameterDict[@"CustomerId"] = loginarray[3];
    parameterDict[@"PaymentStatusCode"] = kPAYMENT_STATUS_PAYED_CODE;
    
    NSMutableDictionary *jsonDict = [bookingModel.extraJSONDict mutableCopy];
    NSMutableDictionary *tranDict = [jsonDict[@"TransactionDetails"] mutableCopy];
    NSMutableArray *paymentsArr = [tranDict[@"PaymentDetails"] mutableCopy];
    
    if (paymentsArr == nil)
    {
        paymentsArr = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *payment = @{@"Transection_ID": paymentSuccessRespDict[@"TransactionId"], @"Amount": jsonDict[@"InitialTotalAmount"], @"PaymentType":@"078QU9"};
    [paymentsArr addObject:payment];
    tranDict[@"PaymentDetails"] = paymentsArr;
    tranDict[@"DueAmount"] = @(0);
    jsonDict[@"TransactionDetails"] = tranDict;
    
    parameterDict[@"JSON"] = jsonDict;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterDict options:kNilOptions error:nil];
    NSString *parameter = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return parameter;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BookNowSuccessSegue"])
    {
        PaymentSuccessViewController *paySucc = segue.destinationViewController;
        paySucc.orderNo = self.categoryModel.orderCode;
        paySucc.totalAmount = [self.categoryModel totalCostAfterDisount];
        if (formatter == nil)
        {
            formatter =[[NSDateFormatter alloc]init];
        }
        [formatter setDateFormat:@"dd MMM yyyy"];
        NSDate *date=[formatter dateFromString:_selectedTimeAndDate[1]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString=[formatter stringFromDate:date];
        paySucc.plannedDate = [NSString stringWithFormat:@"%@ %@",dateString,_selectedTimeAndDate[0]];
        [paySucc setupForPayLaterSuccess];
    }
}

@end
