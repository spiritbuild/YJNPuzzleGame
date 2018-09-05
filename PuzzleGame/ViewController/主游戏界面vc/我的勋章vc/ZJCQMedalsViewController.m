//
//  MedalsViewController.m
//  PuzzleGame
//
//  Created by 哈哈 on 2018/8/31.
//  Copyright © 2018年  张亚飞. All rights reserved.
//

#import "ZJCQMedalsViewController.h"

#import "ZJCQMedalsCollectionViewCell.h"
#import "UIColor+YjnExtension.h"

@interface ZJCQMedalsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
//记录勋章的数组
NSMutableArray *_medals;

}
//我的勋章列表
@property (nonatomic,strong)UICollectionView *medalsListCollectionView;
//所有的勋章列表 
@property (nonatomic,strong)NSMutableArray *datasourceArr;

//底部lbl
@property (nonatomic,strong)NSMutableArray *botLblArr;


@end


@implementation ZJCQMedalsViewController

#pragma mark - 消失按钮事件
- (void)dismissBtnClick:(UIButton*)dismissBtn {

NSLog(@"消失按钮");
[self dismissViewControllerAnimated:YES completion:nil];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

      //获取路径,设置里面的key
      NSString *currentPlistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"CurrentInfoList.plist"];
      NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithContentsOfFile:currentPlistPath];

      //获取当前勋章
     _medals =   [mulDic valueForKey:@"medals" ];

      //消失按钮
      UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     dismissBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-40, 20, 40, 40);
     [dismissBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
     //dismissBtn.backgroundColor = [UIColor redColor];
     [dismissBtn addTarget:self action:@selector(dismissBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:dismissBtn];


    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing =5.0;
    //   flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 5, -5);

    flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-25)/4, ([UIScreen mainScreen].bounds.size.width-25)/4+20);


    self.medalsListCollectionView =  [[UICollectionView alloc] initWithFrame:CGRectMake(0,dismissBtn.frame.size.height+dismissBtn.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
    _medalsListCollectionView.backgroundColor = [UIColor whiteColor];
    _medalsListCollectionView.delegate = self;
    _medalsListCollectionView.dataSource = self;
    //注册cell
    [_medalsListCollectionView registerClass:[ZJCQMedalsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_medalsListCollectionView];


}
#pragma mark - 懒加载数据源数组
- (NSMutableArray*)datasourceArr {

    if (!_datasourceArr) {
    _datasourceArr = [[NSMutableArray alloc] initWithObjects:@"牛刀小试1",@"渐入佳境1",@"拼图达人1",@"炉火纯青1",@"拼图大师1",@"登峰造极1",@"拼图宗师1", nil];
    }
    return _datasourceArr;
}
#pragma mark - 懒加载底部lbl数组
- (NSMutableArray*)botLblArr {

   if (!_botLblArr) {
   _botLblArr = [[NSMutableArray alloc] initWithObjects:@"牛刀小试",@"渐入佳境",@"拼图达人",@"炉火纯青",@"拼图大师",@"登峰造极",@"拼图宗师", nil];
   }

return _botLblArr;
}

#pragma mark - 设置行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {


   return self.datasourceArr.count;
}
#pragma mark - 配置item
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

   ZJCQMedalsCollectionViewCell *cell =   [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];


   cell.medalsImageView.image = [UIImage imageNamed:_datasourceArr[indexPath.row]];
   cell.botLbl.text = self.botLblArr[indexPath.row];

    [_medals enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

    if ([obj isEqualToString:cell.botLbl.text]) {

    cell.medalsImageView.image = [UIImage imageNamed:(NSString*)obj];
    cell.botLbl.textColor = [UIColor colorWithHexString:@"#88DD4B" alpha:1.0];
    }


    }];



    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
