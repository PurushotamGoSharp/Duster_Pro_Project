#import <UIKit/UIKit.h>
#import "UserAddressModel.h"
#import "BookingModel.h"
#import "RescheduleBookingView.h"
@interface BookingDetailViewController : UIViewController<popToMyBookingsProtocol>

@property (strong, nonatomic) IBOutlet UILabel *representativeDetailLabel;
@property(strong,nonatomic)BookingModel *model;

@end
