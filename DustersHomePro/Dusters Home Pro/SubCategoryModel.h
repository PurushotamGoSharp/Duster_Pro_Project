#import <Foundation/Foundation.h>
#import "MenuOptionBaseModel.h"
#import <UIKit/UIKit.h>

@interface SubCategoryModel : MenuOptionBaseModel

@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSArray *typeModels;
@property (assign, nonatomic) BOOL multiSelection;
@property (assign, nonatomic) NSInteger selectedTypeIndex;
@property (strong, nonatomic) NSArray *documentDetails;
@property(strong,nonatomic)UIImage *imageOfSubCategory;
//@property (strong, nonatomic) NSArray *selectedIndexPaths; //for multiple selection.

@property(assign,nonatomic) BOOL isInspectionRequired;
@property (strong, nonatomic) NSString *insepectionDescription;


- (CGFloat)cellHeight;
- (CGFloat)priceOfSelections;

- (BOOL)isAnySelectionMade;

@end
