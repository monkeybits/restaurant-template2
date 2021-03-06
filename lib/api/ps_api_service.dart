import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterrestaurant/api/common/ps_status.dart';
import 'package:flutterrestaurant/viewobject/about_app.dart';
import 'package:flutterrestaurant/viewobject/reservation.dart';
import 'package:flutterrestaurant/viewobject/shipping_area.dart';
import 'package:flutterrestaurant/config/ps_config.dart';
import 'package:flutterrestaurant/api/ps_url.dart';
import 'package:flutterrestaurant/viewobject/api_status.dart';
import 'package:flutterrestaurant/viewobject/blog.dart';
import 'package:flutterrestaurant/viewobject/category.dart';
import 'package:flutterrestaurant/viewobject/comment_detail.dart';
import 'package:flutterrestaurant/viewobject/comment_header.dart';
import 'package:flutterrestaurant/viewobject/coupon_discount.dart';
import 'package:flutterrestaurant/viewobject/default_photo.dart';
import 'package:flutterrestaurant/viewobject/download_product.dart';
import 'package:flutterrestaurant/viewobject/noti.dart';
import 'package:flutterrestaurant/viewobject/product.dart';
import 'package:flutterrestaurant/viewobject/product_collection_header.dart';
import 'package:flutterrestaurant/viewobject/ps_app_info.dart';
import 'package:flutterrestaurant/viewobject/rating.dart';
import 'package:flutterrestaurant/viewobject/shop_info.dart';
import 'package:flutterrestaurant/viewobject/sub_category.dart';
import 'package:flutterrestaurant/viewobject/transaction_detail.dart';
import 'package:flutterrestaurant/viewobject/transaction_header.dart';
import 'package:flutterrestaurant/viewobject/transaction_status.dart';
import 'package:flutterrestaurant/viewobject/user.dart';
import 'common/ps_api.dart';
import 'common/ps_resource.dart';

class PsApiService extends PsApi {
  ///
  /// App Info
  ///
  Future<PsResource<PSAppInfo>> postPsAppInfo(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_app_info_url}';
    return await postData<PSAppInfo, PSAppInfo>(PSAppInfo(), url, jsonMap);
  }

  ///
  /// Apple Login
  ///
  Future<PsResource<User>> postAppleLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_apple_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Register
  ///
  Future<PsResource<User>> postUserRegister(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_register_url}';
    CollectionReference users = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('users');
    jsonMap['status'] = '1';
    jsonMap['is_banned'] = '0';
    var document = await users.doc(jsonMap['user_id']).set(jsonMap);
    return await postData2<User, User>(User(), null, jsonMap);
  }

  ///
  /// User Verify Email
  ///
  Future<PsResource<User>> postUserEmailVerify(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_email_verify_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Login
  ///
  Future<PsResource<User>> postUserLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_login_url}';
    CollectionReference users = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('users');
    var document = await users.doc(jsonMap['user_password']).get();
    return await postData2<User, User>(User(), null, jsonMap);
  }

  ///
  /// FB Login
  ///
  Future<PsResource<User>> postFBLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_fb_login_url}';
        CollectionReference users = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('users');
    try {
      jsonMap['user_profile_photo'] = jsonMap['profile_photo_url'];
      jsonMap['added_date'] = '';
      jsonMap['user_phone'] = '';
      var document = await users.doc(jsonMap['facebook_id']).set(jsonMap);
    } catch (e) {
      var document = await users.doc(jsonMap['facebook_id']).get();
    }
    return await postData2<User, User>(User(), null, jsonMap);
  }

  ///
  /// Google Login
  ///
  Future<PsResource<User>> postGoogleLogin(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_google_login_url}';
    CollectionReference users = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('users');
    try {
      jsonMap['user_profile_photo'] = jsonMap['profile_photo_url'];
      jsonMap['added_date'] = '';
      jsonMap['user_phone'] = '';
      var document = await users.doc(jsonMap['google_id']).set(jsonMap);
    } catch (e) {
      var document = await users.doc(jsonMap['google_id']).get();
    }
    return await postData2<User, User>(User(), null, jsonMap);
  }

  ///
  /// User Forgot Password
  ///
  Future<PsResource<ApiStatus>> postForgotPassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_forgot_password_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// User Change Password
  ///
  Future<PsResource<ApiStatus>> postChangePassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_change_password_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// User Profile Update
  ///
  Future<PsResource<User>> postProfileUpdate(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_update_profile_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Phone Login
  ///
  Future<PsResource<User>> postPhoneLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_phone_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Resend Code
  ///
  Future<PsResource<ApiStatus>> postResendCode(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_resend_code_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Touch Count
  ///
  Future<PsResource<ApiStatus>> postTouchCount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_touch_count_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Get User
  ///
  Future<PsResource<List<User>>> getUser(String userId) async {
    final String url =
        '${PsUrl.ps_user_url}/api_key/${PsConfig.ps_api_key}/user_id/$userId';
     CollectionReference users = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('users');
    var document = await users.doc(userId).get();
    return await getServerCall2<User, List<User>>(User(), null, document.data());
  }

  Future<PsResource<User>> postImageUpload(
      String userId, String platformName, File imageFile) async {
    const String url = '${PsUrl.ps_image_upload_url}';

    return postUploadImage<User, User>(
        User(), url, userId, platformName, imageFile);
  }

  ///
  /// About App
  ///
  Future<PsResource<List<AboutApp>>> getAboutAppDataList() async {
    const String url =
        '${PsUrl.ps_about_app_url}/api_key/${PsConfig.ps_api_key}/';
    return await getServerCall<AboutApp, List<AboutApp>>(AboutApp(), url);
  }

  ///
  /// Get Shipping Area
  ///
  Future<PsResource<List<ShippingArea>>> getShippingArea() async {
    const String url =
        '${PsUrl.ps_shipping_area_url}/api_key/${PsConfig.ps_api_key}';

    return await getServerCall<ShippingArea, List<ShippingArea>>(
        ShippingArea(), url);
  }

  ///
  /// Get Shipping Area By Id
  ///
  Future<PsResource<ShippingArea>> getShippingAreaById(
      String shippingId) async {
    final String url =
        '${PsUrl.ps_shipping_area_url}/api_key/${PsConfig.ps_api_key}/id/$shippingId';

    return await getServerCall<ShippingArea, ShippingArea>(ShippingArea(), url);
  }

  ///
  /// Category
  ///
  Future<PsResource<List<Category>>> getCategoryList(
      int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
    // final String url =
    //     '${PsUrl.ps_category_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    // return await postData<Category, List<Category>>(Category(), url, jsonMap);
    CollectionReference categories = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('categories');
    QuerySnapshot querySnapshot = await categories.get();
    var categoriesList = [];
    querySnapshot.docs.forEach((doc) {
      var category = doc.data();
      print(category);
      categoriesList.add(category);
    });
    return await postData2<Category, List<Category>>(
        Category(), null, categoriesList);
  }

  Future<PsResource<List<Category>>> getAllCategoryList(
      Map<dynamic, dynamic> jsonMap) async {
    const String url =
        '${PsUrl.ps_category_url}/api_key/${PsConfig.ps_api_key}';

    return await postData2<Category, List<Category>>(Category(), url, jsonMap);
  }

  ///
  /// Sub Category
  ///
  Future<PsResource<List<SubCategory>>> getSubCategoryList(
      int limit, int offset, String categoryId) async {
    // final String url =
    //     '${PsUrl.ps_subCategory_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset/cat_id/$categoryId';

    // return await getServerCall<SubCategory, List<SubCategory>>(
    //     SubCategory(), url);
    CollectionReference categories = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('subcategories');
    QuerySnapshot querySnapshot =
        await categories.where('cat_id', whereIn: [categoryId]).get();
    var subcategoriesList = [];
    querySnapshot.docs.forEach((doc) {
      var subcategory = doc.data();
      print(subcategory);
      subcategoriesList.add(subcategory);
    });
    return await postData2<SubCategory, List<SubCategory>>(
        SubCategory(), null, subcategoriesList);
  }

  Future<PsResource<List<SubCategory>>> getAllSubCategoryList(
      String categoryId) async {
    // final String url =
    //     '${PsUrl.ps_subCategory_url}/api_key/${PsConfig.ps_api_key}/cat_id/$categoryId';

    // return await getServerCall<SubCategory, List<SubCategory>>(
    //     SubCategory(), url);
    CollectionReference categories = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('subcategories');
    QuerySnapshot querySnapshot =
        await categories.where('cat_id', whereIn: [categoryId]).get();
    var subcategoriesList = [];
    querySnapshot.docs.forEach((doc) {
      var subcategory = doc.data();
      print(subcategory);
      subcategoriesList.add(subcategory);
    });
    return await postData2<SubCategory, List<SubCategory>>(
        SubCategory(), null, subcategoriesList);
  }

  //noti
  Future<PsResource<List<Noti>>> getNotificationList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_noti_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<Noti, List<Noti>>(Noti(), url, paramMap);
  }

  //
  /// Product
  ///
  Future<PsResource<List<Product>>> getProductList(
      String cat_id, String sub_cat_id, int limit, int offset) async {
    // final String url =
    //     '${PsUrl.ps_product_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    // return await postData<Product, List<Product>>(Product(), url, paramMap);
    CollectionReference products = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('products');
    QuerySnapshot querySnapshot;
    if (cat_id != '' && sub_cat_id != '')
      querySnapshot = await products
          .where('cat_id', isEqualTo: cat_id)
          .where('sub_cat_id', isEqualTo: sub_cat_id)
          .get();
    else if (cat_id != '' && sub_cat_id == '')
      querySnapshot = await products.where('cat_id', isEqualTo: cat_id).get();
    else
      querySnapshot = await products.get();

    var productsList = [];
    querySnapshot.docs.forEach((doc) {
      var product = doc.data();
      print(product);
      productsList.add(product);
    });
    return await postData2<Product, List<Product>>(
        Product(), null, productsList);
  }

  Future<PsResource<Product>> getProductDetail(
      String productId, String loginUserId) async {
    // final String url =
    //     '${PsUrl.ps_product_detail_url}/api_key/${PsConfig.ps_api_key}/id/$productId/login_user_id/$loginUserId';
    // return await getServerCall<Product, Product>(Product(), url);
    CollectionReference products = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('products');
    QuerySnapshot querySnapshot =
        await products.where('id', whereIn: [productId]).get();
    var productsList = [];
    querySnapshot.docs.forEach((doc) {
      var product = doc.data();
      print(product);
      productsList.add(product);
    });
    return await getServerCall2<Product, Product>(
        Product(), null, productsList[0]);
  }

  Future<PsResource<List<Product>>> getRelatedProductList(
      String productId, String categoryId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_relatedProduct_url}/api_key/${PsConfig.ps_api_key}/id/$productId/cat_id/$categoryId/limit/$limit/offset/$offset';
    print(url);
    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  //
  /// Product Collection
  ///
  Future<PsResource<List<ProductCollectionHeader>>> getProductCollectionList(
      int limit, int offset) async {
    final String url =
        '${PsUrl.ps_collection_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await getServerCall<ProductCollectionHeader,
        List<ProductCollectionHeader>>(ProductCollectionHeader(), url);
  }

  ///Setting
  ///

  Future<PsResource<ShopInfo>> getShopInfo() async {
    const String url =
        '${PsUrl.ps_shop_info_url}/api_key/${PsConfig.ps_api_key}';
    return await getServerCall<ShopInfo, ShopInfo>(ShopInfo(), url);
  }

  ///Blog
  ///

  Future<PsResource<List<Blog>>> getBlogList(int limit, int offset) async {
    final String url =
        '${PsUrl.ps_bloglist_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await getServerCall<Blog, List<Blog>>(Blog(), url);
  }

  ///Transaction
  ///

  Future<PsResource<List<TransactionHeader>>> getTransactionList(
      String userId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_transactionList_url}/api_key/${PsConfig.ps_api_key}/user_id/$userId/limit/$limit/offset/$offset';

    CollectionReference transactions = FirebaseFirestore.instance
        .collection('lowcostapps')
        .doc('tinpanalley')
        .collection('orders');
    QuerySnapshot querySnapshot;
    querySnapshot =
        await transactions.where('user_id', isEqualTo: userId).get();
    var transactionsList = [];
    querySnapshot.docs.forEach((doc) {
      var transaction = doc.data();
      transactionsList.add(transaction);
    });
    return await postData2<TransactionHeader, List<TransactionHeader>>(
        TransactionHeader(), null, transactionsList);
  }

  Future<PsResource<List<TransactionDetail>>> getTransactionDetail(
      String id, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_transactionDetail_url}/api_key/${PsConfig.ps_api_key}/transactions_header_id/$id/limit/$limit/offset/$offset';
    print(url);
    return await getServerCall<TransactionDetail, List<TransactionDetail>>(
        TransactionDetail(), url);
  }

  Future<PsResource<TransactionHeader>> postTransactionSubmit(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_transaction_submit_url}';
    return await postData<TransactionHeader, TransactionHeader>(
        TransactionHeader(), url, jsonMap);
  }

  Future<PsResource<List<TransactionStatus>>> getTransactionStatusList() async {
    const String url =
        '${PsUrl.ps_transactionStatus_url}/api_key/${PsConfig.ps_api_key}';

    return await getServerCall<TransactionStatus, List<TransactionStatus>>(
        TransactionStatus(), url);
  }

  ///
  /// Comments
  ///
  Future<PsResource<List<CommentHeader>>> getCommentList(
      String productId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_commentList_url}/api_key/${PsConfig.ps_api_key}/product_id/$productId/limit/$limit/offset/$offset';

    return await getServerCall<CommentHeader, List<CommentHeader>>(
        CommentHeader(), url);
  }

  Future<PsResource<List<CommentDetail>>> getCommentDetail(
      String headerId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_commentDetail_url}/api_key/${PsConfig.ps_api_key}/header_id/$headerId/limit/$limit/offset/$offset';

    return await getServerCall<CommentDetail, List<CommentDetail>>(
        CommentDetail(), url);
  }

  Future<PsResource<CommentHeader>> getCommentHeaderById(
      String commentId) async {
    final String url =
        '${PsUrl.ps_commentList_url}/api_key/${PsConfig.ps_api_key}/id/$commentId';

    return await getServerCall<CommentHeader, CommentHeader>(
        CommentHeader(), url);
  }

  ///
  /// Favourites
  ///
  Future<PsResource<List<Product>>> getFavouritesList(
      String loginUserId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_favouriteList_url}/api_key/${PsConfig.ps_api_key}/login_user_id/$loginUserId/limit/$limit/offset/$offset';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  ///
  /// Product List By Collection Id
  ///
  Future<PsResource<List<Product>>> getProductListByCollectionId(
      String collectionId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_all_collection_url}/api_key/${PsConfig.ps_api_key}/id/$collectionId/limit/$limit/offset/$offset';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  Future<PsResource<List<CommentHeader>>> postCommentHeader(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_commentHeaderPost_url}';
    return await postData<CommentHeader, List<CommentHeader>>(
        CommentHeader(), url, jsonMap);
  }

  Future<PsResource<List<CommentDetail>>> postCommentDetail(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_commentDetailPost_url}';
    return await postData<CommentDetail, List<CommentDetail>>(
        CommentDetail(), url, jsonMap);
  }

  Future<PsResource<List<DownloadProduct>>> postDownloadProductList(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_downloadProductPost_url}';
    return await postData<DownloadProduct, List<DownloadProduct>>(
        DownloadProduct(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> rawRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_register_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> rawUnRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_unregister_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<Noti>> postNoti(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_post_url}';
    return await postData<Noti, Noti>(Noti(), url, jsonMap);
  }

  ///
  /// Rating
  ///
  Future<PsResource<Rating>> postRating(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_ratingPost_url}';
    return await postData<Rating, Rating>(Rating(), url, jsonMap);
  }

  Future<PsResource<List<Rating>>> getRatingList(
      String productId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_ratingList_url}/api_key/${PsConfig.ps_api_key}/product_id/$productId/limit/$limit/offset/$offset';

    return await getServerCall<Rating, List<Rating>>(Rating(), url);
  }

  ///
  ///Favourite
  ///
  Future<PsResource<List<Product>>> getFavouriteList(
      String loginUserId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_ratingList_url}/api_key/${PsConfig.ps_api_key}/login_user_id/$loginUserId/limit/$limit/offset/$offset';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  Future<PsResource<Product>> postFavourite(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_favouritePost_url}';
    return await postData<Product, Product>(Product(), url, jsonMap);
  }

  ///
  /// Gallery
  ///
  Future<PsResource<List<DefaultPhoto>>> getImageList(
      String parentImgId,
      // String imageType,
      int limit,
      int offset) async {
    final String url =
        '${PsUrl.ps_gallery_url}/api_key/${PsConfig.ps_api_key}/img_parent_id/$parentImgId/limit/$limit/offset/$offset';

    return await getServerCall<DefaultPhoto, List<DefaultPhoto>>(
        DefaultPhoto(), url);
  }

  ///
  /// Contact
  ///
  Future<PsResource<ApiStatus>> postContactUs(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_contact_us_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// CouponDiscount
  ///
  Future<PsResource<CouponDiscount>> postCouponDiscount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_couponDiscount_url}';
    return await postData<CouponDiscount, CouponDiscount>(
        CouponDiscount(), url, jsonMap);
  }

  ///
  /// Token
  ///
  Future<PsResource<ApiStatus>> getToken() async {
    const String url = '${PsUrl.ps_token_url}/api_key/${PsConfig.ps_api_key}';
    return await getServerCall<ApiStatus, ApiStatus>(ApiStatus(), url);
  }

  ///
  /// Reservation
  ///
  Future<PsResource<ApiStatus>> postReservation(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_create_reservation_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<List<Reservation>>> getReservationList(
      String userId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_reservationList_url}/user_id/$userId/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await getServerCall<Reservation, List<Reservation>>(
        Reservation(), url);
  }

  Future<PsResource<Reservation>> postReservationStatus(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_create_reservation_status_url}';
    return await postData<Reservation, Reservation>(
        Reservation(), url, jsonMap);
  }
}
