<?php
$config = [
    'setup_db_type' => 'mysql',
    'setup_db_host_name' => 'sugar-mysql',
    'setup_db_database_name' => 'sugar',
    'setup_db_admin_user_name' => 'root',
    'setup_db_admin_password' => 'root',
    'setup_db_drop_tables' => 1,
    'setup_db_create_database' => 1,
    'setup_site_admin_user_name' => 'admin',
    'setup_site_admin_password' => 'asdf',
    'setup_site_url' => 'http://docker.local/sugar',
    'setup_host_name' => 'docker.local',
    'setup_system_name' => 'Sugar On SugarDockerized',
    'setup_fts_type' => 'Elastic',
    'setup_fts_host' => 'sugar-elasticsearch',
    'setup_fts_port' => '9200',
    'default_currency_iso4217' => 'USD',
    'default_currency_name' => 'US Dollars',
    'default_currency_significant_digits' => '2',
    'default_currency_symbol' => '$',
    'default_date_format' => 'Y-m-d',
    'default_time_format' => 'H:i',
    'default_decimal_seperator' => '.',
    'default_export_charset' => 'ISO-8859-1',
    'default_language' => 'en_us',
    'default_locale_name_format' => 's f l',
    'default_number_grouping_seperator' => ',',
    'export_delimiter' => ',',
    'demoData' => 'yes',
    'developerMode' => false,
];

include('install_config_custom.php');
$config = array_merge($config, $config_override);

echo '<?php
$sugar_config_si = ';
var_export($config);
echo ';' . PHP_EOL;
