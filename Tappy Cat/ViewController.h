//
//  ViewController.h
//  Tappy Cat
//
//  Created by Michelle Chen on 9/28/15.
//  Copyright (c) 2015 Michelle Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>



@interface ViewController : UIViewController


//Xib properties

@property (weak, nonatomic) IBOutlet UIImageView *iTappyCat01;
@property (weak, nonatomic) IBOutlet UIImageView *iBackground;
@property (weak, nonatomic) IBOutlet UIImageView *iTappyCat02;
@property (weak, nonatomic) IBOutlet UIImageView *iTappyCat03;
@property (weak, nonatomic) IBOutlet UIImageView *iTappyCat04;

@property (weak, nonatomic) IBOutlet UILabel *lScore;
@property (weak, nonatomic) IBOutlet UILabel *lBottomInstructions;
@property (weak, nonatomic) IBOutlet UILabel *lTime;
@property (weak, nonatomic) IBOutlet UIButton *bNextLabel;

- (IBAction)bNext:(UIButton *)sender;

@end