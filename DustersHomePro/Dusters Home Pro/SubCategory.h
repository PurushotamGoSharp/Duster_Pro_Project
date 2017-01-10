#import "MenuModel.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SubCategory : MenuModel
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSArray *typeModels;
@property (assign, nonatomic) BOOL multiSelection;
@property (assign, nonatomic) NSInteger selectedTypeIndex;
@property (strong, nonatomic) NSArray *selectedIndexPaths; //for multiple selection.

-(void)getServiceType:(NSArray*)subCategoryCode;
@end
