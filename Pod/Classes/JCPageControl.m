//
//  JCPageControl.m
//  Pods
//
//  Created by 李京城 on 2016/12/16.
//
//

#import "JCPageControl.h"
#import "JCBannerView.h"
#import "Masonry.h"

#define kIncreasingTag 8080
#define kPageIndicatorWidth 3
#define kPageIndicatorSpacing 4

@implementation JCPageControl

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.numberOfPages > 1) {
        JCBannerView *bannerView = (JCBannerView *)self.superview;
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (bannerView.hideTitleLabel) {
                make.centerX.equalTo(self.superview);
            }
            else {
                make.right.equalTo(self.superview).with.offset(-10);
            }
            
            make.bottom.equalTo(self.superview).offset(-6);
            make.width.mas_equalTo(self.numberOfPages * kPageIndicatorWidth + (self.numberOfPages - 1) * kPageIndicatorSpacing);
            make.height.mas_equalTo(10);
        }];
    }
}

#pragma mark - setter/getter

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (numberOfPages <= 1) {
        return;
    }
    
    _numberOfPages = numberOfPages;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (int i = 0; i < self.numberOfPages; i++) {
        [self addSubview:[self pageIndicator:i]];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    UIView *previousIndicator = [self viewWithTag:_currentPage + kIncreasingTag];
    UIView *currentIndicator = [self viewWithTag:currentPage + kIncreasingTag];
    
    _currentPage = currentPage;
    
    [UIView animateWithDuration:0.3f animations:^{
        previousIndicator.transform = CGAffineTransformIdentity;
        previousIndicator.alpha = 0.6f;
        
        currentIndicator.transform = CGAffineTransformScale(previousIndicator.transform, 2.0f, 2.0f);
        currentIndicator.alpha = 1.0f;
    }];
}

- (UIView *)pageIndicator:(NSInteger)index {
    UIView *indicator = [[UIView alloc] initWithFrame:CGRectMake((kPageIndicatorSpacing * index + kPageIndicatorWidth * index), 0, kPageIndicatorWidth, kPageIndicatorWidth)];
    indicator.backgroundColor = [UIColor whiteColor];
    indicator.tag = index + kIncreasingTag;
    indicator.alpha = (index == 0) ? 1.0f : 0.6f;
    indicator.layer.cornerRadius = indicator.frame.size.width/2;
    
    return indicator;
}

@end
