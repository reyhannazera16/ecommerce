<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\PaymentMethod;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Validator;

class PaymentMethodController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index(Request $request)
    {
        try {
            DB::beginTransaction();

            $data = DB::table('payment_methods');

            if ($request->filled('id')) {
                $data = $data->where('id', $request->id);
            }

            $data = $data
                ->where('is_deleted', false)
                ->select('id', 'name')
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

            $data = Validator::make($request->all(), [
                'name' => ['required', 'string'],
            ]);

            if ($data->fails()) {
                return response()->json($data->errors(), 422);
            }

            $validatedData = $data->validated();

            PaymentMethod::create([
                'name' => $validatedData['name'],
            ]);

            DB::commit();

            return response()->json(['message' => 'Payment method successfully created'], 201);
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
                'name' => ['string'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            PaymentMethod::where('id', $validated['id'])
                ->get()
                ->first()
                ->update(['name' => $validated['name']]);

            DB::commit();

            return response()->json(['message' => 'Payment method successfully updated'], 200);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request'], 400);
        }
    }
}
