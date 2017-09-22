//
//  TopicTableViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/22.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TopicTableViewController.h"
#import "TopicCell.h"

@interface TopicTableViewController ()

/**    加载下一页需要传的字段    */
@property (copy, nonatomic) NSString *maxtime;
/**    footerView    */
@property (strong, nonatomic) UIView *footerView;
/**    headerView    */
@property (strong, nonatomic) UIView *headerView;
/**    footerLabel    */
@property (strong, nonatomic) UILabel *footerLabel;
/**    headerLabel    */
@property (strong, nonatomic) UILabel *headerLabel;

/**    帖子的数据    */
@property (strong, nonatomic) NSMutableArray *topicData;

/**    上拉加载状态    */
@property (assign, nonatomic) BOOL footerRefreshing;
/**    下拉刷新状态    */
@property (assign, nonatomic) BOOL headerRefreshing;

@end

static NSString *const TopicCellID = @"TopicCellID";

@implementation TopicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(NavMaxY + TitleViewH, 0, TabBarH, 0);
    // 设置滚动条的内边距与tableView一样
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    // 不要系统的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景颜色
    self.tableView.backgroundColor = Color(206, 206, 206);
    
    // 设置底部加载的View
    [self setupFooter];
    // 设置顶部刷新
    [self setupHeader];
    // 刷新数据
    [self refreshData];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TopicCell class]) bundle:nil] forCellReuseIdentifier:TopicCellID];
    
    // 监听tabBar被重复点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonRepeatClick) name:WYTabBarDidRepeatClickNotificationName object:nil];
    // 监听titlaButton被重复点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonRepeatClick) name:TitleButtonDidRepeatClickNotificationName object:nil];
}

- (NSMutableArray *)topicData {
    
    if (!_topicData) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        _topicData = array;
        
    }
    
    return _topicData;
    
}

- (TopicCellType)type {
    
    return TopicCellTypeAll;
    
}

#pragma mark - tabBar被重复点击的通知
- (void)tabBarButtonRepeatClick {
    // 判断我所在的控制器是不是当前显示的控制器，如果不是则不用处理
    if (self.view.window == nil) return;
    // 判断当前控制器显示的View是不是我的View，如果不是则不用处理
    if (self.tableView.scrollsToTop == NO) return;
    
    WYFunc;
    
    // 刷新数据
    [self refreshData];
    
}

#pragma mark - titlaButton被重复点击的通知
- (void)titleButtonRepeatClick {
    
    [self tabBarButtonRepeatClick];
    
}

#pragma mark - 添加底部加载View
- (void)setupFooter {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
    footerView.backgroundColor = [UIColor redColor];
    
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, footerView.width, footerView.height)];
    footerLabel.text = @"上拉可以加载更多";
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    
    [footerView addSubview:footerLabel];
    
    self.tableView.tableFooterView = footerView;
    
    self.footerView = footerView;
    self.footerLabel = footerLabel;
    
}

#pragma mark - 添加顶部刷新的View
- (void)setupHeader {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, kScreenW, 50)];
    headerView.backgroundColor = [UIColor blueColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.width, headerView.height)];
    headerLabel.text = @"下拉可以刷新";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:headerLabel];
    
    [self.tableView addSubview:headerView];
    
    self.headerView = headerView;
    self.headerLabel = headerLabel;
    
}

#pragma mark - 刷新数据
- (void)refreshData {
    
    // 如果正在加载更多数据，直接返回，防止同时存在下拉刷新和上拉加载
    if (self.footerRefreshing) return;
    
    // 如果正在下拉刷新，直接返回
    if (self.headerRefreshing) return;
    
    // 进入刷新状态
    self.headerRefreshing = YES;
    self.headerLabel.text = @"正在刷新";
    self.headerView.backgroundColor = [UIColor purpleColor];
    self.headerLabel.textColor = [UIColor yellowColor];
    
    [UIView animateWithDuration:0.25 animations:^{
        // 增加内边距，使得保持刷新状态
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top += 50;
        self.tableView.contentInset = inset;
        
        // 修改偏移量
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,  - inset.top);
        
    }];
    
    [self loadNewData];
    
}

#pragma mark - 请求数据
- (void)loadNewData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    
    
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.maxtime = [[responseObject objectForKey:@"info"] objectForKey:@"maxtime"];
        
        // 字典数组 -> 模型数据
        self.topicData = [TopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        WYLog(@"%@",error);
        
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试！"];
        
    }];
    
}

#pragma mark - 停止刷新
- (void)endRefreshing {
    
    self.headerRefreshing = NO;
    
    // 减少内边距，退出刷新状态
    [UIView animateWithDuration:0.25 animations:^{
        // 减少内边距，使得保持刷新状态
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= 50;
        self.tableView.contentInset = inset;
    }];
    
}

#pragma mark - 加载更多数据
- (void)loadMoreData {
    // 如果正在下拉刷新，直接返回，防止同时存在下拉刷新和上拉加载
    if (self.headerRefreshing) return;
    
    // 如果正在加载更多数据，直接返回
    if (self.footerRefreshing) return;
    
    self.footerRefreshing = YES;
    
    self.footerView.backgroundColor = [UIColor greenColor];
    self.footerLabel.textColor = [UIColor blueColor];
    self.footerLabel.text = @"正在加载更多数据";
    
    // 加载更多
    [self loadMoreTopic];
    
}

#pragma mark - 加载更多帖子
- (void)loadMoreTopic {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.maxtime = [[responseObject objectForKey:@"info"] objectForKey:@"maxtime"];
        
        // 字典数组 -> 模型数据
        NSArray *moreTopics = [TopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.topicData addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self endFooterFreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WYLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试！"];
    }];
    
}

#pragma mark - 停止加载
- (void)endFooterFreshing  {
    
    self.footerRefreshing = NO;
    
    self.footerView.backgroundColor = [UIColor redColor];
    self.footerLabel.textColor = [UIColor whiteColor];
    self.footerLabel.text = @"上拉可以加载更多";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.topicData.count == 0) return 200;
    
    TopicItem *item = self.topicData[indexPath.row];
    
    return item.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 如果没有数据，隐藏底部加载
    self.footerView.hidden = (self.topicData.count == 0);
    
    return self.topicData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicItem *item = self.topicData[indexPath.row];
    
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellID];
    
    cell.item = item;
    
    // 禁止选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - 滑动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 处理顶部刷新
    [self dealHeader];
    
    // 处理底部加载
    [self dealFooter];
    
    // 清除缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.tableView.contentOffset.y <= -(self.tableView.contentInset.top + self.headerView.height)) {
        // 刷新数据
        [self refreshData];
    }
    
}

#pragma mark - 处理顶部刷新
- (void)dealHeader {
    
    if (self.headerRefreshing) return;
    
    if (self.tableView.contentOffset.y <= -(self.tableView.contentInset.top + self.headerView.height)) {
        // 进入准备刷新状态
        self.headerLabel.text = @"释放立即刷新";
        self.headerView.backgroundColor = [UIColor brownColor];
        self.headerLabel.textColor = [UIColor blackColor];
        
    } else {
        self.headerLabel.text = @"下拉可以刷新";
        self.headerView.backgroundColor = [UIColor blueColor];
        self.headerLabel.textColor = [UIColor whiteColor];
    }
    
}

#pragma mark - 处理底部加载
- (void)dealFooter {
    // 没有数据的时候直接返回
    if (self.tableView.contentSize.height == 0) return;
    
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.height;
    
    if (self.tableView.contentOffset.y >= offsetY && self.tableView.contentOffset.y > -(self.tableView.contentInset.top)) { // footer完全出现，并且是往下拖拽的才加载
        // 进入加载状态
        [self loadMoreData];
    }
    
}
@end
