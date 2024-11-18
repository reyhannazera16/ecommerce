<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\Shop;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Validator;

class ShopController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index(Request $request)
    {
        try {
            DB::beginTransaction();

            $data = DB::table('shops');

            if ($request->filled('id')) {
                $data = $data->where('id', $request->id);
            } else {
                if ($request->filled('searchTerm')) {
                    $data = $data->where('name', 'like', '%' . $request->searchTerm . '%');
                } elseif ($request->filled('userId')) {
                    $userId = $request->user()->id;
                    $data = $data->where('user_id', $userId);
                }
            }

            $data = $data
                ->where('is_deleted', false)
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
                'name' => ['required', 'max:32'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();
            $userId = $request->user()->id;

            Shop::create([
                'user_id' => $userId,
                'name' => $validated['name'],
            ]);

            DB::commit();

            return response()->json(['message' => 'Shop successfully created'], 201);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request'], 400);
        }
    }

    public function update(Request $request, $id)
    {
        try {
            DB::beginTransaction();

            $validator = Validator::make($request->all(), [
                'name' => ['nullable', 'max:32'],
                'isActive' => ['nullable', 'boolean'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();
            $userId = $request->user()->id;

            $shop = Shop::where('id', $id)
                ->where('user_id', $userId)
                ->first();

            if (!$shop) {
                return response()->json(['message' => 'Shop not found'], 404);
            }

            // Update only the provided fields
            $shop->update([
                'name' => $validated['name'] ?? $shop->name,
                'is_active' => $validated['isActive'] ?? $shop->is_active,
            ]);

            DB::commit();

            return response()->json(['message' => 'Shop successfully updated'], 200);
        } catch (QueryException) {
            DB::rollBack();
            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable) {
            DB::rollBack();
            return response()->json(['message' => 'Bad request'], 400);
        }
    }

    public function detail($shopId){
        try {
            $data = Shop::where("id",$shopId)->orderByDesc("id")->first();
            return response()->json($data);
        } catch (QueryException $e) {
            return response()->json($e->getMessage(), 500);
        } catch (\Throwable $e) {
            return response()->json($e->getMessage(), 400);
        }
    }
}