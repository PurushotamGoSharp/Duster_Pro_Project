#import "OTPViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "Postman.h"
#import "VMEnvironment.h"

@interface OTPViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet UITextField *OTPTf;
@property (strong, nonatomic) IBOutlet UILabel *otpLabel;
@end

@implementation OTPViewController
{
    UIControl *activeField;
    Postman *postman;
    NSString *verificationString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
    postman = [[Postman alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor=[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1];
    [self textFieldPadding];
    
    [self callOTPApi];
}

- (void)textFieldPadding
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5,49)];
    _OTPTf.leftView=view;
    _OTPTf.leftViewMode=3;
    self.submitBtn.layer.cornerRadius=5;
    self.OTPTf.attributedPlaceholder =[[NSAttributedString alloc]initWithString:@"Enter OTP" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    _otpLabel.textColor=[UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1];
}
- (IBAction)submit:(id)sender
{
    [self.view endEditing:YES];
    if (([self.OTPTf.text compare:verificationString options:NSCaseInsensitiveSearch] == NSOrderedSame) && (verificationString.length > 0))
    {
        [self callApiForSignup];
    }else
    {
        [self toastMessage:@"OTP does not match."];
    }
}

- (IBAction)resendOTP:(id)sender
{
    [self callOTPApi];
    verificationString = @"";
    self.OTPTf.text = @"";
}

- (IBAction)backToSignUp:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)gestureRecognizer:(id)sender
{
    [self.view endEditing:YES];
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)name:UIKeyboardWillShowNotification object:nil];
    
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
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (void)callOTPApi
{
    NSString *urlString =[NSString stringWithFormat:@"%@%@",base_url,kSEND_OTP_NEW_USER_URL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *parameter = [NSString stringWithFormat:@"{\"MobileNumber\": \"%@\", \"Email\": \"%@\"}", self.phoneNumber, self.emailID];
    
    [postman post:urlString withParameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
              [self parseOTPResponse:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          }];
}

- (void)parseOTPResponse:(id)response
{
    NSDictionary *respDict = response;
    
    if ([respDict[@"Success"] boolValue])
    {
        verificationString = respDict[@"ViewModel"][@"Password"];
        [self toastMessage:respDict[@"Message"]];
    }else
    {
        verificationString = @"";
    }
}

- (void)callApiForSignup
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",base_url,userRegisterURL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:urlString withParameters:self.parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              {
                  [self parsingResponseData:responseObject];
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              {
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              }
          }];
}

- (void)parsingResponseData:(id)responseObject
{
    NSLog(@"%@",responseObject);
    NSDictionary *dictionary=responseObject;
    int success=[dictionary[@"Success"]intValue];
    if(success==1)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictionary = responseObject[@"UserDetailsViewModel"];
        NSString *name = dictionary[@"FirstName"];
        NSString *mobileNumber = dictionary[@"MobileNumber"];
        NSString *emailId = dictionary[@"Email"];
        NSString *Id = dictionary[@"Id"];
        NSString *code = dictionary[@"Code"];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:name];
        [array addObject:mobileNumber];
        [array addObject:emailId];
        [array addObject:Id];
        [array addObject:code];
        [defaults setValue:array forKey:@"login"];
        [defaults setObject:code forKey:@"UserCodeKey"];
        [defaults setBool:YES forKey:kLOGGED_IN_KEY];

        [self toastMessage:@"SignUp Successfully"];
        [self performSegueWithIdentifier:@"SignUpSuccessSegue" sender:nil];
    }
    else{
        [self toastMessage:dictionary[@"Message"]];
    }
}

- (void)toastMessage:(NSString*)message
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode=MBProgressHUDModeText;
    hud.detailsLabelText=message;
    hud.detailsLabelFont=[UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
}

@end
