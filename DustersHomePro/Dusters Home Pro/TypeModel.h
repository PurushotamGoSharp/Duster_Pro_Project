#import <Foundation/Foundation.h>
#import "MenuOptionBaseModel.h"
#import <UIKit/UIKit.h>

#define MAX_TYPE_CELL_HEIGHT 84

@interface TypeModel : MenuOptionBaseModel
@property (strong, nonatomic) NSArray *optionModels;
@property (assign, nonatomic) NSInteger selectedOptionIndex;

@property (assign, nonatomic) BOOL partOfMulitSelect;
@property (assign, nonatomic) BOOL selected;// used only in MULTI_SELECT

@property(assign,nonatomic) BOOL isInspectionRequired;
@property (strong, nonatomic) NSString *insepectionDescription;


- (CGFloat)cellHeight;
- (CGFloat)priceOfSelecltion;

- (BOOL)isAnySelectionMade;

//- (BOOL)isInspectionSelected;

@end
