//
//  TopicTableViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/22.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "TopicTableViewController.h"
#import "TopicCell.h"
#import "CommentViewController.h"

@interface TopicTableViewController ()

/**    加载下一页需要传的字段    */
@property (copy, nonatomic) NSString *maxtime;

/**    帖子的数据    */
@property (strong, nonatomic) NSMutableArray *topicData;

@end

static NSString *const TopicCellID = @"TopicCellID";

@implementation TopicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - titlaButton被重复点击的通知
- (void)titleButtonRepeatClick {
    
    [self tabBarButtonRepeatClick];
    
}

#pragma mark - 添加底部加载View
- (void)setupFooter {
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    
}

#pragma mark - 添加顶部刷新的View
- (void)setupHeader {

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    // 自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 刚开始进入页面就刷新一次
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 刷新数据
- (void)refreshData {
    
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
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        WYLog(@"%@",error);
        
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试！"];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
    
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
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WYLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试！"];
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];

    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicItem *item = self.topicData[indexPath.row];
    
    return item.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 如果没有数据，隐藏底部加载
    self.tableView.mj_footer.hidden = (self.topicData.count == 0);
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicItem *item = self.topicData[indexPath.row];

    CommentViewController *commentVc = [[CommentViewController alloc] init];
    
    commentVc.topicItem = item;
    
    [self.navigationController pushViewController:commentVc animated:YES];
    
}


#pragma mark - 滑动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 清除缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
}

@end
