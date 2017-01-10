#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ForgotPasswordView : UIView<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTF;
-(void)alphaViewInitialize;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@end
