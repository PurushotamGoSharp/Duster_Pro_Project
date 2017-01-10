#import "SignUpViewController.h"
#import "Postman.h"
#import "Constant.h"
#import "OTPViewController.h"

@interface SignUpViewController ()
{
    UIControl *activeField;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTF;
@property (weak, nonatomic) IBOutlet UITextField *emailIdTF;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *alreadyRegisteredButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SignUpViewController
{
    NSMutableArray *fieldAlertArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self paddingSpace];
    self.signUpButton.layer.cornerRadius=5;
    [self changePlaceHolderColor];
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.view.backgroundColor=[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1];
    self.navigationController.navigationBarHidden=YES;
    self.phoneNoTF.text=@"";
    self.emailIdTF.text=@"";
    self.nameTF.text=@"";
    self.passwordTF.text=@"";
 
}
- (IBAction)IHaveLoginCredentials:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)tapGestureMethod:(id)sender {
    [self.mainView endEditing:YES];
}
-(void)paddingSpace
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 49)];
    self.nameTF.leftView=view;
    self.nameTF.leftViewMode=3;
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 49)];
    self.phoneNoTF.leftView=view1;
    self.phoneNoTF.leftViewMode=3;
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 49)];
    self.emailIdTF.leftView=view2;
    self.emailIdTF.leftViewMode=3;
    
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 49)];
    self.passwordTF.leftView=view3;
    self.passwordTF.leftViewMode=3;
}

- (void)changePlaceHolderColor
{
    self.signUpButton.layer.cornerRadius=5;
    UIColor *color = [UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1];
    
    self.emailIdTF.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Enter your Email-ID" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    self.nameTF.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Enter your Name" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    self.phoneNoTF.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Enter 10 digit Mobile Number"attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    self.passwordTF.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Choose a Password"attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName : [UIFont systemFontOfSize:15]}];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (IBAction)signUpAction:(id)sender
{
    if (_phoneNoTF.text.length==0 | _emailIdTF.text.length==0 | _passwordTF.text.length==0 | _nameTF.text.length==0) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"All fields are mandatory." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else if ([self validateEntries])
        [self performSegueWithIdentifier:@"signUpSuccess" sender:nil];
    
}

- (BOOL)validateEntries
{
    BOOL goodToGo = YES;
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    if (self.nameTF.text.length == 0)
    {
        goodToGo = NO;
        [mutableString appendString:@"'Name' is required\n"];
    }
    
    if (self.phoneNoTF.text.length > 10)
    {
        goodToGo = NO;
        [mutableString appendString:@"'Mobile Number' should be of 10 digits.\n"];
    }

    if (self.passwordTF.text.length <= 3)
    {
        goodToGo = NO;
        [mutableString appendString:@"'Password' should be minimum of 3 letters.\n"];
    }
    if (![self stringIsValidEmail:self.emailIdTF.text])
    {
        goodToGo = NO;
        [mutableString appendString:@"A valid 'Email Address' is required\n"];
    }
    
    if (!goodToGo)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                        message:mutableString
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    return goodToGo;
}

-(BOOL)stringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.phoneNoTF])
    {
        NSMutableString *expectedString = [textField.text mutableCopy];
        [expectedString replaceCharactersInRange:range withString:string];
        
        return (expectedString.length <= 10);
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"signUpSuccess"])
    {
        OTPViewController *otpVC = [segue destinationViewController];
        NSString *parameterString=[NSString stringWithFormat:@"{\"FirstName\": \"%@\",\"MiddleName\": \"\",\"LastName\": \"\",\"UserName\": \"%@\",\"Email\": \"%@\",\"Password\": \"%@\",\"Role\": \"WZUWZH\",\"MobileNumber\": \"%@\",\"Gender\": \"\",\"Status\": 1,\"DOB\": \"1991-04-05\",\"UserID\":1}",self.nameTF.text,self.emailIdTF.text,self.emailIdTF.text,self.passwordTF.text,self.phoneNoTF.text];

        otpVC.parameter = parameterString;
        otpVC.phoneNumber = self.phoneNoTF.text;
        otpVC.emailID = self.emailIdTF.text;
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
    [hud hide:YES afterDelay:1];  
}

@end
