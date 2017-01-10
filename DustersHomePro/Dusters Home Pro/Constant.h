#import <Foundation/Foundation.h>
@interface Constant : NSObject
FOUNDATION_EXPORT NSString *const baseUrl;
FOUNDATION_EXPORT NSString *const userLoginURL;
FOUNDATION_EXPORT NSString *const userRegisterURL;
FOUNDATION_EXPORT NSString *const forgotPasswordUrl;
FOUNDATION_EXPORT NSString *const changePasswordURL;
FOUNDATION_EXPORT NSString *const getuserDetailURL;
FOUNDATION_EXPORT NSString *const getAllCategoriesURL;
FOUNDATION_EXPORT NSString *const getAllSubCategoriesUnderCategoryURL;
FOUNDATION_EXPORT NSString *const addAddressURL;
FOUNDATION_EXPORT NSString *const getAddressURL;
FOUNDATION_EXPORT NSString *const deleteAddress;
FOUNDATION_EXPORT NSString *const orderItemURL;
FOUNDATION_EXPORT NSString *const searchOrderURL;
FOUNDATION_EXPORT NSString *const getSingleSubCategory;
FOUNDATION_EXPORT NSString *const rescheduleOrderURL;
FOUNDATION_EXPORT NSString *const kUPDATE_ORDER_URL;
FOUNDATION_EXPORT NSString *const ratingUrl;

FOUNDATION_EXPORT NSString *const getLocationURL;

FOUNDATION_EXPORT NSString *const kONLINE_PAYMENT_CODE;
FOUNDATION_EXPORT NSString *const kPAYMENT_STATUS_PAYED_CODE;
FOUNDATION_EXPORT NSString *const kPAYMENT_STATUS_DUE_CODE;
FOUNDATION_EXPORT NSString *const kPAYMENT_STATUS_PENDING_CODE;

FOUNDATION_EXPORT NSString *const kUSER_DETAILS_URL;
FOUNDATION_EXPORT NSString *const kSEND_OTP_URL;
FOUNDATION_EXPORT NSString *const kSEND_OTP_NEW_USER_URL;
FOUNDATION_EXPORT NSString *const kGET_CONFIG_URL;

FOUNDATION_EXPORT NSString *const kGET_SEED_URL;

FOUNDATION_EXPORT NSString *const kAVAILABLITY_OF_SLOTS_URL;
FOUNDATION_EXPORT NSString *const kORDER_BY_CODE;

FOUNDATION_EXPORT NSString *const openCode;
FOUNDATION_EXPORT NSString *const confirmedCode;
FOUNDATION_EXPORT NSString *const cancelledCode;
FOUNDATION_EXPORT NSString *const rescheduleCode;
FOUNDATION_EXPORT NSString *const startCode;
FOUNDATION_EXPORT NSString *const stopCode;
FOUNDATION_EXPORT NSString *const IncpectionRejectCode;
FOUNDATION_EXPORT NSString *const IncpectionAcceptCode;
FOUNDATION_EXPORT NSString *const closedCode;
FOUNDATION_EXPORT NSString *const rejectedCode;
FOUNDATION_EXPORT NSString *const InspectionStop;
FOUNDATION_EXPORT NSString *const PartialClose;

FOUNDATION_EXPORT NSString *const getImageOfCategoryURL;


FOUNDATION_EXPORT NSString *const kRUPPEE_SYMBOL;

FOUNDATION_EXPORT NSString *const kCURRENT_TAX_KEY;
FOUNDATION_EXPORT NSString *const kMIN_SEC_BEFORE_BOOKING_KEY;
FOUNDATION_EXPORT NSString *const kLOGGED_IN_KEY;

@end
