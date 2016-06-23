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
    
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    
    if (self.pageControl.numberOfPages > 1) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        });
    }
}

- (void)dealloc
{
    [self stopPlay];
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.pageControl.numberOfPages = self.items.count <= 1 ? : (self.items.count - 2);
    self.pageControl.currentPage = 0;
    
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
    NSInteger currentPage = fabs(scrollView.contentOffset.x/scrollView.frame.size.width);
    
    if (currentPage == 0) {
        currentPage = self.items.count - 3;
        
        self.collectionView.contentOffset = CGPointMake((self.items.count-2) * self.collectionView.frame.size.width, 0);
    }
    else if (currentPage == self.items.count-1) {
        currentPage = 0;
        
        self.collectionView.contentOffset = CGPointMake(self.collectionView.frame.size.width, 0);
    }
    else {
        currentPage--;
    }
    
    self.pageControl.currentPage = currentPage;
    
    [self startPlay];
}

#pragma mark - public

- (void)setCompletionBlockWithSeleted:(JCBannerViewBlock)completionBlock
{
    self.seletedBlock = completionBlock;
}

- (void)reloadData
{
    [self stopPlay];
    
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

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    if (items.count > 1) {
        NSMutableArray *newItems = [[NSMutableArray alloc] initWithArray:items];
        [newItems insertObject:items.lastObject atIndex:0];
        [newItems addObject:items.firstObject];
        
        _items = newItems;
    }
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
    NSInteger currentPage = self.pageControl.currentPage;
    
    if (self.pageControl.currentPage == (self.items.count - 3)) {
        currentPage = 0;
    }
    else {
        currentPage++;
    }
    
    self.collectionView.contentOffset = CGPointMake((currentPage + 1) * self.collectionView.frame.size.width, 0);
    
    [self.collectionView.layer addAnimation:[self scrollBannerAnimation] forKey:kScrollAnimationKey];
    
    self.pageControl.currentPage = currentPage;
    
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
