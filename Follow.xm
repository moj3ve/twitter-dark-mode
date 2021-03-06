#import "Common.h"

NSString* kDefaultsFirstLaunchKey = @"shown_announcement_1";

@interface T1HomeTimelineItemsViewController: UIViewController
- (void)openTwitterAccount:(NSString *)username;
@end

%group NEW_INSTALLATION_WELCOME
%hook T1HomeTimelineItemsViewController
-(void)viewDidLoad {
    %orig;
    NSString *message = @"Thanks for installing Twitter Dark Mode.\n\n If you have any suggestions or bugs to report "
                        "send it to me on Twitter. This tweak is free but you can always consider donating a dollar "
                        "or more and following me on Twitter for updates.";

    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Welcome!"
                                                                    message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Not Interested 😞" style:UIAlertActionStyleCancel handler:nil]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Follow @NeoIghodaro"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
        [self openTwitterAccount:kTwitterUsername];
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Buy me coffee"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/neocreativitykills"]];
    }]];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

%new
- (void)openTwitterAccount:(NSString *)username {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:username]]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:username]]];
    }
}
%end
%end


%ctor {
    NSNumber *shownMessage = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsFirstLaunchKey
                                                                        inDomain:kTwitterDarkModeBundleIdentifier];

    if (shownMessage == 0) {
        %init(NEW_INSTALLATION_WELCOME)

        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                                  forKey:kDefaultsFirstLaunchKey
                                                inDomain:kTwitterDarkModeBundleIdentifier];
    }
}

