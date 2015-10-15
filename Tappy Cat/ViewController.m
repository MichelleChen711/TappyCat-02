//
//  ViewController.m
//  Tappy Cat
//
//  Created by Michelle Chen on 9/29/15.
//  Copyright (c) 2015 Michelle Chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    int imageCount;
    int tapCount;
    int state;
    int currMin;
    int currSec;
    UIImageView *imageView;
    UIView *sweetSpot;
    UIView *gettingClose;
    NSTimer *timer;
    NSMutableArray *images;
    UIImage *tappyCat1;
    UIImage *tappyCat2;
    int start;
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
    imageCount = 0;
    _lScore.text = [NSString stringWithFormat:@"Score: %d",tapCount];
    imageView = _iTappyCat01;
    state = 2;
    sweetSpot = [[UIView alloc] init];
    gettingClose = [[UIView alloc] init];
    _lTime.text = @"Time: 1:00";
    currMin = 1;
    currSec = 00;
    images = [[NSMutableArray alloc] init];
    tappyCat1 = [UIImage imageNamed:@"tappycat_s1-01"];
    tappyCat2 = [UIImage imageNamed:@"tappycat_s1-02"];
    [images addObject:tappyCat1];
    [images addObject:tappyCat2];
    
    [self animation];
    
}

-(void)animation{
    [self tappyCatState];
    [images replaceObjectAtIndex:0 withObject:tappyCat1];
    [images replaceObjectAtIndex:1 withObject:tappyCat2];
    
    imageView.animationImages = images;
    imageView.animationDuration = .5;
    while(![imageView isAnimating]){
        [imageView startAnimating];
    }
    imageView.hidden = NO;
    _iTappyCat02.hidden = YES;
    _iTappyCat03.hidden = YES;
    _iTappyCat04.hidden = YES;

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
    //[images replaceObjectAtIndex:0 withObject:tappyCat1];
    //[images replaceObjectAtIndex:1 withObject:tappyCat2];
}
/*
Within the cat image boundaries, create a small shape at a random coordinate and a larger shape around its center.
 */
-(void)generateSweetSpot {

    int maxX = CGRectGetMaxX(imageView.frame);
    int maxY = CGRectGetMaxY(imageView.frame);
    int minX = CGRectGetMinX(imageView.frame);
    int minY = CGRectGetMinY(imageView.frame);

    int randX = (arc4random()%((maxX-50)-minX))+minX;
    int randY = (arc4random()%(maxY-minY))+minY;
    
    sweetSpot.frame = CGRectMake(randX, randY, 50, 50);

    gettingClose.frame = CGRectMake(sweetSpot.center.x - 80, sweetSpot.center.y -80, 160,160);
    
    //For testing purposes
    //[gettingClose setBackgroundColor:[UIColor blueColor]];
    //[sweetSpot setBackgroundColor:[UIColor redColor]];
    
    
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
        
        if(_bNextLabel.isEnabled){
            _lBottomInstructions.text = @"Press Start first...";
        }
        else{
            if(CGRectContainsPoint(gettingClose.frame, touchPoint)){
                //touched within the large shape
                state = 2;
                [imageView setImage:[UIImage imageNamed:@"tappycat_s2-01"]];
                //[self tappyCatState];
                _lBottomInstructions.text = @"Getting warmer...";
                imageView.hidden = YES;
                _iTappyCat02.hidden = NO;
                [imageView stopAnimating];
                
                if(CGRectContainsPoint(sweetSpot.frame, touchPoint)){
                    //touched within the small shape
                    tapCount ++;
                    _lScore.text = [NSString stringWithFormat:@"Score: %d",tapCount];
                    _lBottomInstructions.text = @"You got it! Find the next spot...";
                    state = 1;
                    [imageView setImage:[UIImage imageNamed:@"tappycat_s1-01"]];
                    //[self tappyCatState];
                    imageView.hidden = YES;
                    _iTappyCat04.hidden = NO;
                    [imageView stopAnimating];
                    [self generateSweetSpot];
                }
            }
            else{
                //touched outside of both shapes
                state = 3;
                [imageView setImage:[UIImage imageNamed:@"tappycat_s2-01"]];
                //[self tappyCatState];
                _lBottomInstructions.text = @"Not even close...";
                imageView.hidden = YES;
                _iTappyCat03.hidden = NO;
                [imageView stopAnimating];
            }
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
    _lBottomInstructions.text = @"Start tappin'!";
}

@end


