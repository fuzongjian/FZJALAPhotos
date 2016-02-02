//
//  DisplayCollectionViewCell.m
//  FZJALAPhotos
//
//  Created by fdkj0002 on 16/2/1.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "DisplayCollectionViewCell.h"

@implementation DisplayCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.ImageView.layer.cornerRadius = 5;
    self.ImageView.layer.masksToBounds = YES;
}

@end
