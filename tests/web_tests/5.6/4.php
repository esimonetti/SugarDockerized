<?php
$ok = 'ok';

$conn = mysqli_connect('sugar-mysql:3306', 'root', 'root');
if (mysqli_connect_errno()) {
    die('Connection failed: ' . mysqli_connect_error());
}

$sql = 'CREATE DATABASE dockertest';
if (mysqli_query($conn, $sql) === TRUE) {
    mysqli_select_db($conn, 'dockertest');
    $sql = 'CREATE TABLE test ( id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255) NOT NULL )';
    if (mysqli_query($conn, $sql) === TRUE) {
        echo $ok;
    }
    $sql = 'DROP DATABASE dockertest';
    mysqli_query($conn, $sql);
}

mysqli_close($conn);
