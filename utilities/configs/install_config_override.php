<?php
$config = [
    'default_minify_resources' => false,
    'external_cache_disabled' => false,
    'external_cache_disabled_redis' => false,
    'external_cache' => [
        'redis' => [
            'host' => 'sugar-redis',
        ],
    ],
    'external_cache_disabled_db' => true,
    'cache_expire_timeout' => 600,
    'disable_vcr' => true,
    'disable_count_query' => true,
    'dump_slow_queries' => true,
    'slow_query_time_msec' => 500,
    'import_max_records_total_limit' => 2000,
    'verify_client_ip' => false,
    'default_permissions' => [
        'user' => 'sugar',
        'group' => 'sugar',
    ],
];

include('custom_install_config_override.php');

$config = array_merge_recursive($config, $config_override);

echo '<?php' . PHP_EOL;
$arrayUtilsFile = './include/utils/array_utils.php';
if (file_exists($arrayUtilsFile)) {
    require_once($arrayUtilsFile);
    foreach ($config as $key => $val) {
        echo override_value_to_string_recursive2('sugar_config', $key, $val); 
    }
} else {
    echo '$sugar_config = ';
    var_export($config);
    echo ';' . PHP_EOL;
}
