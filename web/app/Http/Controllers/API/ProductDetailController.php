<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\ProductDetail;
use Exception;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Validator;

class ProductDetailController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index(Request $request)
    {
        try {
            DB::beginTransaction();

            $data = DB::table('product_details');

            if ($request->filled('id')) {
                $data = $data->where('id', $request->id);
            } else 
            if ($request->filled('productId')) {
                $data = $data->where('product_id', $request->productId);
            }

            $data = $data->where('is_deleted', false)->get();

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

            $data = Validator::make($request->all(), [
                'product_id' => ['required'],
                'description' => ['required', 'string'],
            ]);

            if ($data->fails()) {
                return response()->json($data->errors(), 422);
            }

            $validatedData = $data->validated();

            ProductDetail::create([
                'product_id' => $validatedData['product_id'],
                'description' => $validatedData['description'],
            ]);

            DB::commit();

            return response()->json(['message' => 'Product detail successfully created'], 201);
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
                'id' => ['required'],
                'product_id' => ['required', 'string'],
                'description' => ['string'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            $data = ProductDetail::findOrFail($validated['id']);

            $data->update([
                'product_id' => $validated['product_id'],
                'description' => $validated['description'],
            ]);

            DB::commit();

            return response()->json(['message' => 'Product detail successfully updated'], 200);
        } catch (QueryException $qe) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error' . $qe->getMessage()], 500);
        } catch (\Throwable $th) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request'], 400);
        }
    }



    

    public function show($id)
    {
        $productDetail = ProductDetail::find($id);


    

        // Return a view if the product is found
        return view('product_detail', ['productDetail' => $productDetail]);
    }
}