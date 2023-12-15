<?php

if (!defined('sugarEntry')) {
    define('sugarEntry', true);
}

require_once('config.php');
if (file_exists('config_override.php')) {
    require_once('config_override.php');
}

require_once('include/entryPoint.php');

echo("Preparing SystemUser...\n");
$u = \BeanFactory::newBean('Users');
$GLOBALS['current_user'] = $u->getSystemUser();

echo("Running QRR...\n");
$repair = new \RepairAndClear();
$repair->repairAndClearAll(['clearAll'], [$mod_strings['LBL_ALL_MODULES']], true, false, '');

echo("Rebuilding cache...\n");
\SugarAutoLoader::buildCache();

echo("Warming up Services...\n");
$sd = new \ServiceDictionary();
$sd->buildAllDictionaries();

echo("Done repairing...\n");
