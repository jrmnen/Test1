*** Settings ***
Documentation     This resource file contains keywords used by Test suite 1

*** Keywords ***
Login With Random FI User
    [Arguments]    ${browser}
    [Documentation]    This keyword is for suite setup: it opens a specified brower: Chrome, Firefox or IE. Logs in with a random FI portfolio from a list (keyword: Input Random FI Username). Waits until integrated blotter is loaded.
    Set Selenium Speed    0.1
    Set Selenium Implicit wait    0.1 sec
    Open Browser    ${adress}    ${browser}
    Maximize Browser Window
    Sleep    1
    Wait Until Keyword Succeeds    3 x    5 s    Force Page Open
    Input Random FI Username
    Submit Form
    Wait Until Page Contains Element    css=div.integratedBlotter    20

Login With Given User
    [Arguments]    ${browser}    ${user}    ${adress}
    [Documentation]    This keyword is for suite setup: it opens a specified brower: Chrome, Firefox or IE. Logs in with given username (${user}). Waits until integrated blotter is loaded.
    Set Selenium Speed    0
    Set Selenium Implicit wait    0.1 sec
    Open Browser    ${adress}    ${browser}
    Maximize Browser Window
    Sleep    1
    Wait Until Keyword Succeeds    3 x    5 s    Force Page Open
    Input Text    name=username    ${user}
    Submit Form
    Wait Until Page Contains Element    css=div.integratedBlotter    120

Login With Admin User
    [Arguments]    ${browser}
    [Documentation]    This keyword is for suite setup: it opens a specified brower: Chrome, Firefox or IE. Logs in with given admin username (TEST_Huy1). Waits until integrated blotter is loaded.
    Set Selenium Speed    0
    Set Selenium Implicit wait    0.1 sec
    Open Browser    ${adress}    ${browser}
    Maximize Browser Window
    Sleep    1
    Wait Until Keyword Succeeds    2 x    5 s    Force Page Open
    Input Text    name=username    TEST_Huy1
    Submit Form
    Wait Until Page Contains Element    css=div.integratedBlotter    30

Login With TEST_HELEN_1
    [Arguments]    ${browser}
    [Documentation]    This keyword is for suite setup: You can change browser: Chrome, Firefox or IE. Logs in with TEST_HELEN_1 user. Waits until integrated blotter is loaded.
    Set Selenium Speed    0.1
    Set Selenium Implicit wait    0.1 sec
    Open Browser    ${adress}    ${browser}
    Maximize Browser Window
    Sleep    1
    Wait Until Keyword Succeeds    4 x    5 s    Force Page Open
    Input Text    name=username    TEST_HELEN_1
    Submit Form
    Wait Until Page Contains Element    css=div.integratedBlotter    20

Performance Test Setup
    [Arguments]    ${browser}
    [Documentation]    Use this keyword if you need to set Selenium speed so basic keywords stay untouched. This keyword is for browswer performance testing setup: Selenium speed is set very fast and Selenium implicit wait is default. Logs in with user specified after "Input Text name=username".
    Set Selenium Speed    0
    Open Browser    ${adress}    ${browser}
    Maximize Browser Window
    Sleep    1
    Wait Until Keyword Succeeds    3 x    5 s    Force Page Open
    Input Text    name=username    TEST_Joniar
    Submit Form
    Wait Until Page Contains Element    css=div.integratedBlotter    18

Force Page Open
    [Documentation]    Page reloading keyword. In 1.5.1 IE needed a lot of refreshing to get into the login page.
    Reload Page
    Wait Until Page Contains Element    css=div.loginFormContainer    8    Page didn't load in 8 seconds

Get Timezone
    [Documentation]    Fetches user time zone (GMT+1, EEST...) for determining which PHs are open.
    ${timezone}=    Get Text    css=div.clock .timeZone
    Set Suite Variable    ${timezone}

Get Random PH
    [Documentation]    Generates a random open Power Hour variable using user time zone and and current time. Adds "PH" text in front of hours.
    ${timestamp}=    Get Current Hours
    Get Timezone
    ${PH}=    Get Random Open Ph    ${timestamp_h}    ${timezone}
    ${PH}=    Add Ph    ${PH}
    Set Suite Variable    ${PH}

Get Random Quantity
    [Documentation]    Generates a random quantity variable between 1 and 100 and sets as suite variable.
    ${quantity}=    Evaluate    random.randint(1,101)    random
    Set Suite Variable    ${quantity}

Get Random Price
    [Documentation]    Generates a random price variable between 1 and 100 and sets as suite variable.
    ${price}=    Evaluate    random.randint(1,50)    random
    Set Suite Variable    ${price}

Decide buy or sell
    [Documentation]    Randomly chooses either buy or sell and sets the action as suite variable. 1 == Sell, 2 = Buy.
    ${action}=    Evaluate    random.randint(1,2)    random
    Run Keyword If    ${action}==1    Click Sell Button
    Set Suite Variable    ${action}

Click Sell Button
    [Documentation]    Clicks the secon button in order ticket. Needs the ticket to be open.
    Click Element    xpath=(//button[@type='button'])[2]

Select PH Row
    [Documentation]    Selects a random (open) PH row and opens the order ticket.
    Get Random PH
    ${n}=    Get Matching Xpath Count    //div[contains(@class, 'nps-open-product-row')]//div[contains(text(), '${PH}')]
    Run Keyword If    ${n}==0    Fail
    Run Keyword If    ${n}==1    Doubleclick PH Row

Select Expiring PH Row
    [Documentation]    Selects the last open PH in MI and opens the order ticket. Works with time zones GMT+1, EEST and Cest.
    Get Current Hours
    Get Timezone
    ${PH}=    Get Expiring Ph    ${timestamp_h} \    ${timezone}
    Set Suite Variable    ${PH}
    ${n}=    Get Matching Xpath Count    //div[contains(@class, 'nps-open-product-row')]//div[contains(text(), '${PH}')]
    Run Keyword If    ${n}==0    Fail    Tried to select expiring row, but product already closed. Check your time zone.
    Run Keyword If    ${n}==1    Doubleclick PH Row

Select Any Product Row
    [Documentation]    Selects a random (open) row of any product that is visible in the market information window. Opens also the order ticket. 
    ${row}=    Evaluate    random.randint(5,35)    random
    Set Suite Variable    ${row}
    ${is_available}=    Get Matching Xpath Count    xpath=//div[contains(@class, 'ui-grid-pinned-container-left')]//div[contains(@class, 'ui-grid-row') and position()=${row}]//div[contains(@class, 'nps-open-product-row')]
    Run Keyword If    ${is_available}==0    Fail
    ...    ELSE    Doubleclick Row

Doubleclick Row

    Double Click Element    xpath=//div[contains(@class, 'ui-grid-canvas')]//div[position()=${row}]
    Wait Until Element Is Enabled    name=quantity  0.3

Get MI row count
    Get Matching Xpath Count    xpath=//div[contains(@class,'ui-grid-canvas')]//div[contains(@class,'nps-open-product-row')]
    ${count}=    Get Element Count    xpath=//div[contains(@class,'ui-grid-canvas')]    xpath=//div[contains(@class,'nps-open-product-row')]

Select A Finnish PF
    [Documentation]    Opens the portfolio selector and randomly selects a portfolio. Keyword fails if the selected portfolio is not in Finland.
    ${nth_PF}=    Fetch Random PF    ${n_PF}
    Run Keyword And Ignore Error    Open PF Selector
    Click Element    css= .marketInfo .gridMast .dropdownSingleSelector .selector .option:nth-child(${nth_PF})
    ${flag}    Get Text    css=div.marketInfo .gridMast .maxHeightTall.dropdownFlagSelector .summary .label
    ${value}    Compare Pf To Fi    ${flag}
    Should Be True    ${value}

Doubleclick PH Row
    [Documentation]    Doubleclicks the row that contains text set in ${PH} suite variable in order to open the order ticket. Waits for order ticket to open.
    Double Click Element    xpath=//div[contains(@class, 'nps-open-product-row')]//div[contains(text(), '${PH}')]
    Wait Until Element Is Enabled    name=quantity    0.5

Open PF Selector
    Click Element    css=div.ws-workspace .gridMast .dropdownSingleSelector .summary

Input Random FI Username
    [Documentation]    Fetches a random FI username from a list in MyPythonKeywords.py file and enters it in username field.
    ${username}=    Fetch Random Fi Username
    Set Suite Variable    ${username}
    Input Text    name=username    ${username}

Select FI Portfolio If Not Selected
    Click Element    css=div.gridMast .summary
    Wait Until Element Is Enabled    css=div.gridMast .selector
    ${n_PF}    Get Matching Xpath Count    //div[contains(@class, 'gridMast')]//div[contains(@class, 'maxHeightTall')]//div[contains(@class, 'selector')]//div[contains(@class, 'option')]
    Set Suite Variable    ${n_PF}
    Run Keyword If    ${n_PF}==0    Fail    PF dropdown error
    Pass Execution If    ${n_PF}==1    Didn't need to change PF: just one option
    ${result}    Wait Until Keyword Succeeds    45 s    0.4 s    Select A Finnish PF

Input Quantity
    [Documentation]    Inputs suite variable ${quantity} to quantity field.
    Input Text    name=quantity    ${quantity}

Input Price
    [Documentation]    Inputs suite variable ${price} to price field.
    Input Text    name=price    ${price}

Input IBO Values
    [Documentation]    Inputs predefined values (except price) to IBO fields.
    Input Text    name=quantity    200
    Get Random Price
    Input Text    name=price    ${price}
    Input Text    name=clipSize    25
    Input Text    name=clipPriceChange    0

Get Current Hours
    [Documentation]    Sets application current hours (HH) as suite varible. Note that open PHs stay the same even though user time zone may vary. Use 'Get Timezone' keyword.
    ${timestamp}=    Get Text    css=div.clock .time
    ${timestamp_h}    Pick Timestamp Hours    ${timestamp}
    Set Suite Variable    ${timestamp_h}

Compare open order time stamps to current time
    [Documentation]    Compares timestamps of open orders in My Orders to application time to see if expired order is shown as open, part filled or deactivated.
    Store My Orders Row Count
    : FOR    ${row}    IN RANGE    1    ${n_rows_1}
    \    Run Keyword If    ${row}==0    Exit For Loop
    \    ${state}=    Get Text    css= div.integratedBlotter .ui-grid-row:nth-child(${row}) .ui-grid-cell:nth-child(2)
    \    ${result}=    Verify If State Expired    ${state}
    \    Continue For Loop If    ${result}==True
    \    Get Current Hours
    \    ${power_hour}    Get Text    css=div.integratedBlotter .ui-grid-row:nth-child(${row}) .ui-grid-cell:nth-child(4) .ui-grid-cell-contents
    \    ${corrected_timestamp}=    Adjust Timestamp    ${timestamp_h}    ${timezone}
    \    ${value}=    Compare Time Stamps    ${corrected_timestamp}    ${power_hour}
    \    Should Be True    ${value}

Store My Orders Row Count
    [Documentation]    Not usable. Counts rows in My Orders, but cannot count to more than 15.
    ${n_rows}=    Get Matching Xpath Count    //div[contains(@class, 'integratedBlotter')]//div[contains(@class, 'ui-grid-row')]
    ${n_rows_1}=    Add one    ${n_rows}
    Set Suite Variable    ${n_rows}
    Set Suite Variable    ${n_rows_1}

Verify no empty who fields
    [Documentation]    Verifies that the 'who' field in My Orders is not empty. Works only for the 15 first rows. Fix implementation not confirmed.
    Store My Orders Row Count
    : FOR    ${row}    IN RANGE    1    ${n_rows_1}
    \    Run Keyword If    ${row}==0    Exit For Loop
    \    ${who}=    Get Text    css= div.integratedBlotter .ui-grid-row:nth-child(${row}) .ui-grid-cell:nth-child(11)
    \    ${result}=    Verify Who Field    ${who}
    \    Should Be True    ${result}

Select Integrated Blotter Today Filter
    [Documentation]    Selects the first filter choice for date in Integrated Blotter.
    Click Element    css=div.integratedBlotter .date .summary
    Click Element    css=div.integratedBlotter .date .selector .option:nth-child(1)

Verify Deactivate And Activate All
    [Documentation]    Verifies that panic buttons work correctly. Needs to be run with a trade client.
    Run Keyword If    ${n_rows}==0    No orders visible, cannot run test
    Click Element    css=div.integratedBlotter .img-svg-switch-deactivate
    Sleep    1
    ${options}=    Get Matching Xpath Count    //div[contains(@class, 'calloutDropdown')]//div[contains(@class, 'ng-scope')]//div[contains(@class, 'item')]
    Run Keyword If    ${options}==2    Click Element    css=div.calloutDropdownContainer .item:nth-child(2)
    ...    ELSE    Click Element    css=div.calloutDropdownContainer .item
    Sleep    1
    Verify Deactivated
    Click Element    css= .integratedBlotter .img-svg-switch-activate
    Sleep    1
    Click Element    css=div.modalOverlay .buttonContainer .button.yes
    Sleep    1.5
    Verify Activated

Verify Deactivated
    [Documentation]    Verifies that first 100 orders in my orders are either deactivated or expired.
    : FOR    ${row}    IN RANGE    1    100
    \    ${does_row_exist}=    Run Keyword And Return Status    Page Should Contain    css= div.integratedBlotter .ui-grid-row:nth-child(${row})
    \    Run Keyword If    ${does_row_exist}==False    Exit For Loop
    \    ${state}=    Get Text    css= div.integratedBlotter .ui-grid-row:nth-child(${row}) .ui-grid-cell:nth-child(2)
    \    ${result}=    Verify If State Expired    ${state}
    \    Continue For Loop If    ${result}==True
    \    ${result}=    Verify State Deact    ${state}
    \    Should Be True    ${result}
    \    Element Should Be Visible    css=div.integratedBlotter .ui-grid-row:nth-child(${row}) .img-svg-toggle-off

Verify Activated
    [Documentation]    Verifies that first 100 orders in my orders are either open, part filled or expired.
    : FOR    ${row}    IN RANGE    1    100
    \    ${does_row_exist}=    Run Keyword And Return Status    Page Should Contain    css= div.integratedBlotter .ui-grid-row:nth-child(${row})
    \    Run Keyword If    ${does_row_exist}==False    Exit For Loop
    \    ${state}=    Get Text    css= div.integratedBlotter .ui-grid-row:nth-child(${row}) .ui-grid-cell:nth-child(2)
    \    ${result}=    Verify If State Expired    ${state}
    \    Continue For Loop If    ${result}==True
    \    ${result}=    Verify State Open    ${state}
    \    Should Be True    ${result}
    \    Element Should Be Visible    css=div.integratedBlotter .ui-grid-row:nth-child(${row}) .img-svg-toggle-on

Make Sure Time Zone Is EEST
    [Documentation]    Checks if time zone is EEST. If not, runs "Select EEST Locale"
    ${timeZone}=    Get Text    css=div.clock .timeZone
    ${result}    See If Values Are Equal    EEST    ${timeZone}
    Run Keyword If    ${result}==False    Select EEST Locale

Select EEST Locale
    [Documentation]    Selects 9th country in country list.
    Click Element    css=div.profileSection
    Click Element    css=div.userSettings .locale .summary
    Wait Until Element Is Enabled    css=div.userSettings .locale .selector
    Click Element    css=div.userSettings .locale .selector .option:nth-child(9)
    Click Element    css=div.integratedBlotter
    Sleep    2
    Wait Until Element Is Enabled    name=username
    Input Text    name=username    ${username}
    Submit Form
    Wait Until Page Contains Element    css=div.integratedBlotter    20

Deactivate And Verify All For Loop
    [Documentation]    Turns every order in my orders off one by one. You should see if "page should contain element" works so you could delete verify deactivated.
    Store My Orders Row Count
    : FOR    ${row}    IN RANGE    1    100
    \    Run Keyword If    ${row}==0    Exit For Loop
    \    ${a}=    Run Keyword And Ignore Error    Click Element    css=div.integratedBlotter .ui-grid-row:nth-child(${row}) .img-svg-toggle-on
    \    Run Keyword If    'FAIL' in ${a}    Exit For Loop
    \    Page Should Contain Element    css=div.integratedBlotter .ui-grid-row:nth-child(${row}) .img-svg-toggle-off
    Verify Deactivated

Activate And Verify All For Loop
    [Documentation]    Turns every order in my orders on one by one. You should see if "page should contain element" works so you could delete verify activated.
    : FOR    ${row}    IN RANGE    1    100
    \    Run Keyword If    ${row}==0    Exit For Loop
    \    ${a}=    Run Keyword And Ignore Error    Click Element    css=div.integratedBlotter .ui-grid-row:nth-child(${row}) .img-svg-toggle-off
    \    Run Keyword If    'FAIL' in ${a}    Exit For Loop
    \    Page Should Contain Element    css=div.integratedBlotter .ui-grid-row:nth-child(${row}) .img-svg-toggle-on
    Verify Activated

Place Max 10 Orders Until Best
    [Documentation]    Places 10 random orders and checks from ordrer depth if your order is the best in depth until true.
    : FOR    ${var}    IN RANGE    10
    \    Get Random Quantity
    \    Get Random Price
    \    Wait Until Keyword Succeeds    10 sec    0.4 sec    Select PH Row
    \    Wait Until Element is Enabled    name=quantity
    \    Decide buy or sell
    \    Input Quantity
    \    Input Price
    \    Submit Form
    \    Run Keyword If    ${action}=='1'    Is Best Bid
    \    ...    ELSE    Is Best Ask
    \    Run Keyword If    ${isBest}==True    Exit For Loop

Is Best Bid
    [Documentation]    Checks order depth to see if the best bid is yours. This happens if ${action}==1. This is to prevent self trading.
    ${y}=    Get Matching Xpath Count    //div[contains(@class, 'orderDepthTable')]//div[contains(@class, 'bidRowContainer')]//div[position()=1 and contains(@class, 'orderDepthSubTableBidRow')]//div[contains(@class, 'isOwnOrder')]
    ${isBest}=    Is Own Order Best    ${y}
    Set Suite Variable    ${isBest}

Is Best Ask
    [Documentation]    Checks order depth to see if the best ask is yours. This happens if ${action}==2. This is to prevent self trading.
    ${y}=    Get Matching Xpath Count    //div[contains(@class, 'orderDepthTable')]//div[contains(@class, 'askRowContainer')]//div[position()=1 and contains(@class, 'orderDepthSubTableAskRow')]//div[contains(@class, 'isOwnOrder')]
    ${isBest}=    Is Own Order Best    ${y}
    Set Suite Variable    ${isBest}

Close Order Depth
    [Documentation]    Closes order depth panel. Same keyword as 'Open Order Depth'. Use Verification keyword to see if worked.
    ${a}=    Get Matching Xpath Count    //div[contains(@class,'ws-workspace')]//div[contains(@class,'parentPanel')]//div[contains(@class,'content')]//div[position()=3 and contains(@class, 'edgeBarLeft') and contains(@class, 'expanded')]
    Run Keyword If    ${a}==1    Click Element    css=div.ws-workspace .parentPanel .ws-panel:nth-child(3) .edgeBar

Verify Order Depth Closed
    [Documentation]    Closes order depth panel. Same keyword as 'Open Order Depth'. Use Verification keyword to see if worked.
    Page Should Contain Element    //div[contains(@class,'ws-workspace')]//div[contains(@class,'parentPanel')]//div[contains(@class,'content')]//div[position()=3 and contains(@class, 'edgeBarLeft') and contains(@class, 'collapsed')]

Open Order Depth
    [Documentation]    Closes order depth panel. Same keyword as 'Close Order Depth'. Use Verification keyword to see if worked.
    ${a}=    Get Matching Xpath Count    //div[contains(@class,'ws-workspace')]//div[contains(@class,'parentPanel')]//div[contains(@class,'content')]//div[position()=3 and contains(@class, 'edgeBarLeft') and contains(@class, 'collapsed')]
    Run Keyword If    ${a}==1    Click Element    css=div.ws-workspace .parentPanel .ws-panel:nth-child(3) .edgeBar

Verify Order Depth Open
    [Documentation]    Checks if order depth panel is open. Fails if closed.
    Page Should Contain Element    //div[contains(@class,'ws-workspace')]//div[contains(@class,'parentPanel')]//div[contains(@class,'content')]//div[position()=3 and contains(@class, 'edgeBarLeft') and contains(@class, 'expanded')]

Close Integrated Blotter
    [Documentation]    Closes integradted blotter panel. Same keyword as 'Open Integrated blotter'. Use Verification keyword to see if worked.
    ${a}    Get Matching Xpath Count    //div[contains(@class,'bottom') and contains(@class, 'expanded')]
    Run Keyword If    ${a}==1    Click Element    css=div.bottom .edgeBar

Verify Integrated Blotter Closed
    [Documentation]    Checks if integrated blotter panel is open. Fails if open.
    Page Should Contain Element    //div[contains(@class,'bottom') and contains(@class, 'collapsed')]

Open Integrated Blotter
    ${a}    Get Matching Xpath Count    //div[contains(@class,'bottom') and contains(@class, 'collapsed')]
    Run Keyword If    ${a}==1    Click Element    css=div.bottom .edgeBar

Verify Integrated Blotter Open
    Page Should Contain Element    //div[contains(@class,'bottom') and contains(@class, 'expanded')]

Open My Trades
    [Documentation]    Opens and verifies that My Trades view is open.
    Click Element    xpath=//div[contains(@class, 'integratedBlotter')]//div[contains(@class, 'gridMast')]//div[contains(@title, 'My Orders')]
    Click Element    xpath=//div[contains(@class, 'integratedBlotter')]//div[contains(@class, 'gridMast')]//div[contains(@title, 'My Trades')]
    Page Should Contain Element    xpath=//div[contains(@class, 'integratedBlotter')]//div[contains(@class, 'gridMast')]//div[contains(@title, 'My Trades')]

Open Correct Market Information Columns
    [Documentation]    Opens the first 11 columns in Market Information window for last price and quantity tests. Verifies that only 1 OD column is shown.
    Click Element    css=div.icon.settings
    Set Selenium Speed    0
    : FOR    ${var}    IN RANGE    11
    \    Continue For Loop If    ${var}==0
    \    ${a}=    Get Matching Xpath Count    //div[contains(@class, 'columnGroupsSelector')]//div[contains(@class, 'left')]//div[contains(@class, 'selector')]//div[position()=${var} and contains(@class, 'option')]//div[contains(@class, 'npsCheckbox') and contains(@class, 'unchecked')]
    \    Run Keyword If    ${a}==1    Click Element    css=div.columnGroupsSelector .left .option:nth-child(${var}) .npsCheckbox.unchecked
    \    Run Keyword If    ${var}==2    Verify Only One Order Depth Level
    : FOR    ${var}    IN RANGE    11
    \    Continue For Loop If    ${var}==0
    \    Page Should Contain Element    css=div.columnGroupsSelector .left .option:nth-child(${var}) .npsCheckbox.checked
    Set Selenium Speed    0.1

Verify Only One Order Depth Level
    [Documentation]    Checks that only one order depth level is shown, so that last price and quantity keywords work.
    ${b}=    Get Matching Xpath Count    //div[contains(@class, 'columnGroupsSelector')]//div[contains(@class, 'left')]//div[contains(@class, 'selector')]//div[position()=2 and contains(@class, 'option')]//div[contains(@class, 'npsCheckbox') and contains(@class, 'unchecked')]
    Run Keyword If    ${b}==1    Log    Only one order depth level selected
    ...    ELSE    Select Only One Order Depth Level

Select Only One Order Depth Level
    [Documentation]    Selects the tickbox so that only 1 order depth level is shown in market information, for last price and quantity keyword.
    Click Element    css=div.columnGroupsSelector .left .option:nth-child(2) .npsCheckbox.checked

Find A PH To Make The Trade On
    [Documentation]    Selects a PH so that there is at least one order in Order Depth. Makes A buy/sell decicion based on orders in order depth.
    Select PH Row
    ${asks}=    Get Matching Xpath Count    //div[contains(@class, 'orderDepthTable')]//div[contains(@class, 'askRowContainer')]//div[position()=1 and contains(@class, 'orderDepthSubTableAskRow')]
    ${bids}=    Get Matching Xpath Count    //div[contains(@class, 'orderDepthTable')]//div[contains(@class, 'bidRowContainer')]//div[position()=1 and contains(@class, 'orderDepthSubTableBidRow')]
    ${action}=    Decide Buy Or Sell In Order Depth    ${bids}    ${asks}
    Run Keyword If    ${action}==0    Fail
    ${isBest} =    Set Variable    None
    Run Keyword If    ${action}==1    Is Best Bid
    ...    ELSE    Is Best Ask
    Run Keyword If    ${isBest}=='True'    Fail
    Set Suite Variable    ${action}

Store Last Price Quantity And Time
    [Documentation]    This keyword doesn't yet return the time. It returns just an empty variable
    ${price}=    Get Text    css=div.nps-row-container.nps-selected-row .ui-grid-cell:nth-child(9)
    ${quantity}=    Get Text    css=div.nps-row-container.nps-selected-row .ui-grid-cell:nth-child(10)
    ${time}=    Get Element Attribute    xpath=//div[contains(@class, 'nps-row-container') and contains(@class, 'nps-selected-row')]//div[position()=11 and contains(@class, 'ui-grid-cell')]@title
    ${time}=    Split Long Time    ${time}
    ${PQT}=    Create List    ${price}    ${quantity}    ${time}
    Set Suite Variable    ${PQT}

Save Initial PQT
    Set Suite Variable    ${PQT_1}    ${PQT}

Store Last Trade Time In Ticker
    [Documentation]    This seems pretty hard to achieve, as the time stamp is stored in the 'title' attribute, which I can't extract. Could be achieved by keyword 'Element Attribute Should Be', if trade time stamp is first acuired from My Trades.
    ${a}=    Get Matching Xpath Count    //div[contains(@class, 'tradeBlotter')]//div[contains(@class, 'ui-grid-row')]
    Run Keyword If    ${a}==0    Log    Ticker window empty before trade
    ...    ELSE    Store First Ticker Time

Store First Ticker Time
    ${ticker_time}=    Get Element Attribute    xpath=//div[contains(@class, 'tradeBlotter')]//div[position()=1 and contains(@class, 'ui-grid-row')]//div[position()=7 and contains(@class, 'ui-grid-cell')]//div[contains(@class, 'ui-grid-cell-contents')]@title
    ${ticker_time}=    Split Long Time    ${ticker_time}
    Set Suite Variable    ${ticker_time}

Make A Trade In Order Depth
    Run Keyword If    ${action}==2    Make A Buy Order In Order Depth
    ...    ELSE    Make A Sell Order In Order Depth

Make A Buy Order In Order Depth
    [Documentation]    Needs a self trade prevention loop here
    ${j}=    Get Text    css=div.orderDepthSubTableAskRow:nth-child(1) .askQty
    Set Suite Variable    ${j}
    ${k}=    Get Text    css=div.orderDepthSubTableAskRow:nth-child(1) .askPrice
    Set Suite Variable    ${k}
    Double Click Element    css=div.orderDepthSubTableAskRow:nth-child(1)
    Page Should Contain Element    css=button.button.placeOrder
    Click Element    css=button.button.placeOrder

Make A Sell Order In Order Depth
    [Documentation]    Needs a self trade prevention loop here
    ${j}=    Get Text    css=div.orderDepthSubTableBidRow:nth-child(1) .bidQty
    Set Suite Variable    ${j}
    ${k}=    Get Text    css=div.orderDepthSubTableBidRow:nth-child(1) .bidPrice
    Set Suite Variable    ${k}
    Double Click Element    css=div.orderDepthSubTableBidRow:nth-child(1)
    Page Should Contain Element    css=button.button.placeOrder
    Click Element    css=button.button.placeOrder

Verify from Ticker That Own Trade Happened
    [Documentation]    First compares the ticker time stamps, then verifies that ticker shows the trade as own
    ${ticker_time2}=    Get Element Attribute    xpath=//div[contains(@class, 'tradeBlotter')]//div[position()=1 and contains(@class, 'ui-grid-row')]//div[position()=7 and contains(@class, 'ui-grid-cell')]//div[contains(@class, 'ui-grid-cell-contents')]@title
    ${ticker_time2}=    Split Long Time    ${ticker_time2}
    ${value}=    Compare Ticker Times    ${ticker_time}    ${ticker_time2}
    Should Be True    ${value}
    Run Keyword If    ${action}==1    Page Should Contain Element    css=div.tradeBlotter .ui-grid-canvas .ui-grid-row:nth-child(1) .nps-row-container.isUsersSellTrade
    ...    ELSE    Page Should Contain Element    css=div.tradeBlotter    .ui-grid-canvas .ui-grid-row:nth-child(1) .nps-row-container.isUsersBuyTrade

Verify PQT Are Updated Correctly
    [Documentation]    Compares the price and quantity in market information to the price and quantity of the trade in order depth.
    Compare Last Pqs    ${PQT}    ${j}    ${k}

Open My Orders
    Run Keyword And Ignore Error    Click Element    xpath=//div[contains(@class, 'integratedBlotter')]//div[contains(@class, 'gridMast')]//div[contains(@title, 'My Trades')]
    Click Element    xpath=//div[contains(@class, 'integratedBlotter')]//div[contains(@class, 'gridMast')]//div[contains(@title, 'My Orders')]
    Page Should Contain Element    xpath=//div[contains(@class, 'integratedBlotter')]//div[contains(@class, 'gridMast')]//div[contains(@title, 'My Orders')]

Save Initial Turnover
    ${turnover}=    Get Text    css=div.nps-row-container.nps-selected-row .ui-grid-cell:nth-child(13)
    ${turnover}=    Replace Commas    ${turnover}
    Set Suite Variable    ${turnover}

Verify Turnover Is Updated Correctly
    ${turnover2}=    Get Text    css=div.nps-row-container.nps-selected-row .ui-grid-cell:nth-child(13)
    ${turnover2}=    Replace Commas    ${turnover2}
    Set Suite Variable    ${turnover2}
    ${value}=    Verify New Turnover Matches    ${turnover}    ${j}    ${turnover2}
    Should Be True    ${value}

Place A Succesful FoK Order
    Wait Until Keyword Succeeds    40 sec    1 sec    Find A PH To Make The Trade On
    Run Keyword If    ${action}==2    Get Order Depth Ask Values
    ...    ELSE    Get Order Depth Bid Values
    ${price}=    Get Successfull Fok Price    ${action}    ${price}
    Set Suite Variable    ${price}
    Input Quantity
    Input Price
    Run Keyword If    ${action}==1    Click Element    xpath=(//button[@type='button'])[2]
    Click Element    xpath=(//button[@type='button'])[4]
    Submit Form

Place A Failing FoK Order
    Wait Until Keyword Succeeds    40 sec    1 sec    Find A PH To Make The Trade On
    Run Keyword If    ${action}==2    Get Order Depth Ask Values
    ...    ELSE    Get Order Depth Bid Values
    ${price}=    Get Unsuccessfull Fok Price    ${action}    ${price}
    Set Suite Variable    ${price}
    Input Quantity
    Input Price
    Run Keyword If    ${action}==1    Click Element    xpath=(//button[@type='button'])[2]
    Click Element    xpath=(//button[@type='button'])[4]
    Submit Form

Place A Random FoK Order
    Wait Until Keyword Succeeds    20 sec    1 sec    Select PH Row
    Decide Buy Or Sell
    Get Random Quantity
    Get Random Price
    Input Quantity
    Input Price
    Click Element    xpath=(//button[@type='button'])[4]
    Submit Form

Place A Succesful IoC Order
    Wait Until Keyword Succeeds    30 sec    1 sec    Find A PH To Make The Trade On
    Run Keyword If    ${action}==2    Get Order Depth Ask Values
    ...    ELSE    Get Order Depth Bid Values
    ${quantity}=    Get Successfull Ioc Qty    ${action}    ${quantity}
    Set Suite Variable    ${quantity}
    Input Quantity
    Input Price
    Run Keyword If    ${action}==1    Click Element    xpath=(//button[@type='button'])[2]
    Click Element    xpath=(//button[@type='button'])[5]
    Submit Form

Place A Failing IoC Order
    Wait Until Keyword Succeeds    30 sec    1 sec    Find A PH To Make The Trade On
    Run Keyword If    ${action}==2    Get Order Depth Ask Values
    ...    ELSE    Get Order Depth Bid Values
    ${quantity}=    Get Unsuccessfull Ioc Qty    ${action}    ${quantity}
    Set Suite Variable    ${quantity}
    Input Quantity
    Input Price
    Run Keyword If    ${action}==1    Click Element    xpath=(//button[@type='button'])[2]
    Click Element    xpath=(//button[@type='button'])[5]
    Submit Form

Place A Random IoC Order
    Wait Until Keyword Succeeds    20 sec    1 sec    Select PH Row
    Decide Buy Or Sell
    Get Random Quantity
    Get Random Price
    Input Quantity
    Input Price
    Click Element    xpath=(//button[@type='button'])[5]
    Submit Form

Place a random IBO
    Sleep    0.1
    Select PH Row
    Decide Buy Or Sell
    Click Element    xpath=(//button[@type='button'])[6]
    Sleep    0.2
    Input IBO values
    Submit Form

Get Order Depth Bid Values
    ${quantity}=    Get Text    css=div.orderDepthSubTableBidRow:nth-child(1) .bidQty
    Set Suite Variable    ${quantity}
    ${price}=    Get Text    css=div.orderDepthSubTableBidRow:nth-child(1) .bidPrice
    ${price}=    Remove Decimals    ${price}
    Set Suite Variable    ${price}

Get Order Depth Ask Values
    ${quantity}=    Get Text    css=div.orderDepthSubTableAskRow:nth-child(1) .askQty
    Set Suite Variable    ${quantity}
    ${price}=    Get Text    css=div.orderDepthSubTableAskRow:nth-child(1) .askPrice
    ${price}=    Remove Decimals    ${price}
    Set Suite Variable    ${price}

Log Out
    [Documentation]    Basic keyword for clicking logout button and logout verification button
    Click Element    css=div.barSection.logoutSection .barItem
    Wait Until Element Is Visible    css=button.button
    Click Button    xpath=//button[contains(text(), 'Yes')]

Change User
    [Documentation]    Basic keyword for changing to random FI trade client. (Change keyword name to mention FI)
    Log Out
    Wait Until Element is Enabled    name=username    5
    Input Random FI Username
    Submit Form
    Wait Until Page Contains Element    css=div.integratedBlotter    20

Select Integrated Blotter Last 7 Days Filter
    [Documentation]    Selects the 'Last 7 Days' filter in My Orders or My Trades
    Click Element    css=div.integratedBlotter .date .summary
    Click Element    css=div.integratedBlotter .date .selector .option:nth-child(4)

Select Integrated Blotter Last 2 Days Filter
    [Documentation]    Selects the 'Last 2 Days' filter in My Orders or My Trades
    Click Element    css=div.integratedBlotter .date .summary
    Click Element    css=div.integratedBlotter .date .selector .option:nth-child(3)

Random Trades Loop
    [Documentation]    Sets random buy/sell orders (For only PHs and for the first day that is open in MI. You can set the number of orders.
    : FOR    ${var}    IN RANGE    5
    \    Get Random Quantity
    \    Get Random Price
    \    Wait Until Keyword Succeeds    25 sec    0.2 sec    Select PH Row
    \    Wait Until Element Is Enabled    name=quantity    0.2
    \    Decide buy or sell
    \    Run Keyword If    ${action}==1    Higher Ask Price
    \    Input Quantity
    \    Input Price
    \    Submit Form

Higher Ask Price
    [Documentation]    Temporary solution to make trades not match that easily. Add to a 'random trades loop' after decide buy or sell. (run keyword if $action==1)
    ${price}    Add 50 To Price    ${price}
    Set Suite Variable    ${price}

Random Trades Loop 2
    [Documentation]    Sets random buy/sell orders for all available products. You can set the number of orders.
    : FOR    ${var}    IN RANGE    8
    \    Get Random Quantity
    \    Get Random Price
    \    Wait Until Keyword Succeeds    12 sec    0.1 sec    Select Any Product Row
    \    Wait Until Element Is Enabled    name=quantity    0.3
    \    Decide buy or sell
    \    Input Quantity
    \    Input Price
    \    Submit Form

Random Trades Loop 3
    [Documentation]    3rd variation of the random trade loop initially for testsuite9.2.2. Makes orders that don't match so easily.
    : FOR    ${var}    IN RANGE    10
    \    Get Random Quantity
    \    Get Random Price
    \    Wait Until Keyword Succeeds    12 sec    0.1 sec    Select Any Product Row
    \    Wait Until Element Is Enabled    name=quantity    0.3
    \    Decide buy or sell
    \    Run Keyword If    ${action}==1    Higher Ask Price
    \    Input Quantity
    \    Input Price
    \    Submit Form

Random Trades Loop 4
    [Documentation]    Sets random buy/sell orders for all available products. Verifies before and after placing an order that best ask price is higher than best buy price.
    : FOR    ${var}    IN RANGE    8
    \    Get Random Quantity
    \    Get Random Price
    \    Wait Until Keyword Succeeds    20 sec    0.1 sec    Select Any Product Row
    \    Verify Prices Match Before Placing An Order
    \    Wait Until Element Is Enabled    name=quantity    0.3
    \    Decide buy or sell
    \    Input Quantity
    \    Input Price
    \    Submit Form
    \    Verify Prices Match After Placing An Order

Change PF
    Click Element    css=div.marketInfo .gridMast .dropdownSingleSelector .summary
    ${n_PF}    Get Matching Xpath Count    //div[contains(@class, 'gridMast')]//div[contains(@class, 'dropdownSingleSelector')]//div[contains(@class, 'selector')]//div[contains(@class, 'option')]
    Set Suite Variable    ${n_PF}
    ${nth_PF}=    Fetch Random PF    ${n_PF}
    Click Element    css=div.gridMast .dropdownSingleSelector .selector .option:nth-child(${nth_PF})

If Uk PF Change Again
    [Documentation]  Changes to a random portfolio, if current portfolio is for UK.
    : FOR    ${a}    IN RANGE    2
    \    ${flag}    Get Text    css=div.marketInfo .gridMast .maxHeightTall.dropdownFlagSelector .summary .label
    \    ${value}    Compare Pf To Uk    ${flag}
    \    Exit For Loop If    ${value}==None
    \    Change PF

If Be PF Change Again
    [Documentation]  Changes to a random portfolio, if current portfolio is for BE.
    : FOR    ${a}    IN RANGE    2
    \    ${flag}    Get Text    css=div.marketInfo .gridMast .maxHeightTall.dropdownFlagSelector .summary .label
    \    ${value}    Compare Pf To Be    ${flag}
    \    Exit For Loop If    ${value}==None
    \    Change PF

If Not No or NL PF Change Again
    [Documentation]  Changes to a random portfolio, until portfolio is for NO2 or NL.
    : FOR    ${a}    IN RANGE    40
    \    ${flag}    Get Text    css=div.marketInfo .gridMast .maxHeightTall.dropdownFlagSelector .summary .label
    \    ${value}    Compare Pf To Nonl    ${flag}
    \    Exit For Loop If    ${value}==True
    \    Change PF

Make LCC Order
    [Documentation]    For LCC testing: sets random buy/sell orders for only PH-03X. You can set the number of orders.
    : FOR    ${var}    IN RANGE    2
    \    Get Random Quantity
    \    Get Random Price
    \    Doubleclick PH-03X
    \    Sleep    0.02
    \    Decide buy or sell
    \    Input Quantity
    \    Input Price
    \    Submit Form
    \    Sleep    1

Doubleclick PH-03X
    [Documentation]    For LCC testing: opens the order ticket for PH-03X and waits until qty field visible.
    Double Click Element    xpath=//div[contains(@class, 'nps-open-product-row')]//div[contains(text(), 'PH-03X')]
    Wait Until Element Is Visible    name=quantity

Prevent Self-Trade In Market Information
    run keyword if    ${action}==sell    Prevent Self-Trade Ask
    ...    ELSE    Prevent Self-Trade Bid

Make A Custom Block Order
    set variable    ${block_hours}=4
    define last possible MI row for block
    select PH row (don't double click)
    press shift
    double click the last row defined earlier

Make All Products Visible In Market Information
    [Documentation]  Chooses the 'All Products' filter in market information. Useful if need to place orders for all product types.
    Click Element    xpath=//div[contains(@class, 'marketInfo')]//div[contains(@class, 'rightContainer')]//div[contains(@class, 'product')]//div[contains(@class, 'icon')]
    Click Element    xpath=//div[contains(@class, 'marketInfo')]//div[contains(@class, 'rightContainer')]//div[contains(@class, 'selector')]//div[contains(@class, 'allOption')]

Make 60 Orders In Large Areas
    [Documentation]  For API load tests.
    : FOR    ${var}    IN RANGE    6
    \    Change To Large Area PF
    \    Make All Products Visible In Market Information
    \    Random Trades Loop 3

Make 30 Orders In Medium Areas
    [Documentation]  For API load tests.
    : FOR    ${var}    IN RANGE    3
    \    Change To Medium Area PF
    \    Make All Products Visible In Market Information
    \    Random Trades Loop 3

Make 10 Orders In Small Areas
    [Documentation]  For API load tests.
    : FOR    ${var}    IN RANGE    1
    \    Change To Small Area PF
    \    Make All Products Visible In Market Information
    \    Random Trades Loop 3

Change To Large Area PF
    Click Element    css=div.marketInfo .gridMast .maxHeightTall .summary
    Run Keyword And Ignore Error    Open PF Selector
    ${PF}    Fetch Large Pf
    Click Element    xpath=//div[contains(@class, 'gridMast')]//div[contains(@class, 'maxHeightTall')]//div[contains(@class, 'selector')]//div[contains(@class, 'option')]//div[contains(@title, '${PF}')]

Change To Medium Area PF
    Click Element    css=div.marketInfo .gridMast .maxHeightTall .summary
    Run Keyword And Ignore Error    Open PF Selector
    ${PF}    Fetch Medium Pf
    Click Element    xpath=//div[contains(@class, 'gridMast')]//div[contains(@class, 'maxHeightTall')]//div[contains(@class, 'selector')]//div[contains(@class, 'option')]//div[contains(@title, '${PF}')]

Change To Small Area PF
    Click Element    css=div.marketInfo .gridMast .maxHeightTall .summary
    Run Keyword And Ignore Error    Open PF Selector
    ${PF}    Fetch Small Pf
    Click Element    xpath=//div[contains(@class, 'gridMast')]//div[contains(@class, 'maxHeightTall')]//div[contains(@class, 'selector')]//div[contains(@class, 'option')]//div[contains(@title, '${PF}')]

Open View And Check Filters
    [Arguments]    ${given_view}
    Open ${given_view}
    Verify filters    ${given_view}

Verify filters
    Element Should Be Visible    xpath=//div[contains(@class, 'integratedBlotter')]//div[contains(@class, 'left')]//div[contains(@class, 'label')]//div[contains(@text, '${given_view}')]
    ${filters}=    Get Matching Xpath Count    xpath=//div[contains(@class, 'integratedBlotter')]//[contains(@class, 'filters')]
    ${result}=    See If Values Are Equal    ${filters}    7
    Click Element    xpath=//div[contains(@class, 'integratedBlotter')]//div[contains(@class, 'filters')]//div[contains(@class, 'summary') and position()=1]//div[contains(@class, 'dropdown-small')]
    Element Should Be Visible    Click Element    xpath=//div[contains(@class, 'integratedBlotter')]//div[contains(@class, 'filters')]//div[contains(@class, 'summary') and position()=1]//div[contains(@class, 'dropdown-small')]

Verify Prices Match After Placing An Order
    [Documentation]    This will compare the ask price to bid price.
    ${askPrice}=    Get Text    css=div.nps-row-container.nps-selected-row .ui-grid-cell:nth-child(4)
    ${bidPrice}=    Get Text    css=div.nps-row-container.nps-selected-row .ui-grid-cell:nth-child(2)
    ${result}=    See If Second Value Higher    ${askPrice}    ${bidPrice}
    Run Keyword If    ${result}==True    Verify Prices Not Matching


Verify Prices Match Before Placing An Order
    ${askPrice}=    Get Text    css=div.nps-row-container.nps-selected-row .ui-grid-cell:nth-child(4)
    ${bidPrice}=    Get Text    css=div.nps-row-container.nps-selected-row .ui-grid-cell:nth-child(2)
    ${result}=    See If Second Value Higher    ${askPrice}    ${bidPrice}
    Run Keyword If    ${result}==True    Capture Page Screenshot
    Run Keyword If    ${result}==True    Fatal Error

Verify Prices Not Matching
    [Documentation]  Will double check the bid and ask prices for 'verify prices match after placing and order' keyword
    Sleep  0.2
    ${askPrice}=    Get Text    css=div.nps-row-container.nps-selected-row .ui-grid-cell:nth-child(4)
    ${bidPrice}=    Get Text    css=div.nps-row-container.nps-selected-row .ui-grid-cell:nth-child(2)
    ${result}=    See If Second Value Higher    ${askPrice}    ${bidPrice}
    Run Keyword If    ${result}==True    Capture Page Screenshot
    Run Keyword If    ${result}==True    Fatal Error

Open Column Group Selector
    Click Element    css=div.icon.settings
    Verify Only One Order Depth Level
    Click Element    css=div.marketInfo