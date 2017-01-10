#import "DustProHomeViewController.h"
#import "DustProHomeListCollectionViewCell.h"
#import "SWRevealViewController.h"
#import "ChangePasswordViewController.h"
#import "Postman.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "CategroyModel.h"
#import "CleaningViewController.h"
#import "ServicesSelectionViewController.h"
#import "GetImageModel.h"
#import "CarpentryViewController.h"
#import "SeedSyncer.h"
#import "NetworkHandler.h"
#import "VMEnvironment.h"

@interface DustProHomeViewController ()<SWRevealViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation DustProHomeViewController
{
    NSMutableArray *cleanListLabelArray;
    Postman *postman;
    NSMutableArray *categoryArray;
    NSInteger selectedButtonTag;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cleanListLabelArray=[[NSMutableArray alloc]init];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate=self;
    postman = [[Postman alloc] init];
    [self.revealViewController setRearViewRevealWidth:180];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    categoryArray=[[NSMutableArray alloc]init];

    [[SeedSyncer sharedSyncer] callSeedAPI:^(BOOL success) {
        
        if ([userDefault boolForKey:@"category_FLAG"] || [userDefault boolForKey:@"subcategory_FLAG"] || [userDefault boolForKey:@"servicetype_FLAG"] || [userDefault boolForKey:@"option_FLAG"])
        {
            [self callAPI];
        }

    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.revealViewController.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.view.backgroundColor=[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1];
//    self.navigationController.navigationBarHidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    if ([userDefault boolForKey:@"category_FLAG"] || [userDefault boolForKey:@"subcategory_FLAG"] || [userDefault boolForKey:@"servicetype_FLAG"] || [userDefault boolForKey:@"option_FLAG"])
    {
//        [self callAPI];
    }else
    {
        NSString *url=[NSString stringWithFormat:@"%@%@",base_url,getAllCategoriesURL];

        [[SeedSyncer sharedSyncer] getResponseFor:url
                                completionHandler:^(BOOL success, id response) {
                                    if (success)
                                    {
                                        [self processResponse:response];
                                    }
//                                    else
//                                    {
//                                        [self callAPI];
//                                    }
                                }];
    }
    
}

- (IBAction)SlideOutBar:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return categoryArray.count + 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DustProHomeListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == categoryArray.count) {
        cell.button.tag = indexPath.item;
        cell.cleaningListLabel.text = @"My Bookings";
        cell.cleaningListImageView.image = [UIImage imageNamed:@"mybookings-icon"];
    } else {
        CategroyModel *model=categoryArray[indexPath.row];
        cell.button.tag=indexPath.item;
        cell.cleaningListLabel.text=model.name;
        cell.cleaningListImageView.image= model.imageOfCategory;
    }
    [cell.button addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)selectCell:(UIButton*)btn{
    if (btn.tag == categoryArray.count) {
        [self performSegueWithIdentifier:@"MyBooking" sender:nil];
    }
    else{
        selectedButtonTag=btn.tag;
        CategroyModel *model = categoryArray[selectedButtonTag];
        if (model.isInspectionRequired ) {
            [self performSegueWithIdentifier:@"CarpentryServices" sender:nil];
        }
        else [self performSegueWithIdentifier:@"ServiceOfferedSegue" sender:nil];
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionViewWidth = collectionView.frame.size.width/2;
    return CGSizeMake(collectionViewWidth, 163);
}

- (void)callAPI{
    NSString *url=[NSString stringWithFormat:@"%@%@",base_url,getAllCategoriesURL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponse:responseObject];
        [[SeedSyncer sharedSyncer] saveResponse:[operation responseString] forIdentity:url];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:@"category_FLAG"];
        [userDefault setBool:NO forKey:@"subcategory_FLAG"];
        [userDefault setBool:NO forKey:@"servicetype_FLAG"];
        [userDefault setBool:NO forKey:@"option_FLAG"];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (void)processResponse:(id)responseObject
{
    NetworkHandler *netHandler = [[NetworkHandler alloc] init];
    categoryArray = [[NSMutableArray alloc] init];
    NSDictionary *responseDict=responseObject;
    for (NSDictionary *dict in responseDict[@"ViewModels"]) {
        if ([dict[@"Status"] intValue]==1) {
            CategroyModel *model=[[CategroyModel alloc]init];
            GetImageModel *imageModel=[[GetImageModel alloc]init];
            model.Id=dict[@"Id"];
            model.name=dict[@"Name"];
            model.documentDetails=dict[@"DocumentDetails"];
            if (model.documentDetails.count>0) {
                [imageModel getJsonData:model.documentDetails onComplete:^(UIImage *image) {
                    if (image)
                    {
                        model.imageOfCategory=image;
                        [_collectinView reloadData];
                    }
                } onError:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
            model.code=dict[@"Code"];
            model.DayStartTime = dict[@"DayStartTime"];
            model.DayEndTime = dict[@"DayEndTime"];
            model.isInspectionRequired=[dict[@"IsInspectionrequired"] boolValue];
            model.allSubCategories = [netHandler parseResponseObject:dict[@"SubCategory"]];
            [categoryArray addObject:model];
        }
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if (position==FrontViewPositionRight) {
        UIView *topView=[[UIView alloc]initWithFrame:self.view.frame];
        [topView setTag:111];
        [self.view addSubview:topView];
        SWRevealViewController *revealVC=self.revealViewController;
        if (revealVC) {
            [topView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            [topView addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        }
    }else if(position==FrontViewPositionLeft){
        UIView *lower=[self.view viewWithTag:111];
        [lower removeFromSuperview];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ServiceOfferedSegue"])
    {
        ServicesSelectionViewController *serviceVC = segue.destinationViewController;
        CategroyModel *model = categoryArray[selectedButtonTag];
        serviceVC.categoryModel = model;
    }
    else if ([segue.identifier isEqualToString:@"CarpentryServices"])
    {
        CarpentryViewController *carpentVC = segue.destinationViewController;
        CategroyModel *model = categoryArray[selectedButtonTag];
        carpentVC.categoryModel = model;
    }
}

@end
