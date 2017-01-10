#import <UIKit/UIKit.h>
#import "TotalCostDetailTableViewCell.h"
#import "TotalCostDetailModel.h"
#import "CategroyModel.h"

@protocol heightOfCostDetailView <NSObject>

- (void) getHeightOfCostDetailView:(CGFloat)frameHeight;

@optional
- (void)successfullyAppledCoupun:(NSInteger)discount;
- (void)applyingCoupon;
- (void)failedToApplyCoupon:(NSString *)errorMessage;
- (void)showingKeyboardFor:(UITextField *)textField;
- (void)hideKeyboardFor:(UITextField *)textField;

@end

@interface TotalCostDetailView : UIView

@property(weak,nonatomic)id <heightOfCostDetailView>delegateForHeightofCostDetailView;
@property (strong, nonatomic) NSArray *detailArray;
@property (strong, nonatomic) IBOutlet UILabel *totalCost;

@property (strong, nonatomic) CategroyModel *catModel;
@property (assign, nonatomic) BOOL showCouponEntry;

- (CGFloat)heightOfView;
- (void)updateView;

- (void)setUpForHideDetails;
- (void)setUpForShowDetails;

@end
