//
//  ViewController.m
//  Tappy Cat
//
//  Created by Michelle Chen on 9/29/15.
//  Copyright (c) 2015 Michelle Chen. All rights reserved.
//

#import "ViewController.h"
#import "CustomIOSAlertView.h"

@interface ViewController () {
    int tapCount;
    float heartScore;
    int state;
    int currMin;
    int currSec;
    Boolean animate;
    
    UIImageView *imageView;
    UIView *sweetSpot;
    UIView *gettingClose;
    NSTimer *timer;
    NSMutableArray *images;
    UIImage *tappyCat1;
    UIImage *tappyCat2;

    SystemSoundID meowSound;
    CustomIOSAlertView *alertView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setMultipleTouchEnabled:YES];
    
    UIView *oMainView = [[[NSBundle mainBundle] loadNibNamed:@"main" owner:self options:nil] firstObject];
    CGSize oMainSize = self.view.bounds.size;
    oMainView.frame = CGRectMake(0, 0, oMainSize.width, oMainSize.height);
    [self.view addSubview:oMainView];
    
    _iTappyCat02.hidden = YES;
    _iTappyCat03.hidden = YES;
    _iTappyCat04.hidden = YES;

    
    //initializing variables
    tapCount = 0;
    heartScore = 9;
    state = 2;
    currMin = 1;
    currSec = 00;

    _lScore.text = [NSString stringWithFormat:@"Score: %d",tapCount];
    _lTime.text = @"Time: 1:00";

    imageView = _iTappyCat01;
    sweetSpot = [[UIView alloc] init];
    gettingClose = [[UIView alloc] init];
    images = [[NSMutableArray alloc] init];
    tappyCat1 = [UIImage imageNamed:@"tappycat_s1-01"];
    tappyCat2 = [UIImage imageNamed:@"tappycat_s1-02"];
    [images addObject:tappyCat1];
    [images addObject:tappyCat2];
    
    NSString *meowPath = [[NSBundle mainBundle]pathForResource:@"meow01" ofType:@"wav"];
    NSURL *meowURL = [NSURL fileURLWithPath:meowPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)meowURL, &(meowSound));

    
    alertView = [[CustomIOSAlertView alloc] init];
    [alertView setContainerView:_alertBox];
    
    animate = true;
    [self animation];
    
}

-(void)animation{
    [self tappyCatState];
    [images replaceObjectAtIndex:0 withObject:tappyCat1];
    [images replaceObjectAtIndex:1 withObject:tappyCat2];
    
    imageView.animationImages = images;
    imageView.animationDuration = .5;
    imageView.animationRepeatCount = INFINITY;
    
    _iTappyCat02_2.hidden = YES;
    _iTappyCat03_2.hidden = YES;
    _iTappyCat04_2.hidden = YES;

    if(animate){
        [imageView startAnimating];
        imageView.hidden = NO;
    }
}

/*
Changes the image of the cat depending on the value of state.
 */
-(void)tappyCatState {
    if(state == 1){
        //[imageView setImage:[UIImage imageNamed:@"tappycat2.png"]];
        tappyCat1 = [UIImage imageNamed:@"tappycat_s3-01"];
        tappyCat2 = [UIImage imageNamed:@"tappycat_s3-02"];
    }
    else if(state == 2){
        //[imageView setImage:[UIImage imageNamed:@"tappycat.png"]];
        tappyCat1 = [UIImage imageNamed:@"tappycat_s1-01"];
        tappyCat2 = [UIImage imageNamed:@"tappycat_s1-02"];
    }
    else if(state == 3){
        //[imageView setImage:[UIImage imageNamed:@"tappycat3.png"]];
        tappyCat1 = [UIImage imageNamed:@"tappycat_s2-01"];
        tappyCat2 = [UIImage imageNamed:@"tappycat_s2-02"];
    }
}

-(BOOL) isTransparentPoint:(CGPoint)point
{
    CGImageRef cgim = [imageView image].CGImage;

    unsigned char pixel[1] = {0};
    
    CGContextRef context = CGBitmapContextCreate(pixel,
                                                 1, 1, 8, 1, NULL, (CGBitmapInfo)kCGImageAlphaOnly);
    
    CGContextDrawImage(context, CGRectMake(-point.x,
                                           -point.y,
                                           CGImageGetWidth(cgim),
                                           CGImageGetHeight(cgim)),cgim);
    CGContextRelease(context);
    CGFloat alpha = pixel[0]/255.0;
    BOOL transparent = alpha < 1.0;
    
    return transparent;
}

/*
Within the cat image boundaries, create a small shape at a random coordinate and a larger shape around its center.
 */
-(void)generateSweetSpot {
    
    int maxX = CGRectGetMaxX(imageView.frame);
    int maxY = CGRectGetMaxY(imageView.frame);
    int minX = CGRectGetMinX(imageView.frame);
    int minY = CGRectGetMinY(imageView.frame);
    
    maxX = maxX-55;
    maxY = maxY-55;
    minX = minX+55;
    minY = minY+55;
    
    int randX = 0;
    int randY = 0;
    
    BOOL transparent = true;
    
    while(transparent){
        randX = (arc4random()%((maxX)-minX))+minX;
        randY = (arc4random()%(maxY-minY))+minY;
        CGPoint point = CGPointMake(randX, randY);
        transparent = [self isTransparentPoint:point];
        NSLog(@"is transparent?: %d",transparent);
    }
    
    if(transparent == false){
        sweetSpot.frame = CGRectMake(randX-25, randY-25, 50, 50);
        NSLog(@"%d, %d, %f, %f", randX, randY, sweetSpot.center.x, sweetSpot.center.y);
        gettingClose.frame = CGRectMake(sweetSpot.center.x - 80, sweetSpot.center.y -80, 160,160);
    }
    
    //For testing purposes
    [gettingClose setBackgroundColor:[UIColor blueColor]];
    [sweetSpot setBackgroundColor:[UIColor redColor]];
    [gettingClose setAlpha:0.5];
    [sweetSpot setAlpha:0.5];
    
    [self.view addSubview:gettingClose];
    [self.view addSubview:sweetSpot];

}

/*
 Handle the user's touch request by creating a point and checking to see if that point is within the two created shapes in generateSweetSpot(). Set the state and score accordingly.
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        // Get a single touch and it's coordinates
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:self.view];
        
        //[self checkEnd];
        
        if(!_bNextLabel.isEnabled && CGRectContainsPoint(imageView.frame,touchPoint)){
            animate = false;
            if(CGRectContainsPoint(gettingClose.frame, touchPoint)){
                //touched within the large shape
                NSLog(@"TOUCHED CLOSE");
                
                //change image
                state = 2;
                [imageView setImage:[UIImage imageNamed:@"tappycat_s2-01"]];
                _lBottomInstructions.text = @"Meow. . . \n(Getting warmer)";
                imageView.hidden = YES;
                _iTappyCat02.hidden = NO;
                [imageView stopAnimating];
                
                if(CGRectContainsPoint(sweetSpot.frame, touchPoint)){
                    //touched within the small shape
                    NSLog(@"TOUCHED POINT");

                    //change image
                    state = 1;
                    [imageView setImage:[UIImage imageNamed:@"tappycat_s1-01"]];
                    _lBottomInstructions.text = @"*Purr Purr!* \n (You got it, keep going!)";
                    imageView.hidden = YES;
                    _iTappyCat04.hidden = NO;
                    [imageView stopAnimating];

                    //score increase
                    tapCount ++;
                    _lScore.text = [NSString stringWithFormat:@"Score: %d",tapCount];
                    
                    //play meow sound
                    AudioServicesPlaySystemSound(meowSound);
                    
                }
            }
            else{
                //touched outside of both shapes
                NSLog(@"TOUCHED OUT");
                
                //change image
                state = 3;
                [imageView setImage:[UIImage imageNamed:@"tappycat_s2-01"]];
                _lBottomInstructions.text = @"*Hiss!* \n(Not even close!)";
                imageView.hidden = YES;
                _iTappyCat03.hidden = NO;
                [imageView stopAnimating];

                //decrement heart score
                heartScore = heartScore -.1;
                
                NSLog(@"heartCOunt: %f", heartScore);
            }
            [imageView stopAnimating];
            if([imageView isAnimating] == false)NSLog(@"stopped animating");
        }
    }];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        
        // Get a single touch and it's coordinates
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:self.view];
        
        if(!_bNextLabel.isEnabled && CGRectContainsPoint(imageView.frame,touchPoint)){        
            
            _iTappyCat02.hidden = YES;
            _iTappyCat03.hidden = YES;
            _iTappyCat04.hidden = YES;
            animate = true;

            if(CGRectContainsPoint(gettingClose.frame, touchPoint)){
                //touched within the large shape
                imageView.hidden = YES;
                _iTappyCat02_2.hidden = NO;
                NSLog(@"LET GO CLOSE");

                if(CGRectContainsPoint(sweetSpot.frame, touchPoint)){
                    //touched within the small shape
                    imageView.hidden = YES;
                    _iTappyCat04_2.hidden = NO;
                    [self generateSweetSpot];
                    NSLog(@"LET GO POINT");

                }
            }
            else{
                //touched outside of both shapes
                imageView.hidden = YES;
                _iTappyCat03_2.hidden = NO;
                NSLog(@"LET GO OUT");

            }
            [self animation];
            if([imageView isAnimating])NSLog(@"started animating");
        }
    }];
}

/*
 Selector method for timer that updates the timer and displays pop-up for when the time left is 0.
 */
- (void) timerStart {
    [self animation];

    if((currMin >0 || currSec >=0) && currMin >= 0){
        if(currSec == 0){
            currMin -= 1;
            currSec = 59;
        }
        else if(currSec > 0){
            currSec -= 1;
        }
        if(currMin >- 1){
            _lTime.text = [NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMin,@":",currSec];

        }
    }
    else{
        [timer invalidate];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Over!"
                                                        message:_lScore.text
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

/*
 When the user clicks "ok" in the game over alert box, it will segue to home screen and the game resets.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        [self performSegueWithIdentifier:@"oHomeSegue" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Click Actions

/*
 Button action begins the game and hides the button.
 */
- (IBAction)bNext:(UIButton *)sender {
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    [self generateSweetSpot];
    [_bNextLabel setEnabled:NO];
    _bNextLabel.hidden = YES;
    _lBottomInstructions.text = @"Meow! \n(Start tappin'!)";
}

@end


