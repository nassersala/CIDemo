//
//  CIDemoViewController.h
//  CIDemo
//
//  Created by Nasser Ali on 6/27/11.
//  Copyright 2011 rmh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CIDemoViewController : UIViewController {
    UIImageView *faceView;
    UISlider *slider;
}

-(CIImage *)faceboxImageForFace:(CIFaceFeature *)face;
- (IBAction)reDraw:(id)sender;
@property (nonatomic, strong) IBOutlet UIImageView *faceView;

- (IBAction)filterIt:(id)sender;
- (IBAction)changeHue:(id)sender;
@property (nonatomic, strong) IBOutlet UISlider *slider;
@end
