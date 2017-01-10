#import "NewCleaningViewController.h"
#import "CleaningVCCollectionViewCell.h"
#import "NewCleaningTableViewCell.h"
@interface NewCleaningViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIImageView *moreImage;

@property (strong, nonatomic) IBOutlet UIView *completeCostDetail;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation NewCleaningViewController
{
    NSMutableArray *cleanListImageViewArray;
    NSMutableArray *cleanListLabelArray;
    NSMutableArray *selectedItemIndexPath;
    NSArray *homeArray,*sofa,*carpet,*matress,*floorCleaning,*floorPollishing;
    NSString *selectedIndexPathRow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    cleanListImageViewArray=[[NSMutableArray alloc]init];
    cleanListLabelArray=[[NSMutableArray alloc]init];
    selectedItemIndexPath=[[NSMutableArray alloc]init];
    NSArray *ar=@[@"Home-icon",@"Sofa-icon",@"Carpet-icon",@"Carpet-icon",@"Floor-icon",@"Others-icon"];
    NSArray *ar1=@[@"Home",@"Sofa",@"Carpet",@"Matress",@"Floor",@"Others"];
    [cleanListImageViewArray addObjectsFromArray:ar];
    [cleanListLabelArray addObjectsFromArray:ar1];
    homeArray=@[@"1 BHK cleaning-Occupied",@"2 BHK cleaning-Occupied",@"3 BHK cleaning", @"4 BHK cleaning",@"Villas cleaning",@
                "1 BHK cleaning-Vacant",@"2 BHK cleaning-Vacant", @"3 BHK cleaning", @"4 BHK cleaning", @"Villas cleaning"];
    sofa=@[@"single seater",@"two seater",@"Three seater",@"L Seater"];
    carpet=@[@"based on sizes"];
    floorCleaning=@[@"Marble",@"Granite",@"Wood",@"Vitrified tiles",@"mosaic" ];
    floorPollishing=@[@"Marble",@"Wood"];
    _tableView.hidden=YES;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return cleanListImageViewArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CleaningVCCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-unselected-button"]];
    cell.itemCleaningImageView.image=[UIImage imageNamed:cleanListImageViewArray[indexPath.row]];
    cell.itemName.text=cleanListLabelArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectedItemIndexPath containsObject:indexPath]) {
        CleaningVCCollectionViewCell *cell=(CleaningVCCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [selectedItemIndexPath removeObject:indexPath];
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-unselected-button"]];
        cell.selectTickMark.hidden=YES;
        //        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //        [_tableView reloadData];
    }
    else{
        CleaningVCCollectionViewCell *cell=(CleaningVCCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-selected-button"]];
        cell.selectTickMark.hidden=NO;
        [selectedItemIndexPath addObject:indexPath];
        _tableView.hidden=NO;
        [_tableView reloadData];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return selectedItemIndexPath.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewCleaningTableViewCell *cell;
//    if ([selectedIndexPathRow isEqualToString:[NSString stringWithFormat:@"%d",5]]){
//        cell=[self cellForOtherCollectionViewCell];
//    }
//    else
        cell=[self cellForAllItem];
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(NewCleaningTableViewCell*)cellForOtherCollectionViewCell{
  NewCleaningTableViewCell *cell=  [_tableView dequeueReusableCellWithIdentifier:@"cell1"];
    return cell;
}
-(NewCleaningTableViewCell*)cellForAllItem{
    NewCleaningTableViewCell *cell=  [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectedIndexPathRow isEqualToString:[NSString stringWithFormat:@"%d",5]]) {
        return 325;
    }
    else
        return 99;
}
-(void)checkTableViewtobeHidden{
    if (![selectedItemIndexPath isEqual:nil]) {
        _tableView.hidden=NO;
        [_tableView reloadData];
    }
}
- (IBAction)more:(id)sender {
    _completeCostDetail.hidden=NO;
    _moreButton.enabled=NO;
    _moreImage.image=[UIImage imageNamed:@"More-button-selected"];
}
- (IBAction)closeCompleteCostView:(id)sender {
    _completeCostDetail.hidden=YES;
    _moreButton.enabled=YES;
    _moreImage.image=[UIImage imageNamed:@"More-button"];
}
@end
