#import "LoginViewController.h"
#import "ForgotPasswordView.h"
#import "Postman.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "SeedSyncer.h"
#import "VMEnvironment.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailIdTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LoginViewController
{
    ForgotPasswordView *forgotpasswordView;
    UIControl  *activeField;
    Postman *postman;
    NSString *alertstring;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [self paddingSpace];
    self.loginButton.layer.cornerRadius=5;
    self.signUpButton.layer.cornerRadius=5;
    [self changePlaceHolderColor];
    [self registerForKeyboardNotifications];
    postman = [[Postman alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _emailIdTF.text=@"";
    _passwordTF.text=@"";
    self.view.backgroundColor=[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1];
    alertstring=@"";
}
-(void)paddingSpace
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 49)];
    self.emailIdTF.leftView=view;
    self.emailIdTF.leftViewMode=3;
    self.loginButton.layer.cornerRadius=5;
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 49)];
    self.passwordTF.leftView=view1;
    self.passwordTF.leftViewMode=3;
}
- (IBAction)tapGestureMethod:(id)sender {
    [self.view endEditing:YES];
}
-(void)changePlaceHolderColor
{
    self.loginButton.layer.cornerRadius=5;
    self.signUpButton.layer.cornerRadius=5;
    UIColor *color = [UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1];
    self.emailIdTF.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Enter your Mobile No./Email-ID" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    self.passwordTF.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Enter your Password"attributes:@{ NSForegroundColorAttributeName: color, NSFontAttributeName : [UIFont systemFontOfSize:15]}];
}
- (IBAction)login:(id)sender {
    
    //[self performSegueWithIdentifier:@"loginSuccess" sender:nil];
    [self.view endEditing:YES];
    
    if([self.emailIdTF.text isEqualToString:@""] & [self.passwordTF.text isEqualToString:@""])
    {
        [self mbProgress:@"Enter your Mobile No./Email-ID and Password."];
        
    } else if ([self.emailIdTF.text isEqualToString:@""])
    {
        [self mbProgress:@"Enter your Mobile No./Email-ID."];
        
    }else if ([self.passwordTF.text isEqualToString:@""])
    {
        [self mbProgress:@"Enter your Password."];
    } else if(![self.emailIdTF.text isEqualToString:@""])
    {
        [self validPhonenumber:_emailIdTF.text];
        if(![alertstring isEqualToString:@""])
            [self mbProgress:alertstring];
        else
            [self callAPI];

    }else
    {
        [self callAPI];
    }
    
    
//    else
//        if(![self.emailIdTF.text isEqualToString:@""] & [self.passwordTF.text isEqualToString:@""])
//        {
//            [self validPhonenumber:_emailIdTF.text];
//            
//            if(![alertstring isEqualToString:@""])
//                [self mbProgress:[alertstring stringByAppendingString:@" Required password field"]];
//            else
//                [self mbProgress:@"Required password field"];
//        }
//        else
//            if(![self.passwordTF.text isEqualToString:@""]&[self.emailIdTF.text isEqualToString:@""])
//            {
////                [self validPhonenumber:_emailIdTF.text];
//                
//                if(![alertstring isEqualToString:@""])
//                    [self mbProgress:[alertstring stringByAppendingString:@" Required emailID field"]];
//                else
//                    [self mbProgress:@"Required emailID field"];
//            }
//    
//            else
//                if(!([self.emailIdTF.text isEqualToString:@""] & [self.passwordTF.text isEqualToString:@""]))
//                {
//                    [self validPhonenumber:_emailIdTF.text];
//                    
//                    if(![alertstring isEqualToString:@""])
//                    {
//                        if(self.passwordTF.text.length<3)
//                            [self mbProgress:[alertstring stringByAppendingString:@" Invalid password field"]];
//                        else  [self mbProgress:alertstring];
//                    }
//                    
//                    else
//                    {
//                        if(self.passwordTF.text.length<3)
//                            [self mbProgress:@" Invalid password field"];
//                        else
//                            [self callAPI];
//                    }
//                    
//                }
}

- (void)validPhonenumber:(NSString *)string
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        if (string.length != 10)
        {
            alertstring= @"Invalid Mobile No.";
        } else
        {
            alertstring= @"";
        }
    }else
    {
        [self validateEmailWithString:string];

    }
}
- (void)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL validate=  [emailTest evaluateWithObject:email];
    if (!validate) {
        alertstring= @"Please provide a valid Email-ID.";
    }
    else  alertstring= @"";
}

- (void)mbProgress:(NSString*)message{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText=message;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:1];
    
}
- (void)callAPI
{
    
    NSString *url= [NSString stringWithFormat:@"%@%@",base_url,userLoginURL];
    
    
    
    NSString *parameter=[NSString stringWithFormat:@"{\"Username\": \"%@\",\"Password\": \"%@\", \"Role\": \"WZUWZH\"}",_emailIdTF.text,_passwordTF.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseObject:responseObject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)processResponseObject:(id)responseObject{
    NSDictionary *dict=responseObject;
    int successValue=[dict[@"Success"] intValue];
    if (successValue==1)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSDictionary *dictionary=responseObject[@"UserDetailsViewModel"];
        NSString *name=dictionary[@"FirstName"];
        NSString *mobileNumber=dictionary[@"MobileNumber"];
        NSString *emailId=dictionary[@"Email"];
        NSString *Id=dictionary[@"Id"];
        NSString *code=dictionary[@"Code"];
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [array addObject:name];
        [array addObject:mobileNumber];
        [array addObject:emailId];
        [array addObject:Id];
        [array addObject:code];
        [defaults setValue:array forKey:@"login"];
        [defaults setObject:code forKey:@"UserCodeKey"];
        [defaults setBool:YES forKey:kLOGGED_IN_KEY];
        [self performSegueWithIdentifier:@"loginSuccess" sender:nil];
    }
    else{
        [self mbProgress:dict[@"Message"]];
    }
}

- (IBAction)forgotPassword:(id)sender {
    if (forgotpasswordView==nil)
        forgotpasswordView =[[ForgotPasswordView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+25, 200, self.view.frame.size.width-50,217)];
    [forgotpasswordView alphaViewInitialize];
    
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

- (void)textFieldDidEndEditing:(UITextField *)textFieldcs
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
@end
