//
//  CommentViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/24.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentHeaderFooterView.h"
#import "TopicCell.h"
#import "CommentItem.h"
#import "CommentCell.h"
#import "LoginViewController.h"

@interface CommentViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**    最新评论    */
@property (strong, nonatomic) NSMutableArray<CommentItem *> *lastComments;
/**    数据总量    */
@property (assign, nonatomic) NSInteger totalCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;

@end

static NSString *const cellId = @"cellId";

static NSString *const headerId = @"headerId";

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"评论";
    
    // 监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 初始化tableView
    [self setupTableView];
}

#pragma mark - 监听键盘的弹出
- (void)keyBoardWillChangeFrame:(NSNotification *)note {
    
    //修改底部输入栏的约束
    CGFloat kbY = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y;
    
    self.bottomMargin.constant = kScreenH - kbY;
    
    CGFloat duration = [note.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:nil];
    
}
- (IBAction)gotoLogin:(UIButton *)sender {
    
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    
    [self presentViewController:loginVc animated:YES completion:nil];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)lastComments {
    
    if (!_lastComments) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        _lastComments = array;
        
    }
    return _lastComments;
}

#pragma mark - 初始化tableView
- (void)setupTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 设置header
    [self setupHeader];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentCell class]) bundle:nil] forCellReuseIdentifier:cellId];
}

#pragma mark - 设置header
- (void)setupHeader {
    
    [self.tableView registerClass:[CommentHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerId];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
    
    TopicCell *cell = [TopicCell loadViewFromXib];
    
    cell.item = self.topicItem;
    
    CGFloat cellHeight = cell.height;

    WYLog(@"%f",cell.height);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        cell.height = cellHeight;

    });
    
    cell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.topicItem.height);
    
    headerView.height = self.topicItem.cellHeight - 40;
    
    [headerView addSubview:cell];
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 设置刷新控件
    [self setupRefresh];
        
}

#pragma mark - 设置刷新控件
- (void)setupRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComment)];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComment)];
    
}

#pragma mark - 刷新评论
- (void)loadNewComment {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = self.topicItem.ID;
    parameters[@"hot"] = @1;
    
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        WYLog(@"%@",responseObject);
        
        self.lastComments = [CommentItem mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
        
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

#pragma mark - 加载更多数据
- (void)loadMoreComment {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = self.topicItem.ID;
    parameters[@"lastcid"] = self.lastComments.lastObject.ID;
    
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        WYLog(@"%@",responseObject);
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) { // 如果返回的不是字典，则直接返回
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            return;
        }
        [self.lastComments addObjectsFromArray:[CommentItem mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]]];
        
        [self.tableView reloadData];
        
        self.totalCount = [responseObject[@"total"] integerValue];
        // 结束刷新
        [self footerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        WYLog(@"%@",error);
        
        [SVProgressHUD showErrorWithStatus:@"网络错误，请稍后再试！"];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 结束底部加载更多
- (void)footerEndRefreshing {
    
    if (self.lastComments.count == self.totalCount) { // 已经全部加载完毕
        // 结束刷新
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    } else {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }
    
}


#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CommentHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    
//    if (section == 0) {
//        headerView.textLabel.text = @"最热评论";
//    } else {
        headerView.textLabel.text = @"最新评论";
//    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    self.tableView.mj_footer.hidden = (self.lastComments.count == 0);

    if (self.lastComments.count) {
        return 1;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0) {
//        return 10;
//    }
    
    return self.lastComments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentItem *item = self.lastComments[indexPath.row];
    
    return item.cellHeight;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    CommentItem *item = self.lastComments[indexPath.row];
    
    cell.item = item;
        
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
