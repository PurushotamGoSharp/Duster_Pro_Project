#import "ServicesSelectionViewController.h"
#import "MenuOptionBaseModel.h"
#import "SubCategoryModel.h"
#import "SubServiceCell.h"
#import "TypeModel.h"
#import "TypeSingleSelectionCell.h"
#import "OptionModel.h"
#import "TypeMuliSelectCell.h"
#import "NetworkHandler.h"
#import "MBProgressHUD.h"
#import "TotalCostDetailModel.h"
#import "TotalCostDetailView.h"
#import "SelectCleaningTimeViewController.h"
#import "Constant.h"

@interface ServicesSelectionViewController () <UITableViewDataSource, UITableViewDelegate, MainServiceCellProtocol, TypeMuliSelectCellProtocol, heightOfCostDetailView, TypeSingleSelectCellProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalCostViewHightConst;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarButton;
@property (weak, nonatomic) IBOutlet TotalCostDetailView *totalCostView;
@end

@implementation ServicesSelectionViewController
{
    BOOL haveSubCategroy;
    NSArray *allSubCategories;
    NSMutableArray *selectedSubCategories;
    NetworkHandler *netHandler;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    netHandler = [[NetworkHandler alloc] init];
    
    
    self.totalCostView.delegateForHeightofCostDetailView = self;
    [self updateTotalCostView];

    allSubCategories = self.categoryModel.allSubCategories;
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [netHandler getSubCatergoiesFor:self.categoryModel.code
//                withCompletionBlock:^(BOOL success, NSArray *subCategories) {
//                    if (success)
//                    {
//                        allSubCategories = subCategories;
//                        [self.tableView reloadData];
//                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    }
//                }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self navigationBackBarButtonSpacing];
    self.title = self.categoryModel.name;
}

- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)proceedBtn:(UIButton *)sender
{
    if ([self checkWhetherToProceed])
    {
        [self performSegueWithIdentifier:@"UserDetailsSegue" sender:nil];
    }
}

- (BOOL)checkWhetherToProceed
{
    if (![self.categoryModel isAnySelectionMade])
    {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode=MBProgressHUDModeText;
        hud.labelText = @"Select a service";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        return NO;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserDetailsSegue"])
    {
        SelectCleaningTimeViewController *timeVC = segue.destinationViewController;
        timeVC.category = self.categoryModel;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (selectedSubCategories.count)
    {
        return 2;
    }
    
    if (allSubCategories.count == 0)
    {
        return 0;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return selectedSubCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [self configureMainServiceCellForModel:nil];
    }else {
        SubCategoryModel *model = selectedSubCategories[indexPath.row];
        if (model.isInspectionRequired)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SubCatInspecCell"];
            UILabel *label = (UILabel *)[cell viewWithTag:150];
            label.text = model.insepectionDescription;
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:151];
            UILabel *priceLabel = (UILabel *)[cell viewWithTag:152];
            titleLabel.text = model.serviceTitle;
            priceLabel.text = [NSString stringWithFormat:@"%@%.2f", kRUPPEE_SYMBOL,[model priceOfSelections]];

        }else
        {
            if (model.multiSelection)
            {
                cell = [self configureMulitSelcTypeForSubServiceModel:model];
            }else
            {
                cell = [self configureSingleSelectionTypeCellForSubServiceModel:model];
            }
        }
    }
    return cell;
}

- (SubServiceCell *)configureMainServiceCellForModel:(MenuOptionBaseModel *)model {
    SubServiceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MainServiceCellID"];
    cell.subCategoryArray = allSubCategories;
    cell.delegate = self;
    return cell;
}

- (TypeSingleSelectionCell *)configureSingleSelectionTypeCellForSubServiceModel:(SubCategoryModel *)subService {
    TypeSingleSelectionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TypeSingleSelectionCell"];
    cell.subCategoryModel = subService;
    cell.delegate = self;
    return cell;
}

- (TypeMuliSelectCell *)configureMulitSelcTypeForSubServiceModel:(SubCategoryModel *)subService
{
    TypeMuliSelectCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TypeMuliSelectCell"];
    cell.subCategoryModel = subService;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 100;
    }
    SubCategoryModel *model = selectedSubCategories[indexPath.row];
    return [model cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Services Offered";
    }
    
    return @"Additional Details";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(8, 5, 320, 20);
    myLabel.font = [UIFont systemFontOfSize:16];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

#pragma mark
#pragma mark MainServiceCellProtocol
- (void)mainService:(SubServiceCell *)cell withData:(MenuOptionBaseModel *)subServiceModel deselectedAtIndex:(NSInteger)index
{
    //DESELECT
    [selectedSubCategories removeObject:subServiceModel];
    [self.tableView reloadData];
    self.categoryModel.selectedSubCats = selectedSubCategories;
    [self displayDetailsOfView];
    NSLog(@"Deselected at index %li", (long)index);
}

- (void)mainService:(SubServiceCell *)cell withData:(MenuOptionBaseModel *)subServiceModel selectedAtIndex:(NSInteger)index
{
    //Select
    NSLog(@"Selected at index %li", (long)index);
    
    if (selectedSubCategories == nil) {
        selectedSubCategories = [[NSMutableArray alloc] init];
    }
    [selectedSubCategories insertObject:subServiceModel atIndex:0];
    [self.tableView reloadData];
    self.categoryModel.selectedSubCats = selectedSubCategories;
    [self displayDetailsOfView];
}

- (void)typeCell:(TypeMuliSelectCell *)typeCell selectedType:(TypeModel *)typeModel
{
    [self.tableView reloadData];
}

- (void)typeCell:(TypeMuliSelectCell *)typeCell deselectedType:(TypeModel *)typeModel
{
    [self.tableView reloadData];
}

- (void)getHeightOfCostDetailView:(CGFloat)frameHeight
{
    [self updateTotalCostView];
    [UIView animateWithDuration:.3
                     animations:^{
                         self.totalCostViewHightConst.constant = frameHeight;
                         [self.view layoutIfNeeded];
                     }];
}
- (void)selectedTypeOnSubCategroy
{
//    [UIView setAnimationsEnabled:NO];
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
//    [UIView setAnimationsEnabled:YES];
    [self.tableView reloadData];
}

- (void)optionValueChangedFor:(UITableViewCell *)cell
{
    [self updateTotalCostView];
}

- (void)displayDetailsOfView
{
    [self updateTotalCostView];
    self.totalCostViewHightConst.constant = [self.totalCostView heightOfView];
//    [self.view layoutIfNeeded];
}

- (void)updateTotalCostView
{
    self.totalCostView.detailArray = [self.categoryModel totalCostDetailObjects];
    [self.totalCostView updateView];
}

- (NSArray *)types
{
    NSMutableArray *typesArray = [[NSMutableArray alloc] init];
    TypeModel *model = [[TypeModel alloc] init];
    model.serviceTitle = @"Deep Cleaning";
    model.type = UIElementTypeSingleSelectionChoice;
    model.optionModels = [self optionsObjects];
    [typesArray addObject:model];
    
    model = [[TypeModel alloc] init];
    model.serviceTitle = @"Deep Cleaning";
    model.type = UIElementTypeSingleSelectionChoice;
    model.optionModels = [self optionsObjects];
    [typesArray addObject:model];
    
    return typesArray;
}

- (NSArray *)optionsObjects
{
    NSMutableArray *optionsArray = [[NSMutableArray alloc] init];
    OptionModel *model = [[OptionModel alloc] init];
    model.serviceTitle = @"1 bhk";
    model.type = UIElementTypeNumericSelection;
    model.servicePrice = 100;
    [optionsArray addObject:model];
    
    model = [[OptionModel alloc] init];
    model.serviceTitle = @"2 bhk";
    model.type = UIElementTypeNumericSelection;
    model.servicePrice = 200;
    [optionsArray addObject:model];
    
    model = [[OptionModel alloc] init];
    model.serviceTitle = @"3 bhk";
    model.type = UIElementTypeNumericSelection;
    model.servicePrice = 400;
    [optionsArray addObject:model];
    
    model = [[OptionModel alloc] init];
    model.serviceTitle = @"4 bhk";
    model.type = UIElementTypeNumericSelection;
    model.servicePrice = 1000;
    [optionsArray addObject:model];
    
    return optionsArray;
}

-(void)navigationBackBarButtonSpacing
{
    UIBarButtonItem *fixedbarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedbarbutton.width=-10;
    self.navigationItem.leftBarButtonItems=@[fixedbarbutton,_backBarButton];
}

@end
