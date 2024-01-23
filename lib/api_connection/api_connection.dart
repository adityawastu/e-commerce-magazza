// ignore_for_file: constant_identifier_names

class API {
  static const hostConnect = "http://192.168.0.4/api_magazza";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostUploadItem = "$hostConnect/items";
  static const hostGoods = "$hostConnect/goods";
  static const hostCart = "$hostConnect/cart";
  static const hostFavorite = "$hostConnect/favorite";
  static const hostOrder = "$hostConnect/order";
  static const hostImages = "$hostConnect/transactions_proof_images/";
  static const hostAddress = "$hostConnect/addres";
  //sign up user
  static const ValidateEmail = "$hostConnectUser/validate_email.php";
  static const signUp = "$hostConnectUser/signup.php";
  static const login = "$hostConnectUser/login.php";

  //login admin
  static const adminLogin = "$hostConnectAdmin/login.php";
  static const adminGetAllOrders = "$hostConnectAdmin/read_orders.php";

  //upload image
  static const uploadNewItem = "$hostUploadItem/upload.php";

  //goods
  static const getAllGoods = "$hostGoods/all.php";

  //cart
  static const addToCart = "$hostCart/add.php";
  static const getCartList = "$hostCart/read.php";
  static const deleteSelectedItemsFromCartList = "$hostCart/delete.php";
  static const updateItemInCartList = "$hostCart/update.php";

  //favorite
  static const addFavorite = "$hostFavorite/add.php";
  static const deleteFavorite = "$hostFavorite/delete.php";
  static const validateFavorite = "$hostFavorite/validate_favorite.php";
  static const readFavorite = "$hostFavorite/read.php";

  //search
  static const searchItems = "$hostUploadItem/search.php";

  //order
  static const addOrder = "$hostOrder/add.php";
  static const readOrders = "$hostOrder/read.php";
  static const updateStatus = "$hostOrder/update_status.php";

  //address
  static const addAddress = "$hostAddress/add.php";
  static const readAddress = "$hostAddress/read.php";
}
