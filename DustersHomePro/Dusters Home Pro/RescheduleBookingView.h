#import <UIKit/UIKit.h>
#import "DatePicker.h"
#import "SelectTime.h"
#import "Constant.h"
#import "Postman.h"
#import "MBProgressHUD.h"
#import "MyBookingsTableViewController.h"
#import "BookingModel.h"

@protocol popToMyBookingsProtocol <NSObject>
- (void)popToMyBooking;
- (void)refreshModel:(NSString *)orderCode with:(void(^)(BOOL success, BookingModel *bookingModel))completionHHandler;

@end

@interface RescheduleBookingView : UIView<datePickerProtocol,SelectTimeMethod,UIAlertViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *datePickerLabel;
-(void)showXibView;
@property (strong, nonatomic) IBOutlet UIButton *rescheduleButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong,nonatomic) BookingModel *model;
@property (strong,nonatomic) id<popToMyBookingsProtocol>delegate;
@end
