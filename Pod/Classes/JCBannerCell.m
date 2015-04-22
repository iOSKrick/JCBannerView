//
//  JCBannerCell.m
//  Pods
//
//  Created by 李京城 on 15/4/21.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCBannerCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface JCBannerCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation JCBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageView];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.center = self.imageView.center;
        [self.imageView addSubview:self.activityView];
        
        [self.activityView startAnimating];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
    
    [self.activityView startAnimating];
}

- (void)fill:(NSDictionary *)data
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:data[@"image"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.activityView stopAnimating];
    }];
}

@end
