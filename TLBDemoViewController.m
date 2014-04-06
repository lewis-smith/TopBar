//
//  TLBDemoViewController.m
//  NavBar
//
//  Created by Lewis Smith on 18/09/2013.
//  Copyright (c) 2013 Lasmit TLB. All rights reserved.
//

#import "TLBDemoViewController.h"

@interface TLBDemoViewController ()

@end

@implementation TLBDemoViewController

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
