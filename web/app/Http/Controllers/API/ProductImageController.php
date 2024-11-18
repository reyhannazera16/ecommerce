<?php

namespace App\Http\Controllers\API;

use Exception;
use App\Models\ProductImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ProductImageController extends Controller
{
    public function index(Request $request)
    {
        try {
            DB::beginTransaction();

            $data = DB::table('product_images');

            if ($request->filled('id')) {
                $data = $data->where('id', $request->id);
            } else {
                if ($request->filled('product_id')) {
                    $data = $data->where('product_id', $request->product_id);
                }
            }

            DB::commit();

            return response()->json($data->get());
        } catch (QueryException $qe) {
            DB::rollBack();

            error_log($qe->getMessage());

            return response()->json([], 500);
        } catch (\Throwable $th) {
            DB::rollBack();

            error_log($th->getMessage());

            return response()->json([], 400);
        }
    }

    public function uploads(Request $request)
    {
        try {
            if (!$request->hasFile('file')) throw new Exception('File not uploaded due to size (Max:2MB)');

          $validator = Validator::make($request->all(), [
    'product_id' => ['required'],
    'file' => ['required', 'file', 'mimes:jpg,jpeg,png', 'max:10240'], // 10 MB
]);


            if ($validator->fails()) throw new Exception('Failed to validate request');

            $validated = $validator->validated();

            $file = $request->file('file');

            $result = Storage::putFile('uploads', $file);


            DB::beginTransaction();

            ProductImage::create([
                'product_id' => $validated['product_id'],
                'original_file_name' => $file->getClientOriginalName(),
                'file_path' => $result,
            ]);

            DB::commit();

            return response()->json(['message' => 'uploaded']);
        } catch (QueryException $qe) {
            DB::rollBack();

            error_log($qe->getMessage());

            return response()->json(['message' => 'Internal server error' . $qe->getMessage()], 500);
        } catch (\Throwable $th) {
            DB::rollBack();

            error_log($th->getMessage());

            return response()->json(['message' => 'Bad request' . $th->getMessage()], 400);
        }
    }

    public function downloads($id)
    {
        $productImage = ProductImage::findOrFail($id);
        return Storage::download($productImage->file_path, $productImage->original_file_name);
    }
}