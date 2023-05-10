<?php
session_start();
$ok = 'ok';

$_SESSION[$ok] = $ok;

if ($_SESSION[$ok] == $ok) {
    echo $ok;
}
