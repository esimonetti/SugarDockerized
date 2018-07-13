<?php
session_start();
$ok = 'ok';

$redis = new Redis();
$redis->connect('sugar-redis', 6379);
$keys = $redis->keys('*');

if (!empty($keys[$ok]) && $redis->get($ok) == $ok) {
    echo $ok;
}
