//
//  CIDemoViewController.m
//  CIDemo
//
//  Created by Nasser Ali on 6/27/11.
//  Copyright 2011 rmh. All rights reserved.
//

#import "CIDemoViewController.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>

@implementation CIDemoViewController
@synthesize slider;
@synthesize faceView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.faceView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"face" ofType:@"jpg"]]; //[UIImage imageNamed:@"face.png"];
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}



-(CIImage *)faceboxImageForFace:(CIFaceFeature *)face
{
    CIColor *color = [CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.3];
    
    CIImage *image = [CIFilter filterWithName:@"CIConstantColorGenerator" keysAndValues:@"inputColor", color, nil].outputImage;
    image = [CIFilter filterWithName:@"CICrop" keysAndValues:kCIInputImageKey, image,
             @"inputRectangle", [CIVector vectorWithCGRect:face.bounds], nil].outputImage;
    return image;
    
}

- (void)detectFacesAndDrawFaceBoxes:(UIImage *)image {
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
    
    NSArray *faces = [detector featuresInImage:ciImage];
    
    for (CIFaceFeature *face in faces) {
        ciImage = [CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:kCIInputImageKey, [self faceboxImageForFace:face],
                   kCIInputBackgroundImageKey, ciImage ,nil].outputImage;
        
    }
    CIContext *ctx = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ctx createCGImage:ciImage fromRect:[ciImage extent]];
    self.faceView.image = [UIImage imageWithCGImage:cgImage];

}

- (IBAction)reDraw:(id)sender {
    UIImage *image = self.faceView.image;
    [self detectFacesAndDrawFaceBoxes:image];

}

- (IBAction)filterIt:(id)sender {
     
    UIImage *image = self.faceView.image;
    
    CIImage *cImage = [CIImage imageWithCGImage:[image CGImage]];
    
    CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];    //create the filter and set it up
    [hueAdjust setDefaults];    
    [hueAdjust setValue: cImage forKey: @"inputImage"];    
    [hueAdjust setValue: [NSNumber numberWithFloat:self.slider.value ]     //2.094
                 forKey: @"inputAngle"];
     CIImage *result = [hueAdjust valueForKey: @"outputImage"];
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    self.faceView.image = [UIImage imageWithCGImage:[context createCGImage:result fromRect:CGRectMake(0, 0, image.size.width, image.size.height)]];
}

- (IBAction)changeHue:(id)sender {

    //[self filterIt:nil];
    [self.view setNeedsDisplay];
    
}
- (void)viewDidUnload {
    [self setSlider:nil];
    [super viewDidUnload];
}
@end
