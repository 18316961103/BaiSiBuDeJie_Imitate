//
//  SubTagTableViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "SubTagTableViewController.h"
#import "SubTagItem.h"
#import "SubTagCell.h"

@interface SubTagTableViewController ()

/**    数据数组    */
@property (strong, nonatomic) NSArray *itemArray;

/**    会话管理者    **/
@property (weak, nonatomic) AFHTTPSessionManager *mgr;

@end

static NSString *const ID = @"cell";

@implementation SubTagTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 显示加载菊花
//    [SVProgressHUD showWithStatus:@"正在加载中......"];
    [SVProgressHUD show];
    
    // 请求数据
    [self loadData];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SubTagCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    self.title = @"推荐标签";
    
    // 设置分割线
    /*      
        设计思路：先取消系统的分割线，然后设置背景颜色，最后在cell里面重写setFrame，让高度减去1。那其实分割线就是背景颜色。
                原因：因为cell的frame都是显示之前已经计算好了，只是等显示的时候才去赋值，我们在赋值之前减去1就行了
     */
    [UIColor colorWithRed:220 / 225.0 green:220 / 225.0 blue:220 / 225.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = Color(220, 220, 221);
}

#pragma mark - 当页面消失的时候调用
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 隐藏加载菊花
    [SVProgressHUD dismiss];
    
    // 取消所有请求
    [_mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - 请求数据
- (void)loadData {
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    _mgr = mgr;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏加载菊花
        [SVProgressHUD dismiss];
        
        NSArray *dataArray = (NSArray *)responseObject;
        
        _itemArray = [SubTagItem mj_objectArrayWithKeyValuesArray:dataArray];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WYLog(@"%@",error);
        // 隐藏加载菊花
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 注册的cell就不用在使用下面这个方法了
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
    
    SubTagItem *item = _itemArray[indexPath.row];
    
    cell.item = item;
    
//    cell.textLabel.text = item.theme_name;
    
    return cell;
}

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
