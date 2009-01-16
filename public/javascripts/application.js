// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function insert_message(txt) {
    b = $('messages_body');
    if (b.rows.length > 0) new Insertion.Before(b.rows[0], txt); else b.innerHTML = txt;
}