#pragma mark - Platform
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#pragma mark - Orientation
#define IS_PORTRAIT UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)
#define IS_PORTRAIT_2 UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || UIDeviceOrientationIsPortrait(self.interfaceOrientation)

#pragma mark - Debug
#define BOOL_CHECK(TITLE, CHECK_ITEM) printf("%s: %s\n", TITLE, (CHECK_ITEM) ? "Yes" : "No")

#pragma mark - Strings
#define STREQ(STRING1, STRING2) ([STRING1 caseInsensitiveCompare:STRING2] == NSOrderedSame)
#define PREFIXED(STRING1, STRING2) ([[STRING1 uppercaseString] hasPrefix:[STRING2 uppercaseString]])

#pragma mark - Colors

#pragma mark - Constants
