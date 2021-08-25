//
//  PLPMineBaseVC.m
//  2021-Philips
//
//  Created by Apple on 2021/5/7.
//  Copyright © 2021 com.Kaadas. All rights reserved.
//

#import "PLPMineBaseVC.h"
#import "PLPFormUtils.h"

@interface PLPMineBaseVC () 
//返回按钮
@property(nonatomic,strong) UIButton * backButton;
//导航栏标题
@property(nonatomic,strong) UILabel * navigationTitleLabel;
@end

@implementation PLPMineBaseVC





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.navigationController)
    {
        [self setBackButton];
        [self setNavigationTitleLabel];
//        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [self initializeForm];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 导航栏功能
-(void)setBackButton{
    //设置返回按钮
    UIBarButtonItem * backBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
}
-(void)setNavigationTitleLabel{
    //设置标题
    self.navigationItem.titleView = self.navigationTitleLabel;
    self.navigationTitleLabel.text = self.title;
    
}

-(UIButton *)backButton{
    if (!_backButton) {
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 50, 40);
        [_backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
//        _backButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
        [_backButton addTarget:self action:@selector(navBackClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backButton;
}

-(UILabel *)navigationTitleLabel{
    if (!_navigationTitleLabel) {
        self.navigationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 150, 30)];
        _navigationTitleLabel.font = [UIFont systemFontOfSize:17.0];
        _navigationTitleLabel.textColor = [UIColor blackColor];
        _navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _navigationTitleLabel;
}


#pragma mark - click 导航栏按钮点击方法，右按钮点击方法都需要子类来实现
-(void)navBackClick{
        [self.navigationController popViewControllerAnimated:YES];
}

-(void) initializeForm {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [PLPFormUtils tableViewBackgroudColor];
    
    XLFormDescriptor * form;
//    XLFormSectionDescriptor * section;
//    XLFormRowDescriptor * row;
//
//    __weak __typeof(self)weakSelf = self;
    form = [XLFormDescriptor formDescriptor];
    
    
    
    
    self.form = form;
    
 
    

}



@end
