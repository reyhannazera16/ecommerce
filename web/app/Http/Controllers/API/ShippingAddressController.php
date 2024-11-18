<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Models\ShippingAddress;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Exception;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Validator;

class ShippingAddressController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index(Request $request)
    {
        try {
            DB::beginTransaction();

            $data = DB::table('shipping_addresses');

            if ($request->filled('id')) {
                $data =  $data->where('id', $request->id);
            } else {
                $userId = $request->user()->id;

                $data = DB::table('shipping_addresses')->where('user_id', $userId);
            }

            $data = $data
                ->where('is_deleted', false)
                ->select('id', 'address', 'is_primary')
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
                'address' => ['required', 'max:128'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();
            $userId = $request->user()->id;

            ShippingAddress::create([
                'user_id' => $userId,
                'address' => $validated['address'],
            ]);

            DB::commit();

            return response()->json(['message' => 'Shipping address successfully created'], 201);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request:'], 400);
        }
    }

    public function update(Request $request)
    {
        try {
            DB::beginTransaction();

            $validator = Validator::make($request->all(), [
                'id' => ['required'],
                'address' => ['max:128'],
                'is_primary' => [],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            if ($validated['is_primary'] == 1) {
                $userId = $request->user()->id;

                DB::table('shipping_addresses')
                    ->where('user_id', $userId)
                    ->update(['is_primary' => false]);
            }

            DB::table('shipping_addresses')
                ->where('id', $validated['id'])
                ->update([
                    'address' => $validated['address'],
                    'is_primary' => $validated['is_primary']
                ]);

            DB::commit();

            return response()->json(['message' => 'Address successfully updated'], 200);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request'], 400);
        }
    }

    public function destroy(Request $request)
    {
        try {
            DB::beginTransaction();

            $validator = Validator::make($request->all(), [
                'id' => ['required'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            DB::table('shipping_addresses')
                ->where('id', $validated['id'])
                ->update([
                    'is_deleted' => 1,
                ]);

            DB::commit();

            return response()->json(['message' => 'Address successfully deleted'], 200);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal server error'], 500);
        } catch (\Throwable) {
            DB::rollBack();

            return response()->json(['message' => 'Bad request'], 400);
        }
    }
}
