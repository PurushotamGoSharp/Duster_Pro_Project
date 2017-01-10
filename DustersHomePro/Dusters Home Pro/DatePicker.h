#import <UIKit/UIKit.h>
@protocol datePickerProtocol <NSObject>
-(void)selectingDatePicker:(NSString *)date;
@end
@interface DatePicker : UIView
-(void)alphaViewInitialize;
@property(weak,nonatomic)id<datePickerProtocol>delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@end
