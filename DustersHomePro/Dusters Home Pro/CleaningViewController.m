#import "CleaningViewController.h"
#import "CleaningVCCollectionViewCell.h"
#import "Constant.h"
#import "Postman.h"
#import "MBProgressHUD.h"
#import "SubCategoryModel.h"
#import "TypeModel.h"
#import "OptionModel.h"

@interface CleaningViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *navigationBackBarButton;
@property (strong, nonatomic) IBOutlet UILabel *numberOfRommNumber;
@property (strong, nonatomic) IBOutlet UIButton *deepCleaningButton;
@property (strong, nonatomic) IBOutlet UIButton *sanitizingButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIImageView *moreImage;

@property (strong, nonatomic) IBOutlet UIView *completeCostDetail;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation CleaningViewController
{
    NSMutableArray *cleanListImageViewArray;
    NSMutableArray *cleanListLabelArray,*subCategoryNameArray;
    NSMutableArray *selectedItemIndexPath,*selectedSubCategoryCode;
    int i;
    Postman *postman;
    NSString *url;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationBackBarButtonSpacing];
    cleanListImageViewArray=[[NSMutableArray alloc]init];
    cleanListLabelArray=[[NSMutableArray alloc]init];
    NSArray *ar=@[@"Home-icon",@"Car-icon",@"Sofa-icon",@"Carpet-icon"];
    NSArray *ar1=@[@"Home",@"Car",@"Sofa",@"Carpet"];
    [cleanListImageViewArray addObjectsFromArray:ar];
    [cleanListLabelArray addObjectsFromArray:ar1];
    selectedItemIndexPath=nil;
    i=1;
    _numberOfRommNumber.text=[NSString stringWithFormat:@"%d BHK",i];
    _sanitizingButton.selected=YES;
    selectedItemIndexPath=[[NSMutableArray alloc]init];
    selectedSubCategoryCode=[[NSMutableArray alloc]init];
    postman=[[Postman alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.view.backgroundColor=[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    self.navigationController.navigationBarHidden=NO;
    _numberOfRommNumber.layer.borderWidth=1;
    _numberOfRommNumber.layer.borderColor=[UIColor whiteColor].CGColor;
    _numberOfRommNumber.layer.cornerRadius=5;
    subCategoryNameArray=[[NSMutableArray alloc]init];
    [self callAPI];
}
-(void)callAPI{
    url=[NSString stringWithFormat:@"%@%@/%@%@",baseUrl,getAllCategoriesURL,_categoryCode,getAllSubCategoriesUnderCategoryURL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseResponseObject:responseObject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)parseResponseObject:(id)responseObject{
    NSDictionary *responseDict=responseObject;
     NSArray *viewModelArray=responseDict[@"ViewModels"];
    for (NSDictionary *dict in viewModelArray) {
        if ([dict[@"Status"] boolValue]) {
        SubCategoryModel *model=[[SubCategoryModel alloc]init];
            NSDictionary *serviceType=dict[@"ServiceType"];
            model.code=dict[@"Code"];
            model.serviceTitle=dict[@"Name"];
            model.typeModels= [self typeModelsForArray:serviceType[@"ViewModels"]];
            [subCategoryNameArray addObject:model];
        }
    }
    [_collectionView reloadData];
}
- (NSArray *)typeModelsForArray:(NSArray *)dictArray
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in dictArray) {
        TypeModel *typeModel=[[TypeModel alloc]init];
        typeModel.code=dict[@"Code"];
        typeModel.serviceTitle=dict[@"Name"];
        typeModel.optionModels = [self optionModelsForArray:dict[@"ViewModels"]];
        [array addObject:typeModel];
    }
    
    return array;
}
- (NSArray *)optionModelsForArray:(NSArray *)dictArray
{
   NSMutableArray *array=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in dictArray) {
        OptionModel *model=[[OptionModel alloc]init];
        model.code=dict[@"Code"];
        model.serviceTitle=dict[@"Name"];
//        model.serviceDuration=dict[@"ServiceDuration"];
//        model.servicePrice=dict[@"ServicePrice"];
        [array addObject:model];
    }
    return array;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return subCategoryNameArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CleaningVCCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    SubCategoryModel *model=subCategoryNameArray[indexPath.row];
    cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-unselected-button"]];
    cell.itemCleaningImageView.image=[UIImage imageNamed:cleanListImageViewArray[0]];
    cell.itemName.text=model.serviceTitle;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     SubCategoryModel *model=subCategoryNameArray[indexPath.row];
    if ([selectedItemIndexPath containsObject:indexPath]) {
        CleaningVCCollectionViewCell *cell=(CleaningVCCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [selectedItemIndexPath removeObject:indexPath];
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-unselected-button"]];
        cell.selectTickMark.hidden=YES;
        [selectedSubCategoryCode removeObject:[NSString stringWithFormat:@"%@/%@",url,model.code]];
    }
    else{
    CleaningVCCollectionViewCell *cell=(CleaningVCCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-selected-button"]];
    cell.selectTickMark.hidden=NO;
        [selectedItemIndexPath addObject:indexPath];
        [selectedSubCategoryCode addObject:[NSString stringWithFormat:@"%@/%@",url,model.code]];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat collectionViewWidth=collectionView.frame.size.width/4;
    return CGSizeMake(collectionViewWidth,80);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,5, 10, 5);
}
- (IBAction)popViewController:(id)sende{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)navigationBackBarButtonSpacing{
    UIBarButtonItem *fixedbarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedbarbutton.width=-10;
    self.navigationItem.leftBarButtonItems=@[fixedbarbutton,_navigationBackBarButton];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (IBAction)increaseRommNumber:(id)sender {
    if (i>=1) {
        ++i;
        _numberOfRommNumber.text=[NSString stringWithFormat:@"%d BHK",i];
    }
}
- (IBAction)decreaseRoomNumber:(id)sender {
    if (i>1) {
        --i;
        _numberOfRommNumber.text=[NSString stringWithFormat:@"%d BHK",i];
    }

}
- (IBAction)deepCleaning:(id)sender {
    _sanitizingButton.selected=NO;
    _deepCleaningButton.selected=YES;
}
- (IBAction)sanitizing:(id)sender {
    _sanitizingButton.selected=YES;
    _deepCleaningButton.selected=NO;
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
