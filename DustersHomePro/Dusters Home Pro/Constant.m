
#import "Constant.h"

@implementation Constant
  NSString *const baseUrl = @"http://prithiviraj.vmokshagroup.com:9014/";//MobDev
//NSString *const baseUrl = @"http://prithiviraj.vmokshagroup.com:8066/";//Test
//NSString *const baseUrl=@"http://prithiviraj.vmokshagroup.com:8065/";//Stagging
//NSString *const baseUrl = @"http://akbar.vmokshgroup.com:8065/";//External MobDev

NSString *const userLoginURL =@"api/account/Authenticate";
NSString *const userRegisterURL=@"api/user/0";
NSString *const forgotPasswordUrl=@"api/account/forgotpassword";
NSString *const changePasswordURL=@"api/user/";
NSString *const getuserDetailURL=@"api/user";
NSString *const getAllCategoriesURL=@"api/category";
NSString *const getAllSubCategoriesUnderCategoryURL=@"/subcategory";
NSString *const addAddressURL=@"api/address";
NSString *const getAddressURL=@"api/address";
NSString *const deleteAddress=@"api/address";

NSString *const orderItemURL=@"api/bulk/order/0";
NSString *const searchOrderURL=@"api/order/search";
NSString *const rescheduleOrderURL=@"api/order/bulk/reschedule/";
NSString *const kAVAILABLITY_OF_SLOTS_URL = @"api/order/slots";
NSString *const kORDER_BY_CODE = @"api/order/";

NSString *const getSingleSubCategory=@"/subcategory/";
NSString *const getImageOfCategoryURL=@"api/RenderDocument/";
NSString *const kSEND_OTP_URL = @"api/account/SendOTP";
NSString *const kSEND_OTP_NEW_USER_URL = @"api/account/SendOTP/NewUser";

NSString *const kGET_CONFIG_URL = @"api/configuration/all";
NSString *const kGET_SEED_URL = @"api/seed";
NSString *const kUSER_DETAILS_URL = @"api/user/";
NSString *const getLocationURL = @"api/location";

NSString *const rejectedCode=@"698CZD";
NSString *const confirmedCode=@"7XPJ3I";
NSString *const stopCode=@"FWZ7Q1";
NSString *const rescheduleCode=@"ONHU76";
NSString *const openCode=@"PXR1Y5";
NSString *const closedCode=@"Q695KP";
NSString *const startCode=@"T8KZVB";
NSString *const cancelledCode=@"UIFE8W";
NSString *const IncpectionRejectCode = @"F5OB7F";
NSString *const IncpectionAcceptCode = @"6VZ3CN";
NSString *const InspectionStop = @"A7ZODJ";
NSString *const PartialClose = @"QP3LMO";

NSString *const kONLINE_PAYMENT_CODE = @"078QU9";

NSString *const kPAYMENT_STATUS_PAYED_CODE = @"CVZT06";
NSString *const kPAYMENT_STATUS_DUE_CODE = @"VSD5J7";
NSString *const kPAYMENT_STATUS_PENDING_CODE = @"EO7HNI";

NSString *const kRUPPEE_SYMBOL = @"\u20B9";

NSString *const kCURRENT_TAX_KEY = @"CurrentTaxKey";
NSString *const kMIN_SEC_BEFORE_BOOKING_KEY = @"MinSecsBeforeBookingKey";

NSString *const kLOGGED_IN_KEY = @"UserLoggedInKey";

//NSString *const getImageOfCategoryURL=@"api/RenderDocument/";
NSString *const kUPDATE_ORDER_URL = @"api/order/";
NSString *const ratingUrl=@"api/rate/";
@end
