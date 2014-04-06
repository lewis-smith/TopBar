//
//  TLBSlidersViewController.m
//  NavBar
//
//  Created by Lewis Smith on 17/09/2013.
//  Copyright (c) 2013 Lasmit TLB. All rights reserved.
//

#import "TLBSlidersViewController.h"

@interface TLBSlidersViewController ()

@property (strong, nonatomic) IBOutlet UISlider *hueSlider;
@property (strong, nonatomic) IBOutlet UISlider *saturationSlider;
@property (strong, nonatomic) IBOutlet UISlider *brightnessSlider;
@property (strong, nonatomic) IBOutlet UISlider *alphaSlider;

@property (strong, nonatomic) IBOutlet UITextField *hueTextField;
@property (strong, nonatomic) IBOutlet UITextField *saturationTextField;
@property (strong, nonatomic) IBOutlet UITextField *brightnessTextField;
@property (strong, nonatomic) IBOutlet UITextField *alphaTextField;
@property (strong, nonatomic) IBOutlet UIImageView *colourSwatch;
@property (strong, nonatomic) IBOutlet UIButton *desiredColourButton;

@end

@implementation TLBSlidersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSData *desiredColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"desiredColour"];
    UIColor *desiredColour;
    
    if (desiredColorData){
        desiredColour = [NSKeyedUnarchiver unarchiveObjectWithData:desiredColorData];
    } else {
        desiredColour = [UIColor blackColor];
    }
    
    self.desiredColourButton.backgroundColor = desiredColour;

    if (self.view.tag == 1) {
        NSData *navColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"navColour"];
        UIColor *navColour;
        
        if (navColorData) {
            navColour = [NSKeyedUnarchiver unarchiveObjectWithData:navColorData];
        } else {
            navColour = [UIColor whiteColor];
        }
        
        [self setSlidersToColor:navColour];
        [self updateNavBartoColor:navColour];
	}
    
    if (self.view.tag == 2) {
        [self setSlidersToColor:desiredColour];
    }
    
    [self updateTextBoxes];
}


-(void) updateNavBartoColor:(UIColor*) color
{
    [[UINavigationBar appearance] setBarTintColor: color];
    
    self.navigationController.navigationBar.barTintColor = color;
    
    self.colourSwatch.backgroundColor = color;
    self.tabBarController.tabBar.barTintColor = color;
    [[UINavigationBar appearance] setBarTintColor:color];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setSlidersToColor:(UIColor*) color {
    CGFloat hue, saturation, brightness, alpha;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    self.hueSlider.value = hue*360;
    self.saturationSlider.value = saturation*100;
    self.brightnessSlider.value = brightness*100;
    self.alphaSlider.value = alpha*100;
}

- (IBAction)sliderChanged:(UISlider *)sender {

    NSData *colorData;
    
    switch (self.view.tag) {
        case 1:
            [self updateNavBartoColor:[self colourForSliders]];
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[self colourForSliders]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"navColour"];
            break;
        case 2:
            [self updateButtonColour];
            colorData = [NSKeyedArchiver archivedDataWithRootObject:[self colourForSliders]];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"desiredColour"];

            break;
            
        default:
            break;
    }
    
    [self updateTextBoxes];
}

-(void) updateButtonColour
{
    self.desiredColourButton.backgroundColor = [self colourForSliders];
}

-(UIColor*) colourForSliders
{
    return [UIColor colorWithHue:self.hueSlider.value/360 saturation:self.saturationSlider.value/100 brightness:self.brightnessSlider.value/100 alpha:self.alphaSlider.value/100];
}

-(void) updateTextBoxes
{
    self.hueTextField.text = [NSString stringWithFormat:@"%.2f", self.hueSlider.value];
    self.saturationTextField.text = [NSString stringWithFormat:@"%.2f", self.saturationSlider.value];
    self.brightnessTextField.text = [NSString stringWithFormat:@"%.2f", self.brightnessSlider.value];
    self.alphaTextField.text = [NSString stringWithFormat:@"%.2f",  self.alphaSlider.value];
    
}

- (IBAction)shareTapped:(id)sender {
    NSData *desiredColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"desiredColour"];
    UIColor *desiredColour = [NSKeyedUnarchiver unarchiveObjectWithData:desiredColorData];
    
    NSData *navColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"navColour"];
    UIColor *navColour = [NSKeyedUnarchiver unarchiveObjectWithData:navColorData];
    
    NSString *text = [NSString stringWithFormat:@"Desired Color: %@ \nActual Color: %@", [self describeColour:desiredColour], [self describeColour:navColour]];
    
    
    NSArray *items = [NSArray arrayWithObjects:text, nil];
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
    
    return;
}

-(NSString*) describeColour:(UIColor*)color
{
    CGFloat hue, saturation, brightness, alpha;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    return [NSString stringWithFormat:@"H: %.2f S: %.2f B: %.2f A: %.2f", hue, saturation, brightness, alpha];

}

@end
