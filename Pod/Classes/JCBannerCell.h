//
//  JCBannerCell.h
//  JCBannerView
//
//  Created by 李京城 on 15/4/21.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCBannerCell : UICollectionViewCell

@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) BOOL hideTitleLabel; //default YES

@end
