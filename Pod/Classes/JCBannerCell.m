//
//  JCBannerCell.m
//  JCBannerView
//
//  Created by 李京城 on 15/4/21.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCBannerCell.h"
#import "Masonry.h"
#import "JCBannerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kImageLayerKey @"imageLayer"

@interface UIView (JC)

- (BOOL)jc_hasLayer:(NSString *)name;

@end

@implementation UIView (JC)

- (BOOL)jc_hasLayer:(NSString *)name {
    for (CALayer *subLayer in self.layer.sublayers) {
        if ([subLayer.name isEqualToString:name]) {
            return YES;
        }
    }
    
    return NO;
}

@end

@interface JCBannerCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JCBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _hideTitleLabel = YES;
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-60);
        make.bottom.equalTo(self).offset(-5);
        make.height.mas_equalTo(20);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
    self.imageView.image = nil;
}

#pragma mark - setter/getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;// 默认模式会破坏图片比例，目前保持图片比例不变，并且填充视图
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.hidden = _hideTitleLabel;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
}

- (void)setHideTitleLabel:(BOOL)hideTitleLabel {
    _hideTitleLabel = hideTitleLabel;
    
    self.titleLabel.hidden = _hideTitleLabel;
}

- (void)setData:(NSDictionary *)data {
    self.titleLabel.text = data[@"title"];
    
    if ([data[@"image"] isKindOfClass:[UIImage class]]) {
        self.imageView.image = data[@"image"];
        
        [self addLayerToImageView];
    }
    else {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:data[@"image"]] placeholderImage:self.placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self addLayerToImageView];
        }];
    }
}

#pragma mark - private

- (void)addLayerToImageView {
    if (!self.titleLabel.hidden && ![self.imageView jc_hasLayer:kImageLayerKey]) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 30);
        layer.name = kImageLayerKey;
        layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f].CGColor;
        [self.imageView.layer addSublayer:layer];
    }
}

@end
