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

    public function index(Request $request)
    {
        $orders = Order::where('user_id', $request->user()->id)
            ->join('products', 'orders.product_id', '=', 'products.id')
            ->join('payment_methods', 'orders.payment_method_id', '=', 'payment_methods.id')
            ->join('delivery_services', 'orders.delivery_service_id', '=', 'delivery_services.id')
            ->select(
                'orders.*',
                'products.name as product_name',
                'payment_methods.name as payment_method_name',
                'delivery_services.name as delivery_service_name'
            )
            ->orderBy('orders.created_at', 'desc')
            ->get();
            
        return response()->json($orders); 
    }


    public function store(Request $request)
    {
        try {
            DB::beginTransaction();

            $data = Validator::make($request->all(), [
                'productId' => ['required'],
                'paymentMethodId' => ['required'],
                'deliveryServiceId' => ['required'],
                'shippingAddressId' => ['required'],
                'qty' => ['required', 'integer', 'min:1'],  // Tambah ini
                'price' => ['required', 'integer', 'min:0'] // Tambah ini
            ]);

            if ($data->fails()) {
                return response()->json($data->errors(), 422);
            }

            $validatedData = $data->validated();
            $userId = $request->user()->id;

            Order::create([
                'user_id' => $userId,
                'product_id' => $validatedData['productId'],
                'payment_method_id' => $validatedData['paymentMethodId'],
                'delivery_service_id' => $validatedData['deliveryServiceId'],
                'shipping_address_id' => $validatedData['shippingAddressId'],
                'qty' => $validatedData['qty'],           // Tambah ini
                'price' => $validatedData['price'],       // Tambah ini
                'status' => 'pending'                     // Tambah ini juga
            ]);

            DB::commit();

            return response()->json(['message' => 'Order successfully created'], 201);
        } catch (QueryException $qe) {
            DB::rollBack();
            return response()->json(['message' => 'Internal server error' . $qe], 500);
        } catch (\Throwable) {
            DB::rollBack();
            return response()->json(['message' => 'Bad request'], 400);
        }
    }

    public function update(Request $request)
    {
        try {
            DB::beginTransaction();

            $validator = Validator::make($request->all(), [
                'id' => ['required'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            Order::where('id', $validated['id'])
                ->get()
                ->first();

            DB::commit();

            return response()->json(['message' => 'Order successfully updated'], 200);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request'], 400);
        }
    }

    public function getShopOrders(Request $request, $shopId)
    {
        try {
            DB::beginTransaction();

            $orders = DB::table('orders')
                ->join('users', 'orders.user_id', '=', 'users.id')
                ->join('products', 'orders.product_id', '=', 'products.id')
                ->join('shops', 'products.shop_id', '=', 'shops.id')
                ->where('shops.id', $shopId)
                ->where('orders.is_deleted', false)
                ->select(
                    'orders.id',
                    'orders.status',
                    'orders.tracking_number',
                    'orders.qty',
                    'orders.price',
                    'products.name as product_name',
                    'users.name as buyer_name',
                    'orders.created_at' // Tambahkan created_at
                )
                ->orderBy('orders.created_at', 'desc') // Urutkan berdasarkan created_at terbaru
                ->get();

            DB::commit();
            return response()->json($orders);
        } catch (QueryException) {
            DB::rollBack();
            return response()->json(['message' => 'Internal server error'], 500);
        }
    }
    public function updateOrder(Request $request, $id)
    {
        try {
            DB::beginTransaction();

            $validator = Validator::make($request->all(), [
                'status' => ['required_without:tracking_number'],
                'tracking_number' => ['required_without:status'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $order = Order::findOrFail($id);
            
            // Update status jika ada
            if ($request->has('status')) {
                $order->status = $request->status;
            }
            
            // Update tracking number TANPA mengubah status
            if ($request->has('tracking_number')) {
                $order->tracking_number = $request->tracking_number;
                // Hanya ubah status ke shipped jika tracking number tidak null
                // dan status saat ini adalah confirmed
                if ($request->tracking_number && $order->status === 'confirmed') {
                    $order->status = 'shipped';
                }
            }
            
            $order->save();
            
            DB::commit();
            return response()->json([
                'message' => 'Order updated successfully',
                'status' => $order->status // Tambahkan status di response
            ]);
        } catch (QueryException) {
            DB::rollBack();
            return response()->json(['message' => 'Internal server error'], 500);
        }
    }

    public function commentOrder(Request $request)
    {
        try {
            DB::beginTransaction();

            $validator = Validator::make($request->all(), [
                'id' => ['required'],
                'komentar' => ['required'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            $order = Order::findOrFail($validated['id']);
            $order->komentar = $request->komentar;
            $order->save();

            DB::commit();

            return response()->json(['message' => 'Add comment successfully updated'], 200);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request'], 400);
        }
    }
}