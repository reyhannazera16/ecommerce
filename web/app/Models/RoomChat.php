<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\Relations\HasMany;

class RoomChat extends Model
{
    use HasFactory;

    protected $table = 'room_chat';

    public $timestamps = false;

    protected $fillable = [
        'pembeli',
        'penjual',
    ];

    public function pembeli(): HasOne
    {
        return $this->hasOne(User::class, 'id', 'pembeli');
    }

    public function penjual(): HasOne
    {
        return $this->hasOne(User::class, 'id', 'penjual');
    }

    public function lastchat(): HasMany
    {
        return $this->hasMany(Chat::class, 'room', 'id')->orderByDesc("id")->limit(1);
    }
}
