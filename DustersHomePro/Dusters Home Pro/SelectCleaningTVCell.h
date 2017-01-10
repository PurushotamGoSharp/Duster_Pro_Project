#import <UIKit/UIKit.h>
#import "UserAddressModel.h"
@protocol deleteCellMethod<NSObject>
-(void)deleteCell:(UITableViewCell *)Cell;
@end
@interface SelectCleaningTVCell : UITableViewCell<UIAlertViewDelegate>
@property(weak,nonatomic)id<deleteCellMethod>delegate;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteRowButton;
@property (weak, nonatomic) IBOutlet UIImageView *radioButtonImage;
@property(strong,nonatomic)UserAddressModel *amodel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *pincodeLabel;
@end


