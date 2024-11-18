<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Chat;
use App\Models\RoomChat;
use App\Models\Shop;

class ChatController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index($shopId, Request $request)
    {
        try {
            $shop = Shop::findOrFail($shopId);
            $chats = Chat::where('dari_user', $request->user()->id)->where("untuk_user",$shop->user_id)->get();
            
            return response()->json($chats); 
        } catch (\Throwable $th) {
            throw $th;
        }
    }

    public function store(Request $request){ //antara pembeli ke penjual; penjual tidak dapat masuk ke perintah ini
        try {
            $room = RoomChat::where("pembeli",$request->dari_user)->where("penjual",$request->untuk_user)->first();
            if($room==null){
                $room = new RoomChat();
                $room->pembeli = $request->dari_user;
                $room->penjual = $request->untuk_user;
                $room->save();
            }

            $chat = new Chat();
            $chat->dari_user = $request->dari_user;
            $chat->untuk_user = $request->untuk_user;
            $chat->room = $room->id;
            $chat->pesan = $request->pesan;

            $chat->save();

            return response()->json($chat);
        } catch (\Throwable $th) {
            throw $th;
        }
    }

    public function list(){
        $room = RoomChat::with('pembeli','penjual','lastchat')->get();
        return response()->json($room);
    }

    // public function store(Request $request)
    // {
    //     try {
    //         DB::beginTransaction();

    //         $data = Validator::make($request->all(), [
    //             'productId' => ['required'],
    //             'paymentMethodId' => ['required'],
    //             'deliveryServiceId' => ['required'],
    //             'shippingAddressId' => ['required'],
    //             'qty' => ['required', 'integer', 'min:1'],  // Tambah ini
    //             'price' => ['required', 'integer', 'min:0'] // Tambah ini
    //         ]);

    //         if ($data->fails()) {
    //             return response()->json($data->errors(), 422);
    //         }

    //         $validatedData = $data->validated();
    //         $userId = $request->user()->id;

    //         Order::create([
    //             'user_id' => $userId,
    //             'product_id' => $validatedData['productId'],
    //             'payment_method_id' => $validatedData['paymentMethodId'],
    //             'delivery_service_id' => $validatedData['deliveryServiceId'],
    //             'shipping_address_id' => $validatedData['shippingAddressId'],
    //             'qty' => $validatedData['qty'],           // Tambah ini
    //             'price' => $validatedData['price'],       // Tambah ini
    //             'status' => 'pending'                     // Tambah ini juga
    //         ]);

    //         DB::commit();

    //         return response()->json(['message' => 'Order successfully created'], 201);
    //     } catch (QueryException $qe) {
    //         DB::rollBack();
    //         return response()->json(['message' => 'Internal server error' . $qe], 500);
    //     } catch (\Throwable) {
    //         DB::rollBack();
    //         return response()->json(['message' => 'Bad request'], 400);
    //     }
    // }
}