// Generated by Apple Swift version 2.2 (swiftlang-703.0.18.8 clang-703.0.31)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class FHResponse;
@class NSError;
@class NSDictionary;
@class UIApplication;
@class NSArray;

SWIFT_CLASS_NAMED("FH")
@interface FH : NSObject

/// Check if the device is online. The device is online if either WIFI or 3G network is available. Default value is true.
///
/// <ul><li>Returns true if the device is online</li></ul>
+ (BOOL)isOnline;

/// Initialize the library.
///
/// This must be called before any other API methods can be called. The
/// initialization process runs asynchronously so that it won't block the main UI
/// thread.
///
/// You need to make sure it is successful before calling any other API methods. The
/// best way to do is by catching the error that is thrown in case of failure to initialize.
///
/// <code>FH.init { (resp:Response, error: NSError?) -> Void in
/// if let error = error {
/// self.statusLabel.text = "FH init in error"
/// print("Error: \(error)")
/// return
/// }
/// self.statusLabel.text = "FH init successful"
/// FH.cloud("hello", completionHandler: { (response: Response, error: NSError?) -> Void in
/// if let error = error {
/// print("Error: \(error)")
/// return
/// }
/// print("Response from Cloud Call: \(response.parsedResponse)")
/// })
/// print("Response: \(resp.parsedResponse)")
/// }
/// 
/// </code>
/// <ul><li>Param completionHandler: InnerCompletionBlock is a closure wrap-up that throws errors in case of init failure. If no error, the inner closure returns a JSON Object containing all the details from the init call.</li><li>Throws NSError: Networking issue details.</li></ul>
/// \returns  Void
+ (void)init:(void (^ _Nonnull)(FHResponse * _Nonnull, NSError * _Nullable))completionHandler;

/// Create a new instance of CloudRequest class and execute it immediately with the completionHandler closure. The request runs asynchronously.
///
/// <ul><li>Param path: The path of the cloud API</li><li>Param method: The HTTP request method to use for the request. Defaulted to .POST.</li><li>Param headers: The HTTP headers to use for the request. Can be nil. Defaulted to nil.</li><li>Param args: The request body data. Can be nil. Defaulted to nil.</li><li>Param completionHandler: Closure to be executed as a callback of http asynchronous call.</li></ul>
+ (void)performCloudRequest:(NSString * _Nonnull)path method:(NSString * _Nonnull)method headers:(NSDictionary * _Nullable)headers args:(NSDictionary * _Nullable)args completionHandler:(void (^ _Nonnull)(FHResponse * _Nonnull, NSError * _Nullable))completionHandler;
+ (void)pushEnabledForRemoteNotification:(UIApplication * _Nonnull)aaplication;
+ (void)setPushAlias:(NSString * _Nonnull)alias success:(void (^ _Nonnull)(FHResponse * _Nonnull))success error:(void (^ _Nonnull)(FHResponse * _Nonnull))error;
+ (void)setPushCategories:(NSArray * _Nonnull)categories success:(void (^ _Nonnull)(FHResponse * _Nonnull))success error:(void (^ _Nonnull)(FHResponse * _Nonnull))error;
+ (void)sendMetricsWhenAppLaunched:(NSDictionary * _Nullable)launchOptions;
+ (void)sendMetricsWhenAppAwoken:(UIApplicationState)applicationState userInfo:(NSDictionary * _Nonnull)userInfo;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIWebView;
@class NSURLRequest;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC9FeedHenry19OAuthViewController")
@interface OAuthViewController : UIViewController <UIWebViewDelegate>
- (void)viewDidLoad;
- (void)webView:(UIWebView * _Nonnull)webView didFailLoadWithError:(NSError * _Nullable)error;
- (BOOL)webView:(UIWebView * _Nonnull)webView shouldStartLoadWithRequest:(NSURLRequest * _Nonnull)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView * _Nonnull)webView;
- (void)webViewDidFinishLoad:(UIWebView * _Nonnull)webView;
- (void)closeView;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSData;

SWIFT_CLASS_NAMED("Response")
@interface FHResponse : NSObject

/// Get the raw response data
@property (nonatomic, strong) NSData * _Nullable rawResponse;

/// Get the raw response data as String
@property (nonatomic, copy) NSString * _Nullable rawResponseAsString;

/// Get the response data as NSDictionary
@property (nonatomic, strong) NSDictionary * _Nullable parsedResponse;

/// Get the error of the response
@property (nonatomic, strong) NSError * _Nullable error;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop