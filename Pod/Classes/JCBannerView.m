//
//  JCBannerView.m
//  JCBannerView
//
//  Created by 李京城 on 15/4/21.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCBannerView.h"
#import "JCBannerCell.h"
#import "Masonry.h"

#define kScrollAnimationKey @"scrollAnimation"

@interface JCBannerView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, copy) JCBannerViewBlock seletedBlock;

@end

@implementation JCBannerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.hideTitleLabel) {
            make.centerX.equalTo(self);
        }
        else {
            make.right.equalTo(self).with.offset(0);
        }
        
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self reloadData];
}

- (void)dealloc
{
    [self stopPlay];
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.items.count;
    
    return self.items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JCBannerCell class]) forIndexPath:indexPath];
    cell.hideTitleLabel = self.hideTitleLabel;
    cell.placeholderImage = self.placeholderImage;
    cell.data = self.items[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.seletedBlock) {
        self.seletedBlock(self.items[indexPath.item]);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopPlay];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startPlay];
    
    self.pageControl.currentPage = fabs(scrollView.contentOffset.x/scrollView.frame.size.width);
}

#pragma mark - public

- (void)setCompletionBlockWithSeleted:(JCBannerViewBlock)completionBlock
{
    self.seletedBlock = completionBlock;
}

- (void)reloadData
{
    [self.collectionView reloadData];
    
    [self startPlay];
}

#pragma mark - private

- (void)setup
{
    _items = @[];
    _hideTitleLabel = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[JCBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([JCBannerCell class])];
    [self addSubview:_collectionView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
}

- (void)startPlay
{
    if (self.autoPlayingInterval > 0 && self.items.count > 1) {
        [self stopPlay];
        [self performSelector:@selector(next) withObject:nil afterDelay:self.autoPlayingInterval];
    }
}

- (void)stopPlay
{
    [self.collectionView.layer removeAnimationForKey:kScrollAnimationKey];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}

- (void)next
{
    if (self.pageControl.currentPage == (self.items.count - 1)) {
        self.pageControl.currentPage = 0;
    }
    else {
        self.pageControl.currentPage++;
    }
    
    self.collectionView.contentOffset = CGPointMake(self.pageControl.currentPage * self.collectionView.frame.size.width, 0);
    
    [self.collectionView.layer addAnimation:[self scrollBannerAnimation] forKey:kScrollAnimationKey];
    
    [self startPlay];
}

- (CATransition *)scrollBannerAnimation
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    
    return animation;
}

@end
