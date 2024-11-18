<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Validator;

class ProductController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index(Request $request)
    {
        try {
            DB::beginTransaction();

            $data = DB::table('products');


            if ($request->filled('id')) {
                $data = $data->where('id', $request->id)->get();
            } else {
                $data =  $data->join('product_skus', function ($join) {
                    $join
                        ->on('products.id', '=', 'product_skus.product_id')
                        ->where('product_skus.price', '=', function ($query) {
                            $query->select(DB::raw('MIN(price)'))
                                ->from('product_skus as ps')
                                ->whereColumn('ps.product_id', 'product_skus.product_id');
                        });
                });

                if ($request->filled('searchTerm')) {
                    $searchTerm = '%' . $request->searchTerm . '%';
                    $data = $data->where('products.name', 'like', $searchTerm);
                } else if ($request->filled('shopId')) {
                    $shopId = $request->shopId;
                    $data = $data->where('products.shop_id', $shopId);
                }

                if ($request->filled('skip')) {
                    $skip = $request->skip;
                    $data = $data->skip($skip);
                }

                $data = $data->take(18);

                $data = $data->where('products.is_deleted', false)
                    ->select('products.id', 'products.name', 'product_skus.price', 'products.shop_id', 'products.is_deleted', 'products.created_at', 'products.updated_at')
                    ->get();
            }

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
            $data = Validator::make($request->all(), [
                'id' => ['required', 'string'],
                'shopId' => ['required'],
                'name' => ['required', 'max:32'],
            ]);

            if ($data->fails()) {
                return response()->json($data->errors(), 422);
            }

            $validated = $data->validated();

            DB::beginTransaction();

            Product::create([
                'id' => $validated['id'],
                'shop_id' => $validated['shopId'],
                'name' => $validated['name'],
            ]);

            DB::commit();

            return response()->json(['message' => 'Product successfully created'], 201);
        } catch (QueryException $qe) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error' . $qe->getMessage()], 500);
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
                'name' => ['string'],
                'is_active' => [],
                'is_deleted' => [],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            Product::findOrFail($validated['id'])
                ->update([
                    'name' => $validated['name'],
                    'is_deleted' => $validated['is_deleted'],
                ]);

            DB::commit();

            return response()->json(['message' => 'Product successfully updated'], 200);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable $th) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request' . $th->getMessage()], 400);
        }
    }
}