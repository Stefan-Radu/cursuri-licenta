function showPopup(message) {

    if (!message) return;

    $('body').append(
        `<div id="alert" class="alert alert-info" style="position: fixed; top: 8%; right: 1%; transform: None;" role="alert">
            ${message}
        </div>`
    );
    $('#alert').delay(3000).fadeOut(2000, () => {
        $('#alert').remove();
    })
}