<?php
$ok = 'ok';
$url = 'http://sugar-elasticsearch:9200/';
require 'vendor/autoload.php';

use GuzzleHttp\Client;

$client = new Client(
    array(
        'timeout'  => 4.0,
        'headers' => array(
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
        )
    )
);

$error = true;

$response = $client->get($url . '_stats');
if ($response->getStatusCode() == 200) {

    $response = $client->put($url . 'testbucket');
    if ($response->getStatusCode() == 200) {
        $response = $client->put(
            $url . 'testbucket/_doc/enrico?refresh=true',
            array (
                //'debug' => TRUE,
                'json' => array(
                    'name' => 'Enrico Simonetti'
                )
            )
        );
        if ($response->getStatusCode() == 201) {
            $response = $client->get(
                $url . 'testbucket/_search',
                array(
                    //'debug' => TRUE,
                    'query' => array(
                        'q' => 'simonetti'
                    )
                )  
            );
            $decoded = json_decode($response->getBody(), true);
            if (!empty($decoded['hits'])
                && $decoded['hits']['total']['value'] === 1
                && $decoded['hits']['hits']['0']['_id'] === 'enrico') {
                // expected result found
                $error = false;
            }
        }

        $response = $client->delete($url . 'testbucket');
    }
}

if (!$error) {
    echo $ok;
}
