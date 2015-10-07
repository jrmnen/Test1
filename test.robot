*** Settings ***
Suite Setup
Suite Teardown
Library           Selenium2Library
Library           python_keyword_library
Resource          MyKeywordResources.robot  

*** Comments ***
Performance statistics test

*** Variables ***
${adress}         http://qa-elbasweb1/

*** Test Cases ***
Test Case 1
    [Tags]  IE
    Login With Admin User  ${BROWSER}
    Sleep  10
    [Teardown]  Close Browser
