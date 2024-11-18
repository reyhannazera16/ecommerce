<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Chat extends Model
{
    use HasFactory;

    protected $table = "Chats";

    public $timestamps = false;

    protected $fillable = [
        'dari_user', 
        'untuk_user',
        'pesan',     
        'room_id',   
    ];

    public function sender()
    {
        return $this->belongsTo(User::class, 'dari_user', 'id');
    }

    public function receiver()
    {
        return $this->belongsTo(User::class, 'untuk_user', 'id');
    }

    public function roomChat()
    {
        return $this->belongsTo(RoomChat::class, 'room_id', 'id');
    }
}
