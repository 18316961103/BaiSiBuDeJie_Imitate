//
//  MeTableViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/8.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "MeTableViewController.h"
#import "SettingTableViewController.h"
#import "MeSquareCell.h"
#import "MeSquareItem.h"
#import <SafariServices/SafariServices.h>
#import "WebViewController.h"
#import "LoginViewController.h"

@interface MeTableViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    活动数据源    */
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

static NSString *const ID = @"cell";
// 列数
static NSInteger const cols = 4;
// 行列间距
static NSInteger const margin = 1;
// 计算item的宽高
#define itemWH ((kScreenW - (cols - 1) * margin) / cols)

@implementation MeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setupNavBar];
    
    // 设置tableViewFooterView
    [self setupFooterView];
    
    // 加载数据
    [self loadData];
    
    // 处理section的间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 15;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        _dataArray = array;
        
    }
    return _dataArray;
}

#pragma mark - 设置tableViewFooterView
- (void)setupFooterView {
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置item大小
    
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    // 创建collectionView
    // 注意：footerView的x、y和width都不需要设置，写0即可
    UICollectionView *collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    
    collectionView.backgroundColor = self.tableView.backgroundColor;
    // 设置collectionView不能滚动
    collectionView.scrollEnabled = NO;

    // 设置数据源
    collectionView.dataSource = self;
    // 设置代理
    collectionView.delegate = self;
    // 注册collectionViewCell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MeSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    self.collectionView = collectionView;
    
    self.tableView.tableFooterView = collectionView;
    
}

#pragma mark - 加载数据
- (void)loadData {
    
    // 创建会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";

    // 发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        WYLog(@"%@",responseObject);
        
        self.dataArray = [MeSquareItem mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"square_list"]];
        
        // 处理数据
//        [self resolveData];
        // 重新设置collectionView的高度
        // Rows = （counts - 1）/ cols + 1
        NSInteger rows = (self.dataArray.count - 1) / cols + 1 ;
        self.collectionView.height = rows * itemWH;
        
        // 设置tableView的滚动范围,直接这样设置会有问题，跳转后再返回会有问题
//        self.tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.collectionView.frame));
        self.tableView.tableFooterView = self.collectionView;
        
        // 刷新数据
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WYLog(@"%@",error);
    }];
    
}

#pragma mark - 处理数据
- (void)resolveData {
    
    NSInteger extr = cols - self.dataArray.count % 4;
    
    // 增加空的模型，保证每一行都有四个item
    for (int i = 0; i < extr; i++) {
        
        MeSquareItem *item = [[MeSquareItem alloc] init];
        
        [self.dataArray addObject:item];
    }
    
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    
    // 设置按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highlightImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(settingClick)];
    // 夜间模式
    UIBarButtonItem *nightItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selectedImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(nightClick:)];

    // 设置导航条右边的按钮
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    // 设置导航条标题
    self.navigationItem.title = @"我的";
    
}

#pragma mark - 导航条右边设置按钮的点击
- (void)settingClick {
    
    WYFunc;
    
    SettingTableViewController *settingVc = [[SettingTableViewController alloc] init];
    
    // 隐藏tabBar 必须在跳转之前设置，否则无效
    settingVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:settingVc animated:YES];
}

#pragma mark - 导航条右边夜间模式按钮的点击
- (void)nightClick:(UIButton *)button {
    
    WYFunc;
    
    button.selected = !button.selected;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        
        [self presentViewController:loginVc animated:YES completion:nil];
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MeSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.item = self.dataArray[indexPath.row];
        
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MeSquareItem *item = self.dataArray[indexPath.row];
    
    // 不包含http的不能跳转
    if (![item.url containsString:@"http"]) return;
    
    // SFSafariViewController : iOS9才能用
//    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:item.url]];
//    
//    // 推荐使用Modal方式跳转
//    [self presentViewController:safariVc animated:YES completion:nil];
    
    // 使用WKWebView，WKWebView是UIWebView的升级版，可以监听进度以及缓存,iOS8才可以使用
    WebViewController *webViewVc = [[WebViewController alloc] init];
    webViewVc.url = [NSURL URLWithString:item.url];
    [self.navigationController pushViewController:webViewVc animated:YES];
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
