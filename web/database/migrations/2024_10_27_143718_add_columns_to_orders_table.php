<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->string('status')->default('pending')->after('shipping_address_id');
            $table->string('tracking_number')->nullable()->after('status');
            $table->integer('qty')->default(1)->after('tracking_number');
            $table->integer('price')->default(0)->after('qty');
        });
    }

    public function down()
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['status', 'tracking_number', 'qty', 'price']);
        });
    }
};