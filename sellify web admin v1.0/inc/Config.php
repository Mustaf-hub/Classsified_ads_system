<?php
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
try {
  $sellify = new mysqli("localhost", "username", "password", "database");
  $sellify->set_charset("utf8mb4"); 
  $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https' : 'http';
// Get the domain (host)
$domain = $_SERVER['HTTP_HOST'];
// Get the main URL (without path/query)
$main_url = $protocol . '://' . $domain;
} catch(Exception $e) {
  error_log($e->getMessage());
  //Should be a message a typical user could understand
}
    
$set = $sellify->query("SELECT * FROM `tbl_setting`")->fetch_assoc();
date_default_timezone_set($set['timezone']);
$prints = $sellify->query("select * from tbl_sell")->fetch_assoc();	
?>