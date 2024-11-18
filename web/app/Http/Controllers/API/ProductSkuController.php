<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\ProductSku;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Validator;

class ProductSkuController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index(Request $request)
    {
        try {
            $data = ProductSku::query();

            if ($request->filled('skuId')) {
                $data->where('id', $request->skuId);
            } elseif ($request->filled('productId')) {
                $data->where('product_id', $request->productId);
            }

            $data->where('is_deleted', false);

            return response()->json($data->get(), 200);
        } catch (QueryException $e) {
            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable $e) {
            return response()->json(['message' => 'Bad request'], 400);
        }
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'product_id' => ['required'],
            'name' => ['required', 'string', 'max:32'],
            'price' => ['required', 'integer'],
            'qty' => ['required', 'integer'],
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        try {
            DB::beginTransaction();

            $validated = $validator->validated();

            ProductSku::create($validated);

            DB::commit();

            return response()->json(['message' => 'Product SKU successfully created'], 201);
        } catch (QueryException $e) {
            DB::rollBack();
            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable $e) {
            DB::rollBack();
            return response()->json(['message' => 'Bad request'], 400);
        }
    }

    public function update(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'id' => ['required', 'exists:product_skus,id'], // Pastikan ID valid dan ada di tabel
            'name' => ['nullable', 'string', 'max:32'],
            'price' => ['nullable', 'integer'],
            'qty' => ['nullable', 'integer'],
        ]);

        // Mengembalikan respon error jika validasi gagal
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        try {
            DB::beginTransaction(); // Memulai transaksi database

            $validated = $validator->validated();

            // Ambil SKU dengan ID yang diberikan
            $productSku = ProductSku::findOrFail($validated['id']);

            // Update hanya kolom yang diisi
            $productSku->update(array_filter($validated));

            DB::commit(); // Commit transaksi jika berhasil

            return response()->json(['message' => 'Product SKU successfully updated'], 200);
        } catch (QueryException $e) {
            DB::rollBack(); // Rollback transaksi jika ada kesalahan database
            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable $e) {
            DB::rollBack(); // Rollback transaksi untuk semua jenis kesalahan lainnya
            return response()->json(['message' => 'Bad request'], 400);
        }
    }

}