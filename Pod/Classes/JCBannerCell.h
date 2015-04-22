//
//  JCBannerCell.h
//  Pods
//
//  Created by 李京城 on 15/4/21.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCBannerCell : UICollectionViewCell

/**
 *  填充Cell
 *
 *  @param data 用于填充Cell的数据
 *
 *  @warning 参数必需包含以"image"为key的字典项，value为图片URL
 */
- (void)fill:(NSDictionary *)data;

@end
