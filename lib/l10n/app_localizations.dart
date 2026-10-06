import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('si'), Locale('ta')];

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to FarmFriend'**
  String get authWelcomeBack;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOut;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgot;

  /// No description provided for @authGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authGoogle;

  /// No description provided for @authPhone.
  ///
  /// In en, this message translates to:
  /// **'Continue with phone'**
  String get authPhone;

  /// No description provided for @authNewHere.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get authNewHere;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authCreateTitle;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authFullName;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPassword;

  /// No description provided for @authAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms & Privacy Policy'**
  String get authAgreeTerms;

  /// No description provided for @authAgreeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms to continue.'**
  String get authAgreeRequired;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccount;

  /// No description provided for @authSignInInstead.
  ///
  /// In en, this message translates to:
  /// **'Sign in instead'**
  String get authSignInInstead;

  /// No description provided for @authCheckEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get authCheckEmailTitle;

  /// No description provided for @authCheckEmailBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to {email}. Open it to activate your account, then sign in.'**
  String authCheckEmailBody(String email);

  /// No description provided for @authOpenEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Open email app'**
  String get authOpenEmailApp;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get authBackToLogin;

  /// No description provided for @authForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get authForgotTitle;

  /// No description provided for @authForgotBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we will send you a link to choose a new password.'**
  String get authForgotBody;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get authSendResetLink;

  /// No description provided for @authResetSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for {email}, a reset link is on its way. Open it on this phone.'**
  String authResetSent(String email);

  /// No description provided for @authResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password'**
  String get authResetTitle;

  /// No description provided for @authResetNeedsLink.
  ///
  /// In en, this message translates to:
  /// **'Open the reset link from your email on this phone to choose a new password.'**
  String get authResetNeedsLink;

  /// No description provided for @authNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPassword;

  /// No description provided for @authSavePassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get authSavePassword;

  /// No description provided for @authPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Sign in with your new password.'**
  String get authPasswordUpdated;

  /// No description provided for @authPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your phone'**
  String get authPhoneTitle;

  /// No description provided for @authPhoneBody.
  ///
  /// In en, this message translates to:
  /// **'We will send a 6-digit code by SMS to this number.'**
  String get authPhoneBody;

  /// No description provided for @authPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get authPhoneNumber;

  /// No description provided for @authSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get authSendCode;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get authOtpTitle;

  /// No description provided for @authOtpBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}.'**
  String authOtpBody(String phone);

  /// No description provided for @authVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authVerify;

  /// No description provided for @authResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds} s'**
  String authResendIn(int seconds);

  /// No description provided for @authResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResend;

  /// No description provided for @authCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A new code was sent.'**
  String get authCodeSent;

  /// No description provided for @authChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get authChangeNumber;

  /// No description provided for @authResendLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many codes requested. Try again in a few minutes.'**
  String get authResendLimit;

  /// No description provided for @splashGettingReady.
  ///
  /// In en, this message translates to:
  /// **'Getting things ready…'**
  String get splashGettingReady;

  /// No description provided for @splashProfileError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your profile.'**
  String get splashProfileError;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Plan before you plant'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'See how much of each crop the country needs and how much is already registered, before you decide what to grow.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Fair prices, less waste'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Check forecast prices and the best month to harvest, so your crop sells at a fair price.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Market, community & AgriBot'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'Buy seeds and tools, share with other farmers, and ask AgriBot anything in your own language.'**
  String get onboarding3Body;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @profileCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get profileCompleteTitle;

  /// No description provided for @profileCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We need a few details before you start.'**
  String get profileCompleteSubtitle;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @profileSurname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get profileSurname;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileEmailReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed here.'**
  String get profileEmailReadOnly;

  /// No description provided for @profileTelephone.
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get profileTelephone;

  /// No description provided for @profileType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get profileType;

  /// No description provided for @profileSelectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get profileSelectType;

  /// No description provided for @profileDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get profileDistrict;

  /// No description provided for @profileSelectDistrict.
  ///
  /// In en, this message translates to:
  /// **'Select district'**
  String get profileSelectDistrict;

  /// No description provided for @profileSaveContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & continue'**
  String get profileSaveContinue;

  /// No description provided for @profileTypeFarmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get profileTypeFarmer;

  /// No description provided for @profileTypeBuyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get profileTypeBuyer;

  /// No description provided for @profileTypeOfficer.
  ///
  /// In en, this message translates to:
  /// **'Agricultural Officer'**
  String get profileTypeOfficer;

  /// No description provided for @profileAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get profileAddPhoto;

  /// No description provided for @profileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profileChangePhoto;

  /// No description provided for @profilePhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get profilePhotoGallery;

  /// No description provided for @profilePhotoCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get profilePhotoCamera;

  /// No description provided for @maintenanceBody.
  ///
  /// In en, this message translates to:
  /// **'FarmFriend is being updated. Please try again in a little while.'**
  String get maintenanceBody;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get cartTitle;

  /// No description provided for @cartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review your cart and track your submitted orders.'**
  String get cartSubtitle;

  /// No description provided for @cartCashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cartCashOnDelivery;

  /// No description provided for @cartAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get cartAdded;

  /// No description provided for @cartViewCart.
  ///
  /// In en, this message translates to:
  /// **'View cart'**
  String get cartViewCart;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Cart is Empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your cart is clear. You can browse products or check your order history below.'**
  String get cartEmptyMessage;

  /// No description provided for @cartStartShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get cartStartShopping;

  /// No description provided for @cartUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'{price} each'**
  String cartUnitPrice(String price);

  /// No description provided for @cartRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from cart'**
  String get cartRemove;

  /// No description provided for @cartRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} removed from cart'**
  String cartRemoved(String name);

  /// No description provided for @cartOnlyLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {count} left in stock. Reduce the quantity.'**
  String cartOnlyLeft(String count);

  /// No description provided for @cartLineOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'This product is out of stock. Remove it to continue.'**
  String get cartLineOutOfStock;

  /// No description provided for @cartSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get cartSummaryTitle;

  /// No description provided for @cartSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotal;

  /// No description provided for @cartShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get cartShipping;

  /// No description provided for @cartTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cartTotal;

  /// No description provided for @cartPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get cartPayment;

  /// No description provided for @cartEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'Estimated amounts. The final total is confirmed when you place the order.'**
  String get cartEstimateNote;

  /// No description provided for @cartFixStock.
  ///
  /// In en, this message translates to:
  /// **'Some items are more than the available stock. Fix them to continue.'**
  String get cartFixStock;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to checkout'**
  String get cartCheckout;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery contact'**
  String get checkoutContactTitle;

  /// No description provided for @checkoutName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get checkoutName;

  /// No description provided for @checkoutPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get checkoutPhone;

  /// No description provided for @checkoutPhoneHelper.
  ///
  /// In en, this message translates to:
  /// **'We will call this number about your delivery.'**
  String get checkoutPhoneHelper;

  /// No description provided for @checkoutDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get checkoutDistrict;

  /// No description provided for @checkoutPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get checkoutPaymentTitle;

  /// No description provided for @checkoutCodHint.
  ///
  /// In en, this message translates to:
  /// **'Pay in cash when your order is delivered.'**
  String get checkoutCodHint;

  /// No description provided for @checkoutSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get checkoutSummaryTitle;

  /// No description provided for @checkoutLine.
  ///
  /// In en, this message translates to:
  /// **'{name} × {qty}'**
  String checkoutLine(String name, String qty);

  /// No description provided for @checkoutReviewNote.
  ///
  /// In en, this message translates to:
  /// **'After you place the order, an admin reviews it. You can cancel it while it is pending.'**
  String get checkoutReviewNote;

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get checkoutPlaceOrder;

  /// No description provided for @checkoutEmptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty. Add products before you check out.'**
  String get checkoutEmptyCart;

  /// No description provided for @checkoutFailed.
  ///
  /// In en, this message translates to:
  /// **'We could not place your order. Please try again.'**
  String get checkoutFailed;

  /// No description provided for @checkoutStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough stock'**
  String get checkoutStockTitle;

  /// No description provided for @checkoutStockMessage.
  ///
  /// In en, this message translates to:
  /// **'Only {available} of \"{name}\" left in stock. Reduce the quantity in your cart and try again.'**
  String checkoutStockMessage(String name, String available);

  /// No description provided for @checkoutStockNone.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" is out of stock. Remove it from your cart and try again.'**
  String checkoutStockNone(String name);

  /// No description provided for @checkoutStockGeneric.
  ///
  /// In en, this message translates to:
  /// **'A product in your cart does not have enough stock. Update your cart and try again.'**
  String get checkoutStockGeneric;

  /// No description provided for @checkoutUpdateCart.
  ///
  /// In en, this message translates to:
  /// **'Update cart'**
  String get checkoutUpdateCart;

  /// No description provided for @orderMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get orderMyOrders;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String orderNumber(String id);

  /// No description provided for @orderItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String orderItemsCount(int count);

  /// No description provided for @orderPlacedOn.
  ///
  /// In en, this message translates to:
  /// **'Placed on {date}'**
  String orderPlacedOn(String date);

  /// No description provided for @orderTotalLine.
  ///
  /// In en, this message translates to:
  /// **'Total: {total}'**
  String orderTotalLine(String total);

  /// No description provided for @orderItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get orderItemsTitle;

  /// No description provided for @orderItemsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Item details are not available.'**
  String get orderItemsUnavailable;

  /// No description provided for @orderItemQty.
  ///
  /// In en, this message translates to:
  /// **'Qty: {qty} × {price}'**
  String orderItemQty(String qty, String price);

  /// No description provided for @orderAdminNote.
  ///
  /// In en, this message translates to:
  /// **'Note from admin'**
  String get orderAdminNote;

  /// No description provided for @orderCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get orderCancel;

  /// No description provided for @orderCancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get orderCancelConfirmTitle;

  /// No description provided for @orderCancelConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Order #{id} will be cancelled. This cannot be undone.'**
  String orderCancelConfirmMessage(String id);

  /// No description provided for @orderCancelConfirmYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel order'**
  String get orderCancelConfirmYes;

  /// No description provided for @orderCancelConfirmNo.
  ///
  /// In en, this message translates to:
  /// **'Keep order'**
  String get orderCancelConfirmNo;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Your order was cancelled.'**
  String get orderCancelled;

  /// No description provided for @orderCancelNotCancellable.
  ///
  /// In en, this message translates to:
  /// **'This order can no longer be cancelled because it has already been processed.'**
  String get orderCancelNotCancellable;

  /// No description provided for @orderWaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Your order is waiting for admin review.'**
  String get orderWaitingReview;

  /// No description provided for @orderStatusApprovedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order was approved and is being prepared.'**
  String get orderStatusApprovedMessage;

  /// No description provided for @orderStatusShippedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order is on its way to you.'**
  String get orderStatusShippedMessage;

  /// No description provided for @orderStatusDeliveredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order was delivered. Thank you!'**
  String get orderStatusDeliveredMessage;

  /// No description provided for @orderStatusCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'This order was cancelled.'**
  String get orderStatusCancelledMessage;

  /// No description provided for @orderStatusRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'This order was not accepted. See the note from the admin or contact support.'**
  String get orderStatusRejectedMessage;

  /// No description provided for @orderStatusOtherMessage.
  ///
  /// In en, this message translates to:
  /// **'The status of this order was updated.'**
  String get orderStatusOtherMessage;

  /// No description provided for @orderNotifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}: {status}'**
  String orderNotifyTitle(String id, String status);

  /// No description provided for @orderEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get orderEmptyTitle;

  /// No description provided for @orderEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Orders you place will appear here.'**
  String get orderEmptyMessage;

  /// No description provided for @orderNotFound.
  ///
  /// In en, this message translates to:
  /// **'We could not find that order.'**
  String get orderNotFound;

  /// No description provided for @orderSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Order placed'**
  String get orderSuccessTitle;

  /// No description provided for @orderSuccessHeading.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your order was placed.'**
  String get orderSuccessHeading;

  /// No description provided for @orderSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'We received your order. You pay in cash when it is delivered.'**
  String get orderSuccessMessage;

  /// No description provided for @orderSuccessNumber.
  ///
  /// In en, this message translates to:
  /// **'Order number'**
  String get orderSuccessNumber;

  /// No description provided for @orderViewMyOrders.
  ///
  /// In en, this message translates to:
  /// **'View my orders'**
  String get orderViewMyOrders;

  /// No description provided for @orderContinueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get orderContinueShopping;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'AgriBot'**
  String get chatTitle;

  /// No description provided for @chatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FarmFriend Assistant'**
  String get chatSubtitle;

  /// No description provided for @chatOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get chatOnline;

  /// No description provided for @chatOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get chatOffline;

  /// No description provided for @chatLanguageTooltip.
  ///
  /// In en, this message translates to:
  /// **'AgriBot answers in {language}. Tap to change.'**
  String chatLanguageTooltip(String language);

  /// No description provided for @chatDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'AgriBot can make mistakes. Check important decisions with your agriculture officer.'**
  String get chatDisclaimer;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'How can I help you today?'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Ask about crops, prices, seeds or plant diseases.'**
  String get chatEmptyMessage;

  /// No description provided for @chatSuggestionCrop.
  ///
  /// In en, this message translates to:
  /// **'Which crop should I plant next month?'**
  String get chatSuggestionCrop;

  /// No description provided for @chatSuggestionPrice.
  ///
  /// In en, this message translates to:
  /// **'Price of carrot this month?'**
  String get chatSuggestionPrice;

  /// No description provided for @chatSuggestionSeeds.
  ///
  /// In en, this message translates to:
  /// **'What seeds are in the marketplace?'**
  String get chatSuggestionSeeds;

  /// No description provided for @chatSuggestionDisease.
  ///
  /// In en, this message translates to:
  /// **'How to control leaf curl in chilli?'**
  String get chatSuggestionDisease;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type your question…'**
  String get chatInputHint;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get chatSending;

  /// No description provided for @chatFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Not sent. Tap to retry'**
  String get chatFailedRetry;

  /// No description provided for @chatRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many questions — please wait a minute.'**
  String get chatRateLimited;

  /// No description provided for @chatTyping.
  ///
  /// In en, this message translates to:
  /// **'AgriBot is typing…'**
  String get chatTyping;

  /// No description provided for @chatClear.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get chatClear;

  /// No description provided for @chatClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear this chat?'**
  String get chatClearTitle;

  /// No description provided for @chatClearMessage.
  ///
  /// In en, this message translates to:
  /// **'The messages saved on this phone will be removed.'**
  String get chatClearMessage;

  /// No description provided for @chatClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get chatClearConfirm;

  /// No description provided for @chatLoadEarlier.
  ///
  /// In en, this message translates to:
  /// **'Load earlier messages'**
  String get chatLoadEarlier;

  /// No description provided for @chatMicHold.
  ///
  /// In en, this message translates to:
  /// **'Hold to talk'**
  String get chatMicHold;

  /// No description provided for @chatMicListening.
  ///
  /// In en, this message translates to:
  /// **'Listening… release when you finish'**
  String get chatMicListening;

  /// No description provided for @chatMicUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice typing is not available in this language on this phone.'**
  String get chatMicUnavailable;

  /// No description provided for @chatMicFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start the microphone. Allow microphone access and try again.'**
  String get chatMicFailed;

  /// No description provided for @chatSpeak.
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get chatSpeak;

  /// No description provided for @chatStopSpeaking.
  ///
  /// In en, this message translates to:
  /// **'Stop reading'**
  String get chatStopSpeaking;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'FarmFriend'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get navMarket;

  /// No description provided for @navRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get navRegister;

  /// No description provided for @navCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing saved data.'**
  String get commonOffline;

  /// No description provided for @commonRequiresInternet.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to do this.'**
  String get commonRequiresInternet;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get commonViewAll;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get commonOr;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get commonOptional;

  /// No description provided for @commonSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get commonSelect;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @commonNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get commonNoResults;

  /// No description provided for @commonNothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get commonNothingHere;

  /// No description provided for @commonJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get commonJustNow;

  /// No description provided for @commonMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String commonMinutesAgo(int count);

  /// No description provided for @commonHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String commonHoursAgo(int count);

  /// No description provided for @commonDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String commonDaysAgo(int count);

  /// No description provided for @commonUpdatedAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String commonUpdatedAgo(String time);

  /// No description provided for @commonMt.
  ///
  /// In en, this message translates to:
  /// **'MT'**
  String get commonMt;

  /// No description provided for @recordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No records} =1{1 Record} other{{count} Records}}'**
  String recordsCount(int count);

  /// No description provided for @appBarCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get appBarCart;

  /// No description provided for @appBarNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get appBarNotifications;

  /// No description provided for @appBarProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile and settings'**
  String get appBarProfile;

  /// No description provided for @chatFabTooltip.
  ///
  /// In en, this message translates to:
  /// **'Ask AgriBot'**
  String get chatFabTooltip;

  /// No description provided for @languageSwitch.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get languageSwitch;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorNetwork;

  /// No description provided for @errorPermission.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do this.'**
  String get errorPermission;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find what you were looking for.'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In en, this message translates to:
  /// **'This was already done or has changed. Refresh and try again.'**
  String get errorConflict;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a minute and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please check the details you entered.'**
  String get errorValidation;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorPageNotFound.
  ///
  /// In en, this message translates to:
  /// **'This page doesn\'t exist.'**
  String get errorPageNotFound;

  /// No description provided for @errorGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get errorGoHome;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid login credentials'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email first. Check your inbox for the link.'**
  String get authEmailNotConfirmed;

  /// No description provided for @authUserExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Sign in instead.'**
  String get authUserExists;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Use at least 8 characters with a letter and a number.'**
  String get authWeakPassword;

  /// No description provided for @authSamePassword.
  ///
  /// In en, this message translates to:
  /// **'The new password must be different from the old one.'**
  String get authSamePassword;

  /// No description provided for @authWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Your current password is incorrect.'**
  String get authWrongPassword;

  /// No description provided for @authOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'Code expired, send a new one.'**
  String get authOtpExpired;

  /// No description provided for @authOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'That code is not correct. Try again.'**
  String get authOtpInvalid;

  /// No description provided for @authRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts, try again later.'**
  String get authRateLimited;

  /// No description provided for @authGoogleFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get authGoogleFailed;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationEmail;

  /// No description provided for @validationPassword.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters with a letter and a number'**
  String get validationPassword;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMismatch;

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number (7XXXXXXXX)'**
  String get validationPhone;

  /// No description provided for @validationAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than 0 with up to 2 decimals'**
  String get validationAmount;

  /// No description provided for @validationTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use at most {max} characters'**
  String validationTooLong(int max);

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get statusShipped;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// No description provided for @statusReplied.
  ///
  /// In en, this message translates to:
  /// **'Replied'**
  String get statusReplied;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get statusClosed;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// No description provided for @surplusLow.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get surplusLow;

  /// No description provided for @surplusMedium.
  ///
  /// In en, this message translates to:
  /// **'Filling up'**
  String get surplusMedium;

  /// No description provided for @surplusHigh.
  ///
  /// In en, this message translates to:
  /// **'Almost full'**
  String get surplusHigh;

  /// No description provided for @surplusFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get surplusFull;

  /// No description provided for @quotaFilledOfLimit.
  ///
  /// In en, this message translates to:
  /// **'{filled} of {limit} MT registered'**
  String quotaFilledOfLimit(String filled, String limit);

  /// No description provided for @quotaRemaining.
  ///
  /// In en, this message translates to:
  /// **'{remaining} MT left'**
  String quotaRemaining(String remaining);

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'How are we doing?'**
  String get feedbackTitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your answers help the research team improve FarmFriend.'**
  String get feedbackSubtitle;

  /// No description provided for @feedbackOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get feedbackOverall;

  /// No description provided for @feedbackEase.
  ///
  /// In en, this message translates to:
  /// **'Easy to use'**
  String get feedbackEase;

  /// No description provided for @feedbackUsefulness.
  ///
  /// In en, this message translates to:
  /// **'Useful for my farming'**
  String get feedbackUsefulness;

  /// No description provided for @feedbackComment.
  ///
  /// In en, this message translates to:
  /// **'Anything else? (optional)'**
  String get feedbackComment;

  /// No description provided for @feedbackSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackSubmit;

  /// No description provided for @feedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get feedbackThanks;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'A new version is needed to continue.'**
  String get updateRequiredBody;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll be back soon'**
  String get maintenanceTitle;

  /// No description provided for @adminBanner.
  ///
  /// In en, this message translates to:
  /// **'You are an administrator. Manage targets, products and news in the web admin panel.'**
  String get adminBanner;

  /// No description provided for @adminBannerOpen.
  ///
  /// In en, this message translates to:
  /// **'Open web panel'**
  String get adminBannerOpen;

  /// No description provided for @communityWhatsOnMind.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get communityWhatsOnMind;

  /// No description provided for @communityPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get communityPhoto;

  /// No description provided for @communityActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get communityActivity;

  /// No description provided for @communityPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get communityPost;

  /// No description provided for @communityLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get communityLike;

  /// No description provided for @communityComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get communityComment;

  /// No description provided for @communityShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get communityShare;

  /// No description provided for @communityMyPosts.
  ///
  /// In en, this message translates to:
  /// **'My Posts'**
  String get communityMyPosts;

  /// No description provided for @communitySavedPosts.
  ///
  /// In en, this message translates to:
  /// **'Saved Posts'**
  String get communitySavedPosts;

  /// No description provided for @communityMyPostsCount.
  ///
  /// In en, this message translates to:
  /// **'My Posts ({count})'**
  String communityMyPostsCount(String count);

  /// No description provided for @communitySavedPostsCount.
  ///
  /// In en, this message translates to:
  /// **'Saved Posts ({count})'**
  String communitySavedPostsCount(String count);

  /// No description provided for @communityEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get communityEmptyTitle;

  /// No description provided for @communityEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share something with other farmers.'**
  String get communityEmptyMessage;

  /// No description provided for @communityEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Create a post'**
  String get communityEmptyAction;

  /// No description provided for @communityMyPostsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t posted yet'**
  String get communityMyPostsEmptyTitle;

  /// No description provided for @communityMyPostsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your posts will appear here.'**
  String get communityMyPostsEmptyMessage;

  /// No description provided for @communitySavedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved posts'**
  String get communitySavedEmptyTitle;

  /// No description provided for @communitySavedEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark on a post to keep it here.'**
  String get communitySavedEmptyMessage;

  /// No description provided for @communityLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get communityLoadMore;

  /// No description provided for @communityLoadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load more posts.'**
  String get communityLoadMoreFailed;

  /// No description provided for @communityFarmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get communityFarmer;

  /// No description provided for @communitySave.
  ///
  /// In en, this message translates to:
  /// **'Save post'**
  String get communitySave;

  /// No description provided for @communityUnsave.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get communityUnsave;

  /// No description provided for @communityCommentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No comments} =1{1 comment} other{{count} comments}}'**
  String communityCommentsCount(int count);

  /// No description provided for @communityLikesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No likes} =1{1 like} other{{count} likes}}'**
  String communityLikesCount(int count);

  /// No description provided for @communitySeeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get communitySeeMore;

  /// No description provided for @communitySeeLess.
  ///
  /// In en, this message translates to:
  /// **'See less'**
  String get communitySeeLess;

  /// No description provided for @communityMoreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get communityMoreOptions;

  /// No description provided for @communityReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get communityReport;

  /// No description provided for @communityReportSubject.
  ///
  /// In en, this message translates to:
  /// **'Report post #{id}'**
  String communityReportSubject(String id);

  /// No description provided for @communityDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this post?'**
  String get communityDeleteTitle;

  /// No description provided for @communityDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get communityDeleteMessage;

  /// No description provided for @communityPostDeleted.
  ///
  /// In en, this message translates to:
  /// **'Post deleted'**
  String get communityPostDeleted;

  /// No description provided for @communityViewPhoto.
  ///
  /// In en, this message translates to:
  /// **'View photo'**
  String get communityViewPhoto;

  /// No description provided for @communityActivityChoose.
  ///
  /// In en, this message translates to:
  /// **'What are you doing?'**
  String get communityActivityChoose;

  /// No description provided for @communityActivityNone.
  ///
  /// In en, this message translates to:
  /// **'No activity'**
  String get communityActivityNone;

  /// No description provided for @communityActivityPlanting.
  ///
  /// In en, this message translates to:
  /// **'Planting'**
  String get communityActivityPlanting;

  /// No description provided for @communityActivityHarvesting.
  ///
  /// In en, this message translates to:
  /// **'Harvesting'**
  String get communityActivityHarvesting;

  /// No description provided for @communityActivitySelling.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get communityActivitySelling;

  /// No description provided for @communityActivityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get communityActivityQuestion;

  /// No description provided for @postCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get postCreateTitle;

  /// No description provided for @postEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get postEditTitle;

  /// No description provided for @postDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postDetailTitle;

  /// No description provided for @postGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get postGallery;

  /// No description provided for @postCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get postCamera;

  /// No description provided for @postRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get postRemovePhoto;

  /// No description provided for @postPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the photo. Check the app\'s permissions and try again.'**
  String get postPhotoFailed;

  /// No description provided for @postPublished.
  ///
  /// In en, this message translates to:
  /// **'Your post is live'**
  String get postPublished;

  /// No description provided for @postUpdated.
  ///
  /// In en, this message translates to:
  /// **'Post updated'**
  String get postUpdated;

  /// No description provided for @postEditPhotoNote.
  ///
  /// In en, this message translates to:
  /// **'Only the text can be changed. The photo stays the same.'**
  String get postEditPhotoNote;

  /// No description provided for @postNotYours.
  ///
  /// In en, this message translates to:
  /// **'You can only edit your own posts.'**
  String get postNotYours;

  /// No description provided for @postComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get postComments;

  /// No description provided for @postNoComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get postNoComments;

  /// No description provided for @postNoCommentsMessage.
  ///
  /// In en, this message translates to:
  /// **'Be the first to comment.'**
  String get postNoCommentsMessage;

  /// No description provided for @postCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Write a comment…'**
  String get postCommentHint;

  /// No description provided for @postCommentSend.
  ///
  /// In en, this message translates to:
  /// **'Send comment'**
  String get postCommentSend;

  /// No description provided for @postCommentSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get postCommentSending;

  /// No description provided for @postCommentDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this comment?'**
  String get postCommentDeleteTitle;

  /// No description provided for @postCommentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Comment deleted'**
  String get postCommentDeleted;

  /// No description provided for @postCommentsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more comments'**
  String get postCommentsLoadMore;

  /// No description provided for @postCommentHoldToDelete.
  ///
  /// In en, this message translates to:
  /// **'Press and hold to delete'**
  String get postCommentHoldToDelete;

  /// No description provided for @homePill.
  ///
  /// In en, this message translates to:
  /// **'Smart Farming Dashboard'**
  String get homePill;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String homeWelcome(String name);

  /// No description provided for @homeFarmerFallback.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get homeFarmerFallback;

  /// No description provided for @homeHeroText.
  ///
  /// In en, this message translates to:
  /// **'Track your crop registrations, explore marketplace products, read farming updates, and get help from the AI assistant.'**
  String get homeHeroText;

  /// No description provided for @homeRegisterCrop.
  ///
  /// In en, this message translates to:
  /// **'Register Crop'**
  String get homeRegisterCrop;

  /// No description provided for @homeMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get homeMarketplace;

  /// No description provided for @homeMyCrops.
  ///
  /// In en, this message translates to:
  /// **'My Registered Crops'**
  String get homeMyCrops;

  /// No description provided for @homeTotalMt.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount} MT'**
  String homeTotalMt(String amount);

  /// No description provided for @homeMarketItems.
  ///
  /// In en, this message translates to:
  /// **'Marketplace Items'**
  String get homeMarketItems;

  /// No description provided for @homeProductsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Products available now'**
  String get homeProductsAvailable;

  /// No description provided for @homeFarmingNews.
  ///
  /// In en, this message translates to:
  /// **'Farming News'**
  String get homeFarmingNews;

  /// No description provided for @homeLatestUpdates.
  ///
  /// In en, this message translates to:
  /// **'Latest updates and alerts'**
  String get homeLatestUpdates;

  /// No description provided for @homeCropOutlook.
  ///
  /// In en, this message translates to:
  /// **'Crop Outlook'**
  String get homeCropOutlook;

  /// No description provided for @homeCropOutlookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How full the national quota is for each crop'**
  String get homeCropOutlookSubtitle;

  /// No description provided for @homePercentFull.
  ///
  /// In en, this message translates to:
  /// **'{percent}% full'**
  String homePercentFull(int percent);

  /// No description provided for @homeOutlookEmpty.
  ///
  /// In en, this message translates to:
  /// **'No active crop targets right now.'**
  String get homeOutlookEmpty;

  /// No description provided for @homePriceOutlook.
  ///
  /// In en, this message translates to:
  /// **'Price outlook'**
  String get homePriceOutlook;

  /// No description provided for @homePriceOutlookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Biggest wholesale price changes this month'**
  String get homePriceOutlookSubtitle;

  /// No description provided for @homePricesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Price forecasts are not available yet.'**
  String get homePricesEmpty;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActions;

  /// No description provided for @homeActionRegister.
  ///
  /// In en, this message translates to:
  /// **'Register Harvest'**
  String get homeActionRegister;

  /// No description provided for @homeActionRegisterSub.
  ///
  /// In en, this message translates to:
  /// **'Add expected crop amount'**
  String get homeActionRegisterSub;

  /// No description provided for @homeActionPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan Profit'**
  String get homeActionPlan;

  /// No description provided for @homeActionPlanSub.
  ///
  /// In en, this message translates to:
  /// **'See income before you plant'**
  String get homeActionPlanSub;

  /// No description provided for @homeActionBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse Products'**
  String get homeActionBrowse;

  /// No description provided for @homeActionBrowseSub.
  ///
  /// In en, this message translates to:
  /// **'Buy seeds and farm tools'**
  String get homeActionBrowseSub;

  /// No description provided for @homeActionAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask Assistant'**
  String get homeActionAsk;

  /// No description provided for @homeActionAskSub.
  ///
  /// In en, this message translates to:
  /// **'Get help from AgriBot'**
  String get homeActionAskSub;

  /// No description provided for @homeMyRegistrations.
  ///
  /// In en, this message translates to:
  /// **'My Crop Registrations'**
  String get homeMyRegistrations;

  /// No description provided for @homeMtRegistered.
  ///
  /// In en, this message translates to:
  /// **'{amount} MT registered'**
  String homeMtRegistered(String amount);

  /// No description provided for @homeRegisterLink.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get homeRegisterLink;

  /// No description provided for @homeNoRegistrations.
  ///
  /// In en, this message translates to:
  /// **'No crops registered yet'**
  String get homeNoRegistrations;

  /// No description provided for @homeNoRegistrationsBody.
  ///
  /// In en, this message translates to:
  /// **'Register your expected harvest to lock in your quota.'**
  String get homeNoRegistrationsBody;

  /// No description provided for @homeLatestNews.
  ///
  /// In en, this message translates to:
  /// **'Latest Farming News'**
  String get homeLatestNews;

  /// No description provided for @homeNoNews.
  ///
  /// In en, this message translates to:
  /// **'No news yet.'**
  String get homeNoNews;

  /// No description provided for @homeUpdateBody.
  ///
  /// In en, this message translates to:
  /// **'A newer version of FarmFriend is available.'**
  String get homeUpdateBody;

  /// No description provided for @marketTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketTitle;

  /// No description provided for @marketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse agricultural tools, seeds, and equipment for your farm.'**
  String get marketSubtitle;

  /// No description provided for @marketSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get marketSearchHint;

  /// No description provided for @marketSearchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get marketSearchClear;

  /// No description provided for @marketCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get marketCategoryAll;

  /// No description provided for @marketCategorySeeds.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get marketCategorySeeds;

  /// No description provided for @marketCategoryTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get marketCategoryTools;

  /// No description provided for @marketEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get marketEmptyTitle;

  /// No description provided for @marketEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'There is nothing to show here right now. Pull down to refresh.'**
  String get marketEmptyMessage;

  /// No description provided for @marketEmptySearch.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches \"{query}\". Try another word.'**
  String marketEmptySearch(String query);

  /// No description provided for @marketShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all products'**
  String get marketShowAll;

  /// No description provided for @productInStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock: {count}'**
  String productInStock(String count);

  /// No description provided for @productOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get productOutOfStock;

  /// No description provided for @productAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get productAdd;

  /// No description provided for @productDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetailTitle;

  /// No description provided for @productWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight: {weight}'**
  String productWeight(String weight);

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescription;

  /// No description provided for @productReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get productReadMore;

  /// No description provided for @productShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get productShowLess;

  /// No description provided for @productQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get productQuantity;

  /// No description provided for @productOutOfStockNote.
  ///
  /// In en, this message translates to:
  /// **'This product is out of stock right now. Please check again later.'**
  String get productOutOfStockNote;

  /// No description provided for @productAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get productAddToCart;

  /// No description provided for @productBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get productBuyNow;

  /// No description provided for @moreProfileHint.
  ///
  /// In en, this message translates to:
  /// **'View and edit your profile'**
  String get moreProfileHint;

  /// No description provided for @moreProfileNoName.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get moreProfileNoName;

  /// No description provided for @moreGroupFarming.
  ///
  /// In en, this message translates to:
  /// **'Farming tools'**
  String get moreGroupFarming;

  /// No description provided for @moreGroupActivity.
  ///
  /// In en, this message translates to:
  /// **'My activity'**
  String get moreGroupActivity;

  /// No description provided for @moreGroupApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get moreGroupApp;

  /// No description provided for @moreNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get moreNews;

  /// No description provided for @morePrices.
  ///
  /// In en, this message translates to:
  /// **'Crop Prices'**
  String get morePrices;

  /// No description provided for @morePlanner.
  ///
  /// In en, this message translates to:
  /// **'Profit Planner'**
  String get morePlanner;

  /// No description provided for @moreOutlook.
  ///
  /// In en, this message translates to:
  /// **'Crop Outlook'**
  String get moreOutlook;

  /// No description provided for @moreOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get moreOrders;

  /// No description provided for @moreQuotas.
  ///
  /// In en, this message translates to:
  /// **'My Quotas'**
  String get moreQuotas;

  /// No description provided for @moreSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get moreSupport;

  /// No description provided for @moreNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get moreNotifications;

  /// No description provided for @newsTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get newsTitle;

  /// No description provided for @newsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Farming news and alerts'**
  String get newsSubtitle;

  /// No description provided for @newsDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newsDetailTitle;

  /// No description provided for @newsReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get newsReadMore;

  /// No description provided for @newsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get newsFilterAll;

  /// No description provided for @newsTypeTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get newsTypeTechnology;

  /// No description provided for @newsTypeAlert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get newsTypeAlert;

  /// No description provided for @newsTypeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get newsTypeGeneral;

  /// No description provided for @newsTypeDisease.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get newsTypeDisease;

  /// No description provided for @newsTypeMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get newsTypeMarket;

  /// No description provided for @newsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No news yet'**
  String get newsEmptyTitle;

  /// No description provided for @newsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'New articles and alerts will appear here.'**
  String get newsEmptyMessage;

  /// No description provided for @newsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get newsLoadMore;

  /// No description provided for @newsLoadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load more news.'**
  String get newsLoadMoreFailed;

  /// No description provided for @newsByAuthor.
  ///
  /// In en, this message translates to:
  /// **'By {author}'**
  String newsByAuthor(String author);

  /// No description provided for @newsShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get newsShare;

  /// No description provided for @notifEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notifEmptyTitle;

  /// No description provided for @notifEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Alerts and announcements will appear here.'**
  String get notifEmptyMessage;

  /// No description provided for @notifMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notifMarkAllRead;

  /// No description provided for @notifUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unread} other{{count} unread}}'**
  String notifUnreadCount(int count);

  /// No description provided for @notifNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New notification'**
  String get notifNewTitle;

  /// No description provided for @notifUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notifUnread;

  /// No description provided for @pricesTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Prices'**
  String get pricesTitle;

  /// No description provided for @pricesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wholesale forecast · updated {date}'**
  String pricesSubtitle(String date);

  /// No description provided for @pricesSubtitleNoDate.
  ///
  /// In en, this message translates to:
  /// **'Wholesale forecast'**
  String get pricesSubtitleNoDate;

  /// No description provided for @pricesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search crops'**
  String get pricesSearchHint;

  /// No description provided for @pricesSortAz.
  ///
  /// In en, this message translates to:
  /// **'A–Z'**
  String get pricesSortAz;

  /// No description provided for @pricesSortRise.
  ///
  /// In en, this message translates to:
  /// **'Biggest rise'**
  String get pricesSortRise;

  /// No description provided for @pricesSortFall.
  ///
  /// In en, this message translates to:
  /// **'Biggest fall'**
  String get pricesSortFall;

  /// No description provided for @pricesSortMargin.
  ///
  /// In en, this message translates to:
  /// **'Best margin'**
  String get pricesSortMargin;

  /// No description provided for @pricesAboveFair.
  ///
  /// In en, this message translates to:
  /// **'Above fair price'**
  String get pricesAboveFair;

  /// No description provided for @pricesBelowFair.
  ///
  /// In en, this message translates to:
  /// **'Below fair price'**
  String get pricesBelowFair;

  /// No description provided for @pricesForecastPending.
  ///
  /// In en, this message translates to:
  /// **'Forecast pending'**
  String get pricesForecastPending;

  /// No description provided for @pricesStale.
  ///
  /// In en, this message translates to:
  /// **'Forecast may be outdated'**
  String get pricesStale;

  /// No description provided for @pricesFooterNote.
  ///
  /// In en, this message translates to:
  /// **'Forecasts are estimates from historical prices, weather and fuel costs. Actual market prices can differ.'**
  String get pricesFooterNote;

  /// No description provided for @pricesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No prices yet'**
  String get pricesEmptyTitle;

  /// No description provided for @pricesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Price forecasts appear here after the monthly forecast has run.'**
  String get pricesEmptyBody;

  /// No description provided for @pricesChangeUp.
  ///
  /// In en, this message translates to:
  /// **'Up {percent} from last month'**
  String pricesChangeUp(String percent);

  /// No description provided for @pricesChangeDown.
  ///
  /// In en, this message translates to:
  /// **'Down {percent} from last month'**
  String pricesChangeDown(String percent);

  /// No description provided for @pricesChangeFlat.
  ///
  /// In en, this message translates to:
  /// **'No change from last month'**
  String get pricesChangeFlat;

  /// No description provided for @pricesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month\'s wholesale price'**
  String get pricesThisMonth;

  /// No description provided for @pricesLatestActual.
  ///
  /// In en, this message translates to:
  /// **'Latest market price ({month})'**
  String pricesLatestActual(String month);

  /// No description provided for @pricesVsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'vs. last month'**
  String get pricesVsLastMonth;

  /// No description provided for @pricesRetail.
  ///
  /// In en, this message translates to:
  /// **'Estimated retail {price}'**
  String pricesRetail(String price);

  /// No description provided for @pricesTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Price trend'**
  String get pricesTrendTitle;

  /// No description provided for @pricesTrendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Past 24 months and the next 12 months'**
  String get pricesTrendSubtitle;

  /// No description provided for @pricesLegendActual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get pricesLegendActual;

  /// No description provided for @pricesLegendForecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get pricesLegendForecast;

  /// No description provided for @pricesLegendBand.
  ///
  /// In en, this message translates to:
  /// **'Floor to fair price'**
  String get pricesLegendBand;

  /// No description provided for @pricesToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get pricesToday;

  /// No description provided for @pricesChartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Not enough price data to draw a chart yet.'**
  String get pricesChartEmpty;

  /// No description provided for @pricesBestMonthTitle.
  ///
  /// In en, this message translates to:
  /// **'Best month to harvest'**
  String get pricesBestMonthTitle;

  /// No description provided for @pricesBestMonthProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit {profit}'**
  String pricesBestMonthProfit(String profit);

  /// No description provided for @pricesPlantToHarvest.
  ///
  /// In en, this message translates to:
  /// **'Plant in {plant} to harvest in {harvest}'**
  String pricesPlantToHarvest(String plant, String harvest);

  /// No description provided for @pricesRegisterCrop.
  ///
  /// In en, this message translates to:
  /// **'Register this crop'**
  String get pricesRegisterCrop;

  /// No description provided for @pricesPlanProfit.
  ///
  /// In en, this message translates to:
  /// **'Plan my profit'**
  String get pricesPlanProfit;

  /// No description provided for @pricesCostTitle.
  ///
  /// In en, this message translates to:
  /// **'Costs and fair price'**
  String get pricesCostTitle;

  /// No description provided for @pricesCostPerKg.
  ///
  /// In en, this message translates to:
  /// **'Cost to grow'**
  String get pricesCostPerKg;

  /// No description provided for @pricesFairPrice.
  ///
  /// In en, this message translates to:
  /// **'Fair price (cost + 40%)'**
  String get pricesFairPrice;

  /// No description provided for @pricesProfitPerKg.
  ///
  /// In en, this message translates to:
  /// **'Profit per kg'**
  String get pricesProfitPerKg;

  /// No description provided for @pricesFloorPrice.
  ///
  /// In en, this message translates to:
  /// **'Minimum floor price'**
  String get pricesFloorPrice;

  /// No description provided for @pricesQuotaTitle.
  ///
  /// In en, this message translates to:
  /// **'National quota'**
  String get pricesQuotaTitle;

  /// No description provided for @pricesQuotaOpen.
  ///
  /// In en, this message translates to:
  /// **'See crop outlook'**
  String get pricesQuotaOpen;

  /// No description provided for @pricesWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why this price?'**
  String get pricesWhyTitle;

  /// No description provided for @pricesWhyIntro.
  ///
  /// In en, this message translates to:
  /// **'What the forecast model used for this month:'**
  String get pricesWhyIntro;

  /// No description provided for @pricesWhyRainfall.
  ///
  /// In en, this message translates to:
  /// **'Rainfall used'**
  String get pricesWhyRainfall;

  /// No description provided for @pricesWhyRainfallValue.
  ///
  /// In en, this message translates to:
  /// **'{mm} mm'**
  String pricesWhyRainfallValue(String mm);

  /// No description provided for @pricesWhyWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather shock'**
  String get pricesWhyWeather;

  /// No description provided for @pricesWhyWeatherApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get pricesWhyWeatherApplied;

  /// No description provided for @pricesWhyWeatherNone.
  ///
  /// In en, this message translates to:
  /// **'Not applied'**
  String get pricesWhyWeatherNone;

  /// No description provided for @pricesWhyDiesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel price (per litre)'**
  String get pricesWhyDiesel;

  /// No description provided for @pricesWhyTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport index'**
  String get pricesWhyTransport;

  /// No description provided for @pricesWhyCycle.
  ///
  /// In en, this message translates to:
  /// **'Growth cycle'**
  String get pricesWhyCycle;

  /// No description provided for @pricesWhyCycleValue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String pricesWhyCycleValue(int count);

  /// No description provided for @pricesWhyModel.
  ///
  /// In en, this message translates to:
  /// **'Model version'**
  String get pricesWhyModel;

  /// No description provided for @pricesWhyGenerated.
  ///
  /// In en, this message translates to:
  /// **'Forecast made on'**
  String get pricesWhyGenerated;

  /// No description provided for @pricesAskBot.
  ///
  /// In en, this message translates to:
  /// **'Ask AgriBot'**
  String get pricesAskBot;

  /// No description provided for @pricesAskPrompt.
  ///
  /// In en, this message translates to:
  /// **'What will {crop} sell for in {month}?'**
  String pricesAskPrompt(String crop, String month);

  /// No description provided for @pricesNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No prices for this crop'**
  String get pricesNotFoundTitle;

  /// No description provided for @pricesNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'There is no price history or forecast for {crop} yet.'**
  String pricesNotFoundBody(String crop);

  /// No description provided for @plannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Profit Planner'**
  String get plannerTitle;

  /// No description provided for @plannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If I plant this much, what do I get?'**
  String get plannerSubtitle;

  /// No description provided for @plannerCrop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get plannerCrop;

  /// No description provided for @plannerCropHint.
  ///
  /// In en, this message translates to:
  /// **'Select a crop'**
  String get plannerCropHint;

  /// No description provided for @plannerMonth.
  ///
  /// In en, this message translates to:
  /// **'Harvest month'**
  String get plannerMonth;

  /// No description provided for @plannerBestMonthHint.
  ///
  /// In en, this message translates to:
  /// **'⭐ Best month to harvest'**
  String get plannerBestMonthHint;

  /// No description provided for @plannerLand.
  ///
  /// In en, this message translates to:
  /// **'Land size'**
  String get plannerLand;

  /// No description provided for @plannerLandHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1'**
  String get plannerLandHint;

  /// No description provided for @plannerAcres.
  ///
  /// In en, this message translates to:
  /// **'Acres'**
  String get plannerAcres;

  /// No description provided for @plannerHectares.
  ///
  /// In en, this message translates to:
  /// **'Hectares'**
  String get plannerHectares;

  /// No description provided for @plannerLandInHa.
  ///
  /// In en, this message translates to:
  /// **'= {ha} hectares'**
  String plannerLandInHa(String ha);

  /// No description provided for @plannerPickCrop.
  ///
  /// In en, this message translates to:
  /// **'Choose a crop to start your plan.'**
  String get plannerPickCrop;

  /// No description provided for @plannerEnterLand.
  ///
  /// In en, this message translates to:
  /// **'Enter your land size to see the plan.'**
  String get plannerEnterLand;

  /// No description provided for @plannerResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plan'**
  String get plannerResultTitle;

  /// No description provided for @plannerNoYield.
  ///
  /// In en, this message translates to:
  /// **'The model has no yield figure for this crop and month, so the harvest cannot be estimated.'**
  String get plannerNoYield;

  /// No description provided for @plannerPlantIn.
  ///
  /// In en, this message translates to:
  /// **'Plant in'**
  String get plannerPlantIn;

  /// No description provided for @plannerExpectedHarvest.
  ///
  /// In en, this message translates to:
  /// **'Expected harvest'**
  String get plannerExpectedHarvest;

  /// No description provided for @plannerCost.
  ///
  /// In en, this message translates to:
  /// **'Production cost'**
  String get plannerCost;

  /// No description provided for @plannerIncome.
  ///
  /// In en, this message translates to:
  /// **'Expected income at forecast wholesale price'**
  String get plannerIncome;

  /// No description provided for @plannerProfit.
  ///
  /// In en, this message translates to:
  /// **'Expected profit'**
  String get plannerProfit;

  /// No description provided for @plannerLoss.
  ///
  /// In en, this message translates to:
  /// **'Expected loss'**
  String get plannerLoss;

  /// No description provided for @plannerBreakEven.
  ///
  /// In en, this message translates to:
  /// **'Break-even price'**
  String get plannerBreakEven;

  /// No description provided for @plannerQuotaFits.
  ///
  /// In en, this message translates to:
  /// **'{remaining} MT left — your {amount} MT fits ✅'**
  String plannerQuotaFits(String remaining, String amount);

  /// No description provided for @plannerQuotaExceeds.
  ///
  /// In en, this message translates to:
  /// **'{remaining} MT left — your {amount} MT exceeds the remaining quota ⚠️'**
  String plannerQuotaExceeds(String remaining, String amount);

  /// No description provided for @plannerSeeAlternatives.
  ///
  /// In en, this message translates to:
  /// **'See crops with room'**
  String get plannerSeeAlternatives;

  /// No description provided for @plannerCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare crops'**
  String get plannerCompareTitle;

  /// No description provided for @plannerCompareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Same land and harvest month, up to 3 more crops'**
  String get plannerCompareSubtitle;

  /// No description provided for @plannerCompareAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a crop to compare'**
  String get plannerCompareAdd;

  /// No description provided for @plannerCompareRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove {crop}'**
  String plannerCompareRemove(String crop);

  /// No description provided for @plannerCompareBest.
  ///
  /// In en, this message translates to:
  /// **'Highest profit'**
  String get plannerCompareBest;

  /// No description provided for @plannerCompareNoData.
  ///
  /// In en, this message translates to:
  /// **'— means there is no forecast for that crop in this month.'**
  String get plannerCompareNoData;

  /// No description provided for @plannerShortHarvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get plannerShortHarvest;

  /// No description provided for @plannerShortCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get plannerShortCost;

  /// No description provided for @plannerShortIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get plannerShortIncome;

  /// No description provided for @plannerShortProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get plannerShortProfit;

  /// No description provided for @plannerRegisterCta.
  ///
  /// In en, this message translates to:
  /// **'Register {amount} MT of {crop}'**
  String plannerRegisterCta(String amount, String crop);

  /// No description provided for @plannerDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These are estimates from the forecast model. Real harvests, costs and market prices can differ.'**
  String get plannerDisclaimer;

  /// No description provided for @plannerNoForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'No forecasts yet'**
  String get plannerNoForecastTitle;

  /// No description provided for @plannerNoForecastBody.
  ///
  /// In en, this message translates to:
  /// **'The planner needs price forecasts. Connect to the internet and pull down to refresh.'**
  String get plannerNoForecastBody;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register Harvest Quota'**
  String get registerTitle;

  /// No description provided for @registerAuthBadge.
  ///
  /// In en, this message translates to:
  /// **'Farmer Authenticated'**
  String get registerAuthBadge;

  /// No description provided for @registerInfo.
  ///
  /// In en, this message translates to:
  /// **'Register your crops to secure price.'**
  String get registerInfo;

  /// No description provided for @registerSelectCrop.
  ///
  /// In en, this message translates to:
  /// **'Select Crop'**
  String get registerSelectCrop;

  /// No description provided for @registerSelectCropHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose a crop'**
  String get registerSelectCropHint;

  /// No description provided for @registerCropRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a crop'**
  String get registerCropRequired;

  /// No description provided for @registerSearchCrop.
  ///
  /// In en, this message translates to:
  /// **'Search crops'**
  String get registerSearchCrop;

  /// No description provided for @registerNoTargets.
  ///
  /// In en, this message translates to:
  /// **'There are no active crop targets right now. Please check again later.'**
  String get registerNoTargets;

  /// No description provided for @registerNoActiveTarget.
  ///
  /// In en, this message translates to:
  /// **'There is no active national target for {crop} right now.'**
  String registerNoActiveTarget(String crop);

  /// No description provided for @registerLimit.
  ///
  /// In en, this message translates to:
  /// **'National limit'**
  String get registerLimit;

  /// No description provided for @registerFilled.
  ///
  /// In en, this message translates to:
  /// **'Registered so far'**
  String get registerFilled;

  /// No description provided for @registerRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get registerRemaining;

  /// No description provided for @registerFairPrice.
  ///
  /// In en, this message translates to:
  /// **'Fair price'**
  String get registerFairPrice;

  /// No description provided for @registerWholesale.
  ///
  /// In en, this message translates to:
  /// **'Est. wholesale price'**
  String get registerWholesale;

  /// No description provided for @registerPlantingDate.
  ///
  /// In en, this message translates to:
  /// **'Planting date'**
  String get registerPlantingDate;

  /// No description provided for @registerHarvestDate.
  ///
  /// In en, this message translates to:
  /// **'Target harvest date'**
  String get registerHarvestDate;

  /// No description provided for @registerFarmerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No farmers registered yet} =1{1 farmer registered} other{{count} farmers registered}}'**
  String registerFarmerCount(int count);

  /// No description provided for @registerForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Model forecast for {month}'**
  String registerForecastTitle(String month);

  /// No description provided for @registerForecastWholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale price'**
  String get registerForecastWholesale;

  /// No description provided for @registerForecastProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit per kg'**
  String get registerForecastProfit;

  /// No description provided for @registerSeeTrend.
  ///
  /// In en, this message translates to:
  /// **'See price trend'**
  String get registerSeeTrend;

  /// No description provided for @registerAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected Harvest Amount (MT)'**
  String get registerAmountLabel;

  /// No description provided for @registerAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 100'**
  String get registerAmountHint;

  /// No description provided for @registerAmountHelper.
  ///
  /// In en, this message translates to:
  /// **'Remaining capacity: {remaining} MT'**
  String registerAmountHelper(String remaining);

  /// No description provided for @registerAmountMax.
  ///
  /// In en, this message translates to:
  /// **'The amount cannot be more than {max} MT'**
  String registerAmountMax(String max);

  /// No description provided for @registerInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'This amount was not accepted. Check it and try again.'**
  String get registerInvalidAmount;

  /// No description provided for @registerDontKnow.
  ///
  /// In en, this message translates to:
  /// **'Don\'t know the tonnage?'**
  String get registerDontKnow;

  /// No description provided for @registerCheckAndRegister.
  ///
  /// In en, this message translates to:
  /// **'Check & Register'**
  String get registerCheckAndRegister;

  /// No description provided for @registerSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Quota registered'**
  String get registerSuccessTitle;

  /// No description provided for @registerSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Registered {amount} MT of {crop}. Your quota is locked.'**
  String registerSuccessBody(String amount, String crop);

  /// No description provided for @registerViewQuotas.
  ///
  /// In en, this message translates to:
  /// **'View my quotas'**
  String get registerViewQuotas;

  /// No description provided for @registerNoTarget.
  ///
  /// In en, this message translates to:
  /// **'No active national target for this crop. Contact admin.'**
  String get registerNoTarget;

  /// No description provided for @registerContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get registerContactSupport;

  /// No description provided for @registerUnknownResult.
  ///
  /// In en, this message translates to:
  /// **'We could not confirm this registration. Check My Registered Quotas below, or update the app and try again.'**
  String get registerUnknownResult;

  /// No description provided for @registerCropChanged.
  ///
  /// In en, this message translates to:
  /// **'Crop changed to {crop}. Tap Check & Register to continue.'**
  String registerCropChanged(String crop);

  /// No description provided for @registerSurplusTitle.
  ///
  /// In en, this message translates to:
  /// **'Quota exceeded for {crop}'**
  String registerSurplusTitle(String crop);

  /// No description provided for @registerSurplusBody.
  ///
  /// In en, this message translates to:
  /// **'Only {remaining} MT left. Registering more would cause a surplus and lower prices.'**
  String registerSurplusBody(String remaining);

  /// No description provided for @registerSurplusBodyFull.
  ///
  /// In en, this message translates to:
  /// **'This quota is full. Registering more would cause a surplus and lower prices.'**
  String get registerSurplusBodyFull;

  /// No description provided for @registerSurplusRequested.
  ///
  /// In en, this message translates to:
  /// **'You asked to register {amount} MT.'**
  String registerSurplusRequested(String amount);

  /// No description provided for @registerSurplusConfirming.
  ///
  /// In en, this message translates to:
  /// **'Confirming with the server…'**
  String get registerSurplusConfirming;

  /// No description provided for @registerSurplusAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Alternative crops'**
  String get registerSurplusAlternatives;

  /// No description provided for @registerSurplusNoAlternatives.
  ///
  /// In en, this message translates to:
  /// **'No other crop has room right now.'**
  String get registerSurplusNoAlternatives;

  /// No description provided for @registerAltWhy.
  ///
  /// In en, this message translates to:
  /// **'{remaining} MT of room · Fair price {price}'**
  String registerAltWhy(String remaining, String price);

  /// No description provided for @registerAltWhyNoPrice.
  ///
  /// In en, this message translates to:
  /// **'{remaining} MT of room'**
  String registerAltWhyNoPrice(String remaining);

  /// No description provided for @registerAltChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get registerAltChoose;

  /// No description provided for @registerRemainingCta.
  ///
  /// In en, this message translates to:
  /// **'Register remaining {remaining} MT'**
  String registerRemainingCta(String remaining);

  /// No description provided for @registerLandTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimate from land size'**
  String get registerLandTitle;

  /// No description provided for @registerLandBody.
  ///
  /// In en, this message translates to:
  /// **'Uses the model\'s yield for {crop} harvested in {month}.'**
  String registerLandBody(String crop, String month);

  /// No description provided for @registerLandSize.
  ///
  /// In en, this message translates to:
  /// **'Land size'**
  String get registerLandSize;

  /// No description provided for @registerLandEstimate.
  ///
  /// In en, this message translates to:
  /// **'Estimated harvest'**
  String get registerLandEstimate;

  /// No description provided for @registerLandYield.
  ///
  /// In en, this message translates to:
  /// **'Model yield: {tonnes} MT per hectare'**
  String registerLandYield(String tonnes);

  /// No description provided for @registerLandUse.
  ///
  /// In en, this message translates to:
  /// **'Use {amount} MT'**
  String registerLandUse(String amount);

  /// No description provided for @registerLandUseDisabled.
  ///
  /// In en, this message translates to:
  /// **'Enter your land size'**
  String get registerLandUseDisabled;

  /// No description provided for @quotasTitle.
  ///
  /// In en, this message translates to:
  /// **'My Registered Quotas'**
  String get quotasTitle;

  /// No description provided for @quotasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your locked-in harvest quotas'**
  String get quotasSubtitle;

  /// No description provided for @quotasColCrop.
  ///
  /// In en, this message translates to:
  /// **'Crop Name'**
  String get quotasColCrop;

  /// No description provided for @quotasColAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount (MT)'**
  String get quotasColAmount;

  /// No description provided for @quotasColDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get quotasColDate;

  /// No description provided for @quotasLockedNote.
  ///
  /// In en, this message translates to:
  /// **'These quotas are locked in. Contact admin to modify records.'**
  String get quotasLockedNote;

  /// No description provided for @quotasRequestChange.
  ///
  /// In en, this message translates to:
  /// **'Request a change'**
  String get quotasRequestChange;

  /// No description provided for @quotasChangeSubject.
  ///
  /// In en, this message translates to:
  /// **'Quota change request'**
  String get quotasChangeSubject;

  /// No description provided for @quotasEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No quotas registered yet'**
  String get quotasEmptyTitle;

  /// No description provided for @quotasEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Register your expected harvest to lock in a quota and a fair price.'**
  String get quotasEmptyBody;

  /// No description provided for @quotasEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Register a crop'**
  String get quotasEmptyAction;

  /// No description provided for @quotasTotal.
  ///
  /// In en, this message translates to:
  /// **'Total registered'**
  String get quotasTotal;

  /// No description provided for @quotasCropCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 crop} other{{count} crops}}'**
  String quotasCropCount(int count);

  /// No description provided for @outlookTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Outlook'**
  String get outlookTitle;

  /// No description provided for @outlookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'National demand vs. registered supply'**
  String get outlookSubtitle;

  /// No description provided for @outlookSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search crops'**
  String get outlookSearchHint;

  /// No description provided for @outlookFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get outlookFilterAll;

  /// No description provided for @outlookFilterAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get outlookFilterAvailable;

  /// No description provided for @outlookFilterAlmostFull.
  ///
  /// In en, this message translates to:
  /// **'Almost full'**
  String get outlookFilterAlmostFull;

  /// No description provided for @outlookFilterFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get outlookFilterFull;

  /// No description provided for @outlookSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get outlookSortLabel;

  /// No description provided for @outlookSortMostRoom.
  ///
  /// In en, this message translates to:
  /// **'Most room'**
  String get outlookSortMostRoom;

  /// No description provided for @outlookSortHighestPrice.
  ///
  /// In en, this message translates to:
  /// **'Highest price'**
  String get outlookSortHighestPrice;

  /// No description provided for @outlookSortAz.
  ///
  /// In en, this message translates to:
  /// **'A–Z'**
  String get outlookSortAz;

  /// No description provided for @outlookCropCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No crops} =1{1 crop} other{{count} crops}}'**
  String outlookCropCount(int count);

  /// No description provided for @outlookFairPriceLine.
  ///
  /// In en, this message translates to:
  /// **'Fair price: {price}'**
  String outlookFairPriceLine(String price);

  /// No description provided for @outlookHarvestWindow.
  ///
  /// In en, this message translates to:
  /// **'Harvest: {date}'**
  String outlookHarvestWindow(String date);

  /// No description provided for @outlookEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No active crop targets'**
  String get outlookEmptyTitle;

  /// No description provided for @outlookEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'National targets appear here once they are approved.'**
  String get outlookEmptyBody;

  /// No description provided for @outlookNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No crops match this search or filter'**
  String get outlookNoMatch;

  /// No description provided for @outlookNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No active target'**
  String get outlookNotFoundTitle;

  /// No description provided for @outlookNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'There is no active national target for {crop} right now.'**
  String outlookNotFoundBody(String crop);

  /// No description provided for @outlookSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all crops'**
  String get outlookSeeAll;

  /// No description provided for @outlookNumbers.
  ///
  /// In en, this message translates to:
  /// **'Quota details'**
  String get outlookNumbers;

  /// No description provided for @outlookAllowedExtent.
  ///
  /// In en, this message translates to:
  /// **'Allowed extent'**
  String get outlookAllowedExtent;

  /// No description provided for @outlookHectares.
  ///
  /// In en, this message translates to:
  /// **'{amount} ha'**
  String outlookHectares(String amount);

  /// No description provided for @outlookPriceCompare.
  ///
  /// In en, this message translates to:
  /// **'Fair price vs. wholesale price'**
  String get outlookPriceCompare;

  /// No description provided for @outlookFullNote.
  ///
  /// In en, this message translates to:
  /// **'This quota is full. Choose another crop to avoid a surplus.'**
  String get outlookFullNote;

  /// No description provided for @outlookRegisterCta.
  ///
  /// In en, this message translates to:
  /// **'Register this crop'**
  String get outlookRegisterCta;

  /// No description provided for @outlookAskBot.
  ///
  /// In en, this message translates to:
  /// **'Ask AgriBot about {crop}'**
  String outlookAskBot(String crop);

  /// No description provided for @outlookAskPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tell me about growing {crop}: the demand, the expected price and when to plant.'**
  String outlookAskPrompt(String crop);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTabAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsTabAccount;

  /// No description provided for @settingsTabNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsTabNotifications;

  /// No description provided for @settingsTabCredentials.
  ///
  /// In en, this message translates to:
  /// **'Credentials'**
  String get settingsTabCredentials;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the language of the app. It changes right away.'**
  String get settingsLanguageHint;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give feedback'**
  String get settingsFeedback;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsSignOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get settingsSignOutConfirmTitle;

  /// No description provided for @settingsSignOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to use FarmFriend.'**
  String get settingsSignOutConfirmMessage;

  /// No description provided for @settingsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settingsName;

  /// No description provided for @settingsSurname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get settingsSurname;

  /// No description provided for @settingsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get settingsEmail;

  /// No description provided for @settingsEmailLocked.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed here.'**
  String get settingsEmailLocked;

  /// No description provided for @settingsPhone.
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get settingsPhone;

  /// No description provided for @settingsType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get settingsType;

  /// No description provided for @settingsTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get settingsTypeHint;

  /// No description provided for @settingsTypeFarmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get settingsTypeFarmer;

  /// No description provided for @settingsTypeBuyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get settingsTypeBuyer;

  /// No description provided for @settingsTypeOfficer.
  ///
  /// In en, this message translates to:
  /// **'Agricultural Officer'**
  String get settingsTypeOfficer;

  /// No description provided for @settingsDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get settingsDistrict;

  /// No description provided for @settingsDistrictHint.
  ///
  /// In en, this message translates to:
  /// **'Select district'**
  String get settingsDistrictHint;

  /// No description provided for @settingsChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get settingsChangePhoto;

  /// No description provided for @settingsPhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated.'**
  String get settingsPhotoUpdated;

  /// No description provided for @settingsUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get settingsUpdateProfile;

  /// No description provided for @settingsProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get settingsProfileUpdated;

  /// No description provided for @settingsDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get settingsDangerZone;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account with your registrations, orders and posts. It cannot be undone.'**
  String get settingsDeleteAccountInfo;

  /// No description provided for @settingsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get settingsDeleteConfirmTitle;

  /// No description provided for @settingsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Type {word} to confirm.'**
  String settingsDeleteConfirmMessage(String word);

  /// No description provided for @settingsNotifyMaster.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get settingsNotifyMaster;

  /// No description provided for @settingsNotifyMasterHint.
  ///
  /// In en, this message translates to:
  /// **'Surplus warnings, order updates and replies from FarmFriend.'**
  String get settingsNotifyMasterHint;

  /// No description provided for @settingsNotifyDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'On this phone'**
  String get settingsNotifyDeviceTitle;

  /// No description provided for @settingsNotifyOrders.
  ///
  /// In en, this message translates to:
  /// **'Order updates'**
  String get settingsNotifyOrders;

  /// No description provided for @settingsNotifyOrdersHint.
  ///
  /// In en, this message translates to:
  /// **'When your order is confirmed, shipped or delivered.'**
  String get settingsNotifyOrdersHint;

  /// No description provided for @settingsNotifyCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community replies'**
  String get settingsNotifyCommunity;

  /// No description provided for @settingsNotifyCommunityHint.
  ///
  /// In en, this message translates to:
  /// **'When someone comments on your post.'**
  String get settingsNotifyCommunityHint;

  /// No description provided for @settingsNotifyNews.
  ///
  /// In en, this message translates to:
  /// **'News alerts'**
  String get settingsNotifyNews;

  /// No description provided for @settingsNotifyNewsHint.
  ///
  /// In en, this message translates to:
  /// **'Farming news, warnings and announcements.'**
  String get settingsNotifyNewsHint;

  /// No description provided for @settingsPushTitle.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get settingsPushTitle;

  /// No description provided for @settingsPushHint.
  ///
  /// In en, this message translates to:
  /// **'Let FarmFriend alert you even when the app is closed.'**
  String get settingsPushHint;

  /// No description provided for @settingsEnablePush.
  ///
  /// In en, this message translates to:
  /// **'Enable push notifications'**
  String get settingsEnablePush;

  /// No description provided for @settingsPushEnabled.
  ///
  /// In en, this message translates to:
  /// **'Push notifications are on.'**
  String get settingsPushEnabled;

  /// No description provided for @settingsPushDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked. Allow them in your phone settings.'**
  String get settingsPushDenied;

  /// No description provided for @settingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settingsChangePassword;

  /// No description provided for @settingsCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get settingsCurrentPassword;

  /// No description provided for @settingsNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get settingsNewPassword;

  /// No description provided for @settingsConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get settingsConfirmPassword;

  /// No description provided for @settingsUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get settingsUpdatePassword;

  /// No description provided for @settingsPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated.'**
  String get settingsPasswordUpdated;

  /// No description provided for @settingsGoogleAccount.
  ///
  /// In en, this message translates to:
  /// **'You signed in with Google'**
  String get settingsGoogleAccount;

  /// No description provided for @settingsGoogleAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Set a password if you also want to sign in with your email.'**
  String get settingsGoogleAccountHint;

  /// No description provided for @settingsSetPassword.
  ///
  /// In en, this message translates to:
  /// **'Set a password'**
  String get settingsSetPassword;

  /// No description provided for @settingsPasswordSet.
  ///
  /// In en, this message translates to:
  /// **'Password saved. You can now sign in with your email and password.'**
  String get settingsPasswordSet;

  /// No description provided for @settingsPhoneAccount.
  ///
  /// In en, this message translates to:
  /// **'Signed in with phone {phone}'**
  String settingsPhoneAccount(String phone);

  /// No description provided for @settingsAddEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Add email & password'**
  String get settingsAddEmailPassword;

  /// No description provided for @settingsAddEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Lets you sign in with an email address as well.'**
  String get settingsAddEmailHint;

  /// No description provided for @settingsEmailPasswordAdded.
  ///
  /// In en, this message translates to:
  /// **'Saved. Check your email to confirm the address.'**
  String get settingsEmailPasswordAdded;

  /// No description provided for @aboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Plan before you plant.'**
  String get aboutTagline;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutWebPortal.
  ///
  /// In en, this message translates to:
  /// **'Open web portal'**
  String get aboutWebPortal;

  /// No description provided for @aboutPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get aboutPrivacy;

  /// No description provided for @aboutTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get aboutTerms;

  /// No description provided for @aboutLicences.
  ///
  /// In en, this message translates to:
  /// **'Open-source licences'**
  String get aboutLicences;

  /// No description provided for @aboutCreditsTitle.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get aboutCreditsTitle;

  /// No description provided for @aboutCredits.
  ///
  /// In en, this message translates to:
  /// **'Built by the Horizon Campus research team for the farmers of Sri Lanka.'**
  String get aboutCredits;

  /// No description provided for @aboutLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get aboutLinkFailed;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get supportTitle;

  /// No description provided for @supportNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Send New Message'**
  String get supportNewTitle;

  /// No description provided for @supportNewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Admin will review your message and reply if needed.'**
  String get supportNewSubtitle;

  /// No description provided for @supportSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubject;

  /// No description provided for @supportSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'What is this about?'**
  String get supportSubjectHint;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get supportDescription;

  /// No description provided for @supportDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your problem or question'**
  String get supportDescriptionHint;

  /// No description provided for @supportSend.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get supportSend;

  /// No description provided for @supportSent.
  ///
  /// In en, this message translates to:
  /// **'Message sent. Admin will reply if needed.'**
  String get supportSent;

  /// No description provided for @supportMineTitle.
  ///
  /// In en, this message translates to:
  /// **'My Sent Messages'**
  String get supportMineTitle;

  /// No description provided for @supportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages sent yet.'**
  String get supportEmpty;

  /// No description provided for @supportAdminReplied.
  ///
  /// In en, this message translates to:
  /// **'Admin replied'**
  String get supportAdminReplied;

  /// No description provided for @supportNewReply.
  ///
  /// In en, this message translates to:
  /// **'New reply'**
  String get supportNewReply;

  /// No description provided for @supportDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Message details'**
  String get supportDetailTitle;

  /// No description provided for @supportYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get supportYourMessage;

  /// No description provided for @supportAdminReply.
  ///
  /// In en, this message translates to:
  /// **'Admin reply'**
  String get supportAdminReply;

  /// No description provided for @supportSentOn.
  ///
  /// In en, this message translates to:
  /// **'Sent {date}'**
  String supportSentOn(String date);

  /// No description provided for @supportRepliedOn.
  ///
  /// In en, this message translates to:
  /// **'Replied {date}'**
  String supportRepliedOn(String date);

  /// No description provided for @supportNoReplyYet.
  ///
  /// In en, this message translates to:
  /// **'No reply yet. Admin will review your message and reply if needed.'**
  String get supportNoReplyYet;

  /// No description provided for @supportReplyNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin replied to your message'**
  String get supportReplyNotifTitle;

  /// No description provided for @weatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherTitle;

  /// No description provided for @weatherTemp.
  ///
  /// In en, this message translates to:
  /// **'{value}°C'**
  String weatherTemp(String value);

  /// No description provided for @weatherCardUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Weather unavailable'**
  String get weatherCardUnavailable;

  /// No description provided for @weatherHumidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get weatherHumidity;

  /// No description provided for @weatherWind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get weatherWind;

  /// No description provided for @weatherWindValue.
  ///
  /// In en, this message translates to:
  /// **'{value} km/h'**
  String weatherWindValue(String value);

  /// No description provided for @weatherRainChance.
  ///
  /// In en, this message translates to:
  /// **'Rain chance'**
  String get weatherRainChance;

  /// No description provided for @weatherAdviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Field work advice'**
  String get weatherAdviceTitle;

  /// No description provided for @weatherAdviceAvoidSpraying.
  ///
  /// In en, this message translates to:
  /// **'Avoid spraying today'**
  String get weatherAdviceAvoidSpraying;

  /// No description provided for @weatherAdviceAvoidSprayingDetail.
  ///
  /// In en, this message translates to:
  /// **'Rain is likely today. Pesticide and fertiliser can wash away before they work.'**
  String get weatherAdviceAvoidSprayingDetail;

  /// No description provided for @weatherAdviceIrrigate.
  ///
  /// In en, this message translates to:
  /// **'Irrigate early morning or evening'**
  String get weatherAdviceIrrigate;

  /// No description provided for @weatherAdviceIrrigateDetail.
  ///
  /// In en, this message translates to:
  /// **'It is very hot today. Water your crops when it is cooler so less water is lost.'**
  String get weatherAdviceIrrigateDetail;

  /// No description provided for @weatherAdviceGood.
  ///
  /// In en, this message translates to:
  /// **'Good day for field work'**
  String get weatherAdviceGood;

  /// No description provided for @weatherAdviceGoodDetail.
  ///
  /// In en, this message translates to:
  /// **'No heavy rain or extreme heat is expected today.'**
  String get weatherAdviceGoodDetail;

  /// No description provided for @weatherHourlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Rain chance — next 24 hours'**
  String get weatherHourlyTitle;

  /// No description provided for @weatherHourlyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Hourly rain data is not available right now.'**
  String get weatherHourlyEmpty;

  /// No description provided for @weatherHourlyTooltip.
  ///
  /// In en, this message translates to:
  /// **'{time} · {percent}'**
  String weatherHourlyTooltip(String time, String percent);

  /// No description provided for @weatherDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'7-day forecast'**
  String get weatherDailyTitle;

  /// No description provided for @weatherDailyEmpty.
  ///
  /// In en, this message translates to:
  /// **'The 7-day forecast is not available right now.'**
  String get weatherDailyEmpty;

  /// No description provided for @weatherToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get weatherToday;

  /// No description provided for @weatherHighLow.
  ///
  /// In en, this message translates to:
  /// **'{high}° / {low}°'**
  String weatherHighLow(String high, String low);

  /// No description provided for @weatherLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Weather is shown for the district in your profile.'**
  String get weatherLocationHint;

  /// No description provided for @weatherChangeDistrict.
  ///
  /// In en, this message translates to:
  /// **'Change district'**
  String get weatherChangeDistrict;

  /// No description provided for @weatherSource.
  ///
  /// In en, this message translates to:
  /// **'Weather data by Open-Meteo.com'**
  String get weatherSource;

  /// No description provided for @weatherCondClear.
  ///
  /// In en, this message translates to:
  /// **'Clear sky'**
  String get weatherCondClear;

  /// No description provided for @weatherCondPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get weatherCondPartlyCloudy;

  /// No description provided for @weatherCondCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCondCloudy;

  /// No description provided for @weatherCondFog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get weatherCondFog;

  /// No description provided for @weatherCondDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Light rain'**
  String get weatherCondDrizzle;

  /// No description provided for @weatherCondRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get weatherCondRain;

  /// No description provided for @weatherCondShowers.
  ///
  /// In en, this message translates to:
  /// **'Rain showers'**
  String get weatherCondShowers;

  /// No description provided for @weatherCondSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get weatherCondSnow;

  /// No description provided for @weatherCondThunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get weatherCondThunderstorm;

  /// No description provided for @weatherCondUnknown.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherCondUnknown;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
