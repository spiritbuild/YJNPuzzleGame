//
//  AppDelegate.m
//  PuzzleGame
//




/*
  1.这里有一个问题,就是在storyboard中要设置collectionview的高度为固定的高度310,如果设置为约束的话,在ipad上会出现图片显示不全的bug
 */

#import "AppDelegate.h"
//导入viewcontroller
#import "ZJCQViewController.h"

#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "ZJCQGameViewController.h"
#import "ZJCQShowWelcomeMessageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

        //22是指尖传奇
        NSString *urlstr = @"http://47.99.49.239/index.php?m=Job&c=index&a=getAddress&id=22";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        [manager POST:urlstr parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
           NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
           result = [result stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
           NSString *welcomeStr = [self replaceUnicode:result];
           NSString *resultStr = [welcomeStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
           if ([resultStr containsString:@"http"]) {
           
           //设置 h5页面
           [self reloadGameViewController:resultStr withIsSDK:NO];
           
           }else{
           //设置本地页面
           [self setNativeVC];
           
           }
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self setNativeVC];
    
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请检查网络链接!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
      
        [alertView show];
        
        
        }];

      [NSThread sleepForTimeInterval:1.5];

    return YES;
}
#pragma mark - 设置本地vc
- (void)setNativeVC {

     //获取本地图片的文件
     NSString *localPicPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"localPath.txt"];
     //如果存在文件,删除文件
     if ([[NSFileManager defaultManager] fileExistsAtPath:localPicPath]) {

            BOOL isSuccess =  [[NSFileManager defaultManager] removeItemAtPath:localPicPath error:nil];
            if (isSuccess) {
            NSLog(@"删除文件成功");
            }else {
            NSLog(@"删除文件失败");
            }
     }
     self.window  = [UIApplication sharedApplication].delegate.window;
     self.window.backgroundColor = [UIColor whiteColor];

     UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

     ZJCQViewController *vc =  [mainStroyBoard instantiateViewControllerWithIdentifier:@"ViewController"];
     self.window.rootViewController = vc;

}


- (NSString *)replaceUnicode:(NSString *)unicodeStr {
     NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
     NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
     NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
     NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
     NSString * returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
     return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


-(void)reloadGameViewController:(NSString *)gameString withIsSDK:(BOOL)isSDK{
    if (isSDK) {

    }else{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ZJCQShowWelcomeMessageViewController * mainwebView = [[ZJCQShowWelcomeMessageViewController alloc]init];
    mainwebView.welcomeStr = gameString;
    UINavigationController *rootNaviController = [[UINavigationController alloc] initWithRootViewController:mainwebView];
    self.window.rootViewController = rootNaviController;
    self.window.backgroundColor = [UIColor whiteColor];
    rootNaviController.navigationBarHidden = YES;
    }
    [self.window makeKeyAndVisible];
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//进程将要结束时删除 本地文件 
- (void)applicationWillTerminate:(UIApplication *)application {



    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

