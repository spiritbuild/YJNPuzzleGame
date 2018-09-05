//
//  GameViewController.h
//  PuzzleGame
//


#import <UIKit/UIKit.h>

@interface ZJCQGameViewController : UIViewController


@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *nArray;
@property (nonatomic, strong) UIImage *bigImage;
@property (nonatomic) int count;


@property (strong, nonatomic) IBOutlet UIImageView *fullImage;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *stepLabel;

@end
