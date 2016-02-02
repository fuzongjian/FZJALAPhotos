//
//  EnterAlbumTableViewCell.m
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/1/31.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "EnterAlbumTableViewCell.h"

@implementation EnterAlbumTableViewCell

- (void)awakeFromNib {
    self.firstImageView.layer.cornerRadius = 5;
    self.firstImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
