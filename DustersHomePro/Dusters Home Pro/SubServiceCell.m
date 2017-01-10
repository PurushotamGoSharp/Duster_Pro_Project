
#import "SubServiceCell.h"
#import "CleaningVCCollectionViewCell.h"
#import "SubCategoryModel.h"
#import "GetImageModel.h"
@interface SubServiceCell ()

@end

@implementation SubServiceCell
{
    NSMutableArray *selectedItemIndexPaths;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

    }
        
    return self;
}

- (void)setSubCategoryArray:(NSArray *)subCategoryArray
{
    _subCategoryArray = subCategoryArray;
    [self getImage];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.subCategoryArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CleaningVCCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if ([selectedItemIndexPaths containsObject:indexPath])
    {
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-selected-button"]];
        cell.selectTickMark.hidden = NO;

    }else {
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-unselected-button"]];
        cell.selectTickMark.hidden = YES;
    }
    
    SubCategoryModel *model = self.subCategoryArray[indexPath.row];
   cell.itemCleaningImageView.image = model.imageOfSubCategory;
    cell.itemName.text = model.serviceTitle;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedItemIndexPaths == nil)
    {
        selectedItemIndexPaths = [[NSMutableArray alloc] init];
    }
    
    SubCategoryModel *model = self.subCategoryArray[indexPath.row];
    
    if ([selectedItemIndexPaths containsObject:indexPath]) {
        CleaningVCCollectionViewCell *cell = (CleaningVCCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [selectedItemIndexPaths removeObject:indexPath];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-unselected-button"]];
        [self.delegate mainService:self withData:model deselectedAtIndex:indexPath.row];
        cell.selectTickMark.hidden=YES;
    }
    else{
        CleaningVCCollectionViewCell *cell = (CleaningVCCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-selected-button"]];
        [self.delegate mainService:self withData:model selectedAtIndex:indexPath.row];
        cell.selectTickMark.hidden = NO;
        [selectedItemIndexPaths addObject:indexPath];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat collectionViewWidth = collectionView.frame.size.width/4;
    return CGSizeMake(80,80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (NSArray *)selectedindexs
{
    return selectedItemIndexPaths;
}


- (CGFloat)heightOfRow
{
    return 100;
}
-(void)getImage{
    for (SubCategoryModel *model in _subCategoryArray) {
      GetImageModel *getImageModel=[[GetImageModel alloc]init];
    if (model.documentDetails.count>0) {
        [getImageModel getJsonData:model.documentDetails onComplete:^(UIImage *image) {
            if (image) {
                model.imageOfSubCategory=image;
               [_collectionView reloadData];
            }
        } onError:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    }
}
@end
