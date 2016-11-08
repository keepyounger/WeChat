//
//  SelectionLocationViewController.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/8.
//
//

#import "SelectionLocationViewController.h"
#import "RedManager.h"

@interface SelectionLocationViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation SelectionLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置地理位置";
    
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    
    NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.keepyounger.com/luguo.html"]];
    [self.webView loadRequest:rq];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [bbi setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [bbi setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = bbi;
}

- (void)save
{
    NSString *str  = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSArray *array = [str componentsSeparatedByString:@","];
    if (array.count>=2) {
        RedManager *red = [RedManager sharedManager];
        red.locationStr = str;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
