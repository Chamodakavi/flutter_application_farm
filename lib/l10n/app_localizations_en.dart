// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authWelcomeBack => 'Welcome back to FarmFriend';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignOut => 'Sign out';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authForgot => 'Forgot password?';

  @override
  String get authGoogle => 'Continue with Google';

  @override
  String get authPhone => 'Continue with phone';

  @override
  String get authNewHere => 'New here?';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authCreateTitle => 'Create your account';

  @override
  String get authFullName => 'Full name';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authAgreeTerms => 'I agree to the Terms & Privacy Policy';

  @override
  String get authAgreeRequired => 'Please accept the terms to continue.';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authSignInInstead => 'Sign in instead';

  @override
  String get authCheckEmailTitle => 'Check your email';

  @override
  String authCheckEmailBody(String email) {
    return 'We sent a confirmation link to $email. Open it to activate your account, then sign in.';
  }

  @override
  String get authOpenEmailApp => 'Open email app';

  @override
  String get authBackToLogin => 'Back to login';

  @override
  String get authForgotTitle => 'Reset your password';

  @override
  String get authForgotBody =>
      'Enter your email and we will send you a link to choose a new password.';

  @override
  String get authSendResetLink => 'Send reset link';

  @override
  String authResetSent(String email) {
    return 'If an account exists for $email, a reset link is on its way. Open it on this phone.';
  }

  @override
  String get authResetTitle => 'Choose a new password';

  @override
  String get authResetNeedsLink =>
      'Open the reset link from your email on this phone to choose a new password.';

  @override
  String get authNewPassword => 'New password';

  @override
  String get authSavePassword => 'Save password';

  @override
  String get authPasswordUpdated => 'Password updated. Sign in with your new password.';

  @override
  String get authPhoneTitle => 'Sign in with your phone';

  @override
  String get authPhoneBody => 'We will send a 6-digit code by SMS to this number.';

  @override
  String get authPhoneNumber => 'Mobile number';

  @override
  String get authSendCode => 'Send code';

  @override
  String get authOtpTitle => 'Enter the code';

  @override
  String authOtpBody(String phone) {
    return 'We sent a 6-digit code to $phone.';
  }

  @override
  String get authVerify => 'Verify';

  @override
  String authResendIn(int seconds) {
    return 'Resend code in $seconds s';
  }

  @override
  String get authResend => 'Resend code';

  @override
  String get authCodeSent => 'A new code was sent.';

  @override
  String get authChangeNumber => 'Change number';

  @override
  String get authResendLimit => 'Too many codes requested. Try again in a few minutes.';

  @override
  String get splashGettingReady => 'Getting things ready…';

  @override
  String get splashProfileError => 'We could not load your profile.';

  @override
  String get onboarding1Title => 'Plan before you plant';

  @override
  String get onboarding1Body =>
      'See how much of each crop the country needs and how much is already registered, before you decide what to grow.';

  @override
  String get onboarding2Title => 'Fair prices, less waste';

  @override
  String get onboarding2Body =>
      'Check forecast prices and the best month to harvest, so your crop sells at a fair price.';

  @override
  String get onboarding3Title => 'Market, community & AgriBot';

  @override
  String get onboarding3Body =>
      'Buy seeds and tools, share with other farmers, and ask AgriBot anything in your own language.';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get profileCompleteTitle => 'Complete your profile';

  @override
  String get profileCompleteSubtitle => 'We need a few details before you start.';

  @override
  String get profileName => 'Name';

  @override
  String get profileSurname => 'Surname';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailReadOnly => 'Email cannot be changed here.';

  @override
  String get profileTelephone => 'Telephone';

  @override
  String get profileType => 'Type';

  @override
  String get profileSelectType => 'Select type';

  @override
  String get profileDistrict => 'District';

  @override
  String get profileSelectDistrict => 'Select district';

  @override
  String get profileSaveContinue => 'Save & continue';

  @override
  String get profileTypeFarmer => 'Farmer';

  @override
  String get profileTypeBuyer => 'Buyer';

  @override
  String get profileTypeOfficer => 'Agricultural Officer';

  @override
  String get profileAddPhoto => 'Add photo';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profilePhotoGallery => 'Choose from gallery';

  @override
  String get profilePhotoCamera => 'Take a photo';

  @override
  String get maintenanceBody => 'FarmFriend is being updated. Please try again in a little while.';

  @override
  String get cartTitle => 'Shopping Cart';

  @override
  String get cartSubtitle => 'Review your cart and track your submitted orders.';

  @override
  String get cartCashOnDelivery => 'Cash on Delivery';

  @override
  String get cartAdded => 'Added to cart';

  @override
  String get cartViewCart => 'View cart';

  @override
  String get cartEmptyTitle => 'Your Cart is Empty';

  @override
  String get cartEmptyMessage =>
      'Your cart is clear. You can browse products or check your order history below.';

  @override
  String get cartStartShopping => 'Start Shopping';

  @override
  String cartUnitPrice(String price) {
    return '$price each';
  }

  @override
  String get cartRemove => 'Remove from cart';

  @override
  String cartRemoved(String name) {
    return '$name removed from cart';
  }

  @override
  String cartOnlyLeft(String count) {
    return 'Only $count left in stock. Reduce the quantity.';
  }

  @override
  String get cartLineOutOfStock => 'This product is out of stock. Remove it to continue.';

  @override
  String get cartSummaryTitle => 'Order summary';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartShipping => 'Shipping';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartPayment => 'Payment';

  @override
  String get cartEstimateNote =>
      'Estimated amounts. The final total is confirmed when you place the order.';

  @override
  String get cartFixStock => 'Some items are more than the available stock. Fix them to continue.';

  @override
  String get cartCheckout => 'Proceed to checkout';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutContactTitle => 'Delivery contact';

  @override
  String get checkoutName => 'Name';

  @override
  String get checkoutPhone => 'Phone number';

  @override
  String get checkoutPhoneHelper => 'We will call this number about your delivery.';

  @override
  String get checkoutDistrict => 'District';

  @override
  String get checkoutPaymentTitle => 'Payment method';

  @override
  String get checkoutCodHint => 'Pay in cash when your order is delivered.';

  @override
  String get checkoutSummaryTitle => 'Order summary';

  @override
  String checkoutLine(String name, String qty) {
    return '$name × $qty';
  }

  @override
  String get checkoutReviewNote =>
      'After you place the order, an admin reviews it. You can cancel it while it is pending.';

  @override
  String get checkoutPlaceOrder => 'Place order';

  @override
  String get checkoutEmptyCart => 'Your cart is empty. Add products before you check out.';

  @override
  String get checkoutFailed => 'We could not place your order. Please try again.';

  @override
  String get checkoutStockTitle => 'Not enough stock';

  @override
  String checkoutStockMessage(String name, String available) {
    return 'Only $available of \"$name\" left in stock. Reduce the quantity in your cart and try again.';
  }

  @override
  String checkoutStockNone(String name) {
    return '\"$name\" is out of stock. Remove it from your cart and try again.';
  }

  @override
  String get checkoutStockGeneric =>
      'A product in your cart does not have enough stock. Update your cart and try again.';

  @override
  String get checkoutUpdateCart => 'Update cart';

  @override
  String get orderMyOrders => 'My Orders';

  @override
  String orderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String orderItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String orderPlacedOn(String date) {
    return 'Placed on $date';
  }

  @override
  String orderTotalLine(String total) {
    return 'Total: $total';
  }

  @override
  String get orderItemsTitle => 'Items';

  @override
  String get orderItemsUnavailable => 'Item details are not available.';

  @override
  String orderItemQty(String qty, String price) {
    return 'Qty: $qty × $price';
  }

  @override
  String get orderAdminNote => 'Note from admin';

  @override
  String get orderCancel => 'Cancel Order';

  @override
  String get orderCancelConfirmTitle => 'Cancel this order?';

  @override
  String orderCancelConfirmMessage(String id) {
    return 'Order #$id will be cancelled. This cannot be undone.';
  }

  @override
  String get orderCancelConfirmYes => 'Yes, cancel order';

  @override
  String get orderCancelConfirmNo => 'Keep order';

  @override
  String get orderCancelled => 'Your order was cancelled.';

  @override
  String get orderCancelNotCancellable =>
      'This order can no longer be cancelled because it has already been processed.';

  @override
  String get orderWaitingReview => 'Your order is waiting for admin review.';

  @override
  String get orderStatusApprovedMessage => 'Your order was approved and is being prepared.';

  @override
  String get orderStatusShippedMessage => 'Your order is on its way to you.';

  @override
  String get orderStatusDeliveredMessage => 'Your order was delivered. Thank you!';

  @override
  String get orderStatusCancelledMessage => 'This order was cancelled.';

  @override
  String get orderStatusRejectedMessage =>
      'This order was not accepted. See the note from the admin or contact support.';

  @override
  String get orderStatusOtherMessage => 'The status of this order was updated.';

  @override
  String orderNotifyTitle(String id, String status) {
    return 'Order #$id: $status';
  }

  @override
  String get orderEmptyTitle => 'No orders yet';

  @override
  String get orderEmptyMessage => 'Orders you place will appear here.';

  @override
  String get orderNotFound => 'We could not find that order.';

  @override
  String get orderSuccessTitle => 'Order placed';

  @override
  String get orderSuccessHeading => 'Thank you! Your order was placed.';

  @override
  String get orderSuccessMessage => 'We received your order. You pay in cash when it is delivered.';

  @override
  String get orderSuccessNumber => 'Order number';

  @override
  String get orderViewMyOrders => 'View my orders';

  @override
  String get orderContinueShopping => 'Continue shopping';

  @override
  String get chatTitle => 'AgriBot';

  @override
  String get chatSubtitle => 'FarmFriend Assistant';

  @override
  String get chatOnline => 'Online';

  @override
  String get chatOffline => 'Offline';

  @override
  String chatLanguageTooltip(String language) {
    return 'AgriBot answers in $language. Tap to change.';
  }

  @override
  String get chatDisclaimer =>
      'AgriBot can make mistakes. Check important decisions with your agriculture officer.';

  @override
  String get chatEmptyTitle => 'How can I help you today?';

  @override
  String get chatEmptyMessage => 'Ask about crops, prices, seeds or plant diseases.';

  @override
  String get chatSuggestionCrop => 'Which crop should I plant next month?';

  @override
  String get chatSuggestionPrice => 'Price of carrot this month?';

  @override
  String get chatSuggestionSeeds => 'What seeds are in the marketplace?';

  @override
  String get chatSuggestionDisease => 'How to control leaf curl in chilli?';

  @override
  String get chatInputHint => 'Type your question…';

  @override
  String get chatSend => 'Send';

  @override
  String get chatSending => 'Sending…';

  @override
  String get chatFailedRetry => 'Not sent. Tap to retry';

  @override
  String get chatRateLimited => 'Too many questions — please wait a minute.';

  @override
  String get chatTyping => 'AgriBot is typing…';

  @override
  String get chatClear => 'Clear chat';

  @override
  String get chatClearTitle => 'Clear this chat?';

  @override
  String get chatClearMessage => 'The messages saved on this phone will be removed.';

  @override
  String get chatClearConfirm => 'Clear';

  @override
  String get chatLoadEarlier => 'Load earlier messages';

  @override
  String get chatMicHold => 'Hold to talk';

  @override
  String get chatMicListening => 'Listening… release when you finish';

  @override
  String get chatMicUnavailable => 'Voice typing is not available in this language on this phone.';

  @override
  String get chatMicFailed =>
      'Could not start the microphone. Allow microphone access and try again.';

  @override
  String get chatSpeak => 'Read aloud';

  @override
  String get chatStopSpeaking => 'Stop reading';

  @override
  String get appName => 'FarmFriend';

  @override
  String get navHome => 'Home';

  @override
  String get navMarket => 'Market';

  @override
  String get navRegister => 'Register';

  @override
  String get navCommunity => 'Community';

  @override
  String get navMore => 'More';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonOffline => 'You\'re offline. Showing saved data.';

  @override
  String get commonRequiresInternet => 'Connect to the internet to do this.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonDone => 'Done';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonViewAll => 'View all';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonOk => 'OK';

  @override
  String get commonOr => 'or';

  @override
  String get commonOptional => 'Optional';

  @override
  String get commonSelect => 'Select';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonNoResults => 'No results found';

  @override
  String get commonNothingHere => 'Nothing here yet';

  @override
  String get commonJustNow => 'Just now';

  @override
  String commonMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String commonHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String commonDaysAgo(int count) {
    return '$count d ago';
  }

  @override
  String commonUpdatedAgo(String time) {
    return 'Updated $time';
  }

  @override
  String get commonMt => 'MT';

  @override
  String recordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Records',
      one: '1 Record',
      zero: 'No records',
    );
    return '$_temp0';
  }

  @override
  String get appBarCart => 'Cart';

  @override
  String get appBarNotifications => 'Notifications';

  @override
  String get appBarProfile => 'Profile and settings';

  @override
  String get chatFabTooltip => 'Ask AgriBot';

  @override
  String get languageSwitch => 'Change language';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorNetwork => 'No internet connection. Check your network and try again.';

  @override
  String get errorPermission => 'You don\'t have permission to do this.';

  @override
  String get errorNotFound => 'We couldn\'t find what you were looking for.';

  @override
  String get errorConflict => 'This was already done or has changed. Refresh and try again.';

  @override
  String get errorRateLimited => 'Too many requests. Please wait a minute and try again.';

  @override
  String get errorValidation => 'Please check the details you entered.';

  @override
  String get errorSessionExpired => 'Your session has expired. Please sign in again.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorPageNotFound => 'This page doesn\'t exist.';

  @override
  String get errorGoHome => 'Go to Home';

  @override
  String get authInvalidCredentials => 'Invalid login credentials';

  @override
  String get authEmailNotConfirmed =>
      'Please confirm your email first. Check your inbox for the link.';

  @override
  String get authUserExists => 'This email is already registered. Sign in instead.';

  @override
  String get authWeakPassword =>
      'Password is too weak. Use at least 8 characters with a letter and a number.';

  @override
  String get authSamePassword => 'The new password must be different from the old one.';

  @override
  String get authWrongPassword => 'Your current password is incorrect.';

  @override
  String get authOtpExpired => 'Code expired, send a new one.';

  @override
  String get authOtpInvalid => 'That code is not correct. Try again.';

  @override
  String get authRateLimited => 'Too many attempts, try again later.';

  @override
  String get authGoogleFailed => 'Google sign-in failed. Please try again.';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationEmail => 'Enter a valid email address';

  @override
  String get validationPassword => 'Use at least 8 characters with a letter and a number';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get validationPhone => 'Enter a valid mobile number (7XXXXXXXX)';

  @override
  String get validationAmount => 'Enter an amount greater than 0 with up to 2 decimals';

  @override
  String validationTooLong(int max) {
    return 'Use at most $max characters';
  }

  @override
  String get statusPending => 'Pending';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusShipped => 'Shipped';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusOpen => 'Open';

  @override
  String get statusReplied => 'Replied';

  @override
  String get statusClosed => 'Closed';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get surplusLow => 'Available';

  @override
  String get surplusMedium => 'Filling up';

  @override
  String get surplusHigh => 'Almost full';

  @override
  String get surplusFull => 'Full';

  @override
  String quotaFilledOfLimit(String filled, String limit) {
    return '$filled of $limit MT registered';
  }

  @override
  String quotaRemaining(String remaining) {
    return '$remaining MT left';
  }

  @override
  String get feedbackTitle => 'How are we doing?';

  @override
  String get feedbackSubtitle => 'Your answers help the research team improve FarmFriend.';

  @override
  String get feedbackOverall => 'Overall';

  @override
  String get feedbackEase => 'Easy to use';

  @override
  String get feedbackUsefulness => 'Useful for my farming';

  @override
  String get feedbackComment => 'Anything else? (optional)';

  @override
  String get feedbackSubmit => 'Send feedback';

  @override
  String get feedbackThanks => 'Thank you for your feedback!';

  @override
  String get updateRequiredTitle => 'Update required';

  @override
  String get updateRequiredBody => 'A new version is needed to continue.';

  @override
  String get updateButton => 'Update';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get maintenanceTitle => 'We\'ll be back soon';

  @override
  String get adminBanner =>
      'You are an administrator. Manage targets, products and news in the web admin panel.';

  @override
  String get adminBannerOpen => 'Open web panel';

  @override
  String get communityWhatsOnMind => 'What\'s on your mind?';

  @override
  String get communityPhoto => 'Photo';

  @override
  String get communityActivity => 'Activity';

  @override
  String get communityPost => 'Post';

  @override
  String get communityLike => 'Like';

  @override
  String get communityComment => 'Comment';

  @override
  String get communityShare => 'Share';

  @override
  String get communityMyPosts => 'My Posts';

  @override
  String get communitySavedPosts => 'Saved Posts';

  @override
  String communityMyPostsCount(String count) {
    return 'My Posts ($count)';
  }

  @override
  String communitySavedPostsCount(String count) {
    return 'Saved Posts ($count)';
  }

  @override
  String get communityEmptyTitle => 'No posts yet';

  @override
  String get communityEmptyMessage => 'Be the first to share something with other farmers.';

  @override
  String get communityEmptyAction => 'Create a post';

  @override
  String get communityMyPostsEmptyTitle => 'You haven\'t posted yet';

  @override
  String get communityMyPostsEmptyMessage => 'Your posts will appear here.';

  @override
  String get communitySavedEmptyTitle => 'No saved posts';

  @override
  String get communitySavedEmptyMessage => 'Tap the bookmark on a post to keep it here.';

  @override
  String get communityLoadMore => 'Load more';

  @override
  String get communityLoadMoreFailed => 'Couldn\'t load more posts.';

  @override
  String get communityFarmer => 'Farmer';

  @override
  String get communitySave => 'Save post';

  @override
  String get communityUnsave => 'Remove from saved';

  @override
  String communityCommentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comments',
      one: '1 comment',
      zero: 'No comments',
    );
    return '$_temp0';
  }

  @override
  String communityLikesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count likes',
      one: '1 like',
      zero: 'No likes',
    );
    return '$_temp0';
  }

  @override
  String get communitySeeMore => 'See more';

  @override
  String get communitySeeLess => 'See less';

  @override
  String get communityMoreOptions => 'More options';

  @override
  String get communityReport => 'Report';

  @override
  String communityReportSubject(String id) {
    return 'Report post #$id';
  }

  @override
  String get communityDeleteTitle => 'Delete this post?';

  @override
  String get communityDeleteMessage => 'This can\'t be undone.';

  @override
  String get communityPostDeleted => 'Post deleted';

  @override
  String get communityViewPhoto => 'View photo';

  @override
  String get communityActivityChoose => 'What are you doing?';

  @override
  String get communityActivityNone => 'No activity';

  @override
  String get communityActivityPlanting => 'Planting';

  @override
  String get communityActivityHarvesting => 'Harvesting';

  @override
  String get communityActivitySelling => 'Selling';

  @override
  String get communityActivityQuestion => 'Question';

  @override
  String get postCreateTitle => 'Create Post';

  @override
  String get postEditTitle => 'Edit Post';

  @override
  String get postDetailTitle => 'Post';

  @override
  String get postGallery => 'Gallery';

  @override
  String get postCamera => 'Camera';

  @override
  String get postRemovePhoto => 'Remove photo';

  @override
  String get postPhotoFailed =>
      'Couldn\'t open the photo. Check the app\'s permissions and try again.';

  @override
  String get postPublished => 'Your post is live';

  @override
  String get postUpdated => 'Post updated';

  @override
  String get postEditPhotoNote => 'Only the text can be changed. The photo stays the same.';

  @override
  String get postNotYours => 'You can only edit your own posts.';

  @override
  String get postComments => 'Comments';

  @override
  String get postNoComments => 'No comments yet';

  @override
  String get postNoCommentsMessage => 'Be the first to comment.';

  @override
  String get postCommentHint => 'Write a comment…';

  @override
  String get postCommentSend => 'Send comment';

  @override
  String get postCommentSending => 'Sending…';

  @override
  String get postCommentDeleteTitle => 'Delete this comment?';

  @override
  String get postCommentDeleted => 'Comment deleted';

  @override
  String get postCommentsLoadMore => 'Load more comments';

  @override
  String get postCommentHoldToDelete => 'Press and hold to delete';

  @override
  String get homePill => 'Smart Farming Dashboard';

  @override
  String homeWelcome(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get homeFarmerFallback => 'Farmer';

  @override
  String get homeHeroText =>
      'Track your crop registrations, explore marketplace products, read farming updates, and get help from the AI assistant.';

  @override
  String get homeRegisterCrop => 'Register Crop';

  @override
  String get homeMarketplace => 'Marketplace';

  @override
  String get homeMyCrops => 'My Registered Crops';

  @override
  String homeTotalMt(String amount) {
    return 'Total: $amount MT';
  }

  @override
  String get homeMarketItems => 'Marketplace Items';

  @override
  String get homeProductsAvailable => 'Products available now';

  @override
  String get homeFarmingNews => 'Farming News';

  @override
  String get homeLatestUpdates => 'Latest updates and alerts';

  @override
  String get homeCropOutlook => 'Crop Outlook';

  @override
  String get homeCropOutlookSubtitle => 'How full the national quota is for each crop';

  @override
  String homePercentFull(int percent) {
    return '$percent% full';
  }

  @override
  String get homeOutlookEmpty => 'No active crop targets right now.';

  @override
  String get homePriceOutlook => 'Price outlook';

  @override
  String get homePriceOutlookSubtitle => 'Biggest wholesale price changes this month';

  @override
  String get homePricesEmpty => 'Price forecasts are not available yet.';

  @override
  String get homeQuickActions => 'Quick Actions';

  @override
  String get homeActionRegister => 'Register Harvest';

  @override
  String get homeActionRegisterSub => 'Add expected crop amount';

  @override
  String get homeActionPlan => 'Plan Profit';

  @override
  String get homeActionPlanSub => 'See income before you plant';

  @override
  String get homeActionBrowse => 'Browse Products';

  @override
  String get homeActionBrowseSub => 'Buy seeds and farm tools';

  @override
  String get homeActionAsk => 'Ask Assistant';

  @override
  String get homeActionAskSub => 'Get help from AgriBot';

  @override
  String get homeMyRegistrations => 'My Crop Registrations';

  @override
  String homeMtRegistered(String amount) {
    return '$amount MT registered';
  }

  @override
  String get homeRegisterLink => 'Register';

  @override
  String get homeNoRegistrations => 'No crops registered yet';

  @override
  String get homeNoRegistrationsBody => 'Register your expected harvest to lock in your quota.';

  @override
  String get homeLatestNews => 'Latest Farming News';

  @override
  String get homeNoNews => 'No news yet.';

  @override
  String get homeUpdateBody => 'A newer version of FarmFriend is available.';

  @override
  String get marketTitle => 'Marketplace';

  @override
  String get marketSubtitle => 'Browse agricultural tools, seeds, and equipment for your farm.';

  @override
  String get marketSearchHint => 'Search products';

  @override
  String get marketSearchClear => 'Clear search';

  @override
  String get marketCategoryAll => 'All';

  @override
  String get marketCategorySeeds => 'Seeds';

  @override
  String get marketCategoryTools => 'Tools';

  @override
  String get marketEmptyTitle => 'No products yet';

  @override
  String get marketEmptyMessage => 'There is nothing to show here right now. Pull down to refresh.';

  @override
  String marketEmptySearch(String query) {
    return 'Nothing matches \"$query\". Try another word.';
  }

  @override
  String get marketShowAll => 'Show all products';

  @override
  String productInStock(String count) {
    return 'In Stock: $count';
  }

  @override
  String get productOutOfStock => 'Out of stock';

  @override
  String get productAdd => 'Add';

  @override
  String get productDetailTitle => 'Product details';

  @override
  String productWeight(String weight) {
    return 'Weight: $weight';
  }

  @override
  String get productDescription => 'Description';

  @override
  String get productReadMore => 'Read more';

  @override
  String get productShowLess => 'Show less';

  @override
  String get productQuantity => 'Quantity';

  @override
  String get productOutOfStockNote =>
      'This product is out of stock right now. Please check again later.';

  @override
  String get productAddToCart => 'Add to cart';

  @override
  String get productBuyNow => 'Buy now';

  @override
  String get moreProfileHint => 'View and edit your profile';

  @override
  String get moreProfileNoName => 'Your profile';

  @override
  String get moreGroupFarming => 'Farming tools';

  @override
  String get moreGroupActivity => 'My activity';

  @override
  String get moreGroupApp => 'App';

  @override
  String get moreNews => 'News';

  @override
  String get morePrices => 'Crop Prices';

  @override
  String get morePlanner => 'Profit Planner';

  @override
  String get moreOutlook => 'Crop Outlook';

  @override
  String get moreOrders => 'My Orders';

  @override
  String get moreQuotas => 'My Quotas';

  @override
  String get moreSupport => 'Contact Support';

  @override
  String get moreNotifications => 'Notifications';

  @override
  String get newsTitle => 'Latest News';

  @override
  String get newsSubtitle => 'Farming news and alerts';

  @override
  String get newsDetailTitle => 'News';

  @override
  String get newsReadMore => 'Read More';

  @override
  String get newsFilterAll => 'All';

  @override
  String get newsTypeTechnology => 'Technology';

  @override
  String get newsTypeAlert => 'Alert';

  @override
  String get newsTypeGeneral => 'General';

  @override
  String get newsTypeDisease => 'Disease';

  @override
  String get newsTypeMarket => 'Market';

  @override
  String get newsEmptyTitle => 'No news yet';

  @override
  String get newsEmptyMessage => 'New articles and alerts will appear here.';

  @override
  String get newsLoadMore => 'Load more';

  @override
  String get newsLoadMoreFailed => 'Couldn\'t load more news.';

  @override
  String newsByAuthor(String author) {
    return 'By $author';
  }

  @override
  String get newsShare => 'Share';

  @override
  String get notifEmptyTitle => 'No notifications yet';

  @override
  String get notifEmptyMessage => 'Alerts and announcements will appear here.';

  @override
  String get notifMarkAllRead => 'Mark all read';

  @override
  String notifUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread',
      one: '1 unread',
    );
    return '$_temp0';
  }

  @override
  String get notifNewTitle => 'New notification';

  @override
  String get notifUnread => 'Unread';

  @override
  String get pricesTitle => 'Crop Prices';

  @override
  String pricesSubtitle(String date) {
    return 'Wholesale forecast · updated $date';
  }

  @override
  String get pricesSubtitleNoDate => 'Wholesale forecast';

  @override
  String get pricesSearchHint => 'Search crops';

  @override
  String get pricesSortAz => 'A–Z';

  @override
  String get pricesSortRise => 'Biggest rise';

  @override
  String get pricesSortFall => 'Biggest fall';

  @override
  String get pricesSortMargin => 'Best margin';

  @override
  String get pricesAboveFair => 'Above fair price';

  @override
  String get pricesBelowFair => 'Below fair price';

  @override
  String get pricesForecastPending => 'Forecast pending';

  @override
  String get pricesStale => 'Forecast may be outdated';

  @override
  String get pricesFooterNote =>
      'Forecasts are estimates from historical prices, weather and fuel costs. Actual market prices can differ.';

  @override
  String get pricesEmptyTitle => 'No prices yet';

  @override
  String get pricesEmptyBody => 'Price forecasts appear here after the monthly forecast has run.';

  @override
  String pricesChangeUp(String percent) {
    return 'Up $percent from last month';
  }

  @override
  String pricesChangeDown(String percent) {
    return 'Down $percent from last month';
  }

  @override
  String get pricesChangeFlat => 'No change from last month';

  @override
  String get pricesThisMonth => 'This month\'s wholesale price';

  @override
  String pricesLatestActual(String month) {
    return 'Latest market price ($month)';
  }

  @override
  String get pricesVsLastMonth => 'vs. last month';

  @override
  String pricesRetail(String price) {
    return 'Estimated retail $price';
  }

  @override
  String get pricesTrendTitle => 'Price trend';

  @override
  String get pricesTrendSubtitle => 'Past 24 months and the next 12 months';

  @override
  String get pricesLegendActual => 'Actual';

  @override
  String get pricesLegendForecast => 'Forecast';

  @override
  String get pricesLegendBand => 'Floor to fair price';

  @override
  String get pricesToday => 'Today';

  @override
  String get pricesChartEmpty => 'Not enough price data to draw a chart yet.';

  @override
  String get pricesBestMonthTitle => 'Best month to harvest';

  @override
  String pricesBestMonthProfit(String profit) {
    return 'Profit $profit';
  }

  @override
  String pricesPlantToHarvest(String plant, String harvest) {
    return 'Plant in $plant to harvest in $harvest';
  }

  @override
  String get pricesRegisterCrop => 'Register this crop';

  @override
  String get pricesPlanProfit => 'Plan my profit';

  @override
  String get pricesCostTitle => 'Costs and fair price';

  @override
  String get pricesCostPerKg => 'Cost to grow';

  @override
  String get pricesFairPrice => 'Fair price (cost + 40%)';

  @override
  String get pricesProfitPerKg => 'Profit per kg';

  @override
  String get pricesFloorPrice => 'Minimum floor price';

  @override
  String get pricesQuotaTitle => 'National quota';

  @override
  String get pricesQuotaOpen => 'See crop outlook';

  @override
  String get pricesWhyTitle => 'Why this price?';

  @override
  String get pricesWhyIntro => 'What the forecast model used for this month:';

  @override
  String get pricesWhyRainfall => 'Rainfall used';

  @override
  String pricesWhyRainfallValue(String mm) {
    return '$mm mm';
  }

  @override
  String get pricesWhyWeather => 'Weather shock';

  @override
  String get pricesWhyWeatherApplied => 'Applied';

  @override
  String get pricesWhyWeatherNone => 'Not applied';

  @override
  String get pricesWhyDiesel => 'Diesel price (per litre)';

  @override
  String get pricesWhyTransport => 'Transport index';

  @override
  String get pricesWhyCycle => 'Growth cycle';

  @override
  String pricesWhyCycleValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String get pricesWhyModel => 'Model version';

  @override
  String get pricesWhyGenerated => 'Forecast made on';

  @override
  String get pricesAskBot => 'Ask AgriBot';

  @override
  String pricesAskPrompt(String crop, String month) {
    return 'What will $crop sell for in $month?';
  }

  @override
  String get pricesNotFoundTitle => 'No prices for this crop';

  @override
  String pricesNotFoundBody(String crop) {
    return 'There is no price history or forecast for $crop yet.';
  }

  @override
  String get plannerTitle => 'Profit Planner';

  @override
  String get plannerSubtitle => 'If I plant this much, what do I get?';

  @override
  String get plannerCrop => 'Crop';

  @override
  String get plannerCropHint => 'Select a crop';

  @override
  String get plannerMonth => 'Harvest month';

  @override
  String get plannerBestMonthHint => '⭐ Best month to harvest';

  @override
  String get plannerLand => 'Land size';

  @override
  String get plannerLandHint => 'e.g. 1';

  @override
  String get plannerAcres => 'Acres';

  @override
  String get plannerHectares => 'Hectares';

  @override
  String plannerLandInHa(String ha) {
    return '= $ha hectares';
  }

  @override
  String get plannerPickCrop => 'Choose a crop to start your plan.';

  @override
  String get plannerEnterLand => 'Enter your land size to see the plan.';

  @override
  String get plannerResultTitle => 'Your plan';

  @override
  String get plannerNoYield =>
      'The model has no yield figure for this crop and month, so the harvest cannot be estimated.';

  @override
  String get plannerPlantIn => 'Plant in';

  @override
  String get plannerExpectedHarvest => 'Expected harvest';

  @override
  String get plannerCost => 'Production cost';

  @override
  String get plannerIncome => 'Expected income at forecast wholesale price';

  @override
  String get plannerProfit => 'Expected profit';

  @override
  String get plannerLoss => 'Expected loss';

  @override
  String get plannerBreakEven => 'Break-even price';

  @override
  String plannerQuotaFits(String remaining, String amount) {
    return '$remaining MT left — your $amount MT fits ✅';
  }

  @override
  String plannerQuotaExceeds(String remaining, String amount) {
    return '$remaining MT left — your $amount MT exceeds the remaining quota ⚠️';
  }

  @override
  String get plannerSeeAlternatives => 'See crops with room';

  @override
  String get plannerCompareTitle => 'Compare crops';

  @override
  String get plannerCompareSubtitle => 'Same land and harvest month, up to 3 more crops';

  @override
  String get plannerCompareAdd => 'Add a crop to compare';

  @override
  String plannerCompareRemove(String crop) {
    return 'Remove $crop';
  }

  @override
  String get plannerCompareBest => 'Highest profit';

  @override
  String get plannerCompareNoData => '— means there is no forecast for that crop in this month.';

  @override
  String get plannerShortHarvest => 'Harvest';

  @override
  String get plannerShortCost => 'Cost';

  @override
  String get plannerShortIncome => 'Income';

  @override
  String get plannerShortProfit => 'Profit';

  @override
  String plannerRegisterCta(String amount, String crop) {
    return 'Register $amount MT of $crop';
  }

  @override
  String get plannerDisclaimer =>
      'These are estimates from the forecast model. Real harvests, costs and market prices can differ.';

  @override
  String get plannerNoForecastTitle => 'No forecasts yet';

  @override
  String get plannerNoForecastBody =>
      'The planner needs price forecasts. Connect to the internet and pull down to refresh.';

  @override
  String get registerTitle => 'Register Harvest Quota';

  @override
  String get registerAuthBadge => 'Farmer Authenticated';

  @override
  String get registerInfo => 'Register your crops to secure price.';

  @override
  String get registerSelectCrop => 'Select Crop';

  @override
  String get registerSelectCropHint => 'Tap to choose a crop';

  @override
  String get registerCropRequired => 'Please select a crop';

  @override
  String get registerSearchCrop => 'Search crops';

  @override
  String get registerNoTargets =>
      'There are no active crop targets right now. Please check again later.';

  @override
  String registerNoActiveTarget(String crop) {
    return 'There is no active national target for $crop right now.';
  }

  @override
  String get registerLimit => 'National limit';

  @override
  String get registerFilled => 'Registered so far';

  @override
  String get registerRemaining => 'Remaining';

  @override
  String get registerFairPrice => 'Fair price';

  @override
  String get registerWholesale => 'Est. wholesale price';

  @override
  String get registerPlantingDate => 'Planting date';

  @override
  String get registerHarvestDate => 'Target harvest date';

  @override
  String registerFarmerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count farmers registered',
      one: '1 farmer registered',
      zero: 'No farmers registered yet',
    );
    return '$_temp0';
  }

  @override
  String registerForecastTitle(String month) {
    return 'Model forecast for $month';
  }

  @override
  String get registerForecastWholesale => 'Wholesale price';

  @override
  String get registerForecastProfit => 'Profit per kg';

  @override
  String get registerSeeTrend => 'See price trend';

  @override
  String get registerAmountLabel => 'Expected Harvest Amount (MT)';

  @override
  String get registerAmountHint => 'e.g. 100';

  @override
  String registerAmountHelper(String remaining) {
    return 'Remaining capacity: $remaining MT';
  }

  @override
  String registerAmountMax(String max) {
    return 'The amount cannot be more than $max MT';
  }

  @override
  String get registerInvalidAmount => 'This amount was not accepted. Check it and try again.';

  @override
  String get registerDontKnow => 'Don\'t know the tonnage?';

  @override
  String get registerCheckAndRegister => 'Check & Register';

  @override
  String get registerSuccessTitle => 'Quota registered';

  @override
  String registerSuccessBody(String amount, String crop) {
    return 'Registered $amount MT of $crop. Your quota is locked.';
  }

  @override
  String get registerViewQuotas => 'View my quotas';

  @override
  String get registerNoTarget => 'No active national target for this crop. Contact admin.';

  @override
  String get registerContactSupport => 'Contact support';

  @override
  String get registerUnknownResult =>
      'We could not confirm this registration. Check My Registered Quotas below, or update the app and try again.';

  @override
  String registerCropChanged(String crop) {
    return 'Crop changed to $crop. Tap Check & Register to continue.';
  }

  @override
  String registerSurplusTitle(String crop) {
    return 'Quota exceeded for $crop';
  }

  @override
  String registerSurplusBody(String remaining) {
    return 'Only $remaining MT left. Registering more would cause a surplus and lower prices.';
  }

  @override
  String get registerSurplusBodyFull =>
      'This quota is full. Registering more would cause a surplus and lower prices.';

  @override
  String registerSurplusRequested(String amount) {
    return 'You asked to register $amount MT.';
  }

  @override
  String get registerSurplusConfirming => 'Confirming with the server…';

  @override
  String get registerSurplusAlternatives => 'Alternative crops';

  @override
  String get registerSurplusNoAlternatives => 'No other crop has room right now.';

  @override
  String registerAltWhy(String remaining, String price) {
    return '$remaining MT of room · Fair price $price';
  }

  @override
  String registerAltWhyNoPrice(String remaining) {
    return '$remaining MT of room';
  }

  @override
  String get registerAltChoose => 'Choose';

  @override
  String registerRemainingCta(String remaining) {
    return 'Register remaining $remaining MT';
  }

  @override
  String get registerLandTitle => 'Estimate from land size';

  @override
  String registerLandBody(String crop, String month) {
    return 'Uses the model\'s yield for $crop harvested in $month.';
  }

  @override
  String get registerLandSize => 'Land size';

  @override
  String get registerLandEstimate => 'Estimated harvest';

  @override
  String registerLandYield(String tonnes) {
    return 'Model yield: $tonnes MT per hectare';
  }

  @override
  String registerLandUse(String amount) {
    return 'Use $amount MT';
  }

  @override
  String get registerLandUseDisabled => 'Enter your land size';

  @override
  String get quotasTitle => 'My Registered Quotas';

  @override
  String get quotasSubtitle => 'Your locked-in harvest quotas';

  @override
  String get quotasColCrop => 'Crop Name';

  @override
  String get quotasColAmount => 'Amount (MT)';

  @override
  String get quotasColDate => 'Date';

  @override
  String get quotasLockedNote => 'These quotas are locked in. Contact admin to modify records.';

  @override
  String get quotasRequestChange => 'Request a change';

  @override
  String get quotasChangeSubject => 'Quota change request';

  @override
  String get quotasEmptyTitle => 'No quotas registered yet';

  @override
  String get quotasEmptyBody =>
      'Register your expected harvest to lock in a quota and a fair price.';

  @override
  String get quotasEmptyAction => 'Register a crop';

  @override
  String get quotasTotal => 'Total registered';

  @override
  String quotasCropCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crops',
      one: '1 crop',
    );
    return '$_temp0';
  }

  @override
  String get outlookTitle => 'Crop Outlook';

  @override
  String get outlookSubtitle => 'National demand vs. registered supply';

  @override
  String get outlookSearchHint => 'Search crops';

  @override
  String get outlookFilterAll => 'All';

  @override
  String get outlookFilterAvailable => 'Available';

  @override
  String get outlookFilterAlmostFull => 'Almost full';

  @override
  String get outlookFilterFull => 'Full';

  @override
  String get outlookSortLabel => 'Sort';

  @override
  String get outlookSortMostRoom => 'Most room';

  @override
  String get outlookSortHighestPrice => 'Highest price';

  @override
  String get outlookSortAz => 'A–Z';

  @override
  String outlookCropCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crops',
      one: '1 crop',
      zero: 'No crops',
    );
    return '$_temp0';
  }

  @override
  String outlookFairPriceLine(String price) {
    return 'Fair price: $price';
  }

  @override
  String outlookHarvestWindow(String date) {
    return 'Harvest: $date';
  }

  @override
  String get outlookEmptyTitle => 'No active crop targets';

  @override
  String get outlookEmptyBody => 'National targets appear here once they are approved.';

  @override
  String get outlookNoMatch => 'No crops match this search or filter';

  @override
  String get outlookNotFoundTitle => 'No active target';

  @override
  String outlookNotFoundBody(String crop) {
    return 'There is no active national target for $crop right now.';
  }

  @override
  String get outlookSeeAll => 'See all crops';

  @override
  String get outlookNumbers => 'Quota details';

  @override
  String get outlookAllowedExtent => 'Allowed extent';

  @override
  String outlookHectares(String amount) {
    return '$amount ha';
  }

  @override
  String get outlookPriceCompare => 'Fair price vs. wholesale price';

  @override
  String get outlookFullNote => 'This quota is full. Choose another crop to avoid a surplus.';

  @override
  String get outlookRegisterCta => 'Register this crop';

  @override
  String outlookAskBot(String crop) {
    return 'Ask AgriBot about $crop';
  }

  @override
  String outlookAskPrompt(String crop) {
    return 'Tell me about growing $crop: the demand, the expected price and when to plant.';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTabAccount => 'Account';

  @override
  String get settingsTabNotifications => 'Notifications';

  @override
  String get settingsTabCredentials => 'Credentials';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageHint => 'Choose the language of the app. It changes right away.';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsFeedback => 'Give feedback';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsSignOutConfirmTitle => 'Sign out?';

  @override
  String get settingsSignOutConfirmMessage => 'You will need to sign in again to use FarmFriend.';

  @override
  String get settingsName => 'Name';

  @override
  String get settingsSurname => 'Surname';

  @override
  String get settingsEmail => 'Email';

  @override
  String get settingsEmailLocked => 'Email cannot be changed here.';

  @override
  String get settingsPhone => 'Telephone';

  @override
  String get settingsType => 'Type';

  @override
  String get settingsTypeHint => 'Select type';

  @override
  String get settingsTypeFarmer => 'Farmer';

  @override
  String get settingsTypeBuyer => 'Buyer';

  @override
  String get settingsTypeOfficer => 'Agricultural Officer';

  @override
  String get settingsDistrict => 'District';

  @override
  String get settingsDistrictHint => 'Select district';

  @override
  String get settingsChangePhoto => 'Change photo';

  @override
  String get settingsPhotoUpdated => 'Profile photo updated.';

  @override
  String get settingsUpdateProfile => 'Update Profile';

  @override
  String get settingsProfileUpdated => 'Profile updated.';

  @override
  String get settingsDangerZone => 'Danger zone';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountInfo =>
      'This permanently deletes your account with your registrations, orders and posts. It cannot be undone.';

  @override
  String get settingsDeleteConfirmTitle => 'Delete your account?';

  @override
  String settingsDeleteConfirmMessage(String word) {
    return 'This cannot be undone. Type $word to confirm.';
  }

  @override
  String get settingsNotifyMaster => 'Allow notifications';

  @override
  String get settingsNotifyMasterHint =>
      'Surplus warnings, order updates and replies from FarmFriend.';

  @override
  String get settingsNotifyDeviceTitle => 'On this phone';

  @override
  String get settingsNotifyOrders => 'Order updates';

  @override
  String get settingsNotifyOrdersHint => 'When your order is confirmed, shipped or delivered.';

  @override
  String get settingsNotifyCommunity => 'Community replies';

  @override
  String get settingsNotifyCommunityHint => 'When someone comments on your post.';

  @override
  String get settingsNotifyNews => 'News alerts';

  @override
  String get settingsNotifyNewsHint => 'Farming news, warnings and announcements.';

  @override
  String get settingsPushTitle => 'Push notifications';

  @override
  String get settingsPushHint => 'Let FarmFriend alert you even when the app is closed.';

  @override
  String get settingsEnablePush => 'Enable push notifications';

  @override
  String get settingsPushEnabled => 'Push notifications are on.';

  @override
  String get settingsPushDenied => 'Notifications are blocked. Allow them in your phone settings.';

  @override
  String get settingsChangePassword => 'Change password';

  @override
  String get settingsCurrentPassword => 'Current password';

  @override
  String get settingsNewPassword => 'New password';

  @override
  String get settingsConfirmPassword => 'Confirm new password';

  @override
  String get settingsUpdatePassword => 'Update password';

  @override
  String get settingsPasswordUpdated => 'Password updated.';

  @override
  String get settingsGoogleAccount => 'You signed in with Google';

  @override
  String get settingsGoogleAccountHint =>
      'Set a password if you also want to sign in with your email.';

  @override
  String get settingsSetPassword => 'Set a password';

  @override
  String get settingsPasswordSet =>
      'Password saved. You can now sign in with your email and password.';

  @override
  String settingsPhoneAccount(String phone) {
    return 'Signed in with phone $phone';
  }

  @override
  String get settingsAddEmailPassword => 'Add email & password';

  @override
  String get settingsAddEmailHint => 'Optional. Lets you sign in with an email address as well.';

  @override
  String get settingsEmailPasswordAdded => 'Saved. Check your email to confirm the address.';

  @override
  String get aboutTagline => 'Plan before you plant.';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutWebPortal => 'Open web portal';

  @override
  String get aboutPrivacy => 'Privacy policy';

  @override
  String get aboutTerms => 'Terms of use';

  @override
  String get aboutLicences => 'Open-source licences';

  @override
  String get aboutCreditsTitle => 'Credits';

  @override
  String get aboutCredits =>
      'Built by the Horizon Campus research team for the farmers of Sri Lanka.';

  @override
  String get aboutLinkFailed => 'Could not open the link.';

  @override
  String get supportTitle => 'Contact Support';

  @override
  String get supportNewTitle => 'Send New Message';

  @override
  String get supportNewSubtitle => 'Admin will review your message and reply if needed.';

  @override
  String get supportSubject => 'Subject';

  @override
  String get supportSubjectHint => 'What is this about?';

  @override
  String get supportDescription => 'Description';

  @override
  String get supportDescriptionHint => 'Describe your problem or question';

  @override
  String get supportSend => 'Send Message';

  @override
  String get supportSent => 'Message sent. Admin will reply if needed.';

  @override
  String get supportMineTitle => 'My Sent Messages';

  @override
  String get supportEmpty => 'No messages sent yet.';

  @override
  String get supportAdminReplied => 'Admin replied';

  @override
  String get supportNewReply => 'New reply';

  @override
  String get supportDetailTitle => 'Message details';

  @override
  String get supportYourMessage => 'Your message';

  @override
  String get supportAdminReply => 'Admin reply';

  @override
  String supportSentOn(String date) {
    return 'Sent $date';
  }

  @override
  String supportRepliedOn(String date) {
    return 'Replied $date';
  }

  @override
  String get supportNoReplyYet =>
      'No reply yet. Admin will review your message and reply if needed.';

  @override
  String get supportReplyNotifTitle => 'Admin replied to your message';

  @override
  String get weatherTitle => 'Weather';

  @override
  String weatherTemp(String value) {
    return '$value°C';
  }

  @override
  String get weatherCardUnavailable => 'Weather unavailable';

  @override
  String get weatherHumidity => 'Humidity';

  @override
  String get weatherWind => 'Wind';

  @override
  String weatherWindValue(String value) {
    return '$value km/h';
  }

  @override
  String get weatherRainChance => 'Rain chance';

  @override
  String get weatherAdviceTitle => 'Field work advice';

  @override
  String get weatherAdviceAvoidSpraying => 'Avoid spraying today';

  @override
  String get weatherAdviceAvoidSprayingDetail =>
      'Rain is likely today. Pesticide and fertiliser can wash away before they work.';

  @override
  String get weatherAdviceIrrigate => 'Irrigate early morning or evening';

  @override
  String get weatherAdviceIrrigateDetail =>
      'It is very hot today. Water your crops when it is cooler so less water is lost.';

  @override
  String get weatherAdviceGood => 'Good day for field work';

  @override
  String get weatherAdviceGoodDetail => 'No heavy rain or extreme heat is expected today.';

  @override
  String get weatherHourlyTitle => 'Rain chance — next 24 hours';

  @override
  String get weatherHourlyEmpty => 'Hourly rain data is not available right now.';

  @override
  String weatherHourlyTooltip(String time, String percent) {
    return '$time · $percent';
  }

  @override
  String get weatherDailyTitle => '7-day forecast';

  @override
  String get weatherDailyEmpty => 'The 7-day forecast is not available right now.';

  @override
  String get weatherToday => 'Today';

  @override
  String weatherHighLow(String high, String low) {
    return '$high° / $low°';
  }

  @override
  String get weatherLocationHint => 'Weather is shown for the district in your profile.';

  @override
  String get weatherChangeDistrict => 'Change district';

  @override
  String get weatherSource => 'Weather data by Open-Meteo.com';

  @override
  String get weatherCondClear => 'Clear sky';

  @override
  String get weatherCondPartlyCloudy => 'Partly cloudy';

  @override
  String get weatherCondCloudy => 'Cloudy';

  @override
  String get weatherCondFog => 'Fog';

  @override
  String get weatherCondDrizzle => 'Light rain';

  @override
  String get weatherCondRain => 'Rain';

  @override
  String get weatherCondShowers => 'Rain showers';

  @override
  String get weatherCondSnow => 'Snow';

  @override
  String get weatherCondThunderstorm => 'Thunderstorm';

  @override
  String get weatherCondUnknown => 'Weather';
}
