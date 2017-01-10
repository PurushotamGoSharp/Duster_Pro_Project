#import <UIKit/UIKit.h>
#import "DatePicker.h"
#import "SelectCleaningTVCell.h"
#import "SelectTime.h"
#import "TotalCostDetailView.h"
#import "CategroyModel.h"
#import "UserAddressModel.h"
@interface SelectCleaningTimeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,datePickerProtocol,deleteCellMethod,SelectTimeMethod,heightOfCostDetailView>
@property(strong,nonatomic)CategroyModel *category;
@end
