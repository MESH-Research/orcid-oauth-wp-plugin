# ORCiD Plugin for WordPress with OAuth Authentication

ORCiD plugin for WordPress with OAuth Authentication.

## GUI Install Instructions
- Download the zip package from this site
- Go to the plugins page on your Wordpress site and use the "Add New" and "Upload Plugin" to upload the plugin
- Activate once it's installed

## Install Instructions

- Copy the content of this repo into: `WP_HOME/wp-content/plugins/orcid`

- Register with ORCiD to obtain your OAuth ID and secret codes.

- Copy `orcid-oauth-dist.php` to `orcid-oauth.php`

- Add the ORCiD OAuth ID and secrets to `orcid-oauth.php`

- Edit the following files based on which API you will be using Public (production) or Sandbox (development and testing).
  In each file (un)comment the lines corresponding to the API you want to use. 

- `config.php`
```
// sandbox
define( 'ORCID_URL', 'https://pub.sandbox.orcid.org/v3.0/');
// public
//define( 'ORCID_URL', 'https://pub.orcid.org/v3.0/');

// ...

// sandbox
define( 'ORCID_AUTH_URI', 'https://sandbox.orcid.org/oauth/token');
// public
//define( 'ORCID_AUTH_URI', 'https://orcid.org/oauth/token');
```
    
- `orcid-functions`
```
// sandbox
$orcid_request_uri = 'https://sandbox.orcid.org/oauth/authorize?' .
// public
//$orcid_request_uri = 'https://orcid.org/oauth/authorize?' .
                     'client_id=' . ORCID_OAUTH_CLIENT_ID . '&' .
                     'response_type=code&' .
                     'scope=/authenticate&' .
                     'redirect_uri=' . ORCID_OAUTH_REDIRECT_URI;
```
