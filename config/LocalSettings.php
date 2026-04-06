<?php


// Try to match one of our configured sites.
$conf = '';
if (defined('MW_WIKI_NAME')) {
  // This constant is set by the --wiki flag to maintenance scripts.
  $conf = MW_WIKI_NAME;
} else if (isset($_SERVER['MW_WIKI_NAME'])) {
  $conf = $_SERVER['MW_WIKI_NAME'];
} else if ($_SERVER['HTTP_HOST'] === 'badge.emfcamp.org' || $_SERVER['HTTP_HOST'] === 'badge.localhost' || str_starts_with($_SERVER['HTTP_HOST'], 'badge.localhost:')) {
  $conf = 'badge';
} else {
  if (preg_match('/^\/([0-9]+)\//', $_SERVER['REQUEST_URI'], $matches) === false) {
    die('Unable to figure out which config to use from ' . $_SERVER['REQUEST_URI']);
  }
  $conf = $matches[1];
}

if ($conf === null || $conf === '') {
  die('Unable to figure out which wiki is being accessed');
}

$settings = '/config/' . $conf . '/LocalSettings.php';
if (!file_exists($settings)) {
  http_response_code(404);
  echo '<h1>404 Not Found</h1>';
  die();
}

$wgUploadDirectory = '/images/'. $conf;
$wgFileCacheDirectory = "{$wgUploadDirectory}/cache";

require_once($settings);

$smwgConfigFileDir = '/config/' . $conf;

