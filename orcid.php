<?php
/**
 * Plugin Name: orcid
 * Plugin URI: http://orcid2.joshia.msu.domains/
 * Description: Get ORCiD data using OAuth.
 * Version: 1.0
 * Author: Amaresh R. Joshi
 * Author URI: http://joshia.msu.domains/
 */

/**
 * ... insert any required ownership and copyright boilerplate here
 */
include_once( plugin_dir_path( __FILE__ ) . 'config.php');
include_once( plugin_dir_path( __FILE__ ) . 'orcid-oauth.php');
include( MY_PLUGIN_PATH . 'orcid-functions.php');

/************************
 * WORDPRESS HOOKS
 ************************/

/**
 * add actions to the (de)install activation hooks
 */
register_activation_hook(__FILE__, 'orcid_install');
register_deactivation_hook(__FILE__, 'orcid_uninstall');

//add_action('wp_enqueue_scripts', 'orcid_scripts');
//add_action('admin_enqueue_scripts', 'orcid_scripts');
add_action('admin_menu', 'orcid_create_menu');

/**
 * install procedures:
 * schedule daily event to update publication lists
 */
function orcid_install()
{
    // empty for now
}

/**
 * un-install procedures:
 * remove any scheduled tasks
 */
function orcid_uninstall()
{
    // empty for now
}

/**
 * add javascript and stylesheets to both the admin page and front-end.
 * hooked by 'wp_enqueue_scripts' and 'admin_enqueue_scripts'
 */
function orcid_scripts()
{
    // empty for now
    // wp_enqueue_style('orcid_style', plugins_url('ip_style.css', __FILE__));
    // wp_enqueue_script('orcid_script', plugins_url('ip_script.js', __FILE__), array('jquery'), null, true);
}

/************************
 * SHORTCODE HOOKS
 ************************/
/**
 * register the shortcode
 */
function register_shortcodes(){
	add_shortcode('orcid-data', 'orcid_data_function');
}
/**
 * hook into WordPress
 */
add_action( 'init', 'register_shortcodes');

/**
 * create the admin menu
 * hooked by admin_menu event
 */
function orcid_create_menu()
{
    add_menu_page('My ORCiD Retrieval and Display Information', 'My ORCiD Profile',
        'edit_posts', __FILE__, 'orcid_settings_form');
}

/**
 * create and handle the settings form
 * hooked by orcid_create_menu
 *
 */
function orcid_settings_form()
{
    $user_ob = wp_get_current_user();
    $user = $user_ob->ID;

    echo '<h1>MSU Commons ORCiD Profile Registration Setup</h1>';

    if (isset($_GET['error']))
    {
        //
        // user declined permission to share ORCiD data with MSU Commons
        echo '<p>You did not allow ORCiD to send your profile information to MSU Commons</p>';
        echo '<p>All your ORCiD related metadata will be removed from MSU Commons.</p>';
        echo '<p>You can always return to this page and reconnect with ORCiD.</p>';
        //
        // delte any ORCiD related user metadata
        delete_user_meta($user, '_orcid_id');
        delete_user_meta($user, '_orcid_access_token');
        delete_user_meta($user, '_orcid_xml');
        delete_user_meta($user, '_orcid_xml_download_time');

        //
        exit(0);

        } elseif (! isset($_GET['code']))
    {
        //
        // user has not logged in yet so no code has been returned from ORCiD
        // provide a link to the ORCiD login
        $orcid_request_uri = 'https://sandbox.orcid.org/oauth/authorize?' .
            'client_id=' . ORCID_OAUTH_CLIENT_ID . '&' .
            'response_type=code&' .
            'scope=/authenticate&' .
            'redirect_uri=' . ORCID_OAUTH_REDIRECT_URI;

        // orcid suggested we use their button image since it is easily recognizable
        echo "<a href=\"$orcid_request_uri\">" . ORCID_LOGIN_BUTTON_URI . '</a>';
        //
        exit(0);
        /************************************************************/

    } elseif (isset($_GET['code']))
    {
        $foo = 1;
        /************************************************************/
        //
        // user has returned from ORCiD.
        // use their returned 'code' to get authorization token, orcid_id, etc
        $orcid_code = $_GET['code'];

        // POST data
        $fields = [
            'client_id' => ORCID_OAUTH_CLIENT_ID,
            'client_secret' => ORCID_OAUTH_CLIENT_SECRET,
            'grant_type' => 'authorization_code',
            'code' => $orcid_code,
            'redirect_uri' => ORCID_OAUTH_REDIRECT_URI
        ];
        // url-ify the data ("a=b&c=d&f=g")
        $fields_string = http_build_query($fields);

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $fields_string);
        // allow insecure connections
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        // do not include HTTP headers in output
        curl_setopt($ch, CURLOPT_HEADER, false);
        // allow server redirects
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        // return output as a string
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_URL, ORCID_AUTH_URI);
        $headers = [
            'Accept: application/json'
        ];
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

        try {
            $orcid_json = curl_exec($ch);
        } catch (Exception $e) {
            throw new Exception($e);
        }
        curl_close($ch);

        // convert json into assoc array
        $orcid_token = json_decode($orcid_json, true);
        //
        // fields are:
        //"access_token":"***"
        //"token_type":"bearer",
        //"refresh_token":"***",
        //"expires_in":631138518,  = 20 years in seconds
        //"scope":"/authenticate",
        //"name":"***",
        //"orcid":"***"
        //
        // store in user_meta
        update_user_meta($user, '_orcid_id', $orcid_token['orcid']);
        update_user_meta($user, '_orcid_access_token', $orcid_token['access_token']);

        echo '<p>Congratulations ' . $orcid_token['name'] . ' (ORCiD ID: ' . $orcid_token['orcid'] .
            ') you have successfully logged into ORCiD.</p>';
        echo '<p>Your ORCiD profile will be available from MSU Commons.</p>';

        $orcid_xml = download_orcid_data($orcid_token['orcid'], $orcid_token['access_token']);

        // set which sections to display
        $display_sections['display_header'] = 'yes';
        $display_sections['display_personal'] = 'yes';
        $display_sections['display_education'] = 'yes';
        $display_sections['display_employment'] = 'yes';
        $display_sections['display_works'] = 'yes';
        $display_sections['display_fundings'] = 'yes';
        $display_sections['display_peer_reviews'] = 'yes';
        $display_sections['display_invited_positions'] = 'yes';
        $display_sections['display_memberships'] = 'yes';
        $display_sections['display_qualifications'] = 'yes';
        $display_sections['display_research_resources'] = 'yes';
        $display_sections['display_services'] = 'yes';

        $orcid_html = format_orcid_data_as_html($orcid_xml, $display_sections);
        echo $orcid_html;

        exit(0);
        /************************************************************/
    }
}
