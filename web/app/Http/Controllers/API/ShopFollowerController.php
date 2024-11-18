<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\ShopFollower;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Validator;

class ShopFollowerController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index(Request $request)
    {
        try {
            DB::beginTransaction();

            $data = DB::table('shop_followers')
                ->join('users', 'shop_followers.user_id', 'users.id')
                ->join('shops', 'shop_followers.shop_id', 'shops.id');

            if ($request->filled('userId')) {
                $data = $data->where('shop_followers.user_id', $request->user_id);
            }

            if ($request->filled('shopId')) {
                $data = $data->where('shop_followers.shop_id', $request->shop_id);
            }

            if ($request->filled('withName')) {
                $data = $data->select('shop_followers.user_id', 'shop_followers.shop_id', 'users.name', 'shops.name');
            } else {
                $data = $data->select('shop_followers.user_id', 'shop_followers.shop_id');
            }

            $data = $data->get();

            DB::commit();

            return response()->json($data);
        } catch (QueryException $qe) {
            DB::rollBack();

            return response()->json([], 500);
        } catch (\Throwable $th) {
            DB::rollBack();

            return response()->json([], 400);
        }
    }

    public function store(Request $request)
    {
        try {
            DB::beginTransaction();

            $validator = Validator::make($request->all(), [
                'shopId' => ['required'],
            ]);

            if ($validator->errors()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();
            $userId = $request->user()->id;

            ShopFollower::create([
                'user_id' => $userId,
                'shop_id' => $validated['shopId'],
            ]);

            DB::commit();

            return response()->json(['message' => 'Successfully following'], 201);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
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
                'shopId' => [],
            ]);

            if ($validator->errors()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();
            $userId = $request->user()->id;

            ShopFollower::where('user_id', $userId)
                ->where('shop_id', $validated['shopId'])
                ->get()
                ->first()
                ->delete();

            DB::commit();

            return response()->json(['message' => 'Successfully unfollowed'], 200);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request'], 400);
        }
    }
}
