<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'product_id',
        'payment_method_id',
        'delivery_service_id',
        'shipping_address_id',
        'status',
        'tracking_number',
        'qty',
        'price',
        'is_deleted' 
    ];
}
