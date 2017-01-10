#import <UIKit/UIKit.h>
#import "BookingModel.h"
@interface MyBookingsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeOfCleaningLabel;
@property(strong,nonatomic)BookingModel *bookingModel;
@property (strong, nonatomic) IBOutlet UILabel *dateAndTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderCode;
@property (weak, nonatomic) IBOutlet UIImageView *mainOrederStripImageView;

@end
