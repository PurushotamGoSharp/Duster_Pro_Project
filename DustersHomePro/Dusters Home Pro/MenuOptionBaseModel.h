#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIElementType)
{
    UIElementTypeSubService = 1,
    UIElementTypeSingleSelectionChoice,
    UIElementTypeMultipleSelectionChoice,
    UIElementTypeNumericSelection
};

@interface MenuOptionBaseModel : NSObject

@property (assign, nonatomic) UIElementType type;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *serviceTitle;

- (NSString *)descriptionOfSelection;
- (NSInteger)maxServiceDuration;

@end
