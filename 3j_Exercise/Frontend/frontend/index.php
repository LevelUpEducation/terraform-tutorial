<?php

require_once (dirname(__FILE__) . '/require/Requests.php');

$msg = 'Its cool';

Requests::register_autoloader();

$url = 'http://127.0.0.1:8000/api/v1/response/?msg=';


$url_list = array('insert_your_urls_here_as_you_see_above_like_$url');

$headers = array('Accept' => 'application/json');
$options = array('auth' => array('user', 'pass'));


foreach ($url_list as $url) {
    
    $request = Requests::get($url . $msg, $headers, $options);

    print($request->body);
    print(PHP_EOL);

// var_dump($request->body);
};


?>
