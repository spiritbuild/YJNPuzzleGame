//
//  ViewController.m
//  PuzzleGame
//
//

#import "ZJCQViewController.h"
//这是一个图片的类别
#import "UIImage+YFImage.h"
#import "ZJCQGameViewController.h"
#import "TZImagePickerController.h"

@interface ZJCQViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>


{
     NSString *_currentPlistPath;
     NSMutableDictionary *_mulDic;
     //选择的本地图片
     UIImage *_localImage;
}
//大图image
@property (strong, nonatomic) IBOutlet UIImageView *bigImage;
//当前难度lbl
@property (weak, nonatomic) IBOutlet UILabel *levelLbl;


@property (nonatomic) int count;
@end

@implementation ZJCQViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置图片image 的 mode
    _bigImage.contentMode = UIViewContentModeScaleAspectFit;

   _currentPlistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"CurrentInfoList.plist"];
    NSLog(@"查看plist文件路径>>>%@",_currentPlistPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:_currentPlistPath]) {
   
    [[NSFileManager defaultManager] createFileAtPath:_currentPlistPath contents:nil attributes:nil];
    NSMutableDictionary *mulDic = [[NSMutableDictionary alloc] init];
    [mulDic setValue:@"2" forKey:@"difficulty"];
    [mulDic setValue:@"1" forKey:@"level"];
    NSMutableArray *mulArr = [[NSMutableArray alloc] init];
    
    [mulDic setValue:mulArr forKey:@"medals"];
    [mulDic writeToFile:_currentPlistPath atomically:YES];
    _mulDic =mulDic;
    }else {
    
    _mulDic = [NSMutableDictionary dictionaryWithContentsOfFile:_currentPlistPath];
    }


}

- (void)viewWillAppear:(BOOL)animated {
       [super viewWillAppear:animated];




       NSString *currentPlistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"CurrentInfoList.plist"];
       _mulDic = [NSMutableDictionary dictionaryWithContentsOfFile:currentPlistPath];

       //获取当前关卡值,设置封面图
       NSString *level = [_mulDic objectForKey:@"level"];
       NSLog(@"当前关卡>>>%@",level);

       NSString *localPicPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"localPath.txt"];

       if (![level isEqualToString:@""]) {
       
             //如果存在本地文件
             if ([[NSFileManager defaultManager] fileExistsAtPath:localPicPath]) {
             
             NSLog(@"存在这个文件");
             
             //1.首先把他裁成了一个正方形的 image(桌面默认的图片,后面可以换成一个log)
             _bigImage.image = [UIImage clipImageWithImage:_localImage];
             }else {
             //1.首先把他裁成了一个正方形的 image(桌面默认的图片,后面可以换成一个log)
             _bigImage.image = [UIImage clipImageWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"image%@",level]]];
             }
    
       }else {
       //如果是选择本地图片
               if ([[NSFileManager defaultManager] fileExistsAtPath:localPicPath]) {

               //这个默认是第一关
               _bigImage.image = [UIImage clipImageWithImage:_localImage];
               }else {
               //这个默认是第一关
               _bigImage.image = [UIImage clipImageWithImage:[UIImage imageNamed:@"image1"]];
               }
       
              [_mulDic setObject:@"1" forKey:@"level"];
              [_mulDic writeToFile:_currentPlistPath atomically:YES];
       }

        //获取当前难度
        NSString *difficulty = [_mulDic objectForKey:@"difficulty"];
        if (![difficulty isEqualToString:@""]) {
        //设置默认的初始拼图的块数
        _count = [difficulty intValue];
        }else {
        //设置默认的初始拼图的块数
        _count = 2;
        [_mulDic setObject:@"2" forKey:@"difficulty"];
        [_mulDic writeToFile:_currentPlistPath atomically:YES];
        }

        //当前难度text
        _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];
}

#pragma mark ImagePickerDelegate(代理内容)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    //相册修改后的图片
    _localImage = info[@"UIImagePickerControllerEditedImage"];

     NSLog(@"查看选中的image>>>%@",_localImage);
     _bigImage.image = [UIImage clipImageWithImage:_localImage];
     //_bigImage.image = image;
     [picker dismissViewControllerAnimated:YES completion:nil];

     NSString *localPicPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"localPath.txt"];

     if (![[NSFileManager defaultManager] fileExistsAtPath:localPicPath]) {
     NSLog(@"查看本地图片的文件路径>>>%@",localPicPath);
     [[NSFileManager defaultManager] createFileAtPath:localPicPath contents:nil attributes:nil];

     }

}
#pragma mark - 选择图片按钮
- (IBAction)changePic:(id)sender {
    //创建图片选择器
  /*  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //设置图片的来源
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

    //设置是否可以编辑
    picker.allowsEditing = YES;
    //设置代理
    picker.delegate = self;
    //跳转到图片选择界面
    [self presentViewController:picker animated:YES completion:nil];*/

     TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
     // 你可以通过block或者代理，来得到用户选择的照片.
     [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

     _localImage = photos[0];
     _bigImage.image = [UIImage clipImageWithImage:_localImage];


     NSString *localPicPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"localPath.txt"];

     if (![[NSFileManager defaultManager] fileExistsAtPath:localPicPath]) {
     NSLog(@"查看本地图片的文件路径>>>%@",localPicPath);
     [[NSFileManager defaultManager] createFileAtPath:localPicPath contents:nil attributes:nil];

     }

     }];

     [self presentViewController:imagePickerVc animated:YES completion:nil];


}
#pragma mark - 选择游戏难度按钮事件
- (IBAction)choseGameDiffculty:(id)sender {


    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择游戏难度" message:nil preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"入门级(2x2)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     _count = 2;
     _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];
     [_mulDic setObject:@"2" forKey:@"difficulty"];
      [_mulDic setObject:@"1" forKey:@"level"];
     [_mulDic writeToFile:_currentPlistPath atomically:YES];
     
     
     
     
     }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"正常级(3x3)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _count = 3;
    _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];
    [_mulDic setObject:@"3" forKey:@"difficulty"];
       [_mulDic setObject:@"4" forKey:@"level"];
    [_mulDic writeToFile:_currentPlistPath atomically:YES];
    
    
    
    
    }];
     UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"有点难(4x4)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     _count = 4;
     _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];
     [_mulDic setObject:@"4" forKey:@"difficulty"];
    [_mulDic setObject:@"7" forKey:@"level"];
     [_mulDic writeToFile:_currentPlistPath atomically:YES];
     
     
     }];
    UIAlertAction *alertAction4 = [UIAlertAction actionWithTitle:@"困难级(5x5)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _count = 5;
    _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];
    [_mulDic setObject:@"5" forKey:@"difficulty"];
      [_mulDic setObject:@"10" forKey:@"level"];
    [_mulDic writeToFile:_currentPlistPath atomically:YES];
    
    
    }];
    UIAlertAction *alertAction5 = [UIAlertAction actionWithTitle:@"地狱级(6x6)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     _count = 6;
    _levelLbl.text = [NSString stringWithFormat:@"当前难度:%dx%d",_count,_count];
    [_mulDic setObject:@"6" forKey:@"difficulty"];
    [_mulDic setObject:@"13" forKey:@"level"];
    [_mulDic writeToFile:_currentPlistPath atomically:YES];
    
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

    ZJCQGameViewController *gameVC  = segue.destinationViewController;
    gameVC.count = _count;
    gameVC.bigImage = _bigImage.image;

    //返回的是一个分解的图片 count
    gameVC.imageArray = [UIImage clipImageWithImage:_bigImage.image withConuntM:_count withCountN:_count];

}

@end


