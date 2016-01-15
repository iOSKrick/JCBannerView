//
//  JCBannerView.h
//  JCBannerView
//
//  Created by 李京城 on 15/4/21.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JCBannerViewBlock)(NSDictionary *data);

@interface JCBannerView : UICollectionReusableView

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) BOOL hideTitleLabel; //default YES
@property (nonatomic, assign) NSInteger autoPlayingInterval; //default 0

- (void)reloadData;

- (void)setCompletionBlockWithSeleted:(JCBannerViewBlock)completionBlock;

@end