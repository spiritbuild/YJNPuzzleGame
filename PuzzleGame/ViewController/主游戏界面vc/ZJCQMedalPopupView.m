//
//  MedalPopupView.m
//  PuzzleGame
//
//  Created by 哈哈 on 2018/9/3.
//  Copyright © 2018年  张亚飞. All rights reserved.
//

#import "ZJCQMedalPopupView.h"

@implementation ZJCQMedalPopupView


- (id)initWithFrame:(CGRect)frame {
if (self =[super initWithFrame:frame]) {

         self.medalsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-50, frame.size.height/2-50, 100, 100)];
         //_medalsImgView.backgroundColor = [UIColor yellowColor];
         [self addSubview:_medalsImgView];

         self.botLbl = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-100, _medalsImgView.frame.origin.y+_medalsImgView.frame.size.height+5, 200, 20)];
         //_botLbl.text = @"牛刀小试";
          _botLbl.font =[UIFont systemFontOfSize:15.0];
         _botLbl.textAlignment = NSTextAlignmentCenter;
         _botLbl.textColor = [UIColor whiteColor];
         [self addSubview:_botLbl];

}
return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
