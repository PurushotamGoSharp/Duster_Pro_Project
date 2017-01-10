
#import <UIKit/UIKit.h>
#import "TotalCostDetailView.h"
#import "CategroyModel.h"
#import "UserAddressModel.h"
#import "BookingSummaryView.h"
@interface PayNowViewController : UIViewController<backToServiceMethod>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *navigationBackBarButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *totalCostDetailViewHeight;
@property (strong, nonatomic) IBOutlet TotalCostDetailView *totalCost;
@property (strong, nonatomic) CategroyModel *categoryModel;
@property(strong,nonatomic) UserAddressModel *userAddressModel;
@property(strong,nonatomic)NSArray *selectedTimeAndDate;

@end
