<?php
$ok = 'ok';

$conn = new mysqli('sugar-mysql', 'root', 'root');
if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}

$sql = 'CREATE DATABASE dockertest';
if ($conn->query($sql) === TRUE) {
    mysqli_select_db($conn, 'dockertest');
    $sql = 'CREATE TABLE test ( id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255) NOT NULL )';
    if ($conn->query($sql) === TRUE) {
        echo $ok;
    }
    $sql = 'DROP DATABASE dockertest';
    $conn->query($sql);
}

$conn->close();
