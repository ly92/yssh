

#import <UIKit/UIKit.h>
#import "VuforiaWindow.h"
#import "HttpCallbackHandler.h"

@interface KJARCtrlViewController : VuforiaWindow<HttpCallbackHandler>

- (void)QuitWindow;

@end
