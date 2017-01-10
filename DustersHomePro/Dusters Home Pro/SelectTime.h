#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SelectTimeCell.h"
@protocol SelectTimeMethod <NSObject>
-(void)SelectTime:(NSString *)string;
@end
@interface SelectTime : UIView<UITableViewDataSource,UITableViewDelegate>
@property(weak,nonatomic)id<SelectTimeMethod>delegate;
@property(strong,nonatomic)NSArray *selectTimeArray;
-(void)alphaInitialize;

@property (strong, nonatomic) IBOutlet SelectTimeCell *selectTimeCell;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
