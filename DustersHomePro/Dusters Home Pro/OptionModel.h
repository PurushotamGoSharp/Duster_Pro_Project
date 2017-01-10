
#import "MenuOptionBaseModel.h"
#import <UIKit/UIKit.h>

@interface OptionModel : MenuOptionBaseModel

@property (assign, nonatomic) NSInteger serviceDurationInMin;
@property (assign, nonatomic) CGFloat servicePrice;

@property (strong, nonatomic) NSString *insepectionDescription;

@property(assign,nonatomic) BOOL isInspectionRequired;

- (NSString *)descriptionOfSelection;

@end
