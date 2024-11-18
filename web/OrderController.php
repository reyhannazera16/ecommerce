<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }


public function index()
{
    try {
        // Ambil data order beserta relasi yang diperlukan
        $orders = Order::with(['user', 'product', 'paymentMethod', 'deliveryService', 'shippingAddress'])
            ->where('user_id', auth()->id()) // Filter berdasarkan user_id yang sedang login
            ->get();

        // Mengelompokkan berdasarkan product_name
        $groupedOrders = $orders->groupBy('product_name')->map(function ($items) {
            return [
                'product_name' => $items->first()->product_name, // Nama produk
                'total_qty' => $items->sum('qty'), // Total qty dari produk yang sama
                'status' => $items->pluck('status')->unique()->toArray(), // Mengambil status yang unik
                'orders' => $items->map(function ($item) {
                    return [
                        'id' => $item->id,
                        'qty' => $item->qty, // Menampilkan qty
                        'price' => $item->price,
                        'buyer_name' => $item->user->name, // Nama pembeli
                        'created_at' => $item->created_at,
                        'status' => $item->status // Status pesanan
                    ];
                })
            ];
        });

        return response()->json($groupedOrders);

    } catch (\Exception $e) {
        return response()->json(['error' => $e->getMessage()], 500);
    }
}




public function store(Request $request)
{
    try {
        $validatedData = $request->validate([
            'productId' => 'required',
            'paymentMethodId' => 'required',
            'deliveryServiceId' => 'required',
            'shippingAddressId' => 'required',
            'qty' => 'required|integer|min:1',
            'price' => 'required|integer|min:0'
        ]);

        $order = Order::create([
            'user_id' => auth()->id(),
            'product_id' => $validatedData['productId'],
            'payment_method_id' => $validatedData['paymentMethodId'],
            'delivery_service_id' => $validatedData['deliveryServiceId'],
            'shipping_address_id' => $validatedData['shippingAddressId'],
            'qty' => $validatedData['qty'],
            'price' => $validatedData['price'],
            'status' => 'pending'
        ]);

        return response()->json([
            'message' => 'Order successfully created',
            'data' => $order
        ], 201);
    } catch (\Exception $e) {
        return response()->json(['error' => $e->getMessage()], 500);
    }
}


// update
public function update(Request $request)
{
    try {
        DB::beginTransaction();
        
        // Validasi hanya untuk field yang dibutuhkan saat update status
        $validator = Validator::make($request->all(), [
            'id' => 'required',
            'status' => 'required|string|in:pending,confirmed,shipped,completed,cancelled',
            'tracking_number' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $order = Order::findOrFail($request->id);
        
        // Update hanya status dan tracking number
        $order->update([
            'status' => $request->status,
            'tracking_number' => $request->tracking_number
        ]);

        // Ambil data lengkap order yang sudah diupdate
        $updatedOrder = DB::table('orders')
            ->join('users', 'orders.user_id', '=', 'users.id')
            ->join('products', 'orders.product_id', '=', 'products.id')
            ->select(
                'orders.id',
                'orders.status',
                'orders.tracking_number',
                'orders.qty',
                'orders.price',
                'products.name as product_name',
                'users.name as buyer_name',
                'users.photo as buyer_photo',
                'orders.user_id as buyer_id',
                'orders.created_at'
            )
            ->where('orders.id', $request->id)
            ->first();

        DB::commit();

        return response()->json([
            'message' => 'Order status updated successfully',
            'data' => $updatedOrder
        ]);

    } catch (\Exception $e) {
        DB::rollBack();
        return response()->json(['error' => $e->getMessage()], 500);
    }
}


public function getShopOrders($shopId)
{
    try {
        $orders = DB::table('orders')
            ->join('users', 'orders.user_id', '=', 'users.id')
            ->join('products', 'orders.product_id', '=', 'products.id')
            ->select(
                'orders.id',
                'orders.status',
                'orders.tracking_number',
                'orders.qty',
                'orders.price',
                'products.name as product_name',
                'users.name as buyer_name',     // Pastikan field ini ada
                'users.photo as buyer_photo',   // Pastikan field ini ada
                'orders.user_id as buyer_id',   // Tambahkan buyer_id
                'orders.created_at'
            )
            ->where('products.shop_id', $shopId)
            ->orderBy('orders.created_at', 'desc')
            ->get();

        return response()->json($orders);
    } catch (\Exception $e) {
        return response()->json(['error' => $e->getMessage()], 500);
    }
}

}
