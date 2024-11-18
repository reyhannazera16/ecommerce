<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\DeliveryServiceController;
use App\Http\Controllers\API\OrderController;
use App\Http\Controllers\API\OrderStatusController;
use App\Http\Controllers\API\PaymentMethodController;
use App\Http\Controllers\API\ProductController;
use App\Http\Controllers\API\ProductSkuController;
use App\Http\Controllers\API\ProductDetailController;
use App\Http\Controllers\API\ProductImageController;
use App\Http\Controllers\API\ShippingAddressController;
use App\Http\Controllers\API\ShopController;
use App\Http\Controllers\API\ShopFollowerController;
use App\Http\Controllers\API\ShopProfileController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\ChatController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);

Route::get('/get-users', [UserController::class, 'getAllUsers']);

Route::get('/user', [UserController::class, 'index'])->name('showCurrentUser');
Route::put('/user', [UserController::class, 'update'])->name('updateCurrentUser');

// Delivery Service Model
Route::get('/delivery-services', [DeliveryServiceController::class, 'index'])->name('getDeliveryServices');
Route::post('/delivery-services', [DeliveryServiceController::class, 'store'])->name('createDeliveryService');
Route::put('/delivery-services', [DeliveryServiceController::class, 'update'])->name('updateDeliveryService');

// Order Model
Route::get('/orders', [OrderController::class, 'index'])->name('getOrders');
Route::post('/orders', [OrderController::class, 'store'])->name('createOrder');
Route::put('/orders', [OrderController::class, 'update'])->name('updateOrder');

// new 
Route::post('orders/update-status', [OrderStatusController::class, 'update']);
Route::post('orders/comment', [OrderController::class, 'commentOrder']);
Route::get('orders/shop/{shopId}', [OrderController::class, 'getShopOrders']);


// Payment Method Model
Route::get('/payment-methods', [PaymentMethodController::class, 'index'])->name('getPaymentMethods');
Route::post('/payment-methods', [PaymentMethodController::class, 'store'])->name('createPaymentMethod');
Route::put('/payment-methods', [PaymentMethodController::class, 'update'])->name('updatePaymentMethod');

// Product Model
Route::get('/products', [ProductController::class, 'index'])->name('getProducts');
Route::post('/products', [ProductController::class, 'store'])->name('createProduct');
Route::put('/products', [ProductController::class, 'update'])->name('updateProduct');

// Product Detail Model
Route::get('/product-details', [ProductDetailController::class, 'index'])->name('getProductDetails');
Route::post('/product-details', [ProductDetailController::class, 'store'])->name('createProductDetail');
Route::put('/product-details', [ProductDetailController::class, 'update'])->name('updateProductDetail');
Route::get('/api/products/{id}', [ProductDetailController::class, 'show']);

// Product Sku Model
Route::get('/product-skus', [ProductSkuController::class, 'index'])->name('getProductSkus');
Route::post('/product-skus', [ProductSkuController::class, 'store'])->name('createProductSku');
//Route::put('/product-skus', [ProductSkuController::class, 'destroy'])->name('updateProductSkuById');
Route::put('/product-skus/{id}', [ProductSkuController::class, 'update'])->name('updateProductSkuById');

// Shipping Address Model
Route::get('/shipping-addresses', [ShippingAddressController::class, 'index'])->name('getShippingAddresses');
Route::post('/shipping-addresses', [ShippingAddressController::class, 'store'])->name('createShippingAddress');
Route::put('/shipping-addresses', [ShippingAddressController::class, 'update'])->name('updateShippingAddress');
Route::delete('/shipping-addresses', [ShippingAddressController::class, 'destroy'])->name('deleteShippingAddress');

// Shop Model
Route::get('/shops', [ShopController::class, 'index'])->name('getShops');
Route::post('/shops', [ShopController::class, 'store'])->name('createShop');
Route::put('/shops', [ShopController::class, 'update'])->name('updateShop');

Route::get('/shop/{userId}', [ShopController::class, 'detail'])->name('getDetailShop');

// Shop Follower Model
Route::get('/shop-followers', [ShopFollowerController::class, 'index'])->name('getShopFollowers');
Route::post('/shop-followers', [ShopFollowerController::class, 'store'])->name('createShopFollower');
Route::put('/shop-followers', [ShopFollowerController::class, 'update'])->name('updateShopFollower');

// Shop Profile Model
Route::get('/shops-profile', [ShopProfileController::class, 'index'])->name('getShopProfiles');
Route::post('/shops-profile', [ShopProfileController::class, 'store'])->name('createShopProfile');
Route::put('/shops-profile', [ShopProfileController::class, 'update'])->name('updateShopProfile');

Route::get('/test', [ProductImageController::class, 'index'])->name('getProductImages');
Route::post('/product-images/uploads', [ProductImageController::class, 'uploads'])->name('uploadProductImage');
Route::get('/download/{id}', [ProductImageController::class, 'downloads'])->name('downloadProductImage');


Route::post('/chat', [ChatController::class, 'store'])->name('sendChats');
Route::get('/chat/list', [ChatController::class, 'list'])->name('listChats');
Route::get('/chat/{shopId}', [ChatController::class, 'index'])->name('getChats');