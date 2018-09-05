//
//  ViewController.m
//  PuzzleGame
//
//

#import "ViewController.h"
//这是一个图片的类别
#import "UIImage+YFImage.h"
#import "GameViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//大图image
@property (strong, nonatomic) IBOutlet UIImageView *bigImage;
//当前难度lbl
@property (weak, nonatomic) IBOutlet UILabel *levelLbl;
@property (nonatomic) int count;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置图片image 的 mode
    _bigImage.contentMode = UIViewContentModeScaleAspectFit;

    //根据本地的plist文件来判断当前的等级
    NSString *currentPlistPath =  [[NSBundle mainBundle] pathForResource:@"CurrentInfoList" ofType:@"plist"];
    NSLog(@"当前的信息plist文件路径>>>%@",currentPlistPath);

    NSMutableDictionary *mulDic =  [NSMutableDictionary dictionaryWithContentsOfFile:currentPlistPath];

    //获取当前关卡值,设置封面图
    NSString *level = [mulDic objectForKey:@"level"];
    if (![level isEqualToString:@""]) {
    //1.首先把他裁成了一个正方形的 image(桌面默认的图片,后面可以换成一个log)
    _bigImage.image = [UIImage clipImageWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"image%@",level]]];
    }else {
    //这个默认是第一关
    _bigImage.image = [UIImage clipImageWithImage:[UIImage imageNamed:@"image1"]];
    [mulDic setObject:@"1" forKey:@"level"];
    }

   //获取当前难度
    NSString *difficulty = [mulDic objectForKey:@"difficulty"];
    if (![difficulty isEqualToString:@""]) {
    //设置默认的初始拼图的块数
    _count = [difficulty intValue];
    }else {
    //设置默认的初始拼图的块数
    _count = 2;
    [mulDic setObject:@"2" forKey:@"difficulty"];
    }

    //当前难度text
    _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];

}
#pragma mark ImagePickerDelegate(代理内容)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    _bigImage.image = [UIImage clipImageWithImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 选择图片按钮
- (IBAction)changePic:(id)sender {
    //创建图片选择器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //设置图片的来源
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置是否可以编辑
    picker.allowsEditing = YES;
    //设置代理
    picker.delegate = self;
    //跳转到图片选择界面
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - 选择游戏难度按钮事件
- (IBAction)choseGameDiffculty:(id)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择游戏难度" message:nil preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"入门级(2x2)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     _count = 2;
     _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];
     }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"正常级(3x3)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _count = 3;
    _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];
    }];
     UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"有点难(4x4)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     _count = 4;
     _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];
     }];
    UIAlertAction *alertAction4 = [UIAlertAction actionWithTitle:@"困难级(5x5)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _count = 5;
    _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];

    }];
    UIAlertAction *alertAction5 = [UIAlertAction actionWithTitle:@"地狱级(6x6)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _count = 6;
    _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];

    }];
    [alertC addAction:alertAction1];
    [alertC addAction:alertAction2];
    [alertC addAction:alertAction3];
    [alertC addAction:alertAction4];
    [alertC addAction:alertAction5];
    [self presentViewController:alertC animated:YES completion:nil];



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 界面跳转 (开始按钮的segue事件)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    GameViewController *gameVC  = segue.destinationViewController;
    gameVC.count = _count;
    gameVC.bigImage = _bigImage.image;

   //返回的是一个分解的图片 count
    gameVC.imageArray = [UIImage clipImageWithImage:_bigImage.image withConuntM:_count withCountN:_count];

}


@end


