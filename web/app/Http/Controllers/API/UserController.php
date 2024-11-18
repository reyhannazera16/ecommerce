<?php

namespace App\Http\Controllers\API;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    public function index(Request $request)
    {
        return $request->user();
    }

    public function update(Request $request)
    {
        try {
            $userId = $request->user()->id;

            DB::beginTransaction();

            $data = User::findOrFail($userId);

            if ($data->name != $request->name && $request->name != '') {
                $validator = Validator::make($request->all(), [
                    'name' => ['string', 'max:32'],
                ]);

                if ($validator->fails()) {
                    return response()->json($validator->errors(), 422);
                }

                $validated = $validator->validated();

                $data->update([
                    'name' => $validated['name'],
                ]);
            }

            if ($data->email != $request->email && $request->email != '') {
                $validator = Validator::make($request->all(), [
                    'email' => ['email', 'max:255', 'unique:users'],
                ]);

                if ($validator->fails()) {
                    return response()->json($validator->errors(), 422);
                }

                $validated = $validator->validated();

                $data->update([
                    'email' => $validated['email'],
                ]);
            }

            if ($data->password != '') {
                if (!Hash::check($data->password, $data->password)) {
                    $validator = Validator::make($request->all(), [
                        'password' => ['string', 'min:8'],
                    ]);

                    if ($validator->fails()) {
                        return response()->json($validator->errors(), 422);
                    }

                    $validated = $validator->validated();

                    $data->update([
                        'password' => Hash::make($validated['password']),
                    ]);
                }
            }

            DB::commit();

            return response()->json(['message' => 'User updated successfully'], 200);
        } catch (QueryException $qe) {
            DB::rollBack();

            return response()->json(['message' => $qe->getMessage()], 500);
        } catch (\Throwable $th) {
            DB::rollBack();

            return response()->json(['message' => $th->getMessage()], 400);
        }
    }
}
