//
//  MedalsCollectionViewCell.m
//  PuzzleGame
//
//  Created by 哈哈 on 2018/8/31.
//  Copyright © 2018年  张亚飞. All rights reserved.
//

#import "ZJCQMedalsCollectionViewCell.h"

@implementation ZJCQMedalsCollectionViewCell



- (id)initWithFrame:(CGRect)frame {

if (self= [super initWithFrame:frame]) {

        //1.设置勋章图片
        self.medalsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width-25)/4, ([UIScreen mainScreen].bounds.size.width-25)/4)];
        //_medalsImageView.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_medalsImageView];


        //2.设置底部botlbl;
        self.botLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, _medalsImageView.frame.size.height+_medalsImageView.frame.origin.y, _medalsImageView.frame.size.width, 20)];
        _botLbl.font = [UIFont systemFontOfSize:15.0];
        _botLbl.textAlignment = NSTextAlignmentCenter;
       //_botLbl.backgroundColor = [UIColor yellowColor];
        _botLbl.font = [UIFont systemFontOfSize:15.0];
       _botLbl.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_botLbl];



}

return self;
}




@end
