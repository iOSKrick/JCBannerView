//
//  JCBannerCell.h
//  JCBannerView
//
//  Created by 李京城 on 15/4/21.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCBannerCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) NSDictionary *data;

@end
