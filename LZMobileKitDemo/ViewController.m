//
//  ViewController.m
//  LZMobileKitDemo
//
//  Created by 何伟东 on 2019/12/6.
//

#import "ViewController.h"
#import "NSObject+LZProperty.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.a = @"dddd";
    self.b = @"ccc";
    self.d = self;
    self.e = [NSNumber numberWithInt:2];
    self.f = 5.5f;
    
    NSDictionary *dictioanry = [self getAllProperties];
    if ([NSDictionary.class isMemberOfClass:[NSMutableDictionary class]]) {
        NSLog(@"sssss");
    }
    
    // Do any additional setup after loading the view.
}


@end
