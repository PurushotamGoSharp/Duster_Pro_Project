#import "ForgotPasswordView.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "Postman.h"
#import "VMEnvironment.h"


@implementation ForgotPasswordView
{
    UIView *view;
    UIControl *alphaView,*activeTf;
    Postman *postman;
    UIAlertView *successAlert;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"ForgotPasswordView" owner:self options:nil]lastObject];
    view.frame=self.bounds;
    [self addSubview:view];
    [self initializeView];
    self.mobileNumberTF.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Enter 10 Digit Mobile Number"  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    postman=[[Postman alloc]init];
    return self;
}
-(void)initializeView
{
    _mobileNumberTF.layer.borderColor=[UIColor colorWithRed:0.1372 green:0.1216 blue:0.025 alpha:1].CGColor;
    _mobileNumberTF.layer.borderWidth=1;
    _mobileNumberTF.layer.cornerRadius=5;
    view.layer.cornerRadius =10;
    view.layer.borderWidth=1;
    view.layer.masksToBounds  = YES;
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 49)];
    self.mobileNumberTF.leftView=view1;
    self.mobileNumberTF.leftViewMode=3;
    _cancelButton.layer.cornerRadius=5;
    _sendButton.layer.cornerRadius=5;
    
}
- (IBAction)cancelButton:(id)sender {
    [alphaView removeFromSuperview];
}
- (IBAction)sendButton:(id)sender {
    [self hidekeyBoard];
    if (self.mobileNumberTF.text.length == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter your Mobile Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    BOOL validate=[self validPhonenumber:self.mobileNumberTF.text];
    if(!validate | (self.mobileNumberTF.text.length!=10))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please provide a 10 digit Mobile Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
        [self callAPI];
}
- (BOOL)validPhonenumber:(NSString *)string
{
    NSString *phoneRegex = @"[0-9]{0,10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:string];
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
    _mobileNumberTF.text=@"";
    [_mobileNumberTF becomeFirstResponder];
    view.center = alphaView.center;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [appDel.window addSubview:alphaView];
    [alphaView addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapgest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidekeyBoard)];
    [view addGestureRecognizer:tapgest];
}
-(void)hidekeyBoard{
    [view endEditing:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTf=textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTf=nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *expectedString = [textField.text mutableCopy];
    [expectedString replaceCharactersInRange:range withString:string];
    
    return (expectedString.length <= 10);
}

- (void)callAPI{
    NSString *url=[NSString stringWithFormat:@"%@%@",base_url,forgotPasswordUrl];
    NSString *parameter=[NSString stringWithFormat:@"{\"email\": \"%@\"}",_mobileNumberTF.text];
    [MBProgressHUD showHUDAddedTo:alphaView  animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:alphaView animated:NO];
        [self processResponseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:alphaView animated:YES];
    }];
}
- (void)processResponseObject:(id)responseObject
{
    NSDictionary *dictionary=responseObject;
    if([dictionary[@"Success"]boolValue])
    {
        successAlert = [[UIAlertView alloc]initWithTitle:@"Successful" message:dictionary[@"Message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [successAlert show];
        //        [self mbProgress:dictionary[@"Message"]];
        //        [alphaView removeFromSuperview];
        //        self.mobileNumberTF.text=@"";
        
    }else
    {
        [self mbProgress:@"Mobile Number does not exist."];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([successAlert isEqual:alertView])
    {
        if(buttonIndex == 0)
        {
            [alphaView removeFromSuperview];
            self.mobileNumberTF.text = @"";
        }
    }
}

-(void)mbProgress:(NSString*)message{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:alphaView animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText=message;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:1];
}

@end
