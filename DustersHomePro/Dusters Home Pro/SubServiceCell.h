#import <UIKit/UIKit.h>
#import "SubCategoryModel.h"

@class SubServiceCell;

@protocol MainServiceCellProtocol <NSObject>
//- (void)mainService:(MainServiceCell *)cell withData:(ServiceModel *)serviceModel selectedIndex:(NSArray *)indexs;
- (void)mainService:(SubServiceCell *)cell withData:(SubCategoryModel *)subServiceModel selectedAtIndex:(NSInteger)index;
- (void)mainService:(SubServiceCell *)cell withData:(SubCategoryModel *)subServiceModel deselectedAtIndex:(NSInteger)index;
@end

@interface SubServiceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *subCategoryArray;
@property (weak, nonatomic) id<MainServiceCellProtocol> delegate;

- (NSArray *)selectedindexs;
- (CGFloat)heightOfRow;

@end
