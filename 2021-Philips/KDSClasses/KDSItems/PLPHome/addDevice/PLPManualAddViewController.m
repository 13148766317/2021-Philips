//
//  PLPManualAddViewController.m
//  2021-Philips
//
//  Created by kaadas on 2021/4/27.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPManualAddViewController.h"
#import "KDSFuntionTabListCell.h"
#import "KDSAddVideoWifiLockStep3VC.h"

#import "PLPAddVideoWifiLockStep3VC.h"

#import "PLPProductListManager.h"

#import "KDSFormController.h"

#import "PLPFormUtils.h"
#import "PLPAddDeviceSectionHeaderView.h"

@interface PLPManualAddViewController ()<UICollectionViewDelegate ,UICollectionViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong) UITextField  *devTextField;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) PLPProductCategory datasourceCategory;
@property (nonatomic, strong) NSArray *productCategorys;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *,NSMutableArray<PLPProductInfo *>*> *productListDict;
//用于搜索产品
@property (nonatomic, strong) NSString *lastSearchKeyword;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) KDSFormController *searchFormController;
@property (nonatomic, strong) NSMutableArray<XLFormRowDescriptor *> *searchDataSource;
@property (nonatomic, strong) XLFormSectionDescriptor *searchFormSection;

@property (nonatomic,strong)  UIView  * customView;
@property (nonatomic,strong)   UIView  *  scanLine ;
@property (nonatomic,strong)   UIView  *  manualLine ;
@end

@implementation PLPManualAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.navigationTitleLabel.text =Localized(@"手动添加");
  //  自动右边的buttin
    self.customView  = [UIView new];
    self.customView.frame = CGRectMake(0, 0, kScreenWidth-40, 100);
    self.customView.backgroundColor = UIColor.whiteColor;
   // 添加3个自定义view
    UIView *scanView = [UIView new];
    scanView.backgroundColor = UIColor.whiteColor;
    scanView.frame = CGRectMake(0, 0, 100, 45);
    [self.customView addSubview:scanView];
    
    UIView *manualView = [UIView new];
    manualView.backgroundColor = UIColor.whiteColor;
    manualView.frame = CGRectMake(100+30, 0, 100, 45);
    [self.customView addSubview:manualView];
    
    UIButton  *button = [UIButton new];
    button.tag = 100;
    [button setTitle:@"扫码添加" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setFont:[UIFont systemFontOfSize:17]];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    button.frame = CGRectMake(5, 0, 80, 30);
    [scanView addSubview:button];
    self.scanLine  = [UIView new];
    _scanLine.backgroundColor = UIColor.whiteColor;
    _scanLine.frame = CGRectMake(0, 41, 90, 4);
    [scanView addSubview:_scanLine];
    
    UIButton  *manualbutton = [UIButton new];
    manualbutton.tag = 100;
    [manualbutton setTitle:@"手动添加" forState:UIControlStateNormal];
    [manualbutton addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [manualbutton setFont:[UIFont systemFontOfSize:17]];
    [manualbutton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    manualbutton.frame = CGRectMake(5, 0, 80, 30);
    [manualView addSubview:manualbutton];
    self.manualLine  = [UIView new];
    _manualLine.backgroundColor = KDSRGBColor(0, 102, 161);
    _manualLine.frame = CGRectMake(0, 41, 90, 4);
    [manualView addSubview:_manualLine];
    
    UIBarButtonItem *rightButtonView = [[UIBarButtonItem alloc] initWithCustomView:self.customView];
    self.navigationItem.rightBarButtonItem = rightButtonView;
    [self.navigationItem.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    
    self.productCategorys = [[PLPProductListManager sharedInstance] productCategorys];
    
    [self setupUI];
}

- (void)selectedBtn :(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.tag ==100) {
        self.scanLine.backgroundColor = KDSRGBColor(0, 102, 161);
        self.manualLine.backgroundColor = [UIColor whiteColor];
    // 返回到上一页
     [self.navigationController  popViewControllerAnimated:YES];
    }else{ // 选中手动添加
        self.scanLine.backgroundColor = [UIColor whiteColor];
        self.manualLine.backgroundColor = KDSRGBColor(0, 102, 161);
        
    }
    
    NSLog(@"按钮的点击事件line1");
}
-(void)setupUI{
    UIView * topView = [UIView new];
    topView.backgroundColor = UIColor.whiteColor;
    topView.layer.cornerRadius = 5;
    topView.layer.masksToBounds = YES;
    topView.layer.borderWidth= 1;
    topView.layer.borderColor = KDSRGBColor(0, 102, 161).CGColor;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.height.equalTo(@44);
    }];
    UIView * searchView = [UIView new];
    searchView.backgroundColor = UIColor.whiteColor;
    [topView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(topView.mas_left).offset(13);
        make.right.equalTo(topView.mas_right).offset(-60);
    }];
    
    UIImageView * searchIconImg = [UIImageView new];
    searchIconImg.image = [UIImage imageNamed:@"icon-search"];
    [searchView addSubview:searchIconImg];
    [searchIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(searchView.mas_left).offset(5);
        make.centerY.equalTo(searchView);
        
    }];
    _devTextField = [UITextField new];
    _devTextField.borderStyle = UITextBorderStyleNone;
    _devTextField.font = [UIFont systemFontOfSize:15];
    _devTextField.keyboardType = UIKeyboardTypeDefault; //UIKeyboardTypeASCIICapable;
    _devTextField.placeholder = Localized(@"请输入您的门锁型号");
    [searchView addSubview:_devTextField];
 //   [_devTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_devTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIconImg.mas_right).offset(7);
        make.right.equalTo(searchView.mas_right).offset(0);
        make.top.equalTo(searchView.mas_top).offset(0);
        make.bottom.equalTo(searchView.mas_bottom).offset(0);
    }];
    //添加一个搜索的button
    UIButton  * searchBtn = [UIButton new];
    searchBtn.backgroundColor = KDSRGBColor(0, 102, 161);
    [searchBtn setTitle:Localized(@"搜索") forState:UIControlStateNormal];
    [topView addSubview:searchBtn];
    [searchBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(topView);
        make.left.equalTo(searchView.mas_right);
        
    }];
  
// 智能锁分割线
    UIView   * lineView = [UIView new];
    //lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    [lineView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(50);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    
    UILabel * textlabel = [UILabel new];
    textlabel.text = Localized(@"智能锁");
    textlabel.textColor = KDSRGBColor(0, 102, 161);
    [lineView addSubview:textlabel];
    [textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView).offset(15);
        make.width.equalTo(@60);
        make.centerY.equalTo(lineView.mas_centerY);
    }];
    
    UIView  * line = [UIView new];
    line.backgroundColor = [UIColor grayColor];
    [lineView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textlabel.mas_right).offset(30);
        make.centerY.equalTo(lineView.mas_centerY);
        make.width.equalTo(@90);
        make.height.equalTo(@1);
        
    }];
    UILabel * textlabel2 = [UILabel new];
    textlabel2.text = Localized(@"智能锁");
    textlabel2.textColor = [UIColor grayColor];
    textlabel2.font = [UIFont systemFontOfSize:14];
    [lineView addSubview:textlabel2];
    [textlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(18);
        make.width.equalTo(@50);
        make.centerY.equalTo(lineView.mas_centerY);
    }];
    
    UIView  * line2 = [UIView new];
    line2.backgroundColor = [UIColor grayColor];
    [lineView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textlabel2.mas_right).offset(18);
        make.centerY.equalTo(lineView.mas_centerY);
        make.width.equalTo(@90);
        make.height.equalTo(@1);
        
    }];
    
  // 锁的列表视图
    UIView  * lockList = [UIView new];
    lockList.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lockList];
    [lockList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.height.equalTo(@500);
        make.left.equalTo(self.view).offset(117);
        make.right.equalTo(self.view).offset(-16);
    }];
    
    // 拷贝晾衣机的collectionView
    [lockList addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(lockList);
    }];
    
    self.devTextField.delegate = self;
    
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        self.searchTableView
        = [[UITableView alloc] init];
        [self.view addSubview:_searchTableView];
        [_searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.devTextField.mas_bottom);
            make.bottom.equalTo(self.view.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
        _searchTableView.tableFooterView = [UIView new];
    }
    return _searchTableView;
}

- (KDSFormController *)searchFormController {
    if (!_searchFormController) {
        XLFormDescriptor *form = [XLFormDescriptor formDescriptor];
        self.searchFormSection = [XLFormSectionDescriptor formSection];
        [form addFormSection:self.searchFormSection];
        self.searchFormController= [[KDSFormController alloc] initWithForm:form];
        _searchFormController.tableView = self.searchTableView;
        [_searchFormController viewDidLoad];
    }
    return _searchFormController;
}


- (NSMutableArray<XLFormRowDescriptor *> *)searchDataSource {
    if (!_searchDataSource) {
        self.searchDataSource = [[NSMutableArray alloc] init];
    }
    return _searchDataSource;
}

-(void) updateSearchDataSource: (NSArray <PLPProductInfo *>*) dataSource {
    NSUInteger count = self.searchDataSource.count;
    for (NSUInteger i=0; i< count; i++) {
        [self.searchFormSection removeFormRow:self.searchDataSource[i]];
    }
    
    [self.searchDataSource removeAllObjects];
    if (dataSource && dataSource.count) {
        __weak __typeof(self)weakSelf = self;
        for (NSUInteger i=0; i<dataSource.count; i++) {
            PLPProductInfo *product = dataSource[i];
            XLFormRowDescriptor *row = [PLPFormUtils genRowTag:product.idField imageName:nil title:[product plpDisplayName]  subTitle:nil formBlock:^(XLFormRowDescriptor * _Nonnull sender) {
                [weakSelf presentAddDeviceVC:sender.value];
            } cellStyle:UITableViewCellStyleDefault enableDefaultAccessoryView:NO];
            //row.value = product;
            [self.searchFormSection addFormRow:row];
            [self.searchDataSource addObject:row];
        }
    }
    
    [self.searchTableView reloadData];
}

#pragma mark - 添加设备

-(void) presentAddDeviceVC:(PLPProductInfo *) product {
    
    KDSAddVideoWifiLockStep3VC  *vc  = [KDSAddVideoWifiLockStep3VC new];
    vc.isAgainNetwork = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark   UICollectionView 代理的实现


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSNumber *category = self.productCategorys[section];
    NSArray *productList = [[PLPProductListManager sharedInstance] searchProductList:[category unsignedIntegerValue]];
    return productList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  self.productCategorys.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KDSFuntionTabListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTQVideoListCell" forIndexPath:indexPath];
   // KDSFuntionTabModel *data = self.dataSource[indexPath.item];
    //是因为命名冲突导致的问题
    //[cell setupData:nil];
    NSNumber *category = self.productCategorys[indexPath.section];

    NSArray *productList = [[PLPProductListManager sharedInstance] searchProductList:[category unsignedIntegerValue]];

    [cell setupDataModel:productList[indexPath.row]];
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    return cell;
}
// 返回cell的间距
// 3.这个是两行cell之间的最小间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 30;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KDSLog(@"控件的点击事件");
    //进入管理者模式
  //  PLPAddVideoWifiLockStep3VC  * vc = [PLPAddVideoWifiLockStep3VC new];
//    KDSAddVideoWifiLockStep3VC  *vc  = [KDSAddVideoWifiLockStep3VC new];
//    vc.isAgainNetwork = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    NSNumber *category = self.productCategorys[indexPath.section];

    NSArray *productList = [[PLPProductListManager sharedInstance] searchProductList:[category unsignedIntegerValue]];
    
    [self presentAddDeviceVC:productList[indexPath.row]];
}
//  控件懒加载
- (UICollectionView *)collectionView{
    if (_collectionView ==nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenWidth -117-15-30) / 3;
        CGFloat itemH = 90;
        layout.itemSize = CGSizeMake(itemW, itemH);
       // layout.sectionInset = UIEdgeInsetsMake(40, 40, 40, 40);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
       // layout.minimumLineSpacing = 20;
       // layout.minimumInteritemSpacing = 10;
        
        layout.headerReferenceSize=CGSizeMake((kScreenWidth -117-15-30), 30);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //_collectionView.backgroundColor =KDSRGBColor(242, 242, 242);
        [_collectionView registerClass:[KDSFuntionTabListCell class] forCellWithReuseIdentifier:@"TTQVideoListCell"];
        _collectionView.scrollEnabled = YES;
        
        //[_collectionView registerClass:[PLPAddDeviceSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    KDSLog(@"textFieldDidBeginEditing");
    self.searchFormController.tableView.hidden = NO;
    [self updateSearchDataSource:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    KDSLog(@"textFieldDidEndEditing");

    self.searchFormController.tableView.hidden = YES;
    textField.text = @"";
    self.lastSearchKeyword = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void) textFieldTextDidChange {
    KDSLog(@"textFieldTextDidChange %@",self.devTextField.text);
    NSString *searchText = [self.devTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![searchText isEqualToString:self.lastSearchKeyword
        ]) {
        
        self.lastSearchKeyword = searchText;
        
        if (self.lastSearchKeyword.length) {
            [self updateSearchDataSource:[[PLPProductListManager sharedInstance] searchProductList:PLPProductCategoryAll keyword:searchText]];
        }else {
            [self updateSearchDataSource:nil];
        }
        
    }
    
}
@end
