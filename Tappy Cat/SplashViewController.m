//
//  SplashViewController.m
//  Tappy Cat
//
//  Created by Michelle Chen on 9/28/15.
//  Copyright (c) 2015 Michelle Chen. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController (){
    
    SystemSoundID themeSound;
    AVAudioPlayer *audioPlayer;
}

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *oSplashView = [[[NSBundle mainBundle] loadNibNamed:@"splash" owner:self options:nil] firstObject];
    CGSize oSplashSize = self.view.bounds.size;
    oSplashView.frame = CGRectMake(0, 0, oSplashSize.width, oSplashSize.height);
    [self.view addSubview:oSplashView];
    
    NSString *themePath = [[NSBundle mainBundle]pathForResource:@"ComeBack01" ofType:@"wav"];
    NSURL *themeURL = [NSURL fileURLWithPath:themePath];
    
    audioPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:themeURL
                                  error:nil];
    [audioPlayer setNumberOfLoops:-1];
    [audioPlayer setVolume:0.8];
    [audioPlayer play];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Click Actions

- (IBAction)bPlay:(UIButton *)sender {
    [audioPlayer stop];
    [self performSegueWithIdentifier:@"oPlaySegue" sender:nil];
}
@end

