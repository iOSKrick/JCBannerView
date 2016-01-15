//
//  JCViewController.m
//  JCBannerView
//
//  Created by lijingcheng on 07/02/2015.
//  Copyright (c) 2014 lijingcheng. All rights reserved.
//

#import "JCViewController.h"
#import "JCBannerView.h"

@interface JCViewController()

@property (nonatomic, copy) NSArray *datas;

@end

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.datas = @[
                   @{@"id": @"1", @"title": @"Facebook开源Nuclide项目", @"image": @"http://7x00ed.com1.z0.glb.clouddn.com/avatar.png", @"url": @"http://lijingcheng.github.io/"},
                   @{@"id": @"2", @"title": @"Facebook应用Moments使用C++实现跨平台代码共享", @"image": @"http://7x00ed.com1.z0.glb.clouddn.com/cocoapods.png", @"url": @"http://lijingcheng.github.io/"},
                   @{@"id": @"3", @"title": @"密码管理器LastPass遭到黑客攻击", @"image": @"http://7x00ed.com1.z0.glb.clouddn.com/github-octopress.png", @"url": @"http://lijingcheng.github.io/"}
                   ];

    [self.collectionView registerClass:[JCBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JCBannerView class])];
}

#pragma mark - UICollectionView 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 180);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqual:UICollectionElementKindSectionHeader]) {
        JCBannerView *bannerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JCBannerView class]) forIndexPath:indexPath];
        bannerView.placeholderImage = [UIImage imageNamed:@"img_placeholder"];
        bannerView.hideTitleLabel = NO;
        bannerView.autoPlayingInterval = 3;
        bannerView.items = self.datas;
        [bannerView setCompletionBlockWithSeleted:^(NSDictionary *data) {
            NSLog(@"%@", data);
        }];
        
        return bannerView;
    }
    
    return nil;
}

@end
