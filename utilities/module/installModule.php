<?php

// Enrico Simonetti
// enricosimonetti.com
// adapted from https://github.com/esimonetti/sugarcrm-silent-module-installer

if (!empty($argv[1]) && file_exists($argv[1]) && is_readable($argv[1])) {
    $zipFile = $argv[1];
    $packageDir = './cache/tmp/sugarpkg_' . rand(10000,99999);
    mkdir($packageDir, 0777, true);

    if (!is_dir($packageDir)) {
        echo 'Failed to create temporary directory ' . $packageDir . PHP_EOL;
        exit(1);
    }

    if (!is_readable('config.php') || !is_readable('sugar_version.php')) {
        echo 'The current directory is not a Sugar system' . PHP_EOL;
        exit(1);
    }

    if (!defined('sugarEntry')) define('sugarEntry', true);
    require('config.php');
    require_once('include/entryPoint.php');
    require_once('include/dir_inc.php');
    require_once('include/utils/zip_utils.php');
    require_once('ModuleInstall/ModuleInstaller.php');
    $current_user = new User();
    $current_user->getSystemUser();

    $_REQUEST['install_file'] = '';
    unzip($zipFile, $packageDir);

    if (!is_readable($packageDir . '/manifest.php')) {
        echo 'The installable package does not contain a readable manifest.php' . PHP_EOL;
        exit(1);
    }

    require_once($packageDir . '/manifest.php');
    if (!is_array($manifest)) {
        echo '\$manifest is not set within manifest.php' . PHP_EOL;
        exit(1);
    }

    if (!array_key_exists('name', $manifest) || $manifest['name'] == '') {
        echo 'The installable package does not contain a name property' . PHP_EOL;
        exit(1);
    }

    $modInstaller = new ModuleInstaller();
    $modInstaller->silent = true;

    $GLOBALS['app_list_strings']['moduleList'] = [];

    $up = new UpgradeHistory();
    $up->name = $manifest['name'];
    if ($up->checkForExisting($up) !== null) {
        echo 'The installable package has been previously installed' . PHP_EOL;
        exit(0);
    }

    echo 'Installing ' . $zipFile . PHP_EOL;
    $modInstaller->install($packageDir);

    $content = [
        'manifest' => $manifest,
        'installdefs' => isset($installdefs) ? $installdefs : [],
        'upgrade_manifest' => isset($upgrade_manifest) ? $upgrade_manifest : [],
    ];

    mkdir('upload/upgrades/module/', 0777, true);
    copy($zipFile, 'upload/upgrades/module/' . basename($zipFile));

    $up->filename = 'upload/upgrades/module/' . basename($zipFile);
    $up->name = $manifest['name'];
    $up->md5sum = md5_file($zipFile);
    $up->type = array_key_exists('type', $manifest) ? $manifest['type'] : 'module';
    $up->version = array_key_exists('version', $manifest) ? $manifest['version'] : '';
    $up->status = 'installed';
    $up->author = array_key_exists('author', $manifest) ? $manifest['author'] : '';
    $up->description = array_key_exists('description', $manifest) ? $manifest['description'] : '';
    $up->id_name = array_key_exists('id', $installdefs) ? $installdefs['id'] : '';
    $up->manifest = base64_encode(serialize($content));
    $up->save();

    echo 'Installation completed' . PHP_EOL;
    echo 'Deleting temporay directory ' . $packageDir . PHP_EOL;
    rmdir_recursive($packageDir);

    echo 'Repairing' . PHP_EOL;
    $repair = new RepairAndClear();
    $repair->repairAndClearAll(['clearAll'], ['All Modules'], true, false, '');
}
