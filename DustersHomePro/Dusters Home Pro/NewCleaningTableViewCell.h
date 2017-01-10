#import <UIKit/UIKit.h>
@interface NewCleaningTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *washroomBtn;
@property (strong, nonatomic) IBOutlet UIButton *windowBtn;
@property (strong, nonatomic) IBOutlet UIButton *kitchenBtn;
@property (strong, nonatomic) IBOutlet UIButton *bedroomBtn;
@property (strong, nonatomic) IBOutlet UIButton *showerBtn;
@property (strong, nonatomic) IBOutlet UIButton *periperyBtn;
@property (strong, nonatomic) IBOutlet UIButton *loftBtn;
@property (strong, nonatomic) IBOutlet UIButton *cleaning1Btn;
@property (strong, nonatomic) IBOutlet UIButton *cleaning2Btn;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property(strong,nonatomic)NSArray *labelDetailArray;
@end
