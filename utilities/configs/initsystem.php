<?php

// Enrico Simonetti
// enricosimonetti.com

if (file_exists('include/entryPoint.php')) {
    define('sugarEntry', true);
    require_once('include/entryPoint.php');
    if (empty($current_language)) {
        $current_language = $sugar_config['default_language'];
    }

    $GLOBALS['app_list_strings'] = return_app_list_strings_language($current_language);
    $GLOBALS['app_strings'] = return_application_language($current_language);
    $GLOBALS['mod_strings'] = return_module_language($current_language, 'Administration');
    $GLOBALS['locale'] = \Localization::getObject();
    $GLOBALS['current_user'] = \BeanFactory::newBean('Users');
    $GLOBALS['current_user']->getSystemUser();

    if (file_exists('../custominitsystem.php')) {
        echo 'Found custominitsystem.php, executing...' . PHP_EOL;
        include('../custominitsystem.php');
        echo 'Completed custominitsystem.php' . PHP_EOL;
    }

    echo 'Initialisation scripts completed!' . PHP_EOL;
} else {
    echo 'The system is not installed successfully, please try again' . PHP_EOL;
}
