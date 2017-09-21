//
//  SettingTableViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "SettingTableViewController.h"
#import "WYFileTool.h"

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface SettingTableViewController ()

/**    缓存大小    */
@property (assign, nonatomic) NSInteger totalSize;

@end

@implementation SettingTableViewController

static NSString *const ID = @"cell";

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 计算缓存大小
    [WYFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        
        _totalSize = totalSize;
        
        [self.tableView reloadData];
        
    }];

}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [self sizeString];;
    } else {
        cell.textLabel.text = @"联系我们";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) { // 清除缓存
        
        [WYFileTool removeDirectoryPath:CachePath];
        // 清除缓存的时候要把totalSize清零
        _totalSize = 0;
        
        [SVProgressHUD showSuccessWithStatus:@"清除缓存成功"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
//        [SVProgressHUD showSuccessWithStatus:@"清除缓存成功" maskType:SVProgressHUDMaskTypeBlack];
        
        // 删除后刷新
        [self.tableView reloadData];
    }
    
}

#pragma mark - 计算缓存尺寸
- (NSString *)sizeString {
    
    NSString *sizeStr = @"清除缓存";
    
    if (self.totalSize > 1000 * 1000) {
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)",sizeStr,self.totalSize / 1000.0 / 1000.0];
    } else if (self.totalSize > 1000) {
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)",sizeStr,self.totalSize / 1000.0];
    } else if (self.totalSize > 0) {
        sizeStr = [NSString stringWithFormat:@"%@(%zdB)",sizeStr,self.totalSize];
    }
    
    return sizeStr;
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
