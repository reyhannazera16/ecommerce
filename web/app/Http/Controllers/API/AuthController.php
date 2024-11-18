<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\User;
use Exception;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{

public function getAllUsers() {
    return response()->json(User::all());
}



    public function login(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'email' => ['required', 'email'],
                'password' => ['required'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            if (!Auth::attempt($validated)) {
                throw new Exception('The provided credentials do not match our records.');
            }

            $user = Auth::user();

            if (!$user instanceof User) {
                throw new Exception('Failed to proceed request.');
            }

            $token = $user->createToken('fradel_n_spies_user_auth')->plainTextToken;

            return response()->json(['token' => $token], 200);
        } catch (\Throwable $th) {
            return response()->json(['message' => $th->getMessage()], 400);
        }
    }

    public function register(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'name' => ['required', 'string', 'max:32'],
                'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
                'password' => ['required', 'string', 'min:8', 'max:16', 'confirmed'],
            ]);

            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $validated = $validator->validated();

            DB::beginTransaction();

            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => Hash::make($validated['password']),
            ]);

            if (!Auth::attempt(['email' => $validated['email'], 'password' => $validated['password']])) {
                throw new Exception('Account creation failed.');
            }

            $user = Auth::user();

            if (!$user instanceof User) {
                throw new Exception('Failed to proceed request.');
            }

            $token = $user->createToken('fradel_n_spies_user_auth')->plainTextToken;

            DB::commit();

            return response()->json(['token' => $token], 201);
        } catch (QueryException) {
            DB::rollBack();

            return response()->json(['message' => 'Internal Server Error.'], 500);
        } catch (\Throwable $th) {
            DB::rollBack();

            return response()->json(['message' => $th->getMessage()], 400);
        }
    }

}
