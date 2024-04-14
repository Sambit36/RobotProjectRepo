*** Settings ***
Library     Selenium2Library
Library     String
Library     JSONLibrary
Library     OperatingSystem

*** Variables ***
${BROWSER}        Chrome
${URL}            https://www.google.com/
${count}          0
${rating5_count}     0
${First_5_rating_Product}   0
${JSON_FILE}     Data.json
${JSON_FILE_LOCATORS}    Locators/AmazonLocators.json

*** Test Cases ***
Amazon Assignment
    Open Browser    ${URL}    ${BROWSER}
    delete all cookies
    Maximize Browser Window
    ${data}=    load json from file    ${JSON_FILE}
    ${ldata}=    load json from file    ${JSON_FILE_LOCATORS}

    #Verifying Title
    ${title}=    Get Title
    Log    Window Opened: ${title}

    #Searching for amazon and verification of links
    Click Element    ${ldata["searchbar"]}
    Input Text    ${ldata["searchbar"]}    ${data["Amazon_text"]}
    Click Element    ${ldata["Googlepage"]}
    Click Element    ${ldata["Searchbutton"]}
    Sleep    2
    @{links}=    Get WebElements    ${ldata["allLinks"]}
    FOR    ${link}    IN    @{links}
        Log To Console    ${link}
    END
    #Click Link    partial link:Amazon.in
    Click Link    ${ldata["AmazonPartiallink"]}
    Sleep    2
    Click Element    ${ldata["accountlist"]}
    Sleep    3
    Input Text    ${ldata["email"]}    ${data["amazon_email"]}
    Sleep    1
    Click Element    ${ldata["continue"]}
    Sleep    3
    Input Text    ${ldata["email_pass"]}    ${data["amazon_pass"]}
    Sleep    1
    Click Element    ${ldata["emailsignin"]}
    Sleep    3
    Select From List By Value    ${ldata["dropdown"]}    ${ldata["dropdownvalue"]}
    Sleep    2
    ${selected_text}=    Get Text    id:nav-search-label-id
    Log    ${selected_text}
    Input Text    ${ldata["product_search"]}    ${data["product_filter"]}
    Click Element    ${ldata["product_searchbtn"]}
    Execute JavaScript    window.scrollTo(0, 700)
    Sleep    3
    Wait Until Page Contains Element    ${ldata["lowpricesearch"]}    timeout=5s
    ${element1_visible}    Run Keyword And Return Status    Element Should Be Visible    ${ldata["lowpricesearch"]}
    #${low_price_element}=    Run Keyword And Return Status    Page Should Contain Element    xpath://input[@id='low-price']
    Run Keyword If    not ${element1_visible}    Expand All Filters
    Input Text        ${ldata["inputlowprice"]}     ${data["lower_price"]}
    Input Text    ${ldata["inputhighprice"]}    ${data["higher_price"]}
    Click Element    ${ldata["Go_button"]}
    Sleep    5
    @{page_1_result}=    Get WebElements    ${ldata["all_productprice"]}
    @{product_links}=    Get WebElements    ${ldata["all_productlink"]}
    @{Ratings}=     execute javascript    return window.document.querySelectorAll('i.aok-align-bottom span')
    ${Ratings_length}=    get length    ${Ratings}
    FOR    ${result}    IN    @{page_1_result}
            ${ElementText}=    GET TEXT    ${result}
            ${replaced_price}=    Replace String    ${ElementText}    ,    ${EMPTY}
            Run Keyword If    ${data["lower_price"]} <= ${replaced_price} <= ${data["higher_price"]}    Log To Console    Price range: ${replaced_price}    ELSE    Log To Console    Price range beyond given limit: ${replaced_price}
    END
    FOR    ${i}    IN RANGE    ${Ratings_length}
        ${RatingText}=    execute javascript    return window.document.querySelectorAll('i.aok-align-bottom span')[${i}].innerText.split(' ')[0]
        RUN KEYWORD IF    ${RatingText} == 5.0    log to console    Rating found: ${RatingText}    ELSE    log to console    Rating not matching:${RatingText}

    END
    FOR    ${element}    IN    ${product_links}
        FOR   ${j}    IN RANGE    ${Ratings_length}
            ${RatingText}=    execute javascript    return window.document.querySelectorAll('i.aok-align-bottom span')[${j}].innerText.split(' ')[0]
            RUN KEYWORD IF    ${RatingText} == 5.0    run keyword    click link    ${element}[${j}]
        END
    END
    @{Tabs}=    get window handles
    log    ${Tabs}
    switch window    ${Tabs}[1]
    Execute JavaScript    window.scrollTo(0, 200)
    click element    ${ldata["addtowishlistbtn"]}
    sleep    2
    click element    ${ldata["Create_wishlistbtn"]}
    sleep    3
    click element    ${ldata["Viewwishlistbtn"]}
    sleep    3
    element should be visible    ${ldata["all_productlink"]}     Item added in Wishlist

    switch window    ${Tabs}[0]
    sleep    4
    Go To Next Page
    sleep    5
    @{page_2_result}=    Get WebElements    ${ldata["all_productprice"]}
    FOR    ${result}    IN    @{page_2_result}
            ${ElementText}=    GET TEXT    ${result}
            ${replaced_price}=    Replace String    ${ElementText}    ,    ${EMPTY}
            Run Keyword If    ${data["lower_price"]} <= ${replaced_price} <= ${data["higher_price"]}    Log To Console    Price range: ${replaced_price}    ELSE    Log To Console    Price range beyond given limit: ${replaced_price}
    END
    @{Ratings}=     execute javascript    return window.document.querySelectorAll('i.aok-align-bottom span')
    ${Ratings_length}=    get length    ${Ratings}
    FOR   ${element}    IN RANGE    ${Ratings_length}
        ${RatingText}=    execute javascript    return window.document.querySelectorAll('i.aok-align-bottom span')[${element}].innerText.split(' ')[0]
        RUN KEYWORD IF    ${RatingText} == 5.0    log to console    Rating Found:${RatingText}    ELSE    log to console    Rating not matching:${RatingText}
    END


*** Keywords ***
Expand All Filters
    Click Element    xpath://a[normalize-space()='Expand all']

Go To Next Page
    Click Element    xpath://a[normalize-space()='Next']
    ${previous_button_enabled}=    Run Keyword And Return Status    Page Should Contain Element    xpath://a[@aria-label='Go to previous page, page 1']
    Run Keyword If    ${previous_button_enabled}    Log    Showing validations for 2nd page products    ELSE    Log    Still in 1st page
