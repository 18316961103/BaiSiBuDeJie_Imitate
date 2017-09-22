//
//  SeeBigPictureViewController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/22.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "SeeBigPictureViewController.h"
#import "TopicItem.h"
#import <Photos/Photos.h>

@interface SeeBigPictureViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

/**    scrollView    */
@property (strong, nonatomic) UIScrollView *scrollView;

/**    显示图片的imageView    */
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation SeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置scrollView
    [self setupUI];
    
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        scrollView.backgroundColor = [UIColor blackColor];
        
        scrollView.delegate = self;
        
        // 添加点击屏幕返回上一级的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
        
        [scrollView addGestureRecognizer:tap];
        
        //    [self.view addSubview:scrollView];
        // 把scrollView插入到最下面，防止挡住按钮
        [self.view insertSubview:scrollView atIndex:0];

        self.scrollView = scrollView;

    }
    return _scrollView;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        _imageView = imageView;
        
    }
    return _imageView;
}

#pragma mark - 搭建界面
- (void)setupUI {
    
    [self.scrollView addSubview:self.imageView];
    
    CGFloat imageViewH = self.scrollView.width * self.topicItem.height / self.topicItem.width;
    
    self.imageView.frame = CGRectMake(0, 0, self.scrollView.width, imageViewH);

    if (imageViewH > self.scrollView.height) {
        
        self.scrollView.contentSize = CGSizeMake(0, imageViewH);
        
    } else { // 如果不大于屏幕高度，则显示在中间区域
        
        self.imageView.centerY = self.scrollView.centerY;
    }
    // 加载原图
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.topicItem.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        self.saveButton.enabled = YES;
        
    }];
    // 根据图片的拉伸来算出图片的缩放比例
    CGFloat maxScale = self.topicItem.width / self.imageView.width;
    
    if (maxScale > 1) {
        
        self.scrollView.maximumZoomScale = maxScale;
        
    }
}

#pragma mark - 返回上一页面
- (IBAction)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    
//    [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
//    
//}

#pragma mark - 保存图片到系统相册
- (IBAction)save:(UIButton *)sender {
    
    // 使用C语言函数保存图片，但selector必须是image:didFinishSavingWithError:contextInfo:
//    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
//     保存图片之前，先询问用户是否有权限访问相册
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) { // 子线程执行
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (status == PHAuthorizationStatusNotDetermined) { // 用户不允许访问相册
                [SVProgressHUD showErrorWithStatus:@"您好，请允许访问相册！"];
            } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问
                [self savePhotoToCustomAlbum];
            } else if (status == PHAuthorizationStatusRestricted) { // 系统原因，无法访问相册
                [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册！"];
            }
        });
    }];
    
}

#pragma mark - 保存图片到自定义相册
- (void)savePhotoToCustomAlbum {
    // 保存图片在相机胶卷，也就是系统默认的相册
    PHAsset *asset = [self savePhotoToSystemAlbum];
    
    if (asset == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
        return;
    }
    
    // 自定义相册，把图片放在我们自定义的相册，以便寻找，为了用户体验
    PHAssetCollection *assetCollection = [self createPhotoCollection];
    
    if (assetCollection == nil) {// 创建相册失败
        return;
    }
    
    NSError *error = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        // 把图片插在一个位置，这样相册封面就会显示最新的图片
        [request insertAssets:@[asset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
        
    } error:&error];
    
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功！"];
    }
}

#pragma mark - 保存图片到相机胶卷
- (PHAsset *)savePhotoToSystemAlbum {
    __block PHAsset *asset = nil;
    
    __block NSString *identifier = nil;
    
    // 使用PHPhoto框架保存图片到相机胶卷有两种方法，一个异步操作，一个同步操作
    
    // 同步操作
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 图片的占位标识
        identifier = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];

    if (!error) {
        // 根据图片标识得到相应的图片
        asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil].firstObject;
    }
    return asset;
    
    // 异步操作
    
    //    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    //        // 保存图片的操作必须在这里或者下面的同步方法执行
    //        identifier = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    //
    //    } completionHandler:^(BOOL success, NSError * _Nullable error) {
    //
    //        if (success) {
    //            asset = [PHAsset fetchAssetsWithBurstIdentifier:identifier options:nil].firstObject;
    //        }
    //        
    //    }];

}

#pragma mark - 创建自定义相册
- (PHAssetCollection *)createPhotoCollection {
    
    // 获取当前项目名称
    NSString *appName = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    
    WYLog(@"appNam = %@",appName);
    
    // 获取所有的自定义相册
    PHFetchResult<PHAssetCollection *> * fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHAssetCollection *myAssetCollection = nil;
    
    // 遍历所有的自定义相册，查看当前项目之前是否已经创建过相册
    for (PHAssetCollection *collection in fetchResult) {
        
        if ([collection.localizedTitle isEqualToString:appName]) {
            myAssetCollection = collection;
            return myAssetCollection;
        }
    }
    
    if (myAssetCollection == nil) { // 如果之前没有创建过，则现在新建一个
        
        NSError *error = nil;

        __block NSString *identifier = nil;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            // 这里其实还没创建好相册，调用下面的方法创建只是告诉系统我准备创建相册，并会为你生成一个占位标识，创建完相册之后，你可以根据占位标志找到对应的相册
            identifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appName].placeholderForCreatedAssetCollection.localIdentifier;

        } error:&error];
        
        if (!error) { // 创建相册失败
            // 根据占位标志找到对应的相册
            myAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[identifier] options:nil].firstObject;
           
            return myAssetCollection;

        }
    }
    WYLog(@"%@",myAssetCollection);
    return myAssetCollection;

}

#pragma mark - UIScrollViewDelegate
// 返回响应缩放事件的子控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
