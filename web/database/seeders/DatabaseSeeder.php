<?php

namespace Database\Seeders;

use App\Models\DeliveryService;
use App\Models\PaymentMethod;
use App\Models\Shop;
use App\Models\User;
use App\Models\Product;
use App\Models\ProductSku;
use App\Models\UserProfile;
use App\Models\ProductDetail;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // \App\Models\User::factory(10)->create();
        User::create([
            'name' => 'Adam Najmi Zidan',
            'email' => 'anzidan@gmail.com',
            'password' => Hash::make('12345678'),
        ]);

        UserProfile::create([
            'user_id' => 1,
        ]);

        User::create([
            'name' => 'Reyhan Nazera Rusmana',
            'email' => 'rnrusmana@gmail.com',
            'password' => Hash::make('12345678'),
        ]);

        UserProfile::create([
            'user_id' => 2,
        ]);

        Shop::create([
            'user_id' => 2,
            'name' => 'Toko Bapacc Rehan'
        ]);

        User::create([
            'name' => 'Abdullah Akbar',
            'email' => 'aakbar@gmail.com',
            'password' => Hash::make('12345678'),
        ]);

        UserProfile::create([
            'user_id' => 3,
        ]);

        Shop::create([
            'user_id' => 2,
            'name' => 'Abay Sejati'
        ]);

        // Product::create([
        //     'shop_id' => 1,
        //     'name' => 'AMD Ryzen 5 4500',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 1,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 1,
        //     'name' => 'Tray',
        //     'price' => 1000000
        // ]);

        // ProductSku::create([
        //     'product_id' => 1,
        //     'name' => 'Box',
        //     'price' => 1300000
        // ]);

        // ///

        // Product::create([
        //     'shop_id' => 1,
        //     'name' => 'GeForce RTX 2060 Super',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 2,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 2,
        //     'name' => '8GB VRAM',
        //     'price' => 2000000
        // ]);

        // ProductSku::create([
        //     'product_id' => 2,
        //     'name' => '16GB VRAM',
        //     'price' => 300000
        // ]);

        // ///

        // Product::create([
        //     'shop_id' => 1,
        //     'name' => 'Klevv BoltX Kit 16GB (2x8GB)',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 3,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 3,
        //     'name' => 'Non Heatsink',
        //     'price' => 400000
        // ]);

        // ProductSku::create([
        //     'product_id' => 3,
        //     'name' => 'Heatsink',
        //     'price' => 500000
        // ]);

        // //

        // Product::create([
        //     'shop_id' => 1,
        //     'name' => 'Asrock B450M-HDV R4.0',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 4,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 4,
        //     'name' => 'Mobo Only',
        //     'price' => 900000
        // ]);

        // ProductSku::create([
        //     'product_id' => 4,
        //     'name' => 'Extra Bubblewrap',
        //     'price' => 950000
        // ]);

        // //

        // Product::create([
        //     'shop_id' => 1,
        //     'name' => 'NVME Team 512GB',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 5,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 5,
        //     'name' => 'Non Heatsink',
        //     'price' => 900000
        // ]);

        // ProductSku::create([
        //     'product_id' => 5,
        //     'name' => 'Heatsink',
        //     'price' => 1000000
        // ]);

        // //

        // Product::create([
        //     'shop_id' => 1,
        //     'name' => 'WD Black Harddisk 1TB',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 6,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 6,
        //     'name' => 'Unit Only',
        //     'price' => 500000
        // ]);

        // ProductSku::create([
        //     'product_id' => 6,
        //     'name' => 'Extra Bubblewrap',
        //     'price' => 600000
        // ]);

        // //

        // Product::create([
        //     'shop_id' => 2,
        //     'name' => 'AMD Ryzen 5 5500',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 7,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 7,
        //     'name' => 'Tray',
        //     'price' => 1300000
        // ]);

        // ProductSku::create([
        //     'product_id' => 7,
        //     'name' => 'Box',
        //     'price' => 1500000
        // ]);

        // //

        // Product::create([
        //     'shop_id' => 2,
        //     'name' => 'GeForce RTX 3060',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 8,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 8,
        //     'name' => 'VRAM 8GB',
        //     'price' => 3300000
        // ]);

        // ProductSku::create([
        //     'product_id' => 8,
        //     'name' => 'VRAM 16GB',
        //     'price' => 4300000
        // ]);

        // //

        // Product::create([
        //     'shop_id' => 2,
        //     'name' => 'Team Group Kit 16GB (2x8GB)',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 9,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 9,
        //     'name' => 'Non Heatsink',
        //     'price' => 550000
        // ]);

        // ProductSku::create([
        //     'product_id' => 9,
        //     'name' => 'Heatsink',
        //     'price' => 600000
        // ]);

        // //

        // Product::create([
        //     'shop_id' => 2,
        //     'name' => 'MSI B450M-A PRO',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 10,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 10,
        //     'name' => 'Mobo Only',
        //     'price' => 1100000
        // ]);

        // ProductSku::create([
        //     'product_id' => 10,
        //     'name' => 'Extra Bubblewrap',
        //     'price' => 1200000
        // ]);

        // //

        // Product::create([
        //     'shop_id' => 2,
        //     'name' => 'KYO NVME 512GB',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 11,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 11,
        //     'name' => 'Heatsink',
        //     'price' => 900000
        // ]);

        // ProductSku::create([
        //     'product_id' => 11,
        //     'name' => 'Non Heatsink',
        //     'price' => 800000
        // ]);

        // //

        // Product::create([
        //     'shop_id' => 2,
        //     'name' => 'WD Blue Harddisk 1TB',
        // ]);

        // ProductDetail::create([
        //     'product_id' => 12,
        //     'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        // ]);

        // ProductSku::create([
        //     'product_id' => 12,
        //     'name' => 'Unit only',
        //     'price' => 200000
        // ]);

        // ProductSku::create([
        //     'product_id' => 12,
        //     'name' => 'Extra Bubblewrap',
        //     'price' => 250000
        // ]);

        PaymentMethod::create([
            'name' => 'BCA 7361128404 an Mohamad Iqbal Suriansyah',
        ]);

//        PaymentMethod::create([
//            'name' => 'BiNI',
//        ]);

//        PaymentMethod::create([
//            'name' => 'GoBay',
//        ]);

//        PaymentMethod::create([
//            'name' => 'DADON',
//        ]);

        DeliveryService::create([
            'name' => 'JNT',
        ]);

        DeliveryService::create([
            'name' => 'JNE',
        ]);

//        DeliveryService::create([
//            'name' => 'Pixel',
//        ]);
    }
}
