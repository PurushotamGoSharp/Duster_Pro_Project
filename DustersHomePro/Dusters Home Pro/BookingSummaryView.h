#import <UIKit/UIKit.h>
#import "UserAddressModel.h"
#import "CategroyModel.h"
@protocol payNowProtocol<NSObject>
-(void)makeOrder;
@end
@protocol backToServiceMethod <NSObject>
-(void)backToService;
@end
@interface BookingSummaryView : UIView
@property (strong, nonatomic) IBOutlet UILabel *itemTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactPerson;
@property (strong, nonatomic) IBOutlet UILabel *mobileNumber;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;
@property(weak,nonatomic)id<payNowProtocol>delegateForPayNow;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConst;
-(void)showView;
@property (strong, nonatomic) NSString *buttonTitle;
@property (strong, nonatomic) IBOutlet UIButton *proceedToPayButton;
@property(strong,nonatomic)NSArray *selectTimeAndDate;
@property(strong,nonatomic)UserAddressModel *userModel;
@property(strong,nonatomic)CategroyModel *categoryModel;
@property(strong,nonatomic)NSString *totalCostString;
@property(weak,nonatomic)id<backToServiceMethod>delegate;
@end
