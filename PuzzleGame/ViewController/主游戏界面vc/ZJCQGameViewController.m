//
//  GameViewController.m
//  PuzzleGame
//


#import "ZJCQGameViewController.h"
#import "ZJCQGameViewCell.h"
#import "UIImage+YFImage.h"

#import "ZJCQMedalsViewController.h"
#import "KLCPopup.h"
#import "ZJCQMedalPopupView.h"

@interface ZJCQGameViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height111;

@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *viewFlowLayer;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) ZJCQGameViewCell *emptyCell;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger time;

@property (nonatomic) NSInteger stepNum;
@end

@implementation ZJCQGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _stepNum = 0;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _height111.constant = (self.view.frame.size.width == 320 ? 10:50);

    CGFloat imageWidth = (_collectionView.frame.size.width - (CGFloat)_count - 1.0) / (CGFloat)_count;
   // NSLog(@"%.2f   collection的宽>>>> %.2f",imageWidth,_collectionView.frame.size.width);

     //这个是设置flowLayout的 item尺寸
     _viewFlowLayer.itemSize = CGSizeMake(imageWidth, imageWidth);
     /* _nArray = [self changeArrayOrder];
    [self changeArrayOrder];*/
     //获取一个可还原的数组
    _nArray = [self getNewAvailableRandomNumsWithTotalCount:(int)_imageArray.count with_difficulty:self.count];
    [self getNewAvailableRandomNumsWithTotalCount:(int)_imageArray.count with_difficulty:self.count];

    //设置图片内容
    self.fullImage.contentMode = UIViewContentModeScaleAspectFit;
    self.fullImage.image = _bigImage;

}
//视图将要出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _time = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                              selector:@selector(changeTime) userInfo:nil repeats:true];
    [_timer fire];
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
}
#pragma mark -collectionView- 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}
#pragma mark - 配置 item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJCQGameViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gameCell" forIndexPath:indexPath];
    cell.index = (int)indexPath.item;
    cell.image.image = nil;
    //cell.image.image == _imageArray[_imageArray.count - 1];
    if (_nArray[indexPath.item] == _imageArray[_imageArray.count - 1]) {
    
        //这种情况是空白数组
        _emptyCell = cell;
    } else {
        //获取图片
        cell.image.image = _nArray[indexPath.item];
    }

    return cell;
}
#pragma mark - 选中item事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZJCQGameViewCell *cell = (ZJCQGameViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    int value = abs(cell.index - _emptyCell.index);
    if (value == _count || (value == 1 && cell.index/_count == _emptyCell.index/_count) ) {
        _emptyCell.image.image = cell.image.image;
        cell.image.image = nil;
        _emptyCell = cell;
        
        _stepNum ++;
        _stepLabel.text = @(_stepNum).stringValue;
    }
    if (_emptyCell.index == _imageArray.count - 1) {
        BOOL isComplete = YES;
        for (int i = 0; i < _imageArray.count - 1; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            ZJCQGameViewCell *cell = (ZJCQGameViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            BOOL isSame = cell.image.image == _imageArray[i];
            isComplete = isComplete == isSame;
            //如果isComplete = NO,跳出for循环
            if (!isComplete) {
                break;
            }
        }
        //如果已经完成了
        if (isComplete) {
            //销毁计时器
            [_timer invalidate];
            //将最后一格的图片显示出来  这样拼图才完整
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_imageArray.count - 1 inSection:0];
            ZJCQGameViewCell *cell = (ZJCQGameViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            //如何判断已完成 拼图,当图片为数组中的最后一个时,判断已拼完成
            cell.image.image = _imageArray[_imageArray.count - 1];
        
        
            //判断是否是本地图片,如果是本地图片,完成拼图后删除本地文件
            NSString *localPicPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"localPath.txt"];
            //如果存在文件,删除文件
            if ([[NSFileManager defaultManager] fileExistsAtPath:localPicPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:localPicPath error:nil];
            }
        

           //弹出一个 警告框,每三关升级一次难度,共计15关
           UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"恭喜!" message:@"您已完成当前拼图,继续下一关" preferredStyle:UIAlertControllerStyleAlert];
       
            UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
           //获取路径,设置里面的key
            NSString *currentPlistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"CurrentInfoList.plist"];
           NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithContentsOfFile:currentPlistPath];
            //获取当前难度
            NSString *difficulty =   [mulDic valueForKey:@"difficulty"];
            //获取当前关卡
            NSString *level = [mulDic valueForKey:@"level"];
            //获取当前勋章
            NSMutableArray *medals =   [mulDic valueForKey:@"medals" ];
            //设置等级
            if ([level intValue]<15) {
            
            //每2关,给予一个勋章
            if ([level intValue] == 2) {
            //如果不包含勋章
            if (![medals containsObject:@"牛刀小试"]) {
            
            [medals addObject:@"牛刀小试"];
            [medals writeToFile:currentPlistPath atomically:YES];
            
            
            [self popMedalsWithString:@"牛刀小试"];
          
            
            }
            
            }
            if ([level intValue] == 4) {
            if (![medals containsObject:@"渐入佳境"]) {
            
            [medals addObject:@"渐入佳境"];
            [medals writeToFile:currentPlistPath atomically:YES];
            
            //弹出勋章
            //弹出勋章
           /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获得\"渐入佳境\"成就" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
            */
            [self popMedalsWithString:@"渐入佳境"];
            
            }
            
            }
            if ([level intValue] == 6) {
            if (![medals containsObject:@"拼图达人"]) {
            [medals addObject:@"拼图达人"];
            [medals writeToFile:currentPlistPath atomically:YES];
            
            [self popMedalsWithString:@"拼图达人"];
            
            
            }
            
            }
            if ([level intValue] == 8) {
            if (![medals containsObject:@"炉火纯青"]) {
            [medals addObject:@"炉火纯青"];
            [medals writeToFile:currentPlistPath atomically:YES];
            
            //弹出勋章
            //弹出勋章
            [self popMedalsWithString:@"炉火纯青"];
            
            
            }
            
            }
            if ([level intValue] == 10) {
            
            if (![medals containsObject:@"拼图大师"]) {
            [medals addObject:@"拼图大师"];
            [medals writeToFile:currentPlistPath atomically:YES];
            
            //弹出勋章
            //弹出勋章
            [self popMedalsWithString:@"拼图大师"];
            
            
            }
            }
            if ([level intValue] == 12) {
            
            if (![medals containsObject:@"登峰造极"]) {
            [medals addObject:@"登峰造极"];
            [medals writeToFile:currentPlistPath atomically:YES];
            
            //弹出勋章
            //弹出勋章
            [self popMedalsWithString:@"登峰造极"];
            
            
            }
            }
            if ([level intValue] == 14) {
            if (![medals containsObject:@"拼图宗师"]) {
            [medals addObject:@"拼图宗师"];
            [medals writeToFile:currentPlistPath atomically:YES];
            
            //弹出勋章
            //弹出勋章
            [self popMedalsWithString:@"拼图宗师"];
            
            }
            
            }
            
             _bigImage = [UIImage clipImageWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"image%d",[level intValue]+1]]];
            _fullImage.image =_bigImage;
            [mulDic setObject:[NSString stringWithFormat:@"%d",[level intValue]+1] forKey:@"level"];
            [mulDic writeToFile:currentPlistPath atomically:YES];
            NSLog(@"查看当前难度>>>>%@ 当前关卡>>>%@ 当前勋章>>>%@",difficulty,level,medals);
            
            }
            //15关
            if (1<=[level intValue]   && [level intValue]<=3) {
            [mulDic setObject:@"2" forKey:@"difficulty"];
            [mulDic writeToFile:currentPlistPath atomically:YES];
            }else  if (4<=[level intValue] && [level intValue]<=6){
            [mulDic setObject:@"3" forKey:@"difficulty"];
            [mulDic writeToFile:currentPlistPath atomically:YES];
            }else  if (7<=[level intValue] && [level intValue]<=9){
            [mulDic setObject:@"4" forKey:@"difficulty"];
            [mulDic writeToFile:currentPlistPath atomically:YES];
            }else  if (10<=[level intValue] && [level intValue]<=12){
            [mulDic setObject:@"5" forKey:@"difficulty"];
            [mulDic writeToFile:currentPlistPath atomically:YES];
            }else  if (13<=[level intValue] && [level intValue]<=15) {
            [mulDic setObject:@"6" forKey:@"difficulty"];
            [mulDic writeToFile:currentPlistPath atomically:YES];
            }
         
            NSString *difficultyNew =   [mulDic valueForKey:@"difficulty"];
            //重置关卡难度
            [self restartGameMethlodWithCount:[difficultyNew intValue]];
            
            }];
            [alertC addAction:alertAction1];
            [self presentViewController:alertC animated:YES completion:nil];
        
        }
    }
    
}
#pragma mark - 勋章字符串 
- (void)popMedalsWithString:(NSString*)medalsTitle {
      ZJCQMedalPopupView *popView = [[ZJCQMedalPopupView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
      popView.botLbl.text =[NSString stringWithFormat:@"恭喜获得\"%@\"勋章",medalsTitle] ;
      popView.medalsImgView.image = [UIImage imageNamed:medalsTitle];

      //设置弹出view
      KLCPopup *popup = [KLCPopup popupWithContentView:popView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
      [popup show];

      //2s后勋章消失
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [popup dismiss:YES];
      });
}
//收到内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
//随机的打乱图片,这个打乱图片存在无法复原的问题
#pragma mark - 打乱图片 -
- (NSMutableArray *)changeArrayOrder {

    NSMutableArray *tempArry = [NSMutableArray arrayWithArray:_imageArray];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    while (tempArry.firstObject) {
        NSInteger random = arc4random()%tempArry.count;
       //从临时数组中随机取出一个,加入到打乱的图片中(但是这个存在bug,不可还原)
        [array addObject:tempArry[random]];
        [tempArry removeObject:tempArry[random]];
    }
    return array;
}*/
#pragma mark - 打乱图片(这里打乱的是一个可复原的图片)
- (NSMutableArray *)getNewAvailableRandomNumsWithTotalCount:(int)_puzzleCount with_difficulty:(int)_difficulty {

         //随机数字
         int inverCount = 0;
         while (1) {
         NSMutableArray *initializeNums = [NSMutableArray array];//初始化0-n数字
         NSMutableArray *countNumsArr = [NSMutableArray array];
         for (int i = 0; i < _imageArray.count; i++) {
         //数字
         [countNumsArr addObject:@(i)];
         //图片
         [initializeNums addObject:_imageArray[i]];
         }
         
         NSMutableArray *randomNums = [NSMutableArray array];//随机数组(里面放的是图片)
         NSMutableArray *countNums = [NSMutableArray array]; //数字数组(里面放的数值)
         
         for (int i = 0; i < _puzzleCount; i++) {
          //随机一个数
         int randomNum = arc4random() % initializeNums.count;
         //把随机图片加入数组中
         [randomNums addObject:initializeNums[randomNum]];
         //随机数字加入数组
         [countNums addObject:countNumsArr[randomNum]];
         //初始化数值nums
         [initializeNums removeObjectAtIndex:randomNum];
         [countNumsArr removeObjectAtIndex:randomNum];

         }
         //判断是否可还原拼图
         inverCount = 0;
         int curNum = 0;
         int nextNum = 0;
         for (int i = 0; i < _puzzleCount; i++) {
         curNum = [countNums[i] intValue];
         if (curNum == _puzzleCount - 1) {
         inverCount += _difficulty - 1 - (i / _difficulty);
         inverCount += _difficulty - 1 - (i % _difficulty);
         }
        
         for (int j = i + 1; j < _puzzleCount; j++) {
         nextNum = [countNums[j] intValue];
         if (curNum > nextNum) {
         inverCount++;
         }
         }
         }
         if (!(inverCount % 2)) {//对2求余，余0，逆序数为偶数，即偶排列；否则，为奇排列
         return randomNums;
         }
         }
}
//返回按钮事件
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//改变时间
- (void)changeTime {
    NSInteger mintue = _time / 60;
    NSInteger second = _time % 60;
    _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", mintue, second];
    _time ++;
}
#pragma mark - 重新开始游戏按钮事件
- (IBAction)startGame:(id)sender {

     //重新开始游戏方法
     [self restartGameMethlodWithCount:self.count];

}
#pragma mark - 重新开始游戏方法
- (void)restartGameMethlodWithCount:(int)count {


      //记录新的count(几行几列)
      _count =count;
     [_timer invalidate];
     _time = 0;
     _time = 0;
     _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                             selector:@selector(changeTime) userInfo:nil repeats:true];
     //开启定时器
     [_timer fire];

     _stepNum = 0;
     _stepLabel.text = @"0";
     // _nArray = [self changeArrayOrder];

     CGFloat imageWidth = (_collectionView.frame.size.width - (CGFloat)_count - 1.0) / (CGFloat)_count;
     NSLog(@"%.2f   collection的宽>>>> %.2f",imageWidth,_collectionView.frame.size.width);
     _imageArray =   [UIImage clipImageWithImage:_bigImage withConuntM:_count withCountN:_count];
     //这个是设置flowLayout的 item尺寸
     _viewFlowLayer.itemSize = CGSizeMake(imageWidth, imageWidth);


     //这个图片数组 和 count(行列)
     _nArray = [self getNewAvailableRandomNumsWithTotalCount:(int)_imageArray.count with_difficulty:_count];
     [_collectionView reloadData];


}
#pragma mark - 榜单按钮事件
- (IBAction)bangdanAction:(UIButton *)sender {

    // 数据库真的不想写了 有问题可以交流 

    ZJCQMedalsViewController *medalsVC = [[ZJCQMedalsViewController alloc] init];
    [self presentViewController:medalsVC animated:YES completion:nil];

}
/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
