#import "ChangePasswordViewController.h"
#import "SWRevealViewController.h"
#import "Postman.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "VMEnvironment.h"

@interface ChangePasswordViewController ()<SWRevealViewControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (strong, nonatomic) IBOutlet UITextField *changedPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *navigationBackBarButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ChangePasswordViewController
{
    Postman *postman;
    UITextField *activeField;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self textFieldPadding];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate=self;
    postman=[[Postman alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
      [self navigationBackBarButtonSpacing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)cancel:(id)sender {
    [self.revealViewController.rearViewController performSegueWithIdentifier:@"Home" sender:nil];
}
- (IBAction)confirmPassword:(id)sender
{
    
    [self.view endEditing:YES];
//    if (self.oldPasswordTF.text.length==0) {
//        [self mbProgress:@"Please enter the old password."];
//
//    }
//    else if (self.changedPassword.text.length==0)
//    {
//        [self mbProgress:@"New password should not be blank."];
//    }
//    else if ([self.oldPasswordTF.text isEqualToString:self.changedPassword.text])
//    {
//        [self mbProgress:@"Old password and New Password should not be same."];
//    }
//    else if (self.confirmPassword.text.length==0)
//    {
//        [self mbProgress:@"Confirm password should not be blank."];
//    }
//    else if (![self.changedPassword.text isEqualToString:self.confirmPassword.text])
//    {
//        [self mbProgress:@"New password and Confirm password should be same."];
//    }
//    else
    if (self.oldPasswordTF.text.length==0) {
        [self mbProgress:@"Please enter the old password"];
    }
    else if (self.changedPassword.text.length==0)
    {
        [self mbProgress:@"Please enter the new password"];
    }
    else if (self.confirmPassword.text.length==0)
    {
        [self mbProgress:@"Please enter the confirm password"];
    }
    else if (self.oldPasswordTF.text.length < 4 || self.confirmPassword.text.length < 4 || self.changedPassword.text.length < 4)
    {
        [self mbProgress:@"Password should be minimum of 4 characters"];
    }
    else if (![self.changedPassword.text isEqualToString:self.confirmPassword.text])
    {
        [self mbProgress:@"Password do not match"];
        
    }
    else if ([self.oldPasswordTF.text isEqualToString:self.changedPassword.text])
    {
        [self mbProgress:@"New password should be different"];
    }else
    {
        [self callAPI];
    }
}
-(void)callAPI
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *url=[NSString stringWithFormat:@"%@%@%@",base_url,changePasswordURL,[defaults valueForKey:@"UserCodeKey"]];
    NSString *parameter=[NSString stringWithFormat:@"{\"OldPassword\": \"%@\", \"NewPassword\":\"%@\"}",_oldPasswordTF.text,_changedPassword.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman put:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self processResponseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)processResponseObject:(id)responseObject{
    NSDictionary *dict=responseObject;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:window.rootViewController.view animated:YES];
    hud.mode=MBProgressHUDModeText;
    
    if ([dict[@"Success"] boolValue])
    {
        hud.detailsLabelText = @"Successfully changed Password.";
    }else
    {
        hud.detailsLabelText = @"Old password does not match.";
    }
    
    hud.yOffset=150.f;
    hud.margin=10.f;
    [hud hide:YES afterDelay:2];
    [hud removeFromSuperViewOnHide];
    
    if ([dict[@"Success"] boolValue])
    {
        [self.revealViewController.rearViewController performSegueWithIdentifier:@"Home" sender:nil];
    }
}

- (IBAction)slideOut:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
    [self.revealViewController setRearViewRevealWidth:180];
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if (position==FrontViewPositionRight) {
        UIView *rightView=[[UIView alloc]initWithFrame:self.view.frame];
        [rightView setTag:111];
        [self.view addSubview:rightView];
        SWRevealViewController *revealVC=self.revealViewController;
        if (revealVC) {
            [rightView addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
            [rightView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    }
    else if(position==FrontViewPositionLeft){
        UIView *lowerView=[self.view viewWithTag:111];
        [lowerView removeFromSuperview];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (IBAction)tapGesture:(id)sender
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)navigationBackBarButtonSpacing
{
    self.navigationController.navigationItem.hidesBackButton=YES;
    UIBarButtonItem *fixedbarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedbarbutton.width=-5;
    self.navigationItem.leftBarButtonItems=@[fixedbarbutton,_navigationBackBarButton];
}

-(void)textFieldPadding{
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
    _oldPasswordTF.leftView=v;
    _oldPasswordTF.leftViewMode=3;
    _oldPasswordTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Enter Old Password" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    UIView *v1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
    _changedPassword.leftView=v1;
    _changedPassword.leftViewMode=3;
     _changedPassword.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Enter New Password" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    UIView *v2=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
    _confirmPassword.leftView=v2;
    _confirmPassword.leftViewMode=3;
    _confirmPassword.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Enter Confirm Password" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}

- (void)mbProgress:(NSString*)message
{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText=message;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:1];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeField = textField;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    activeField = nil;
    return YES;
}

- (void)keyboardDidAppear:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsects = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    self.scrollView.contentInset = contentInsects;
    self.scrollView.scrollIndicatorInsets = contentInsects;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    CGPoint origin = [self.scrollView convertPoint:activeField.frame.origin fromView:activeField];
    
    if (!CGRectContainsPoint(aRect, origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
