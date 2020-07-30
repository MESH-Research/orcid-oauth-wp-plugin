<?php
define( 'MY_PLUGIN_PATH', plugin_dir_path( __FILE__ ) );

// time in seconds before reloading orcid data from orcid.org
define( 'ORCID_CACHE_TIMEOUT', 3600);
// XSLT file to convert orcid xml to html
define( 'ORCID_XSLT', MY_PLUGIN_PATH . 'orcid-data-all.xsl');

// sandbox
//define( 'ORCID_URL', 'https://pub.sandbox.orcid.org/v3.0/');
// public
define( 'ORCID_URL', 'https://pub.orcid.org/v3.0/');
// see other examples at:
// https://github.com/ORCID/orcid-model/blob/master/src/main/resources/record_2.0/README.md#read-sections

// NOTE: do NOT use "...page=orcid%2Forcid.php"
// This will result in a "Redirect URI mismatch" error
define( 'ORCID_OAUTH_REDIRECT_URI', 'https://orcid2.joshia.msu.domains/wp-admin/admin.php?page=orcid/orcid.php');

// sandbox
//define( 'ORCID_AUTH_URI', 'https://sandbox.orcid.org/oauth/token');
// public
define( 'ORCID_AUTH_URI', 'https://orcid.org/oauth/token');

define( 'ORCID_LOGIN_BUTTON_URI',
    '<img src="https://members.orcid.org/sites/default/files/create_connect_button.png" alt="ORCiD Login" style="width: 268px; height: 55px;">');

//
// these are defined in orcid-oauth.php
// ORCID_OAUTH_CLIENT_ID
// ORCID_OAUTH_CLIENT_SECRET
