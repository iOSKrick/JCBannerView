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

- (BOOL)jc_hasLayer:(NSString *)name
{
    BOOL flag = NO;
    
    for (CALayer *subLayer in self.layer.sublayers) {
        if ([subLayer.name isEqualToString:name]) {
            flag = YES;
            break;
        }
    }
    
    return flag;
}

@end

@interface JCBannerCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation JCBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _hideTitleLabel = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
        [self.contentView addSubview:_imageView];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.center = _imageView.center;
        [_imageView addSubview:_activityView];
        
        [_activityView startAnimating];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.hidden = _hideTitleLabel;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.activityView.center = self.imageView.center;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(5);
        make.right.equalTo(self).with.offset(-80);
        make.bottom.equalTo(self).offset(0);
        make.height.mas_equalTo(30);
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
    self.imageView.image = nil;
    
    [self.activityView startAnimating];
}

#pragma mark - private

- (void)setHideTitleLabel:(BOOL)hideTitleLabel
{
    _hideTitleLabel = hideTitleLabel;
    
    self.titleLabel.hidden = _hideTitleLabel;
}

- (void)setData:(NSDictionary *)data
{
    self.titleLabel.text = data[@"title"];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:data[@"image"]] placeholderImage:self.placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!self.titleLabel.hidden && ![self.imageView jc_hasLayer:kImageLayerKey]) {
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 30);
            layer.name = kImageLayerKey;
            layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f].CGColor;
            [self.imageView.layer addSublayer:layer];
        }
        
        [self.activityView stopAnimating];
    }];
}

@end
