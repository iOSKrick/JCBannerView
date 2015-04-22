//
//  JCBannerView.h
//  Pods
//
//  Created by 李京城 on 15/4/21.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JCBannerViewBlock)(NSDictionary *data);

@interface JCBannerView : UICollectionReusableView

/**
 *  Banner需要的数据
 */
@property (nonatomic, copy) NSArray *items;

/**
 *  需要Banner自动轮播的话需要设置此属性，默认值为0，不轮播
 */
@property (nonatomic, assign) NSInteger autoPlayingInterval;

/**
 *  更新数据后，用此方法刷新Banner
 */
- (void)reloadData;

/**
 *  当点击Banner上的图片时，用此方法进行回调
 *
 *  @param completionBlock 用于传递参数
 */
- (void)setCompletionBlockWithSeleted:(JCBannerViewBlock)completionBlock;

@end