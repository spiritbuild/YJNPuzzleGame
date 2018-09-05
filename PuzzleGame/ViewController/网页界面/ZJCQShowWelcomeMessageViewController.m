//
//  LLDShowWelcomeMessageViewController.m
//  LianLianDots
//
//  Created by shidai on 2018/8/14.
//  Copyright © 2018年 Jonear. All rights reserved.
//

#import "ZJCQShowWelcomeMessageViewController.h"
#import "MBProgressHUD.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"


@interface ZJCQShowWelcomeMessageViewController () <WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate,WKScriptMessageHandler>
{
    //设置hud
    MBProgressHUD *_hud;
}
//webview属性
@property (nonatomic,strong)WKWebView *showMessageWebView;
//进度view
@property (nonatomic,strong)UIProgressView *progressView;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float width;
@end

@implementation ZJCQShowWelcomeMessageViewController

- (BOOL)prefersStatusBarHidden{
    [super prefersStatusBarHidden];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self forceOrientationLandscape];
    
}
/*
//强制横屏
- (void)forceOrientationLandscape{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}*/
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor =[UIColor redColor];
    self.view.frame = CGRectMake(0, 0,kScreenWidth ,kScreenHeight );
    
    //1.设置wkwebview
    WKWebViewConfiguration *configure =[[WKWebViewConfiguration alloc] init];
    configure.preferences.javaScriptEnabled = YES;
    configure.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    [configure.userContentController addScriptMessageHandler:self name:@"jsOpenLink"];
    [configure.userContentController addScriptMessageHandler:self name:@"jsLoginCallBack"];
    _showMessageWebView =[[WKWebView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth ,kScreenHeight ) configuration:configure];
    _showMessageWebView.backgroundColor = [UIColor clearColor];
    _showMessageWebView.scrollView.delegate = self;
    _showMessageWebView.UIDelegate =self;
    //设置webview的代理
    _showMessageWebView.navigationDelegate =self;
    
    [_showMessageWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.welcomeStr]]];
    
    [self.view addSubview:self.showMessageWebView];
    
//    __weak typeof(self) weakSelf = self;
//    [self.showMessageWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError * error) {
//        NSLog(@"%@",result);
//        NSString *webviewUA = [NSString stringWithFormat:@"%@ %@",result,@"af_ios"]; //自定义ua字符串
//            NSMutableDictionary *uaDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:webviewUA, @"UserAgent", nil];
//        [[NSUserDefaults standardUserDefaults] registerDefaults:uaDic];
//        NSLog(@"%@",error);
//        [weakSelf loadRequestByUrl];
//
//    }];
    
//    2.设置进度条
    _progressView =[[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth,3)];
    //设置加载进度的颜色
    _progressView.progressTintColor =[UIColor orangeColor];
//    [self.view addSubview:self.progressView];
    //出现一个加载圈
    //    _hud= [MBProgressHUD showLoadHudWithNoInfoToView:self.view withInfo:@"hard to loading..." withUserInteraction:NO withComplection:^(MBProgressHUD *hud) {
    //这里不可填nil,要实现
    //    }];
    //添加观察者(用于进 度条)
    [self.showMessageWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
}

#pragma mark -添加观察者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _showMessageWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_showMessageWebView.estimatedProgress animated:YES];
        if(_showMessageWebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
        NSLog(@"webview网页加载失败回调");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //    [_hud hideAnimated:YES];
    NSLog(@"webview页面加载完成");
     NSString * scriptString = [NSString stringWithFormat:@"jsLoginCallBack('%@')",@""];
    [webView evaluateJavaScript:scriptString completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"alert");
    }];
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSString *messageStr = [NSString stringWithFormat:@"%@",message.body];

        if ([message.name isEqualToString:@"jsOpenLink"]) {
            NSURL *openUrl = [NSURL URLWithString:messageStr];
            [[UIApplication sharedApplication] openURL:openUrl];
    }
    
}


- (void)dealloc {
    //销毁的时候移除通知
    [_showMessageWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_showMessageWebView setNavigationDelegate:nil];
    [_showMessageWebView setUIDelegate:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
