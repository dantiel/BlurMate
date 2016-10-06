//
//  BlurMate.m
//  BlurMate
//
//  Created by Cliff Rowley on 15/03/2014.
//  Copyright (c) 2014 Cliff Rowley. All rights reserved.
//

#import "BlurMate.h"

#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...)
#endif

@implementation BlurMate


- (id)initWithPlugInController:(id <TMPlugInController>)controller {
    NSApp = [NSApplication sharedApplication];
    
    if ((self = [self init])) {
        DebugLog(@"LOADED BLURMATE!");
        
        if(CGSMainConnectionID == NULL || CGSSetWindowBackgroundBlurRadius == NULL) {
            DebugLog(@"CGSSetWindowBackgroundBlurRadius or CGSMainConnectionID unavailable.");
            DebugLog(@"BlurMate will not work.");
            return self;
        }
        [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowDidUpdateNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          NSWindow *window = note.object;
                                                          
                                                          if (!!window) {
                                                              
                                                              NSView *view = window.contentView;
                                                              
                                                              if (!!view) {
                                                                  // the default values
                                                                  NSAppearance *appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
                                                                  NSVisualEffectMaterial material = NSVisualEffectMaterialDark;
                                                                  
                                                                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                                  
                                                                  NSString *vibrantObj = [defaults objectForKey:@"BlurMateVibrance"];
                                                                  if (!!vibrantObj) {
                                                                      DebugLog(@"VIBRANTOBJ: %@", vibrantObj);
                                                                      
                                                                      if ([vibrantObj isEqualToString:@"ultra-dark"]) {
                                                                          material = NSVisualEffectMaterialUltraDark;
                                                                      }
                                                                      else if ([vibrantObj isEqualToString:@"dark"]) {
                                                                          /* default, nothing to do*/
                                                                      }
                                                                      else if ([vibrantObj isEqualToString:@"medium-dark"]) {
                                                                          material = NSVisualEffectMaterialDark;
                                                                          appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
                                                                      }
                                                                      else if ([vibrantObj isEqualToString:@"medium"]) {
                                                                          material = NSVisualEffectMaterialTitlebar;
                                                                          appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
                                                                      }
                                                                      else if ([vibrantObj isEqualToString:@"medium-light"]) {
                                                                          material = NSVisualEffectMaterialMediumLight;
                                                                          appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
                                                                      }
                                                                      else if ([vibrantObj isEqualToString:@"light"]) {
                                                                          material = NSVisualEffectMaterialLight;
                                                                          appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
                                                                      }
                                                                  }
                                                                  
                                                                  
                                                                  [self insertVibrancyViewForView:view appearance:appearance material:&material];
                                                              }
                                                              
                                                              /*
                                                               
                                                               if [view isKindOfClass:NSClassFromString(@"OakTextView")].
                                                               
                                                               
                                                               double radius = 20; // the default
                                                               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                               NSNumber *blurRadiusObj = [defaults objectForKey:@"BlurMateRadius"];
                                                               if (!!blurRadiusObj) {
                                                               radius = [blurRadiusObj doubleValue];
                                                               }
                                                               DebugLog(@"RADIUS: %f", radius);
                                                               [self enableBlurForWindow:window radius:radius];
                                                               */
                                                          }
                                                      }];
    }
    
    return self;
}


- (Boolean)containsOakTextView:(NSView *)view {
    if ([view isKindOfClass:NSClassFromString(@"OakTextView")])
        return true;
    for (NSView *subview in [view subviews])
        if ([self containsOakTextView:subview]) return true; //recursive
    return false;
}

- (void)insertVibrancyViewForView:(NSView *)view appearance:(NSAppearance *)appearance material:(NSVisualEffectMaterial *)material {
    Class vibrantClass = NSClassFromString(@"NSVisualEffectView");
    Boolean isAlreadyVibrant = [view.subviews.firstObject isKindOfClass:vibrantClass];
    Boolean isEditorView = [self containsOakTextView:view];
    
    if (vibrantClass && isEditorView && !isAlreadyVibrant) {
        DebugLog(@"Adding vibrancy for view: %@ %@", view.window.identifier, view.identifier);
        
        NSVisualEffectView *vibrant = [[vibrantClass alloc] initWithFrame:view.bounds];
        view.window.titlebarAppearsTransparent = true;
        //visualEffectView.state = NSVisualEffectState.Active//FollowsWindowActiveState,Inactive
        
        [vibrant setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
        [vibrant setAppearance: appearance];
        [vibrant setMaterial: *material];
        [vibrant setBlendingMode: NSVisualEffectBlendingModeBehindWindow];
        [view addSubview: vibrant positioned:NSWindowBelow relativeTo: nil];
    }
    else {
        DebugLog(@"Not adding vibrancy to view: %@ %@", view.window.identifier, view.identifier);
        DebugLog(@"description: %@", view.window.firstResponder.description);
    }
}

- (void)enableBlurForWindow:(NSWindow *)window radius:(double)radius {
    if (CGSMainConnectionID != NULL && CGSSetWindowBackgroundBlurRadius != NULL) {
        CGSConnectionID con = CGSMainConnectionID();
        
        if (!con) {
            return;
        }
        
        CGSSetWindowBackgroundBlurRadius(con, (CGSWindowID)[window windowNumber], (int)radius);
    } else {
        DebugLog(@"Couldn't get blur function");
    }
}

@end
