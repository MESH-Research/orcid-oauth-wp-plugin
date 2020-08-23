<?php
include_once( plugin_dir_path( __FILE__ ) . 'config.php');
include_once( plugin_dir_path( __FILE__ ) . 'orcid-oauth.php');

/**
 * download data from orcid.org
 *
 * @param string $orcid_id - ORCiD ID
 * @return string $orcid_xml
 */
function download_orcid_data($user, $orcid_id, $orcid_access_token){
    $orcid_link = ORCID_URL . $orcid_id . "/record";

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_URL, $orcid_link);
    $headers = [
    'Accept: application/vnd.orcid+xml',
    "Authorization: Bearer " . $orcid_access_token
    ];
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    try {
    $orcid_xml = curl_exec($ch);
    } catch (Exception $e) {
    throw new Exception($e);
    }
    curl_close($ch);
    //
    // store xml and when download occured
    update_user_meta($user, '_orcid_xml', $orcid_xml);
    update_user_meta($user, '_orcid_xml_download_time', strval(time()));

    return $orcid_xml;
}

/**
 * format the orcid XML into HTML with XSLT
 *
 * parameters:
 * @param string $orcid_xml - XML as string
 * @param array $display_sections - which sections of orcid data to display
 * @return string orcid_html
 */
function format_orcid_data_as_html($orcid_xml, $display_sections){
    $xml_doc = new DOMDocument();
    $xml_doc->loadXML($orcid_xml);

    $xsl_doc = new DOMDocument();
    $xsl_doc->load(ORCID_XSLT);

    $html_doc = new XSLTProcessor();

    //
    // control which sections are displayed
	$html_doc->setParameter('', 'display_header', $display_sections['display_header']);
	// $html_doc->setParameter('', 'display_header', 'yes');
	$html_doc->setParameter('', 'display_personal', $display_sections['display_personal']);
    $html_doc->setParameter('', 'display_education', $display_sections['display_education']);
    $html_doc->setParameter('', 'display_employment', $display_sections['display_employment']);
    $html_doc->setParameter('', 'display_works', $display_sections['display_works']);
    $html_doc->setParameter('', 'display_fundings', $display_sections['display_fundings']);
	$html_doc->setParameter('', 'display_peer_reviews', $display_sections['display_peer_reviews']);
	$html_doc->setParameter('', 'display_invited_positions', $display_sections['display_invited_positions']);
	$html_doc->setParameter('', 'display_memberships', $display_sections['display_memberships']);
	$html_doc->setParameter('', 'display_qualifications', $display_sections['display_qualifications']);
	$html_doc->setParameter('', 'display_research_resources', $display_sections['display_research_resources']);
	$html_doc->setParameter('', 'display_services', $display_sections['display_services']);

    $html_doc->importStylesheet($xsl_doc);
    $orcid_html =  $html_doc->transformToXML($xml_doc);

    return $orcid_html;
}

/**
 * Call back function for shortword [orcid-data section="section_name"]
 *
 * parameters:
 * @param array $atts - contains the name of the section to display. if none is specified the header line is displayed
 * @return string shortcode value
 *
 */
function orcid_data_function($atts) {
	//
	// which section of the orcid data to display.
	//if no section is specified display the header by default
	extract(shortcode_atts(array('section' => 'header',), $atts));
	//
	// now we want to display the *author's* (not the viewer's) data

	//
	// get the author's WordPress user id
    // metadata is stored as strings so we need to convert to int
    $author = intval(get_the_author_meta('ID', false));

    //************************************************
    // if the user has disconnected her ORCID account
    // from the commons we cannot proceed.
    // in the case send back an error or blank string
    if (empty(get_user_meta($author, '_orcid_id', true))) {
        return "ORCiD data not available";
    }


	//
	// get orcid data
	//
	// we can either download the data from orcid.org OR use the cached value
	// we download the data IFF ($download_from_orcid_flag = true)
	// 1) there is no cached xml data
	// 2) the cached value is older than ORCID_CACHE_TIMEOUT (in seconds)
	//
	$download_from_orcid_flag = false;
	//
	// 2) there is no cached xml data
	if(empty(get_user_meta($author, '_orcid_xml', true))){
		$download_from_orcid_flag = true;
	}
	//
	// 3) the cached value is older than ORCID_CACHE_TIMEOUT (in seconds)
	$current_time = time();
	// last download time
	$orcid_xml_download_time = intval(get_user_meta($author, '_orcid_xml_download_time', true));
	//
	$time_diff = $current_time - $orcid_xml_download_time;
	if($time_diff >= ORCID_CACHE_TIMEOUT){
		$download_from_orcid_flag = true;
	}

	if($download_from_orcid_flag) {
		// downloading data from ORCID
        $orcid_id = get_user_meta($author, '_orcid_id', true);
        $orcid_access_token = get_user_meta($author, '_orcid_access_token', true);
		$orcid_xml = download_orcid_data($author, $orcid_id, $orcid_access_token);
		update_user_meta($author, '_orcid_xml', $orcid_xml);
		//
		// keep track of when download occurred
		update_user_meta($author, '_orcid_xml_download_time', strval(time()));
	} else {
		// using cached data
		$orcid_xml = get_user_meta($author, '_orcid_xml', true);
	}


	//
	// determine which section to display
	if ($section == 'header') {
		$display_sections['display_header'] = 'yes';
	} else {
		$display_sections['display_header'] = 'no';
	}
	if ($section == 'personal') {
		$display_sections['display_personal'] = 'yes';
	} else {
		$display_sections['display_personal'] = 'no';
	}
	if ($section == 'education') {
		$display_sections['display_education'] = 'yes';
	} else {
		$display_sections['display_education'] = 'no';
	}
	if ($section == 'employment') {
		$display_sections['display_employment'] = 'yes';
	} else {
		$display_sections['display_employment'] = 'no';
	}
	if ($section == 'works') {
		$display_sections['display_works'] = 'yes';
	} else {
		$display_sections['display_works'] = 'no';
	}
	if ($section == 'fundings') {
		$display_sections['display_fundings'] = 'yes';
	} else {
		$display_sections['display_fundings'] = 'no';
	}
	if ($section == 'peer_reviews') {
		$display_sections['display_peer_reviews'] = 'yes';
	} else {
		$display_sections['display_peer_reviews'] = 'no';
	}
	if ($section == 'invited_positions') {
		$display_sections['display_invited_positions'] = 'yes';
	} else {
		$display_sections['display_invited_positions'] = 'no';
	}
	if ($section == 'memberships') {
		$display_sections['display_memberships'] = 'yes';
	} else {
		$display_sections['display_memberships'] = 'no';
	}
	if ($section == 'qualifications') {
		$display_sections['display_qualifications'] = 'yes';
	} else {
		$display_sections['display_qualifications'] = 'no';
	}
	if ($section == 'research_resources') {
		$display_sections['display_research_resources'] = 'yes';
	} else {
		$display_sections['display_research_resources'] = 'no';
	}
	if ($section == 'services') {
		$display_sections['display_services'] = 'yes';
	} else {
		$display_sections['display_services'] = 'no';
	}
	//
	// format as HTML
	$orcid_html = format_orcid_data_as_html($orcid_xml, $display_sections);
	return $orcid_html;
}

/**
 *
 * Display the ORCiD button on the current webpage
 *
 * parameters: none
 *
 */
function orcid_display_login_button()
{
    // sandbox api: 'https://sandbox.orcid.org/oauth/authorize?'
    // public api:  'https://orcid.org/oauth/authorize?'
    $orcid_request_uri = 'https://orcid.org/oauth/authorize?' .
        'client_id=' . ORCID_OAUTH_CLIENT_ID . '&' .
        'response_type=code&' .
        'scope=/authenticate&' .
        'redirect_uri=' . ORCID_OAUTH_REDIRECT_URI;

    // orcid suggested we use their button image since it is easily recognizable
    echo "<a href=\"$orcid_request_uri\">" . ORCID_LOGIN_BUTTON_URI . '</a>';

}

/**
 * Display the users ORCiD data
 *
 * parameters:
 * @param $orcid_xml string - users ORCiD data
 *
 */
function orcid_display_orcid_data($orcid_xml)
{

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
}
// for testing
//$orcidID = "0000-0003-0265-9119"; // Alan Munn
//$orcidID = "0000-0003-1822-3109";  // Bronson Hui
//$orcidID = "0000-0002-8143-2408"; // Scott Schopieray
//$orcidID = "0000-0003-3953-7940"; // Chris Long (U of CO at Boulder)
//$orcidID = "0000-0002-5251-0307"; // Kathleen Fitzpatrick
