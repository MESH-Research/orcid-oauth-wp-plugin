<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:internal="http://www.orcid.org/ns/internal"
                xmlns:funding="http://www.orcid.org/ns/funding"
                xmlns:preferences="http://www.orcid.org/ns/preferences"
                xmlns:address="http://www.orcid.org/ns/address"
                xmlns:education="http://www.orcid.org/ns/education"
                xmlns:work="http://www.orcid.org/ns/work"
                xmlns:deprecated="http://www.orcid.org/ns/deprecated"
                xmlns:other-name="http://www.orcid.org/ns/other-name"
                xmlns:history="http://www.orcid.org/ns/history"
                xmlns:employment="http://www.orcid.org/ns/employment"
                xmlns:error="http://www.orcid.org/ns/error"
                xmlns:common="http://www.orcid.org/ns/common"
                xmlns:person="http://www.orcid.org/ns/person"
                xmlns:activities="http://www.orcid.org/ns/activities"
                xmlns:record="http://www.orcid.org/ns/record"
                xmlns:researcher-url="http://www.orcid.org/ns/researcher-url"
                xmlns:peer-review="http://www.orcid.org/ns/peer-review"
                xmlns:personal-details="http://www.orcid.org/ns/personal-details"
                xmlns:bulk="http://www.orcid.org/ns/bulk"
                xmlns:keyword="http://www.orcid.org/ns/keyword"
                xmlns:email="http://www.orcid.org/ns/email"
                xmlns:external-identifier="http://www.orcid.org/ns/external-identifier"
                xmlns:distinction="http://www.orcid.org/ns/distinction"
                xmlns:membership="http://www.orcid.org/ns/membership"
                xmlns:invited-position="http://www.orcid.org/ns/invited-position"
                xmlns:qualification="http://www.orcid.org/ns/qualification"
                xmlns:service="http://www.orcid.org/ns/service"
                xmlns:research-resource="http://www.orcid.org/ns/research-resource" version="1.0">

    <!-- parameters -->
    <!-- NOTE: parameter values must be quoted if you want strings (and not XPath entries) -->
    <xsl:param name="display_header" select="'yes'"/>
    <xsl:param name="display_personal" select="'yes'"/>
    <xsl:param name="display_education" select="'yes'"/>
    <xsl:param name="display_employment" select="'yes'"/>
    <xsl:param name="display_works" select="'yes'"/>
    <xsl:param name="display_fundings" select="'yes'"/>
    <xsl:param name="display_peer_reviews" select="'yes'"/>
    <xsl:param name="display_invited_positions" select="'yes'"/>
    <xsl:param name="display_memberships" select="'yes'"/>
    <xsl:param name="display_qualifications" select="'yes'"/>
    <xsl:param name="display_research_resources" select="'yes'"/>
    <xsl:param name="display_services" select="'yes'"/>

    <!-- output format -->
    <xsl:output omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="/">

        <div id="orcid_data">
            <xsl:if test="$display_header='yes'">
                <h2>
                    <div id="orcid_header">
                        <xsl:value-of select="record:record/person:person/person:name/personal-details:given-names"/>
                        <!-- &#160; = &nbsp; -->
                        <xsl:text>&#160;</xsl:text>
                        <xsl:value-of select="record:record/person:person/person:name/personal-details:family-name"/>
                        <xsl:text>&#160;</xsl:text>
                        ORCID Profile
                    </div>
                </h2>
            </xsl:if>

            <!-- START: personal -->
            <xsl:if test="$display_personal='yes'">
                <h3>
                    <div>Biographical Information</div>
                </h3>
                <!-- name -->
                <div>
                    <xsl:if test="record:record/person:person/person:name">
                        <h4>
                            <div>Name Information</div>
                        </h4>
                        <xsl:choose>
                            <xsl:when test="record:record/person:person/person:name/personal-details:credit-name">
                                <xsl:value-of
                                        select="record:record/person:person/person:name/personal-details:credit-name"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                        select="record:record/person:person/person:name/personal-details:given-names"/>
                                <xsl:text>&#160;</xsl:text>
                                <xsl:value-of
                                        select="record:record/person:person/person:name/personal-details:family-name"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--
                        <table border="1">
                            <tr bgcolor="#9acd32">
                                <th>Field</th>
                                <th>Value</th>
                            </tr>
                            <tr>
                                <td>First Name</td>
                                <td>
                                    <xsl:value-of select="record:record/person:person/person:name/personal-details:given-names"/>
                                </td>
                            </tr>
                            <tr>
                                <td>Family Name</td>
                                <td>
                                    <xsl:value-of select="record:record/person:person/person:name/personal-details:family-name"/>
                                </td>
                            </tr>
                            <tr>
                                <td>Published Name</td>
                                <td>
                                    <xsl:value-of select="record:record/person:person/person:name/personal-details:credit-name"/>
                                </td>
                            </tr>
                        </table>
                        -->
                    </xsl:if>
                </div>

                <!-- biography -->
                <h4>
                    <div>Biography</div>
                </h4>
                <div>
                    <blockquote>
                        <xsl:choose>
                            <xsl:when test="record:record/person:person/person:biography">
                                <xsl:value-of
                                        select="record:record/person:person/person:biography/personal-details:content"/>
                            </xsl:when>
                            <xsl:otherwise>No biography entered.</xsl:otherwise>
                        </xsl:choose>
                    </blockquote>
                </div>

                <!-- keywords -->
                <!--
                <div>Keywords</div>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Keywords</th>
                        </tr>
                        <xsl:if test="record:record/person:person/keyword:keywords/keyword:keyword">
                            <xsl:for-each select="record:record/person:person/keyword:keywords/keyword:keyword">
                                <tr>
                                    <td>
                                        <xsl:value-of select="keyword:content"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>
                -->

                <!-- URLs -->
                <div>URLs</div>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Name</th>
                            <th>URL</th>
                        </tr>
                        <xsl:if test="record:record/person:person/researcher-url:researcher-urls/researcher-url:researcher-url">
                            <xsl:for-each
                                    select="record:record/person:person/researcher-url:researcher-urls/researcher-url:researcher-url">
                                <tr>
                                    <td>
                                        <xsl:value-of select="researcher-url:url-name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="researcher-url:url"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>

                <!--
                <div>Skipping Section: other-name:other-names</div>
                <div>Skipping Section: external-identifier:external-identifiers</div>
                <div>Skipping Section: address:addresses</div>
                -->

            </xsl:if>
            <!-- END: personal -->

            <!-- START: education -->
            <xsl:if test="$display_education='yes'">
                <h3>
                    <div>Education</div>
                </h3>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Organization</th>
                            <th>Degree</th>
                            <th>Course</th>
                            <th>End Date</th>
                        </tr>
                        <!-- if at least 1 "activities:educations/education:education-summary" exists -->
                        <xsl:if test="record:record/activities:activities-summary/activities:educations/activities:affiliation-group/education:education-summary">
                            <xsl:for-each
                                    select="record:record/activities:activities-summary/activities:educations/activities:affiliation-group/education:education-summary">
                                <xsl:sort select="common:organization/common:name" data-type="text"/>
                                <xsl:sort select="common:end-date/common:year" data-type="number" order="descending"/>
                                <tr>
                                    <td>
                                        <xsl:value-of select="common:organization/common:name"/>
                                    </td>
                                    <!-- Degree/title -->
                                    <td>
                                        <xsl:value-of select="common:role-title"/>
                                    </td>
                                    <!-- Course/title -->
                                    <td>???</td>
                                    <td>
                                        <xsl:value-of select="common:end-date/common:year"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>
            </xsl:if>
            <!-- END: education -->

            <!-- START: employment -->
            <xsl:if test="$display_employment='yes'">
                <h3>
                    <div>Employment</div>
                </h3>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Organization</th>
                            <th>Department</th>
                            <th>Role/Title</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                        </tr>
                        <!-- if at least 1 "activities:employments/employment:employment-summary" exists -->
                        <xsl:if test="record:record/activities:activities-summary/activities:employments/activities:affiliation-group/employment:employment-summary">
                            <xsl:for-each
                                    select="record:record/activities:activities-summary/activities:employments/activities:affiliation-group/employment:employment-summary">
                                <xsl:sort select="common:organization/common:name" data-type="text"/>
                                <xsl:sort select="common:start-date/common:year" data-type="number" order="descending"/>
                                <tr>
                                    <td>
                                        <xsl:value-of select="common:organization/common:name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="common:department-name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="common:role-title"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="common:start-date/common:year"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="common:end-date/common:year"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>
            </xsl:if>
            <!-- END: employmant -->

            <!-- START: works (activities-group) -->
            <xsl:if test="$display_works='yes'">
                <h3>
                    <div>Works</div>
                </h3>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Work Category and Type</th>
                            <th>Title</th>
                            <th>Journal/Conference/Publisher Title</th>
                            <th>Publication Date</th>
                            <!-- multiple values-->
                            <th>Identifier URLs</th>
                        </tr>
                        <!-- if at least 1 "activities:works/activities:group" exists -->
                        <xsl:if test="record:record/activities:activities-summary/activities:works/activities:group">
                            <xsl:for-each
                                    select="record:record/activities:activities-summary/activities:works/activities:group">
                                <xsl:sort select="work:work-summary/work:type" data-type="text"/>
                                <xsl:sort select="work:work-summary/common:publication-date/common:year"
                                          data-type="number" order="descending"/>
                                <tr>
                                    <td>
                                        <xsl:value-of select="work:work-summary/work:type"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="work:work-summary/work:title/common:title"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="work:work-summary/work:journal-title"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="work:work-summary/common:publication-date/common:year"/>
                                    </td>
                                    <!-- if at least 1 "common:external-ids/common:external-id" exists -->
                                    <td>
                                        <xsl:if test="work:work-summary/common:external-ids/common:external-id">
                                            <!-- we only want the URLs-->
                                            <xsl:for-each
                                                    select="work:work-summary/common:external-ids/common:external-id">
                                                <!-- there may be multiple values so stick in a <br> -->
                                                <xsl:value-of select="common:external-id-url"/>
                                                <xsl:if test="common:external-id-url">
                                                    <br/>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>
            </xsl:if>
            <!-- END: works -->

            <!-- START: fundings -->
            <xsl:if test="$display_fundings='yes'">
                <h3>
                    <div>Funding Sources</div>
                </h3>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Title of Funded Project</th>
                            <th>Funding Agency/Name</th>
                            <th>Funding Type</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                        </tr>
                        <xsl:if test="record:record/activities:activities-summary/activities:fundings/activities:group">
                            <xsl:for-each
                                    select="record:record/activities:activities-summary/activities:fundings/activities:group">
                                <tr>
                                    <td>
                                        <xsl:value-of select="funding:funding-summary/funding:title/common:title"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="funding:funding-summary/common:organization/common:name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="funding:funding-summary/funding:type"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="funding:funding-summary/common:start-date/common:year"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="funding:funding-summary/common:end-date/common:year"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>
            </xsl:if>
            <!-- END: fundings -->

            <!-- START: peer-reviews -->
            <xsl:if test="$display_peer_reviews='yes'">
                <h3>
                    <div>Peer Reviews</div>
                </h3>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Convening Organization Name</th>
                            <th>City</th>
                            <th>Region</th>
                            <th>Country</th>
                            <th>Completion Year</th>
                            <th>Completion Month</th>
                            <th>Completion Day</th>
                        </tr>
                        <xsl:if test="record:record/activities:activities-summary/activities:peer-reviews/activities:group/activities:peer-review-group">
                            <xsl:for-each
                                    select="record:record/activities:activities-summary/activities:peer-reviews/activities:group/activities:peer-review-group">
                                <tr>
                                    <td>
                                        <xsl:value-of
                                                select="peer-review:peer-review-summary/peer-review:convening-organization/common:name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="peer-review:peer-review-summary/peer-review:convening-organization/common:address/common:city"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="peer-review:peer-review-summary/peer-review:convening-organization/common:address/common:region"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="peer-review:peer-review-summary/peer-review:convening-organization/common:address/common:country"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="peer-review:peer-review-summary/peer-review:completion-date/common:year"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="peer-review:peer-review-summary/peer-review:completion-date/common:month"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="peer-review:peer-review-summary/peer-review:completion-date/common:day"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>
            </xsl:if>
            <!-- END: peer-reviews -->

            <!-- START: invited_positions -->
            <xsl:if test="$display_invited_positions='yes'">
                <h3>
                    <div>Invited Positions</div>
                </h3>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Department Name</th>
                            <th>Start Year</th>
                            <th>Organization</th>
                            <th>URL</th>
                        </tr>
                        <xsl:if test="record:record/activities:activities-summary/activities:invited-positions/activities:affiliation-group">
                            <xsl:for-each
                                    select="record:record/activities:activities-summary/activities:invited-positions/activities:affiliation-group">
                                <tr>
                                    <td>
                                        <xsl:value-of
                                                select="invited-position:invited-position-summary/common:department-name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="invited-position:invited-position-summary/common:start-date/common:year"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="invited-position:invited-position-summary/common:organization/common:name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="invited-position:invited-position-summary/common:url"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>
            </xsl:if>
            <!-- END: invited_positions -->

            <!-- START: memberships -->
            <xsl:if test="$display_memberships='yes'">
                <h3>
                    <div>Memberships</div>
                </h3>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Department Name</th>
                            <th>Start Year</th>
                            <th>Organization</th>
                            <th>URL</th>
                        </tr>
                        <xsl:if test="record:record/activities:activities-summary/activities:memberships/activities:affiliation-group">
                            <xsl:for-each
                                    select="record:record/activities:activities-summary/activities:memberships/activities:affiliation-group">
                                <tr>
                                    <td>
                                        <xsl:value-of select="membership:membership-summary/common:department-name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="membership:membership-summary/common:start-date/common:year"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="membership:membership-summary/common:organization/common:name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="membership:membership-summary/common:url"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>
            </xsl:if>
            <!-- END: memberships -->

            <!-- START: qualifications -->
            <xsl:if test="$display_qualifications='yes'">
                <h3>
                    <div>Qualifications</div>
                </h3>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Department Name</th>
                            <th>Start Year</th>
                            <th>Organization</th>
                            <th>URL</th>
                        </tr>
                        <xsl:if test="record:record/activities:activities-summary/activities:qualifications/activities:affiliation-group">
                            <xsl:for-each
                                    select="record:record/activities:activities-summary/activities:qualifications/activities:affiliation-group">
                                <tr>
                                    <td>
                                        <xsl:value-of
                                                select="qualification:qualification-summary/common:department-name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="qualification:qualification-summary/common:start-date/common:year"/>
                                    </td>
                                    <td>
                                        <xsl:value-of
                                                select="qualification:qualification-summary/common:organization/common:name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="qualification:qualification-summary/common:url"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>
            </xsl:if>
            <!-- END: qualificationss -->

            <!-- START: research_resources -->
            <!--
                we have an issue here: it's not clear if there can be MULTIPLE <activities:group>

                we do know that there can be MULTIPLE <research-resource:research-resource-summary> within any <activities:group>
            -->
            <xsl:if test="$display_research_resources='yes'">
                <h3>
                    <div>Research Resources</div>
                </h3>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Title</th>
                            <!--
                            <th>Organization</th>
                            -->
                            <th>Start Year</th>
                            <th>End Year</th>
                            <th>URL</th>
                        </tr>
                        <!-- START LOOP on <activities:group> -->
                        <xsl:if test="record:record/activities:activities-summary/activities:research-resources/activities:group">
                            <xsl:for-each
                                    select="record:record/activities:activities-summary/activities:research-resources/activities:group">
                                <!-- <tr><td>INSIDE 1st FOR LOOP</td></tr> -->
                                <!-- START 2ND LOOP on <research-resource:research-resource-summary> -->
                                <xsl:if test="research-resource:research-resource-summary">
                                    <xsl:for-each select="research-resource:research-resource-summary">

                                        <!-- -->
                                        <tr>
                                            <td>
                                                <xsl:value-of
                                                        select="research-resource:proposal/research-resource:title/common:title"/>
                                            </td>
                                            <!-- the <research-resource:hosts> can contain multiple organizations -->
                                            <td>
                                                <xsl:if test="research-resource:proposal/research-resource:hosts/common:organization">
                                                    <xsl:for-each
                                                            select="research-resource:proposal/research-resource:hosts/common:organization">
                                                        <xsl:value-of select="common:name"/>
                                                        <br/>
                                                    </xsl:for-each>
                                                </xsl:if>
                                            </td>
                                            <td>
                                                <xsl:value-of
                                                        select="research-resource:proposal/common:start-date/common:year"/>
                                            </td>
                                            <td>
                                                <xsl:value-of
                                                        select="research-resource:proposal/common:end-date/common:year"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="research-resource:proposal/common:url"/>
                                            </td>
                                        </tr>

                                        <!-- -->
                                    </xsl:for-each>
                                </xsl:if>
                                <!-- END 2ND LOOP on <research-resource:research-resource-summary> -->
                            </xsl:for-each>
                        </xsl:if>
                        <!-- END LOOP on <activities:group> -->
                    </table>
                </div>
            </xsl:if>
            <!-- END: research_resources -->

            <!-- START: services -->
            <xsl:if test="$display_services='yes'">
                <h3>
                    <div>Services</div>
                </h3>
                <div>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Department Name</th>
                            <th>Start Year</th>
                            <th>Organization</th>
                            <th>URL</th>
                        </tr>
                        <xsl:if test="record:record/activities:activities-summary/activities:services/activities:affiliation-group">
                            <xsl:for-each
                                    select="record:record/activities:activities-summary/activities:services/activities:affiliation-group">
                                <tr>
                                    <td>
                                        <xsl:value-of select="service:service-summary/common:department-name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="service:service-summary/common:start-date/common:year"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="service:service-summary/common:organization/common:name"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="service:service-summary/common:url"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </table>
                </div>
            </xsl:if>
            <!-- END: services -->

        </div>

    </xsl:template>

</xsl:stylesheet>
