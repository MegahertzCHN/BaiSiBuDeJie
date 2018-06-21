//
//  SLSeeBigImageViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/11/3.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLSeeBigImageViewController.h"
#import "SLTopic.h"
#import <UIImageView+WebCache.h>
//#import <AssetsLibrary/AssetsLibrary.h>
#import <SVProgressHUD.h>

#import <Photos/Photos.h>


@interface SLSeeBigImageViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) UIImageView *imageView;

/*** 获得当前App对应的自定义相册  */
- (PHAssetCollection *)createCollection;

/** 返回到保存到相机胶卷的图片 */
- (PHFetchResult<PHAsset *> *)createdAssets;
@end

@implementation SLSeeBigImageViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:scrollView atIndex:0];
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)]];
    _scrollView = scrollView;

    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.zh_width = scrollView.zh_width;
    imageView.zh_height = self.topic.height * imageView.zh_width / self.topic.width;
    imageView.zh_x = 0;
    if (imageView.zh_height > SLScreenH) { // 图片超过一个屏幕
        imageView.zh_y = 0;
    } else {
        imageView.zh_centerY = self.view.center.y;
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        self.saveButton.enabled = YES;
    }];
    self.imageView = imageView;
    scrollView.contentSize = CGSizeMake(0, imageView.zh_height);
    [scrollView addSubview:imageView];
    
    // 图片缩放
    CGFloat maxScale = self.topic.width / imageView.zh_width;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = 2.0;
        scrollView.delegate = self;
    }

}





- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - 点击监听
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 获得当前App对应的自定义相册
- (PHAssetCollection *)createCollection
{
    // 获取软件名字
    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    // 抓取所有的自定义相册
    PHFetchResult *collextions = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 查找当前App对应的自定义相册
    for (PHAssetCollection *collection in collextions) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    
    
    /*** 当前App对应的自定义相册没有创建过 ***/
    
    // 拥有一个自定义相册
    NSError *error = nil;
    __block NSString *createCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建一个【自定义相册】
        createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) return nil;
    
    // 根据唯一标识符获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
    
}

- (PHFetchResult<PHAsset *> *)createdAssets
{
    NSError *error = nil;
    // 保存图片到【相册胶卷】
    __block NSString *assetID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error) return nil;
    
    // 获取刚才保存的相片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

- (IBAction)save:(id)sender {
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    // 检查访问权限:
    // 如果用户还没有做出选择，会自动弹框， 用户对弹框做出选择，才执行bloack；
    // 如果已经做出选择，就直接执行bloack
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前App访问相册
            if (oldStatus != PHAuthorizationStatusNotDetermined) {
                ZHLog(@"提醒用户打开开关")
            }
        } else if (status == PHAuthorizationStatusAuthorized){ // 用户允许当前App访问相册
            [self saveImageIntoAlbum];
        } else if (status == PHAuthorizationStatusRestricted){  // 无法访问相册
            [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册"];
        }
    }];
}


/**
 保存图片到相册
 */
- (void)saveImageIntoAlbum
{
    // 获取相片
    PHFetchResult<PHAsset *> *createAsset = self.createdAssets;
    if (createAsset == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
        return;
    }
    
    // 获得相册
    PHAssetCollection *createCollection = self.createCollection;
    if (createCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"创建相册失败！"];
        return;
    }
    
    // 添加刚才保存的图片到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createCollection];
        [request insertAssets:createAsset atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    
    // 最后的判断
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
    }
}



@end
