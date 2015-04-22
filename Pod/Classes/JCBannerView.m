//
//  JCBannerView.m
//  Pods
//
//  Created by 李京城 on 15/4/21.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCBannerView.h"
#import "JCBannerCell.h"

#define kPageControlHeight 30.0f

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
    
    [self startPlay];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JCBannerCell class]) forIndexPath:indexPath];
    [cell fill:self.items[indexPath.item]];
    
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
}

#pragma mark - private

- (void)setup
{
    self.items = @[];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = self.bounds.size;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.collectionView registerClass:[JCBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([JCBannerCell class])];
    [self addSubview:self.collectionView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-kPageControlHeight, self.bounds.size.width, kPageControlHeight)];
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:self.pageControl];
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
    
    [self.collectionView.layer addAnimation:[self scrollBannerAnimation] forKey:@"scrollAnimation"];
    
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
