<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\ShopProfile;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Validator;

class ShopProfileController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index(Request $request)
    {
        try {
            DB::beginTransaction();

            $data = DB::table('shop_profiles');

            if ($request->filled('shopId')) {
                $data = $data->where('id', $request->shop_id);
            }

            $data = $data
                ->where('is_deleted', false)
                ->select('shop_id', 'about')
                ->get();

            DB::commit();

            return response()->json($data);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json([], 500);
        } catch (\Throwable) {
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
                'about' => ['required'],
            ]);

            if ($validator->errors()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            ShopProfile::create([
                'shop_id' => $validated['shopId'],
                'about' => $validated['name'],
            ]);

            DB::commit();

            return response()->json(['message' => 'Shop profile successfully created'], 201);
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
                'about' => [],
            ]);

            if ($validator->errors()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            ShopProfile::where('id', $validated['shopId'])
                ->get()
                ->first()
                ->update(['about' => $validated['about']]);

            DB::commit();

            return response()->json(['message' => 'Shop profile successfully updated'], 200);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request'], 400);
        }
    }
}
