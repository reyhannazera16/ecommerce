<?php

namespace App\Http\Controllers\API;


use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class OrderStatusController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function update(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'id' => 'required|exists:orders,id',
                'status' => 'required|string|in:pending,confirmed,shipped,completed,cancelled',
                'tracking_number' => 'nullable|string'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'message' => 'Validation failed',
                    'errors' => $validator->errors()
                ], 422);
            }

            DB::beginTransaction();

            $order = Order::findOrFail($request->id);
            
            $updateData = ['status' => $request->status];
            if ($request->has('tracking_number')) {
                $updateData['tracking_number'] = $request->tracking_number;
            }
            
            $order->update($updateData);

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
            return response()->json([
                'message' => 'Failed to update order status',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
