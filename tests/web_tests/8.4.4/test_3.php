<?php
$ok = 'ok';

$redis = new Redis();
$redis->connect('sugar-redis', 6379);
$redis->set($ok, $ok);

if ($redis->get($ok) == $ok) {
    echo $ok;
}
